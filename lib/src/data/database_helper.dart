import 'dart:convert';
import 'database_factory.dart';
import 'database_interface.dart';

/// DatabaseHelper now uses platform-aware database implementation
/// - Uses Drift for web platform
/// - Uses SQLite for mobile platforms
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  late final DatabaseInterface _db;

  DatabaseHelper._init() {
    _db = DatabaseFactory.instance;
  }

  Future<DatabaseInterface> get database async {
    await _db.initialize();
    return _db;
  }

  // Platform check helpers
  bool get isWeb => DatabaseFactory.isWeb;
  bool get isMobile => DatabaseFactory.isMobile;

  // Helper method to get ConflictAlgorithm.replace
  ConflictAlgorithm get _replace => ConflictAlgorithm.replace;

  Future<void> insertStudentList(Map<String, dynamic> student) async {
    final db = await instance.database;
    await db.insert(
      'students_list',
      student,
      conflictAlgorithm: _replace,
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
      conflictAlgorithm: _replace,
    );
  }

  Future<void> insertStaff(Map<String, dynamic> staff) async {
    final db = await DatabaseHelper.instance.database;

    await db.insert(
      'staff',
      staff,
      conflictAlgorithm: _replace,
    );
  }

  Future<void> insertSubjectAssign(Map<String, dynamic> subject_assigns) async {
    final db = await DatabaseHelper.instance.database;

    await db.insert(
      'subject_assigns',
      subject_assigns,
      conflictAlgorithm: _replace,
    );
  }

  Future<void> insertGrades(Map<String, dynamic> grades) async {
    final db = await DatabaseHelper.instance.database;

    await db.insert(
      'marks_grade',
      grades,
      conflictAlgorithm: _replace,
    );
  }

  Future<void> insertSubjectAssignChildren(Map<String, dynamic> subject_assign_childrens) async {
    final db = await DatabaseHelper.instance.database;

    await db.insert(
      'subject_assign_childrens',
      subject_assign_childrens,
      conflictAlgorithm: _replace,
    );
  }

  Future<void> insertBankAccounts(Map<String, dynamic> bank_accounts) async {
    final db = await DatabaseHelper.instance.database;

    await db.insert(
      'bank_accounts',
      bank_accounts,
      conflictAlgorithm: _replace,
    );
  }

  Future<void> insertFeeTransactions(Map<String, dynamic> transactions) async {
    final db = await DatabaseHelper.instance.database;

    // Define valid columns for the transactions table
    final validColumns = {
      'id',
      'msisdn',
      'amount',
      'reference',
      'type',
      'status',
      'mechant_id',
      'settlement_status',
      'charge',
      'receiving_account_id',
      'total_amount',
      'settlement_id',
      'settlement_date',
      'transaction_id',
      'created_at',
      'updated_at',
      'description',
    };

    // Filter transaction map to only include valid columns
    final filteredTransaction = <String, dynamic>{};
    transactions.forEach((key, value) {
      if (validColumns.contains(key)) {
        filteredTransaction[key] = value;
      }
    });

    await db.insert(
      'transactions',
      filteredTransaction,
      conflictAlgorithm: _replace,
    );
  }

  Future<int> clearTransactions() async {
    final db = await instance.database;
    await db.delete('loan');
    return await db.delete('transactions');
  }

  Future<void> insertFee(Map<String, dynamic> fee) async {
    final db = await DatabaseHelper.instance.database;

    await db.insert(
      'fees_masters',
      fee,
      conflictAlgorithm: _replace,
    );
  }

  Future<void> insertFeeType(Map<String, dynamic> fee) async {
    final db = await DatabaseHelper.instance.database;

    await db.insert(
      'fees_type',
      fee,
      conflictAlgorithm: _replace,
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
      'created_at': data['created_at'] ?? '',
      'updated_at': data['updated_at'] ?? '',
    };

    // Only include 'id' if it's not null
    if (data['id'] != null) {
      insertData['id'] = data['id'];
    }

    return await db.insert(
      'marks_register_childrens',
      insertData,
      conflictAlgorithm: _replace,
    );
  }

  Future<int> insertMarksRegisterChildrenFromLogin(Map<String, dynamic> data) async {
    final db = await DatabaseHelper.instance.database;

    return await db.insert(
      'marks_register_childrens',
      data,
      conflictAlgorithm: _replace,
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
        'status': status
      },
      conflictAlgorithm: _replace,
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
    return await db.insert('sections', section, conflictAlgorithm: _replace);
  }

  Future<List<String>> getAllSections() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> results = await db.query('sections');

    return results.map((row) => row['name'].toString()).toList();
  }

  Future<int> insertSubject(Map<String, dynamic> subject) async {
    final db = await DatabaseHelper.instance.database;
    return await db.insert('subjects', subject, conflictAlgorithm: _replace);
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

    final List<Map<String, dynamic>> results = await db.rawQuery(
      'SELECT name FROM marks_grade WHERE ? BETWEEN percent_from AND percent_upto ORDER BY percent_from DESC LIMIT 1',
      [parsedMarks],
    );

    if (results.isNotEmpty) {
      return results.first['name'] as String;
    }

    return 'No Grade';
  }

  Future<String> getClassNameById(String id) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> results = await db.query(
      'classes',
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
    return await db.insert('classes', data, conflictAlgorithm: _replace);
  }

  Future<List<String>> getAllClasses() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> results = await db.query('classes');

    return results.map((row) => row['name'].toString()).toList();
  }

  Future<int> insertExamTypes(Map<String, dynamic> examTypes) async {
    final db = await DatabaseHelper.instance.database;
    return await db.insert('exam_types', examTypes, conflictAlgorithm: _replace);
  }

  Future<List<String>> getExamTypes() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> results = await db.query('exam_types');

    return results.map((row) => row['name'].toString()).toList();
  }

  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await instance.database;
    return await db.insert('users', user, conflictAlgorithm: _replace);
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
        return nameParts[0];
      }
    } else {
      return '';
    }
  }

  Future<List<Map<String, dynamic>>> getTransaction() async {
    final db = await instance.database;
    final results = await db.rawQuery(
      'SELECT * FROM transactions ORDER BY id DESC',
    );
    return results;
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
      String remainedAmount = await getTotalFees(students.first['id'].toString());

      return {
        'id': students.first['id'],
        'full_name': students.first['full_name'],
        'email': students.first['email'],
        'class_name': students.first['class_name'],
        'section_name': students.first['section_name'],
        'remained_amount': remainedAmount
      };
    } else if (users.isNotEmpty) {
      return {
        'id': users.first['id'],
        'full_name': users.first['name'],
        'email': users.first['email'],
        'class_name': '',
        'section_name': '',
        'remained_amount': '0'
      };
    }

    return null;
  }

  Future<List<Map<String, dynamic>>> getStudentsWithDetails() async {
    List<Map<String, dynamic>> students = await getStudents();
    List<Map<String, dynamic>> users = await getUsers();
    List<Map<String, dynamic>> result = [];

    if (students.isNotEmpty) {
      for (var student in students) {
        String remainedAmount = await getTotalFees(student['id'].toString());
        result.add({
          'id': student['id'].toString(),
          'full_name': student['full_name'],
          'first_name': student['first_name'],
          'email': student['email'],
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

    return null;
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await instance.database;
    final result = await db.query('users', where: 'email = ?', whereArgs: [email]);

    return result.isNotEmpty ? result.first : null;
  }

  Future<int> insertCustomer(Map<String, dynamic> user) async {
    try {
      final db = await instance.database;

      // Ensure loan_amount and remain_loan_amount are included
      final customerData = {
        ...user,
        'loan_amount': user['loan_amount']?.toString(),
        'remain_loan_amount': user['remain_loan_amount']?.toString(),
      };

      return await db.insert(
        'customer',
        customerData,
        conflictAlgorithm: _replace,
      );
    } catch (e) {
      print('Error inserting customer: $e');
      return -1;
    }
  }

  Future<int> insertLoan(Map<String, dynamic> user) async {
    try {
      final db = await instance.database;

      return await db.insert(
        'loan',
        user,
        conflictAlgorithm: _replace,
      );
    } catch (e) {
      print('Error inserting loan: $e');
      return -1;
    }
  }

  Future<int> insertTransaction(Map<String, dynamic> transaction) async {
    try {
      final db = await instance.database;

      // Define valid columns for the transactions table
      final validColumns = {
        'id',
        'msisdn',
        'amount',
        'reference',
        'type',
        'status',
        'mechant_id',
        'settlement_status',
        'charge',
        'receiving_account_id',
        'total_amount',
        'settlement_id',
        'settlement_date',
        'transaction_id',
        'created_at',
        'updated_at',
        'description',
      };

      // Filter transaction map to only include valid columns
      final filteredTransaction = <String, dynamic>{};
      transaction.forEach((key, value) {
        if (validColumns.contains(key)) {
          filteredTransaction[key] = value;
        }
      });

      return await db.insert(
        'transactions',
        filteredTransaction,
        conflictAlgorithm: _replace,
      );
    } catch (e) {
      print('Error inserting transaction: $e');
      return -1;
    }
  }

  Future<int> insertUsersCredentials(Map<String, dynamic> transaction) async {
    try {
      final db = await instance.database;

      // Define valid columns for the user_credentials table
      final validColumns = {
        'id',
        'name',
        'email',
        'phone',
        'status',
        'email_verified_at',
        'password',
        'password_hash',
        'username',
        'remember_token',
        'otp',
        'otp_verified',
        'created_at',
        'updated_at',
      };

      // Filter transaction map to only include valid columns
      final filteredCredentials = <String, dynamic>{};
      transaction.forEach((key, value) {
        if (validColumns.contains(key) && value != null) {
          filteredCredentials[key] = value;
        }
      });

      // Check if record exists (by email or username) to preserve existing required fields
      Map<String, dynamic>? existingRecord;
      final email = filteredCredentials['email']?.toString().trim();
      final username = filteredCredentials['username']?.toString().trim();
      
      if (email != null && email.isNotEmpty) {
        final results = await db.query(
          'user_credentials',
          where: 'email = ?',
          whereArgs: [email],
        );
        if (results.isNotEmpty) {
          existingRecord = results.first;
        }
      } else if (username != null && username.isNotEmpty) {
        final results = await db.query(
          'user_credentials',
          where: 'username = ?',
          whereArgs: [username],
        );
        if (results.isNotEmpty) {
          existingRecord = results.first;
        }
      }

      // Merge with existing record to preserve required NOT NULL fields
      if (existingRecord != null) {
        filteredCredentials['name'] ??= existingRecord['name'];
        filteredCredentials['email'] ??= existingRecord['email'];
        filteredCredentials['phone'] ??= existingRecord['phone'];
        filteredCredentials['status'] ??= existingRecord['status'];
        // Preserve id if not provided
        filteredCredentials['id'] ??= existingRecord['id'];
      } else {
        // For new records, provide defaults for required NOT NULL fields
        final phoneValue = filteredCredentials['phone']?.toString().trim();
        filteredCredentials['name'] ??= username ?? phoneValue ?? 'User';
        filteredCredentials['email'] ??= email ?? (username != null && username.isNotEmpty 
            ? '$username@example.com' 
            : 'user@example.com');
        filteredCredentials['phone'] ??= phoneValue ?? username ?? '';
        filteredCredentials['status'] ??= '1';
      }

      return await db.insert(
        'user_credentials',
        filteredCredentials,
        conflictAlgorithm: _replace,
      );
    } catch (e) {
      print('Error inserting user credentials: $e');
      return -1;
    }
  }

  Future<int> insertCharge(Map<String, dynamic> transaction) async {
    try {
      final db = await instance.database;

      return await db.insert(
        'mechant_charge_configurations',
        transaction,
        conflictAlgorithm: _replace,
      );
    } catch (e) {
      print('Error inserting charge: $e');
      return -1;
    }
  }

  Future<int> insertStatus(Map<String, dynamic> transaction) async {
    try {
      final db = await instance.database;

      return await db.insert(
        'status',
        transaction,
        conflictAlgorithm: _replace,
      );
    } catch (e) {
      print('Error inserting status: $e');
      return -1;
    }
  }

  Future<int> insertLoanStatus(Map<String, dynamic> loanStatus) async {
    try {
      final db = await instance.database;

      return await db.insert(
        'loan_status',
        loanStatus,
        conflictAlgorithm: _replace,
      );
    } catch (e) {
      print('Error inserting loan status: $e');
      return -1;
    }
  }

  Future<int> insertLoanSchedule(Map<String, dynamic> loanSchedule) async {
    try {
      print(loanSchedule);
      final db = await instance.database;

      // Map API field names to database column names
      final mappedData = <String, dynamic>{};
      
      // Copy all fields first
      loanSchedule.forEach((key, value) {
        mappedData[key] = value;
      });
      
      // Handle paid_amount/paid field mapping
      if (mappedData.containsKey('paid') && !mappedData.containsKey('paid_amount')) {
        mappedData['paid_amount'] = mappedData['paid'];
        mappedData.remove('paid');
      } else if (!mappedData.containsKey('paid_amount')) {
        mappedData['paid_amount'] = 0; // Default value if not present
      }
      
      // Handle remained_amount/remained field mapping
      if (mappedData.containsKey('remained') && !mappedData.containsKey('remained_amount')) {
        mappedData['remained_amount'] = mappedData['remained'];
        mappedData.remove('remained');
      } else if (!mappedData.containsKey('remained_amount')) {
        mappedData['remained_amount'] = 0; // Default value if not present
      }
      
      // Map other field names if needed (for loan details API format)
      // Always remove installment_number if it exists (table doesn't have this column)
      // Use installment_number value if installment is missing
      if (mappedData.containsKey('installment_number')) {
        if (!mappedData.containsKey('installment')) {
          mappedData['installment'] = mappedData['installment_number'];
        }
        // Always remove installment_number to avoid SQL error
        mappedData.remove('installment_number');
      }
      
      if (mappedData.containsKey('due_date') && !mappedData.containsKey('duedate')) {
        mappedData['duedate'] = mappedData['due_date'];
        mappedData.remove('due_date');
      }

      return await db.insert(
        'loan_schedule',
        mappedData,
        conflictAlgorithm: _replace,
      );
    } catch (e) {
      print('Error inserting loan schedule: $e');
      return -1;
    }
  }

  Future<int> insertSupportTicket(Map<String, dynamic> supportTicket) async {
    try {
      print(supportTicket);
      final db = await instance.database;

      return await db.insert(
        'support_tickets',
        {
          'id': supportTicket['id'],
          'ticket_id': supportTicket['ticket_id'],
          'query_type': supportTicket['query_type'],
          'query': supportTicket['query'],
          'status': supportTicket['status'],
          'priority': supportTicket['priority'],
          'response': supportTicket['response'],
          'created_at': supportTicket['created_at'],
          'updated_at': supportTicket['updated_at'],
        },
        conflictAlgorithm: _replace,
      );
    } catch (e) {
      print('Error inserting support ticket: $e');
      return -1;
    }
  }

  // Get next payment from loan schedule (where completed_derived is not 1)
  Future<Map<String, dynamic>?> getNextPayment() async {
    try {
      final db = await instance.database;
      final result = await db.rawQuery('''
        SELECT total_amount, duedate 
        FROM loan_schedule 
        WHERE completed_derived != 1 
        ORDER BY id ASC 
        LIMIT 1
      ''');
      
      if (result.isNotEmpty) {
        return {
          'total_amount': result.first['total_amount'],
          'duedate': result.first['duedate'],
        };
      }
      return null;
    } catch (e) {
      print('Error getting next payment from SQLite database: $e');
      return null;
    }
  }

  Future<int> insertBalance(Map<String, dynamic> balance) async {
    try {
      Map<String, String> stringStudent = balance.map((key, value) => MapEntry(key, value?.toString() ?? ''));

      final db = await instance.database;

      return await db.insert(
        'balance',
        stringStudent,
        conflictAlgorithm: _replace,
      );
    } catch (e) {
      print('Error inserting balance: $e');
      return -1;
    }
  }

  Future<int> insertAccount(Map<String, dynamic> account) async {
    try {
      Map<String, String> stringStudent = account.map((key, value) => MapEntry(key, value?.toString() ?? ''));

      final db = await instance.database;

      return await db.insert(
        'account_setup',
        stringStudent,
        conflictAlgorithm: _replace,
      );
    } catch (e) {
      print('Error inserting account: $e');
      return -1;
    }
  }

  Future<int> insertStudent(Map<String, dynamic> student) async {
    try {
      Map<String, String> stringStudent = student.map((key, value) => MapEntry(key, value?.toString() ?? ''));

      final db = await instance.database;

      return await db.insert(
        'students',
        stringStudent,
        conflictAlgorithm: _replace,
      );
    } catch (e) {
      print('Error inserting student: $e');
      return -1;
    }
  }

  Future<int> insertParent(Map<String, dynamic> parent) async {
    final db = await instance.database;
    return await db.insert('parent_details', parent, conflictAlgorithm: _replace);
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

  Future<int> updateUserStatus(int userId) async {
    final db = await database;
    return await db.update(
      'users',
      {'status': 2},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  Future<bool> hasUserCredentials() async {
    final db = await instance.database;
    final result = await db.rawQuery('SELECT * FROM user_credentials LIMIT 1');
    return result.isNotEmpty;
  }
}
