import 'package:drift/drift.dart';
import 'drift_database.dart';

/// Simple Drift Web Database Helper (similar to betap's approach)
/// This wraps the existing AppDatabase with cleaner methods
class DriftWebDatabaseHelper {
  static final DriftWebDatabaseHelper _instance = DriftWebDatabaseHelper._internal();
  factory DriftWebDatabaseHelper() => _instance;
  
  AppDatabase? _db;
  
  DriftWebDatabaseHelper._internal() {
    // Don't initialize here to avoid multiple instances
    print('DriftWebDatabaseHelper created');
  }
  
  AppDatabase get _database {
    _db ??= AppDatabase();
    return _db!;
  }
  
  // Customer operations
  Future<void> saveCustomer(Map<String, dynamic> customerData) async {
    try {
      await _database.into(_database.customer).insertOnConflictUpdate(CustomerCompanion.insert(
        displayName: Value(customerData['display_name']),
        externalId: Value(customerData['external_id']),
        mobileNo: Value(customerData['mobile_no']),
        accountNo: Value(null),
        otp: Value(null),
        loanAmount: Value(customerData['loan_amount']?.toString()),
        remainLoanAmount: Value(customerData['remain_loan_amount']?.toString()),
      ));
      print('Customer saved to Drift web database successfully');
    } catch (e) {
      print('Error saving customer to Drift web database: $e');
      rethrow;
    }
  }
  
  Future<List<CustomerData>> getAllCustomers() async {
    try {
      return await _database.select(_database.customer).get();
    } catch (e) {
      print('Error getting customers from Drift web database: $e');
      return [];
    }
  }
  
  // Loan operations
  Future<void> saveLoan(Map<String, dynamic> loanData) async {
    try {
      print("loanData");
      print(loanData);
      
      // Delete all existing loan data to maintain only one record
      await _database.delete(_database.loan).go();
      print('Existing loan data deleted');
      
      await _database.into(_database.loan).insertOnConflictUpdate(LoanCompanion.insert(
        clientId: Value(loanData['client_id']?.toString()),
        totalExpectedRepaymentDerived: Value(loanData['total_expected_repayment_derived']?.toString()),
        totalRepaymentDerived: Value(loanData['total_repayment_derived']?.toString()),
        principalRepaidDerived: Value(null),
        principalAmount: Value(null),
      ));
      print('Loan saved to Drift web database successfully');
    } catch (e) {
      print('Error saving loan to Drift web database: $e');
      rethrow;
    }
  }
  
  // Transaction operations
  Future<void> saveTransaction(Map<String, dynamic> transactionData) async {
    try {
       print("transactionData");
       print(transactionData);
        await _database.into(_database.transactions).insertOnConflictUpdate(TransactionsCompanion.insert(
          id: Value(transactionData['id'] != null ? int.parse(transactionData['id'].toString()) : 0),
        msisdn: Value(transactionData['msisdn']),
        amount: Value(transactionData['amount'] != null ? double.parse(transactionData['amount'].toString()) : null),
        reference: Value(transactionData['reference']),
        type: Value(transactionData['type']),
        status: Value(transactionData['status']),
        settlementStatus: Value(transactionData['settlement_status']),
        mechantId: Value(transactionData['mechant_id'] != null ? int.parse(transactionData['mechant_id'].toString()) : null),
        charge: Value(transactionData['charge']),
        receivingAccountId: Value(transactionData['receiving_account_id']),
        totalAmount: Value(transactionData['total_amount']),
        settlementId: Value(transactionData['settlement_id']),
        settlementDate: Value(transactionData['settlement_date']),
        transactionId: Value(transactionData['transaction_id']),
        createdAt: Value(transactionData['created_at']),
        updatedAt: Value(transactionData['updated_at']),
        description: Value(transactionData['description']),
      ));
      print('Transaction saved to Drift web database successfully');
    } catch (e) {
      print("transactionData2");
      print(e);
      print('Error saving transaction to Drift web database: $e');
      rethrow;
    }
  }
  
  Future<List<Transaction>> getAllTransactions() async {
    try {
      return await _database.select(_database.transactions).get();
    } catch (e) {
      print('Error getting transactions from Drift web database: $e');
      return [];
    }
  }
  
  // User Credentials operations
  Future<void> saveUserCredentials(Map<String, dynamic> credentialsData) async {
    try {
      await _database.into(_database.userCredentials).insertOnConflictUpdate(UserCredentialsCompanion.insert(
        name: credentialsData['name'] ?? '',
        email: credentialsData['email'] ?? '',
        phone: credentialsData['phone'] ?? '',
        status: credentialsData['status'] ?? '',
        password: Value(credentialsData['password']),
        emailVerifiedAt: Value(null), // DateTimeColumn
        rememberToken: Value(null),
        otp: Value(null),
        otpVerified: Value(null),
        // Note: createdAt and updatedAt have defaults, so we don't need to set them
      ));
      print('User credentials saved to Drift web database successfully');
    } catch (e) {
      print('Error saving user credentials to Drift web database: $e');
      rethrow;
    }
  }
  
  // Status operations
  Future<void> saveStatus(Map<String, dynamic> statusData) async {
    try {
      await _database.into(_database.status).insertOnConflictUpdate(StatusCompanion.insert(
        id: Value(statusData['id'] != null ? int.parse(statusData['id'].toString()) : 0),
        name: statusData['name'] ?? '',
        createdAt: Value(statusData['created_at']),
        updatedAt: Value(statusData['updated_at']),
      ));
      print('Status saved to Drift web database successfully');
    } catch (e) {
      print('Error saving status to Drift web database: $e');
      rethrow;
    }
  }
  
  // Loan Status operations
  Future<void> saveLoanStatus(Map<String, dynamic> loanStatusData) async {
    try {
      print("loanStatusData");
      print(loanStatusData);
      await _database.into(_database.loanStatus).insertOnConflictUpdate(LoanStatusCompanion.insert(
        // Note: id is autoIncrement, so we don't set it manually
        loanId: Value(loanStatusData['loan_id']?.toString()),
        status: Value(loanStatusData['status']),
        description: Value(loanStatusData['description']),
        clientName: Value(loanStatusData['client_name']),
        createdAt: Value(loanStatusData['created_at']),
        updatedAt: Value(loanStatusData['updated_at']),
      ));
      print('Loan status saved to Drift web database successfully');
    } catch (e) {
      print("loanStatusData2");
      print(e);
      print('Error saving loan status to Drift web database: $e');
      rethrow;
    }
  }
  
  Future<List<LoanStatusData>> getAllLoanStatuses() async {
    try {
      return await _database.select(_database.loanStatus).get();
    } catch (e) {
      print('Error getting loan statuses from Drift web database: $e');
      return [];
    }
  }
  
  // Loan Schedule operations
  Future<void> saveLoanSchedule(Map<String, dynamic> loanScheduleData) async {
    try {
      await _database.into(_database.loanSchedule).insertOnConflictUpdate(LoanScheduleCompanion.insert(
        id: Value(loanScheduleData['id'] != null ? int.parse(loanScheduleData['id'].toString()) : 0),
        loanId: Value(loanScheduleData['loan_id'] != null ? int.parse(loanScheduleData['loan_id'].toString()) : null),
        fromDate: Value(loanScheduleData['fromdate']),
        dueDate: Value(loanScheduleData['duedate']),
        installment: Value(loanScheduleData['installment'] != null ? int.parse(loanScheduleData['installment'].toString()) : null),
        totalAmountToBePaid: Value(loanScheduleData['total_amount_to_be_paid'] != null ? double.parse(loanScheduleData['total_amount_to_be_paid'].toString()) : null),
        totalAmount: Value(loanScheduleData['total_amount'] != null ? double.parse(loanScheduleData['total_amount'].toString()) : null),
        paidAmount: Value(loanScheduleData['paid_amount'] != null ? double.parse(loanScheduleData['paid_amount'].toString()) : (loanScheduleData['paid'] != null ? double.parse(loanScheduleData['paid'].toString()) : 0.0)),
        remainedAmount: Value(loanScheduleData['remained_amount'] != null ? double.parse(loanScheduleData['remained_amount'].toString()) : (loanScheduleData['remained'] != null ? double.parse(loanScheduleData['remained'].toString()) : 0.0)),
        completedDerived: Value(loanScheduleData['completed_derived'] != null ? int.parse(loanScheduleData['completed_derived'].toString()) : null),
      ));
      print('Loan schedule saved to Drift web database successfully');
    } catch (e) {
      print('Error saving loan schedule to Drift web database: $e');
      rethrow;
    }
  }
  
  Future<List<LoanScheduleData>> getAllLoanSchedules() async {
    try {
      return await _database.select(_database.loanSchedule).get();
    } catch (e) {
      print('Error getting loan schedules from Drift web database: $e');
      return [];
    }
  }

  // Support Tickets operations
  Future<void> saveSupportTicket(Map<String, dynamic> supportTicketData) async {
    try {
      print("supportTicketData");
      print(supportTicketData);
      // Note: This assumes support_tickets table exists in Drift schema
      // If the table doesn't exist, you'll need to add it to drift_database.dart
      // Using customStatement for raw SQL insert
      await _database.customStatement(
        '''
        INSERT OR REPLACE INTO support_tickets 
        (id, ticket_id, query_type, query, status, priority, response, created_at, updated_at)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
        ''',
        [
          supportTicketData['id'] != null ? int.parse(supportTicketData['id'].toString()) : 0,
          supportTicketData['ticket_id']?.toString() ?? '',
          supportTicketData['query_type']?.toString() ?? '',
          supportTicketData['query']?.toString() ?? '',
          supportTicketData['status']?.toString() ?? '',
          supportTicketData['priority']?.toString() ?? '',
          supportTicketData['response']?.toString() ?? '',
          supportTicketData['created_at']?.toString() ?? DateTime.now().toIso8601String(),
          supportTicketData['updated_at']?.toString() ?? DateTime.now().toIso8601String(),
        ],
      );
      print('Support ticket saved to Drift web database successfully');
    } catch (e) {
      print('Error saving support ticket to Drift web database: $e');
      // Don't rethrow - support tickets are optional data
      print('Continuing without support ticket data...');
    }
  }

  // Get next payment from loan schedule (where completed_derived is not 1)
  Future<Map<String, dynamic>?> getNextPayment() async {
    try {
      final schedules = await (_database.select(_database.loanSchedule)
          ..where((tbl) => tbl.completedDerived.equals(1).not())
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.id)])
          ..limit(1))
          .get();
      
      if (schedules.isNotEmpty) {
        final schedule = schedules.first;
        return {
          'total_amount': schedule.totalAmount,
          'duedate': schedule.dueDate,
        };
      }
      return null;
    } catch (e) {
      print('Error getting next payment from Drift web database: $e');
      return null;
    }
  }

  // Clear all data
  Future<void> clearAllData() async {
    try {
      await _database.delete(_database.customer).go();
      await _database.delete(_database.loan).go();
      await _database.delete(_database.transactions).go();
      await _database.delete(_database.userCredentials).go();
      await _database.delete(_database.status).go();
      await _database.delete(_database.loanStatus).go();
      await _database.delete(_database.loanSchedule).go();
      print('All data cleared from Drift web database successfully');
    } catch (e) {
      print('Error clearing data from Drift web database: $e');
      rethrow;
    }
  }
}
