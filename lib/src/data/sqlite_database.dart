import 'package:sqflite/sqflite.dart' if (dart.library.html) 'sqlite_stub.dart';
import 'package:path/path.dart';
import 'database_interface.dart' as db_interface;

/// SQLite implementation for mobile platforms
class SQLiteDatabase implements db_interface.DatabaseInterface {
  static Database? _database;

  @override
  Future<void> initialize() async {
    if (_database != null) return;
    
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'wicom.db');
    
    _database = await openDatabase(
      path,
      version: 11,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    mechant_code TEXT,
    name TEXT,
    phone TEXT,
    password TEXT,
    email TEXT,
    identification_number TEXT,
    licence_number TEXT,
    document_refence_id TEXT,
    status TEXT,
    agent_id INTEGER,
    user_id INTEGER,
    otp TEXT,
    created_at TEXT,
    updated_at TEXT
)
    ''');

    await db.execute('''
  CREATE TABLE app_transaction (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id TEXT NOT NULL,
    receiver_account TEXT NULL,
    sender_account TEXT NULL,
    amount TEXT NOT NULL,
    status TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  )
''');

    await db.execute('''
  CREATE TABLE balance (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id TEXT NOT NULL,
    amount TEXT NULL,
    date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  )
''');

    await db.execute('''
  CREATE TABLE customer (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    display_name TEXT NULL,
    external_id TEXT NULL,
    account_no TEXT NULL,
    mobile_no TEXT NULL,
    otp TEXT NULL,
    loan_amount TEXT NULL,
    remain_loan_amount TEXT NULL
  )
''');

    await db.execute('''
  CREATE TABLE loan (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    total_repayment_derived TEXT NULL,
    total_expected_repayment_derived TEXT NULL,
    principal_repaid_derived TEXT NULL,
    principal_amount TEXT NULL,
    client_id TEXT NULL
  )
''');

    await db.execute('''
  CREATE TABLE mechant_charge_configurations (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    mechant_id TEXT NULL,
    charge_id TEXT NULL,
    status TEXT NULL,
    created_at TEXT,
    updated_at TEXT
  )
''');

    await db.execute('''
 CREATE TABLE account_setup (
    id INTEGER PRIMARY KEY,
    mechant_id INTEGER,
    payment_type TEXT,
    institution_name TEXT,
    receiving_number TEXT,
    status TEXT,
    verified TEXT,
    created_at TEXT,
    updated_at TEXT)
''');

    await db.execute('''
      CREATE TABLE students (
        id INTEGER PRIMARY KEY,
        admission_no TEXT,
        roll_no TEXT,
        first_name TEXT,
        last_name TEXT,
        mobile TEXT,
        email TEXT,
        dob TEXT,
        admission_date TEXT,
        student_category_id INTEGER,
        religion_id INTEGER,
        blood_group_id INTEGER,
        gender_id INTEGER,
        category_id INTEGER,
        image_id INTEGER,
        parent_guardian_id INTEGER,
        user_id INTEGER,
        upload_documents TEXT,
        status INTEGER,
        previous_school INTEGER,
        previous_school_info TEXT,
        previous_school_image_id INTEGER,
        place_of_birth TEXT,
        nationality TEXT,
        cpr_no TEXT,
        spoken_lang_at_home TEXT,
        residance_address TEXT,
        control_number TEXT,
        created_at TEXT,
        updated_at TEXT,
        full_name TEXT,
        class_name TEXT,
        section_name TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE fees_assignments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fees_assign_id INTEGER NOT NULL,
        fees_master_id INTEGER NOT NULL,
        student_id INTEGER NOT NULL,
        control_number TEXT NOT NULL,
        fees_amount TEXT DEFAULT '0',
        paid_amount TEXT DEFAULT '0',
        remained_amount TEXT DEFAULT '0',
        quater_amount TEXT DEFAULT NULL,
        quater_one INTEGER DEFAULT NULL,
        quater_two INTEGER DEFAULT NULL,
        quater_three INTEGER DEFAULT NULL,
        quater_four INTEGER DEFAULT NULL,
        comment TEXT DEFAULT NULL,
        outstandingbalance TEXT DEFAULT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    await db.execute('''
      CREATE TABLE fees_assign_children (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fees_assign_id INTEGER NOT NULL,
        fees_master_id INTEGER NOT NULL,
        student_id INTEGER NOT NULL,
        control_number TEXT NOT NULL,
        fees_amount TEXT DEFAULT '0',
        paid_amount TEXT DEFAULT '0',
        remained_amount TEXT DEFAULT '0',
        quater_amount TEXT DEFAULT NULL,
        quater_one INTEGER DEFAULT NULL,
        quater_two INTEGER DEFAULT NULL,
        quater_three INTEGER DEFAULT NULL,
        quater_four INTEGER DEFAULT NULL,
        comment TEXT DEFAULT NULL,
        outstandingbalance TEXT DEFAULT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    await db.execute('''
      CREATE TABLE exam_types (
        id INTEGER PRIMARY KEY,
        name TEXT,
        type TEXT,
        status INTEGER,
        created_at TEXT,
        updated_at TEXT
      )
    ''');

    await db.execute('''
          CREATE TABLE classes (
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL,
            status INTEGER NOT NULL,
            orders INTEGER NOT NULL,
            created_at TEXT NOT NULL,
            updated_at TEXT NOT NULL,
            class_tran TEXT NOT NULL
          )
        ''');

    await db.execute('''
  CREATE TABLE transactions (
    id INTEGER PRIMARY KEY,
    msisdn TEXT,
    amount REAL,
    reference TEXT,
    type TEXT,
    status TEXT,
    mechant_id INTEGER,
    settlement_status TEXT,
    charge TEXT,
    receiving_account_id TEXT,
    total_amount TEXT,
    settlement_id TEXT,
    settlement_date TEXT,
    transaction_id TEXT,
    created_at TEXT,
    updated_at TEXT,
    description TEXT
)
''');

    await db.execute('''
  CREATE TABLE bank_accounts (
    id INTEGER PRIMARY KEY,
    bank_name TEXT NOT NULL,
    account_name TEXT NOT NULL,
    account_number TEXT NOT NULL,
    account_type TEXT,
    status TEXT DEFAULT '1',
    created_at TEXT,
    updated_at TEXT
)
''');

    await db.execute('''
  CREATE TABLE subject_assign_childrens (
    id INTEGER PRIMARY KEY,
    subject_assign_id TEXT NOT NULL,
    subject_id TEXT NOT NULL,
    staff_id TEXT NOT NULL,
    status TEXT,
    created_at TEXT,
    updated_at TEXT
)
''');

    await db.execute('''
  CREATE TABLE subject_assigns (
    id INTEGER PRIMARY KEY,
    session_id TEXT NOT NULL,
    classes_id TEXT NOT NULL,
    section_id TEXT NOT NULL,
    status TEXT,
    created_at TEXT,
    updated_at TEXT
)
''');

    await db.execute('''
 CREATE TABLE user_credentials (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    phone TEXT NOT NULL,
    status TEXT NOT NULL,
    email_verified_at DATETIME,
    password TEXT NULL,
    password_hash TEXT NULL,
    username TEXT NULL,
    remember_token TEXT,
    otp TEXT,
    otp_verified TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
)
''');

    await db.execute('''
  CREATE TABLE staff (
    id INTEGER PRIMARY KEY,
    user_id TEXT NOT NULL,
    staff_id TEXT NOT NULL,
    role_id TEXT NOT NULL,
    designation_id TEXT NOT NULL,
    department_id TEXT NOT NULL,
    first_name TEXT ,
    last_name TEXT ,
    email TEXT ,
    gender_id TEXT ,
    status TEXT,
    created_at TEXT,
    updated_at TEXT
)
''');

    await db.execute('''
  CREATE TABLE marks_grade (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  percent_from REAL NOT NULL,
  percent_upto REAL NOT NULL,
  point INTEGER NOT NULL,
  remarks TEXT,
  session_id INTEGER NOT NULL,
  status INTEGER DEFAULT 1,
  created_at TEXT,
  updated_at TEXT
)
''');

    await db.execute('''
  CREATE TABLE parent_details (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    father_name TEXT,
    father_mobile TEXT,
    father_profession TEXT,
    father_image TEXT,
    father_nationality TEXT,
    mother_name TEXT,
    mother_mobile TEXT,
    mother_profession TEXT,
    mother_image TEXT,
    guardian_name TEXT,
    guardian_email TEXT,
    guardian_mobile TEXT,
    guardian_image TEXT,
    guardian_profession TEXT,
    guardian_relation TEXT,
    guardian_address TEXT,
    status INTEGER DEFAULT 1,
    created_at TEXT,
    updated_at TEXT
)
''');

    await db.execute('''
    CREATE TABLE notice_boards (
      id INTEGER PRIMARY KEY,
      title TEXT,
      date TEXT,
      publish_date TEXT,
      description TEXT,
      attachment TEXT,
      is_visible_web INTEGER,
      status INTEGER,
      visible_to TEXT,
      created_at TEXT,
      updated_at TEXT
    )
  ''');

    await db.execute('''
    CREATE TABLE students_list (
      id INTEGER PRIMARY KEY,
      admission_no TEXT,
      roll_no INTEGER,
      first_name TEXT,
      last_name TEXT,
      mobile TEXT,
      email TEXT,  
      dob TEXT,
      admission_date TEXT,
      student_category_id INTEGER,
      religion_id INTEGER,
      blood_group_id INTEGER,
      gender_id INTEGER,
      category_id INTEGER,
      image_id INTEGER,
      parent_guardian_id INTEGER,
      user_id INTEGER,
      upload_documents TEXT,
      status INTEGER,
      previous_school INTEGER,
      previous_school_info TEXT,
      previous_school_image_id INTEGER,
      place_of_birth TEXT,
      nationality TEXT,
      cpr_no TEXT,
      spoken_lang_at_home TEXT,
      residance_address TEXT,
      control_number TEXT,
      available TEXT,
      created_at TEXT,
      updated_at TEXT
    )
  ''');

    await db.execute('''
  CREATE TABLE status (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    code TEXT NULL,
    created_at TEXT,
    updated_at TEXT
  )
''');

    await db.execute('''
  CREATE TABLE loan_status (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    loan_id TEXT NULL,
    status TEXT NULL,
    description TEXT NULL,
    client_name TEXT NULL,
    created_at TEXT,
    updated_at TEXT
  )
''');

    await db.execute('''
  CREATE TABLE loan_schedule (
    id INTEGER PRIMARY KEY,
    loan_id INTEGER NULL,
    fromdate TEXT NULL,
    duedate TEXT NULL,
    installment INTEGER NULL,
    total_amount_to_be_paid REAL NULL,
    total_amount REAL NULL,
    paid_amount REAL NULL DEFAULT 0,
    remained_amount REAL NULL DEFAULT 0,
    completed_derived INTEGER NULL
  )
''');

    await db.execute('''
  CREATE TABLE support_tickets (
    id INTEGER PRIMARY KEY,
    ticket_id TEXT NULL,
    query_type TEXT NULL,
    query TEXT NULL,
    status TEXT NULL,
    priority TEXT NULL,
    response TEXT NULL,
    created_at TEXT NULL,
    updated_at TEXT NULL
  )
''');

    await db.execute('''
  CREATE TABLE processed_sms (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    sender TEXT NOT NULL,
    original_message TEXT NOT NULL,
    normalized_message TEXT NULL,
    message_hash TEXT NOT NULL,
    command TEXT NULL,
    amount INTEGER NULL,
    service TEXT NULL,
    phone TEXT NULL,
    status TEXT NOT NULL DEFAULT 'PENDING',
    error_message TEXT NULL,
    api_status_code INTEGER NULL,
    sms_timestamp TEXT NOT NULL,
    processed_at TEXT DEFAULT CURRENT_TIMESTAMP,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    updated_at TEXT DEFAULT CURRENT_TIMESTAMP
  )
''');

    // Create indexes for processed_sms
    await db.execute('CREATE INDEX idx_message_hash ON processed_sms(message_hash)');
    await db.execute('CREATE INDEX idx_status ON processed_sms(status)');
    await db.execute('CREATE INDEX idx_sms_timestamp ON processed_sms(sms_timestamp)');
    await db.execute('CREATE INDEX idx_sender ON processed_sms(sender)');
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add loan_status table
      await db.execute('''
        CREATE TABLE IF NOT EXISTS loan_status (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          loan_id TEXT NULL,
          status TEXT NULL,
          description TEXT NULL,
          client_name TEXT NULL,
          created_at TEXT,
          updated_at TEXT
        )
      ''');
    }
    
    if (oldVersion < 3) {
      // Add loan_schedule table
      await db.execute('''
        CREATE TABLE IF NOT EXISTS loan_schedule (
          id INTEGER PRIMARY KEY,
          loan_id INTEGER NULL,
          fromdate TEXT NULL,
          duedate TEXT NULL,
          installment INTEGER NULL,
          total_amount REAL NULL,
          paid_amount REAL DEFAULT 0,
          remained_amount REAL DEFAULT 0,
          completed_derived INTEGER NULL
        )
      ''');
    }
    
    if (oldVersion < 4) {
      // Add support_tickets table
      await db.execute('''
        CREATE TABLE IF NOT EXISTS support_tickets (
          id INTEGER PRIMARY KEY,
          ticket_id TEXT NULL,
          query_type TEXT NULL,
          query TEXT NULL,
          status TEXT NULL,
          priority TEXT NULL,
          response TEXT NULL,
          created_at TEXT NULL,
          updated_at TEXT NULL
        )
      ''');
    }
    
    if (oldVersion < 5) {
      // Add total_amount_to_be_paid column to loan_schedule table
      try {
        await db.execute('''
          ALTER TABLE loan_schedule 
          ADD COLUMN total_amount_to_be_paid REAL NULL
        ''');
      } catch (e) {
        // Column might already exist, ignore error
        print('Note: total_amount_to_be_paid column may already exist: $e');
      }
    }
    
    if (oldVersion < 6) {
      // Add loan_amount and remain_loan_amount columns to customer table
      try {
        await db.execute('''
          ALTER TABLE customer 
          ADD COLUMN loan_amount TEXT NULL
        ''');
      } catch (e) {
        // Column might already exist, ignore error
        print('Note: loan_amount column may already exist: $e');
      }
      
      try {
        await db.execute('''
          ALTER TABLE customer 
          ADD COLUMN remain_loan_amount TEXT NULL
        ''');
      } catch (e) {
        // Column might already exist, ignore error
        print('Note: remain_loan_amount column may already exist: $e');
      }
    }
    
    if (oldVersion < 7) {
      // Add description column to transactions table
      try {
        await db.execute('''
          ALTER TABLE transactions 
          ADD COLUMN description TEXT NULL
        ''');
      } catch (e) {
        // Column might already exist, ignore error
        print('Note: description column may already exist: $e');
      }
    }
    
    if (oldVersion < 9) {
      // Add processed_sms table
      await db.execute('''
        CREATE TABLE IF NOT EXISTS processed_sms (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          sender TEXT NOT NULL,
          original_message TEXT NOT NULL,
          normalized_message TEXT NULL,
          message_hash TEXT NOT NULL,
          command TEXT NULL,
          amount INTEGER NULL,
          service TEXT NULL,
          phone TEXT NULL,
          status TEXT NOT NULL DEFAULT 'PENDING',
          error_message TEXT NULL,
          api_status_code INTEGER NULL,
          sms_timestamp TEXT NOT NULL,
          processed_at TEXT DEFAULT CURRENT_TIMESTAMP,
          created_at TEXT DEFAULT CURRENT_TIMESTAMP,
          updated_at TEXT DEFAULT CURRENT_TIMESTAMP
        )
      ''');
      
      // Create indexes
      await db.execute('CREATE INDEX IF NOT EXISTS idx_message_hash ON processed_sms(message_hash)');
      await db.execute('CREATE INDEX IF NOT EXISTS idx_status ON processed_sms(status)');
      await db.execute('CREATE INDEX IF NOT EXISTS idx_sms_timestamp ON processed_sms(sms_timestamp)');
      await db.execute('CREATE INDEX IF NOT EXISTS idx_sender ON processed_sms(sender)');
    }
    
    if (oldVersion < 8) {
      // Add username and password_hash columns to user_credentials table
      try {
        await db.execute('''
          ALTER TABLE user_credentials 
          ADD COLUMN username TEXT NULL
        ''');
      } catch (e) {
        print('Note: username column may already exist: $e');
      }
      
      try {
        await db.execute('''
          ALTER TABLE user_credentials 
          ADD COLUMN password_hash TEXT NULL
        ''');
      } catch (e) {
        print('Note: password_hash column may already exist: $e');
      }
      
      // Add code column to status table
      try {
        await db.execute('''
          ALTER TABLE status 
          ADD COLUMN code TEXT NULL
        ''');
      } catch (e) {
        print('Note: code column may already exist: $e');
      }
    }
    
    if (oldVersion < 11) {
      // Add paid_amount and remained_amount columns to loan_schedule table
      try {
        await db.execute('''
          ALTER TABLE loan_schedule 
          ADD COLUMN paid_amount REAL DEFAULT 0
        ''');
      } catch (e) {
        print('Note: paid_amount column may already exist: $e');
      }
      
      try {
        await db.execute('''
          ALTER TABLE loan_schedule 
          ADD COLUMN remained_amount REAL DEFAULT 0
        ''');
      } catch (e) {
        print('Note: remained_amount column may already exist: $e');
      }
    }
    
    if (oldVersion < 10) {
      // Add service column to processed_sms table
      try {
        await db.execute('''
          ALTER TABLE processed_sms 
          ADD COLUMN service TEXT NULL
        ''');
      } catch (e) {
        print('Note: service column may already exist: $e');
      }
    }
  }

  Database get database {
    if (_database == null) {
      throw Exception('Database not initialized. Call initialize() first.');
    }
    return _database!;
  }

  @override
  Future<List<Map<String, dynamic>>> query(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    await initialize();
    return await database.query(table, where: where, whereArgs: whereArgs);
  }

  @override
  Future<int> insert(
    String table,
    Map<String, dynamic> data, {
    db_interface.ConflictAlgorithm? conflictAlgorithm,
  }) async {
    await initialize();
    return await database.insert(
      table,
      data,
      conflictAlgorithm: _convertConflictAlgorithm(conflictAlgorithm),
    );
  }

  @override
  Future<int> update(
    String table,
    Map<String, dynamic> data, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    await initialize();
    return await database.update(table, data, where: where, whereArgs: whereArgs);
  }

  @override
  Future<int> delete(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    await initialize();
    return await database.delete(table, where: where, whereArgs: whereArgs);
  }

  @override
  Future<List<Map<String, dynamic>>> rawQuery(String sql, [List<dynamic>? arguments]) async {
    await initialize();
    return await database.rawQuery(sql, arguments);
  }

  @override
  Future<int> rawInsert(String sql, [List<dynamic>? arguments]) async {
    await initialize();
    return await database.rawInsert(sql, arguments);
  }

  @override
  Future<int> rawUpdate(String sql, [List<dynamic>? arguments]) async {
    await initialize();
    return await database.rawUpdate(sql, arguments);
  }

  @override
  Future<int> rawDelete(String sql, [List<dynamic>? arguments]) async {
    await initialize();
    return await database.rawDelete(sql, arguments);
  }

  @override
  Future<void> execute(String sql, [List<dynamic>? arguments]) async {
    await initialize();
    await database.execute(sql, arguments);
  }

  ConflictAlgorithm _convertConflictAlgorithm(db_interface.ConflictAlgorithm? algorithm) {
    if (algorithm == null) return ConflictAlgorithm.abort;
    
    switch (algorithm) {
      case db_interface.ConflictAlgorithm.rollback:
        return ConflictAlgorithm.rollback;
      case db_interface.ConflictAlgorithm.abort:
        return ConflictAlgorithm.abort;
      case db_interface.ConflictAlgorithm.fail:
        return ConflictAlgorithm.fail;
      case db_interface.ConflictAlgorithm.ignore:
        return ConflictAlgorithm.ignore;
      case db_interface.ConflictAlgorithm.replace:
        return ConflictAlgorithm.replace;
    }
  }
}
