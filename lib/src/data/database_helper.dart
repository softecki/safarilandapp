import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('wicom.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
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
    otp TEXT NULL
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
    updated_at TEXT
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
    created_at TEXT,
    updated_at TEXT
  )
''');


  }

  Future<void> insertStudentList(Map<String, dynamic> student) async {
    final db = await instance.database;    await db.insert(
      'students_list',
      student,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertNotice(Map<String, dynamic> notice) async {
    final db = await instance.database;

    // Clean <p> tags if still present
    final cleanedDescription = notice['description']
        ?.replaceAll('<p>', '')
        .replaceAll('</p>', '');

    await db.insert(
      'notice_boards',
      {
        'id': notice['id'],
        'title': notice['title'],
        'date': notice['date'],
        'publish_date': notice['publish_date'],
        'description': cleanedDescription,
        'attachment': notice['attachment'],
        'is_visible_web': notice['is_visible_web'],
        'status': notice['status'],
        'visible_to': notice['visible_to'],
        'created_at': notice['created_at'],
        'updated_at': notice['updated_at'],
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  Future<void> insertStaff(Map<String, dynamic> staff) async {
    final db = await DatabaseHelper.instance.database;

    await db.insert(
      'staff',
      staff,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertSubjectAssign(Map<String, dynamic> subject_assigns) async {
    final db = await DatabaseHelper.instance.database;

    await db.insert(
      'subject_assigns',
      subject_assigns,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  Future<void> insertGrades(Map<String, dynamic> grades) async {
    final db = await DatabaseHelper.instance.database;

    await db.insert(
      'marks_grade',
      grades,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertSubjectAssignChildren(Map<String, dynamic> subject_assign_childrens) async {
    final db = await DatabaseHelper.instance.database;

    await db.insert(
      'subject_assign_childrens',
      subject_assign_childrens,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertBankAccounts(Map<String, dynamic> bank_accounts) async {
    final db = await DatabaseHelper.instance.database;

    await db.insert(
      'bank_accounts',
      bank_accounts,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  Future<void> insertFeeTransactions(Map<String, dynamic> transactions) async {
    final db = await DatabaseHelper.instance.database;

    await db.insert(
      'transactions',
      transactions,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> clearTransactions() async {
    final db = await instance.database;
    db.delete('loan');
    return await db.delete('transactions');
  }

  Future<void> insertFee(Map<String, dynamic> fee) async {
    final db = await DatabaseHelper.instance.database;

    await db.insert(
      'fees_masters',
      fee,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertFeeType(Map<String, dynamic> fee) async {
    final db = await DatabaseHelper.instance.database;

    await db.insert(
      'fees_type',
      fee,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> insertMarksRegisterChildren(Map<String, dynamic> data) async {
    final db = await DatabaseHelper.instance.database;

    // Prepare the map to insert
    final insertData = <String, dynamic>{
      'marks_register_id': data['marks_register_id'],
      'student_id': data['student_id'],
      'title': data['title'],
      'mark': data['mark'],
      'created_at': data['created_at']??'',
      'updated_at': data['updated_at']??'',
    };

    // Only include 'id' if it's not null
    if (data['id'] != null) {
      insertData['id'] = data['id'];
    }

    return await db.insert(
      'marks_register_childrens',
      insertData,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> insertMarksRegisterChildrenFromLogin(Map<String, dynamic> data) async {
    final db = await DatabaseHelper.instance.database;


    return await db.insert(
      'marks_register_childrens',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  Future<int> insertExam({
    required String sectionId,
    required String examTypeId,
    required String subjectId,
    required String classId,
    required String status,
    required List<Map<String, dynamic>> marks,
  }) async {
    final db = await DatabaseHelper.instance.database;

    // Convert the marks list to JSON
    String marksJson = jsonEncode(marks);

    // Insert into database and return the inserted row ID
    return await db.insert(
      'exams',
      {
        'sectionId': sectionId,
        'examTypeId': examTypeId,
        'subjectId': subjectId,
        'classId': classId,
        'marks': marksJson,
        'status': status// Fixed field name and format
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateExamStatusToOne(int examId) async {
    final db = await DatabaseHelper.instance.database;

    return await db.update(
      'exams',
      {'status': 1}, // Set status to 1
      where: 'id = ?',
      whereArgs: [examId],
    );
  }


  Future<bool> checkExamExists({
    required int sectionId,
    required int examTypeId,
    required int subjectId,
    required int classId,
  }) async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query(
      'exams',
      where: 'sectionId = ? AND examTypeId = ? AND subjectId = ? AND classId = ?',
      whereArgs: [sectionId, examTypeId, subjectId, classId],
    );

    return result.isNotEmpty;
  }

  Future<List<Map<String, Object?>>> getExamExists({
    required int id
  }) async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query(
      'exams',
      where: 'id = ?',
      whereArgs: [id],
    );

    return result;
  }

  Future<int> insertSection(Map<String, dynamic> section) async {
    final db = await DatabaseHelper.instance.database;
    return await db.insert('sections', section, conflictAlgorithm: ConflictAlgorithm.replace);
  }


  Future<List<String>> getAllSections() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> results = await db.query('sections');

    return results.map((row) => row['name'].toString()).toList();
  }

  Future<int> insertSubject(Map<String, dynamic> subject) async {
    final db = await DatabaseHelper.instance.database;
    return await db.insert('subjects', subject, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<String>> getAllSubjects() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> results = await db.query('subjects');

    return results.map((row) => row['name'].toString()).toList();
  }

  Future<int?> getClassIdByName(String className) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> results = await db.query(
      'classes',
      columns: ['id'],
      where: 'name = ?',
      whereArgs: [className],
    );

    if (results.isNotEmpty) {
      return results.first['id'] as int?;
    }
    return null;
  }

  Future<int?> getSectionIdByName(String sectionName) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> results = await db.query(
      'sections',
      columns: ['id'],
      where: 'name = ?',
      whereArgs: [sectionName],
    );

    if (results.isNotEmpty) {
      return results.first['id'] as int?;
    }
    return null;
  }

  Future<String> getSubjectNameById(String id) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> results = await db.query(
      'subjects',
      columns: ['name'],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first['name'];
    }
    return '';
  }

  Future<String> getGradeNameByMarks(String marks) async {
    final db = await instance.database;
    final double parsedMarks = double.tryParse(marks) ?? 0.0;

    final List<Map<String, dynamic>> results = await db.query(
      'marks_grade',
      columns: ['name'],
      where: '? BETWEEN percent_from AND percent_upto',
      whereArgs: [parsedMarks],
      orderBy: 'percent_from DESC', // Just in case overlapping ranges
      limit: 1,
    );

    if (results.isNotEmpty) {
      return results.first['name'] as String;
    }

    return 'No Grade'; // You can return an empty string or a default value
  }

  Future<String> getClassNameById(String id) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> results = await db.query(
      'classes',
      columns: ['name'],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first['name'];
    }
    return '';
  }

  Future<int?> getExamTypeIdByName(String sectionName) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> results = await db.query(
      'exam_types',
      columns: ['id'],
      where: 'name = ?',
      whereArgs: [sectionName],
    );

    if (results.isNotEmpty) {
      return results.first['id'] as int?;
    }
    return null;
  }

  Future<int?> getSubjectIdByName(String sectionName) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> results = await db.query(
      'subjects',
      columns: ['id'],
      where: 'name = ?',
      whereArgs: [sectionName],
    );

    if (results.isNotEmpty) {
      return results.first['id'] as int?;
    }
    return null;
  }



  Future<int> insertClasses(Map<String, dynamic> data) async {
    final db = await instance.database;
    return await db.insert('classes', data, conflictAlgorithm: ConflictAlgorithm.replace);
  }



  Future<List<String>> getAllClasses() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> results = await db.query('classes');

    return results.map((row) => row['name'].toString()).toList();
  }

  Future<int> insertExamTypes(Map<String, dynamic> examTypes) async {

    final db = await DatabaseHelper.instance.database;
    return await db.insert('exam_types', examTypes, conflictAlgorithm: ConflictAlgorithm.replace);

  }


  Future<List<String>> getExamTypes() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> results = await db.query('exam_types');

    return results.map((row) => row['name'].toString()).toList();
  }

  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await instance.database;
    return await db.insert('users', user, conflictAlgorithm: ConflictAlgorithm.replace);

  }

  Future<int> logOutUser() async {
    final db = await instance.database;
    await db.delete('transactions');
    await db.delete('loan');
    return await db.delete('users');

  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await instance.database;
    return await db.query('users');
  }

  Future<List<Map<String, dynamic>>> getStudents() async {
    final db = await instance.database;
    return await db.query('students');
  }

  Future<List<Map<String, dynamic>>> getCustomer() async {
    final db = await instance.database;
    return await db.query('customer');
  }

  Future<List<Map<String, dynamic>>> getAccountSetup() async {
    final db = await instance.database;
    return await db.query('account_setup');
  }

  Future<String> getBalance() async {
    final db = await instance.database;
    final result = await db.rawQuery('''
      SELECT 
        (IFNULL(SUM(CAST(total_expected_repayment_derived AS REAL)), 0) - IFNULL(SUM(CAST(total_repayment_derived AS REAL)), 0)) AS total 
      FROM loan
    ''');
    final total = result.first['total'];
    return total != null ? total.toString() : '0';
  }


  Future<String> getName(String phone) async {
    final db = await instance.database;

    final result = await db.rawQuery(
      '''
    SELECT display_name
    FROM customer
    WHERE mobile_no = ?
    ''',
      [phone],
    );

    if (result.isNotEmpty && result.first['display_name'] != null) {
      String fullName = result.first['display_name'].toString().trim();
      List<String> nameParts = fullName.split(' ');

      if (nameParts.length >= 2) {
        return '${nameParts[0]} ${nameParts[1]}';
      } else {
        return nameParts[0]; // Return just one name if only one exists
      }
    } else {
      return '';
    }
  }


  Future<List<Map<String, dynamic>>> getTransaction() async {
    final db = await instance.database;
    return await db.query(
      'transactions',
      orderBy: 'id DESC', // Change 'date' to your actual column name
    );
  }

  Future<List<Map<String, dynamic>>> getCharge() async {
    final db = await instance.database;
    return await db.query('transactions');
  }

  Future<List<Map<String, dynamic>>> getStaff() async {
    final db = await instance.database;
    return await db.query('staff');
  }

  Future<List<Map<String, dynamic>>> getTransactions() async {
    final db = await instance.database;
    List<Map<String, dynamic>> students = await getStudents();
    List<Map<String, dynamic>> result = [];
    if (students.isNotEmpty) {
       result = await db.rawQuery(
          '''
    SELECT transactions.*,students.full_name,bank_accounts.account_number FROM transactions
    INNER JOIN students ON students.id = transactions.student_id
    INNER JOIN bank_accounts ON bank_accounts.id = transactions.account_id
    WHERE transactions.student_id = ?
    ''',
          [students.first['id']]
      );
    }
    return result;
  }

  Future<List<Map<String, dynamic>>> getSchoolFees(int id) async {
    final db = await instance.database;
    List<Map<String, dynamic>> result = await db.rawQuery(
        '''
    SELECT *,fees_type.name as fee_name FROM fees_assignments
    INNER JOIN fees_masters ON fees_masters.id = fees_assignments.fees_master_id
    INNER JOIN fees_type ON fees_type.id = fees_masters.fees_type_id
    WHERE fees_assignments.student_id = ?
    ''',
        [id]
    );

    return result;
  }

  Future<Map<String, dynamic>?> getFirstStudent() async {
    List<Map<String, dynamic>> students = await getStudents();
    List<Map<String, dynamic>> users = await getUsers();

    if (students.isNotEmpty) {
      String remainedAmount = await getTotalFees(students.first['id'].toString()); // Await the async function

      return {
        'id': students.first['id'],
        'full_name': students.first['full_name'],
        'email': students.first['email'],
        'class_name': students.first['class_name'],
        'section_name': students.first['section_name'],
        'remained_amount':remainedAmount
      };
    }else if (users.isNotEmpty) {
      return {
        'id': users.first['id'],
        'full_name': users.first['name'],
        'email': users.first['email'],
        'class_name': '',
        'section_name': '',
        'remained_amount':'0'
      };
    }

    return null; // Return null if no users exist
  }

  Future<List<Map<String, dynamic>>> getStudentsWithDetails() async {
    List<Map<String, dynamic>> students = await getStudents();
    List<Map<String, dynamic>> users = await getUsers();
    List<Map<String, dynamic>> result = [];

    if (students.isNotEmpty) {
      for (var student in students) {
        String remainedAmount = await getTotalFees(student['id'].toString()); // You may want to customize this per student later
        result.add({
          'id': student['id'].toString(),
          'full_name': student['full_name'],
          'first_name': student['first_name'],
          'email': student['email' ],
          'class_name': student['class_name'],
          'section_name': student['section_name'],
          'remained_amount': remainedAmount.toString(),
        });
      }
    } else if (users.isNotEmpty) {
      for (var user in users) {
        result.add({
          'id': user['id'],
          'full_name': user['name'],
          'email': user['email'],
          'first_name': '',
          'class_name': '',
          'section_name': '',
          'remained_amount': '0',
        });
      }
    }

    return result;
  }

  Future<Map<String, dynamic>?> getFirstUser() async {
    List<Map<String, dynamic>> users = await getUsers();

    if (users.isNotEmpty) {
      return {
        'id': users.first['id'],
        'email': users.first['email'],
        'status': users.first['status'],
        'name': users.first['name'],
        'phone': users.first['phone'],
      };
    }

    return null; // Return null if no users exist
  }
  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await instance.database;
    final result =
    await db.query('users', where: 'email = ?', whereArgs: [email]);

    return result.isNotEmpty ? result.first : null;
  }

  Future<int> insertCustomer(Map<String, dynamic> user) async {
    try {
      final db = await instance.database;

      // Insert into customer table
      return await db.insert(
        'customer',
        user,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Error inserting customer: $e');
      return -1;
    }
  }


  Future<int> insertLoan(Map<String, dynamic> user) async {
    try {
      final db = await instance.database;
      // Get the columns of the customer table

      // Insert into loan table
      return await db.insert(
        'loan',
        user,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Error inserting customer: $e');
      return -1;
    }
  }



  Future<int> insertTransaction(Map<String, dynamic> transaction) async {
    try {
      final db = await instance.database;

      return await db.insert(
        'transactions',
        transaction,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Error inserting transaction: $e');
      return -1;
    }
  }

  Future<int> insertUsersCredentials(Map<String, dynamic> transaction) async {
    try {
      final db = await instance.database;
      return await db.insert(
        'user_credentials',
        transaction,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Error inserting transaction: $e');
      return -1;
    }
  }

  Future<int> insertCharge(Map<String, dynamic> transaction) async {
    try {
      final db = await instance.database;

      return await db.insert(
        'mechant_charge_configurations',
        transaction,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Error inserting transaction: $e');
      return -1;
    }
  }


  Future<int> insertStatus(Map<String, dynamic> transaction) async {
    try {
      final db = await instance.database;

      return await db.insert(
        'status',
        transaction,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Error inserting transaction: $e');
      return -1;
    }
  }


  Future<int> insertBalance(Map<String, dynamic> balance) async {
    try {
      // Convert all values to String
      Map<String, String> stringStudent = balance.map((key, value) => MapEntry(key, value?.toString() ?? ''));

      final db = await instance.database;

      // Insert using converted map
      return await db.insert(
        'balance',
        stringStudent,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Error inserting student: $e');
      return -1;
    }
  }

  Future<int> insertAccount(Map<String, dynamic> account) async {
    try {
      // Convert all values to String
      Map<String, String> stringStudent = account.map((key, value) => MapEntry(key, value?.toString() ?? ''));

      final db = await instance.database;

      // Insert using converted map
      return await db.insert(
        'account_setup',
        stringStudent,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Error inserting student: $e');
      return -1;
    }
  }


  Future<int> insertStudent(Map<String, dynamic> student) async {
    try {
      // Convert all values to String
      Map<String, String> stringStudent = student.map((key, value) => MapEntry(key, value?.toString() ?? ''));

      final db = await instance.database;

      // Insert using converted map
      return await db.insert(
        'students',
        stringStudent,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Error inserting student: $e');
      return -1;
    }
  }

  Future<int> insertParent(Map<String, dynamic> parent) async {
    final db = await instance.database;
    return await db.insert('parent_details', parent, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> insertFeesAssignment(Map<String, dynamic> data) async {
    final db = await instance.database;
    await db.delete(
      'fees_assignments',
      where: 'id = ?',
      whereArgs: [data['id']],
    );
    return await db.insert('fees_assignments', data);
  }
  Future<int> insertFeesAssignChildren(Map<String, dynamic> data) async {
    final db = await instance.database;
    await db.delete(
      'fees_assign_children',
      where: 'id = ?',
      whereArgs: [data['id']],
    );
    return await db.insert('fees_assign_children', data);
  }

  Future<Map<String, dynamic>?> getStudentById(int id) async {
    final db = await instance.database;
    final result = await db.rawQuery('''
    SELECT students.*, parent_details.guardian_mobile, parent_details.guardian_name,parent_details.guardian_email,sections.id as section_id
    FROM students
    INNER JOIN parent_details ON parent_details.id = students.parent_guardian_id
    INNER JOIN sections ON sections.name = students.section_name
    WHERE students.id = ?
  ''', [id]);

    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }
  // Function to sum amount from fees_assignments table
  Future<String> getTotalFees(String studentId) async {
    final db = await instance.database;

    List<Map<String, dynamic>> result = await db.rawQuery(
      "SELECT SUM(remained_amount) as total FROM fees_assignments WHERE student_id = ?",
      [studentId],
    );

    String total = result.first["total"] != null
        ? result.first["total"].toString()
        : "0.0";

    print(total);
    return total;
  }
  Future<Map<String, dynamic>?> getFeesDetails(int id) async {
    final db = await instance.database;
    final result = await db.query('fees_assignments', where: 'id = ?', whereArgs: [id]);

    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }

  // Function to update user status by ID
  Future<int> updateUserStatus(int userId) async {
    final db = await database;
    return await db.update(
      'users',
      {'status': 2}, // Update status to 2
      where: 'id = ?',
      whereArgs: [userId],
    );
  }



  // Returns true if user_credentials table is not empty
  Future<bool> hasUserCredentials() async {
    final db = await instance.database;
    final result = await db.query('user_credentials', limit: 1);
    return result.isNotEmpty;
  }
}
