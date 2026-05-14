import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wicom/core/app_color.dart';
import 'package:wicom/src/data/database_helper.dart';
import 'package:wicom/src/data/drift_database.dart';
import 'package:wicom/src/utils/navigation_helper.dart';
import 'package:wicom/src/view/widget/top_navigation_bar.dart';
import 'package:wicom/src/view/screen/client_screen.dart';
import 'package:wicom/src/view/screen/support_screen.dart';
import 'package:wicom/src/view/screen/profile_screen.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:convert';
import '../../../core/app_data.dart';
import '../../data/drift_web_database_helper.dart';
import 'make_payment_screen.dart';
import 'transactions_list_screen.dart';
import 'transaction_detail_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentNavIndex = 0;

  // Navigation screens
  static List<Widget> screens = [
    const DashboardContent(), // Dashboard content will be moved to separate widget
    ClientScreen(),
    SupportScreen(),
    ProfileScreen(),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Top Navigation Bar
          TopNavigationBar(
            currentIndex: _currentNavIndex,
            onTap: (index) {
              setState(() {
                _currentNavIndex = index;
              });
            },
          ),
          
          // Content Area
          Expanded(
            child: screens[_currentNavIndex],
          ),
        ],
      ),
    );
  }

}

// Dashboard Content Widget (moved from main build method)
class DashboardContent extends StatefulWidget {
  const DashboardContent({Key? key}) : super(key: key);

  @override
  _DashboardContentState createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent> {
  String _loanBalance = '0.00';
  String _name = '';
  String _loanAmount = '0.00';
  String _remainLoanAmount = '0.00';
  bool _showBalance = false;
  bool _isLoading = true;
  final NumberFormat _currencyFormat = NumberFormat.currency(symbol: 'TZS ', decimalDigits: 0);
  final List<Map<String, dynamic>> _recentTransactions = [];
  
  // Loan schedule data
  String _nextPaymentAmount = '0';
  String _nextPaymentDate = 'N/A';

  @override
  void initState() {
    super.initState();
    _loadSavedLanguage();
    _loadDashboardData();
  }

  Future<void> _loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguageCode = prefs.getString('selected_language_code');
      
      if (savedLanguageCode != null && mounted) {
        context.setLocale(Locale(savedLanguageCode));
      }
    } catch (e) {
      print('Error loading saved language: $e');
    }
  }

  Future<void> _loadDashboardData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentStudent = prefs.getString('code_number') ?? '';
      
      // First try to get from SharedPreferences (fastest)
      String? savedName = prefs.getString('display_name');
      String? savedRemainLoanAmount = prefs.getString('remain_loan_amount');
      String? savedLoanAmount = prefs.getString('loan_amount');
      
      // Platform-specific database operations
      final isWeb = kIsWeb;
      
      String balance;
      String name;
      String loanAmount;
      String remainLoanAmount;
      List<Map<String, dynamic>> transactions;
      Map<String, dynamic>? nextPayment;
      
      if (isWeb) {
        // Web platform - Use Drift database
        balance = await _getBalanceFromDrift();
        // Use saved name from SharedPreferences if available, otherwise fetch from database
        name = savedName ?? await _getNameFromDrift(currentStudent);
        final loanData = await _getLoanAmountsFromDrift();
        // Use saved values from SharedPreferences if available
        loanAmount = savedLoanAmount ?? loanData['loan_amount'] ?? '0.00';
        remainLoanAmount = savedRemainLoanAmount ?? loanData['remain_loan_amount'] ?? '0.00';
        transactions = await _getTransactionsFromDrift();
        nextPayment = await _getNextPaymentFromDrift();
      } else {
        // Mobile platform - Use SQLite database
        final rawBalance = await DatabaseHelper.instance.getBalance();
        balance = NumberFormat('#,##0.00').format(double.tryParse(rawBalance) ?? 0);
        // Use saved name from SharedPreferences if available, otherwise fetch from database
        name = savedName ?? await DatabaseHelper.instance.getName(currentStudent);
        final loanData = await _getLoanAmountsFromSQLite();
        // Use saved values from SharedPreferences if available, otherwise use database values
        loanAmount = savedLoanAmount ?? loanData['loan_amount'] ?? '0.00';
        remainLoanAmount = savedRemainLoanAmount ?? loanData['remain_loan_amount'] ?? '0.00';
        transactions = await _getTransactionsFromSQLite();
        nextPayment = await DatabaseHelper.instance.getNextPayment();
        print("nextPayment");
        print(nextPayment);
      }
      
      // Log loaded data for debugging
      print('Dashboard data loaded:');
      print('name: $name');
      print('loanAmount: $loanAmount');
      print('remainLoanAmount: $remainLoanAmount');
      print('balance: $balance');

      setState(() {
        // Use remain_loan_amount as the loan balance if available
        // Format the loan balance with commas for display
        String loanBalanceValue = remainLoanAmount != '0.00' && remainLoanAmount.isNotEmpty 
            ? remainLoanAmount 
            : balance;
        
        // Format the number with commas (remove any existing formatting first)
        try {
          final balanceNum = double.tryParse(loanBalanceValue.replaceAll(',', '')) ?? 0;
          _loanBalance = NumberFormat('#,##0.00').format(balanceNum);
        } catch (e) {
          _loanBalance = loanBalanceValue;
        }
        
        _loanAmount = loanAmount;
        _remainLoanAmount = remainLoanAmount;
        // Use full name if available, otherwise use first name
        _name = name.isNotEmpty ? name : (savedName ?? 'User'.tr());
        _recentTransactions.clear();
        _recentTransactions.addAll(transactions.take(5));
        
        // Set loan schedule data
        if (nextPayment != null) {
          _nextPaymentAmount = nextPayment['total_amount']?.toString() ?? '0';
          _nextPaymentDate = nextPayment['duedate']?.toString() ?? 'N/A';
        } else {
          _nextPaymentAmount = '0';
          _nextPaymentDate = 'N/A';
        }
        
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading dashboard data: $e');
      setState(() => _isLoading = false);
    }
  }

  /// Drift database functions for web platform
  
  /// Get loan balance from Drift database
  Future<String> _getBalanceFromDrift() async {
    try {
      final driftDb = AppDatabase();
      final loans = await driftDb.select(driftDb.loan).get();
      print("loans");
      print(loans);
      
      if (loans.isNotEmpty) {
        final loan = loans.first;
        print("loan");
        print(loan.totalExpectedRepaymentDerived);
        print(loan.totalRepaymentDerived);
        final expected = double.tryParse(loan.totalExpectedRepaymentDerived ?? '0') ?? 0;
        final repaid = double.tryParse(loan.totalRepaymentDerived ?? '0') ?? 0;
        final balance = expected - repaid;
        return NumberFormat('#,##0.00').format(balance);
      }
      return '0.00';
    } catch (e) {
      print('Error getting balance from Drift: $e');
      return '0.00';
    }
  }

  /// Get user name from Drift database
  Future<String> _getNameFromDrift(String phone) async {
    try {
      final driftDb = AppDatabase();
      final customers = await driftDb.select(driftDb.customer).get();
      
      if (customers.isNotEmpty) {
        final customer = customers.first;
        return customer.displayName ?? 'User'.tr();
      }
      return 'User'.tr();
    } catch (e) {
      print('Error getting name from Drift: $e');
      return 'User'.tr();
    }
  }

  /// Get loan amounts from Drift database
  Future<Map<String, String>> _getLoanAmountsFromDrift() async {
    try {
      final driftDb = AppDatabase();
      final customers = await driftDb.select(driftDb.customer).get();
      
      if (customers.isNotEmpty) {
        final customer = customers.first;
        return {
          'loan_amount': customer.loanAmount ?? '0.00',
          'remain_loan_amount': customer.remainLoanAmount ?? '0.00',
        };
      }
      return {'loan_amount': '0.00', 'remain_loan_amount': '0.00'};
    } catch (e) {
      print('Error getting loan amounts from Drift: $e');
      return {'loan_amount': '0.00', 'remain_loan_amount': '0.00'};
    }
  }

  /// Get loan amounts from SQLite database
  Future<Map<String, String>> _getLoanAmountsFromSQLite() async {
    try {
      final db = await DatabaseHelper.instance.database;
      final customers = await db.query('customer');
      
      if (customers.isNotEmpty) {
        final customer = customers.first;
        return {
          'loan_amount': customer['loan_amount']?.toString() ?? '0.00',
          'remain_loan_amount': customer['remain_loan_amount']?.toString() ?? '0.00',
        };
      }
      return {'loan_amount': '0.00', 'remain_loan_amount': '0.00'};
    } catch (e) {
      print('Error getting loan amounts from SQLite: $e');
      return {'loan_amount': '0.00', 'remain_loan_amount': '0.00'};
    }
  }

  /// Get transactions from Drift database
  Future<List<Map<String, dynamic>>> _getTransactionsFromDrift() async {
    try {
      final driftDb = AppDatabase();
      final transactions = await (driftDb.select(driftDb.transactions)
          ..where((tbl) => tbl.status.equals('3'))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)]))
          .get();
      
      return transactions.map((txn) => {
        'id': txn.id,
        'msisdn': txn.msisdn,
        'amount': txn.amount,
        'reference': txn.reference,
        'type': txn.type,
        'status': txn.status,
        'settlement_status': txn.settlementStatus,
        'mechant_id': txn.mechantId,
        'charge': txn.charge,
        'receiving_account_id': txn.receivingAccountId,
        'total_amount': txn.totalAmount,
        'settlement_id': txn.settlementId,
        'settlement_date': txn.settlementDate,
        'transaction_id': txn.transactionId,
        'created_at': txn.createdAt,
        'updated_at': txn.updatedAt,
        'date': txn.createdAt,
        'description': 'Transaction ${txn.reference}',
      }).toList();
    } catch (e) {
      print('Error getting transactions from Drift: $e');
      return [];
    }
  }

  /// Get transactions from SQLite database filtered by status == 3
  Future<List<Map<String, dynamic>>> _getTransactionsFromSQLite() async {
    try {
      final db = await DatabaseHelper.instance.database;
      final results = await db.rawQuery(
        'SELECT * FROM transactions WHERE status = ? ORDER BY id DESC',
        ['3'],
      );
      return results;
    } catch (e) {
      print('Error getting transactions from SQLite: $e');
      return [];
    }
  }

  /// Platform-specific refresh function
  Future<void> _refreshDashboardData() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentStudent = prefs.getString('code_number') ?? '';
      
      // Platform-specific database operations
      final isWeb = kIsWeb;
      
      String balance;
      String name;
      List<Map<String, dynamic>> transactions;
      
      if (isWeb) {
        // Web platform - Use Drift database
        balance = await _getBalanceFromDrift();
        name = await _getNameFromDrift(currentStudent);
        transactions = await _getTransactionsFromDrift();
      } else {
        // Mobile platform - Use SQLite database
        final rawBalance = await DatabaseHelper.instance.getBalance();
        balance = NumberFormat('#,##0.00').format(double.tryParse(rawBalance) ?? 0);
        name = await DatabaseHelper.instance.getName(currentStudent);
        transactions = await _getTransactionsFromSQLite();
      }

      setState(() {
        _loanBalance = balance;
        _name = name;
        _recentTransactions.clear();
        _recentTransactions.addAll(transactions.take(5));
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Dashboard_data_refreshed_successfully".tr()),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print('Error refreshing dashboard data: $e');
      setState(() => _isLoading = false);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${'Error_refreshing_data'.tr()}: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Refresh data by calling login endpoint and updating local data
  Future<void> _refreshData() async {
    try {
      // Show loading indicator
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(
          child: CircularProgressIndicator(
            color: AppColor.primaryColor,
          ),
        ),
      );

      // Get saved credentials
      final prefs = await SharedPreferences.getInstance();
      final savedPhone = prefs.getString('saved_phone') ?? '';
      final savedPassword = prefs.getString('saved_password') ?? '';

      if (savedPhone.isEmpty || savedPassword.isEmpty) {
        if (mounted) {
          Navigator.of(context, rootNavigator: true).pop(); // Dismiss loading dialog
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('No_saved_credentials_found_Please_login_again'.tr()),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      // Call login endpoint
      final url = Uri.parse('${AppData.url}/login');
      final info = await PackageInfo.fromPlatform();
      final versionCode = info.buildNumber;
      final versionName = info.version;
      
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'phone': savedPhone,
          'password': savedPassword,
          'version_name': versionName,
          'version_code': versionCode,
        }),
      );

      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop(); // Dismiss loading dialog

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final data = responseBody['data'];

        if (data == null) {
          throw Exception('No data in response');
        }

        final userData = data['user'];
        if (userData == null) {
          throw Exception('User data not found in response');
        }

        // Update user data in shared preferences
        await prefs.setString(
            'control_number', userData['external_id']?.toString() ?? '0');
        await prefs.setString(
            'code_number', userData['mobile_no']?.toString() ?? '0');
        
        final staffStatus = data['staff'] ?? false;
        await prefs.setBool('is_staff', staffStatus);

        // Prepare user data for local storage
        final userMap = {
          'display_name': userData['display_name']?.toString() ?? '',
          'mobile_no': userData['mobile_no']?.toString() ?? '',
          'external_id': userData['external_id']?.toString() ?? '',
          'loan_amount': userData['loan_amount']?.toString(),
          'remain_loan_amount': userData['remain_loan_amount']?.toString(),
        };

        // Save to local database with platform-specific handling
        await _saveUserDataToDatabase(userMap, data);
        
        // Restart the dashboard to show updated data
        if (mounted) {
          setState(() {
            _isLoading = true;
          });
         
          await _loadDashboardData();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Data_refreshed_successfully'.tr()),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        throw Exception('${'Login_failed_with_status'.tr()}: ${response.statusCode}');
      }
    } catch (e) {
      print('Error refreshing data: $e');
      
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop(); // Dismiss loading dialog
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${'Error_refreshing_data'.tr()}: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
      }
    }
  }

  /// Platform-specific database storage function
  /// Uses SQLite for mobile (Android/iOS) and Drift for web
  Future<void> _saveUserDataToDatabase(Map<String, dynamic> userMap, Map<String, dynamic> data) async {
    try {
      // Platform check
      final isWeb = kIsWeb;
      print("Platform check - isWeb: $isWeb");
      
      if (isWeb) {
        // Web platform - Use DriftWebDatabaseHelper
        print("Using DriftWebDatabaseHelper for web platform");
        try {
          await _saveToDriftWebDatabase(userMap, data);
        } catch (e) {
          print('Drift database failed, falling back to SharedPreferences: $e');
          await _saveToSharedPreferences(userMap, data);
        }
      } else {
        // Mobile platform - Use SQLite database
        print("Using SQLite database for mobile platform");
        await _saveToSQLiteDatabase(userMap, data);
      }
    } catch (e) {
      print('Error saving data to database: $e');
      // Continue with refresh even if database save fails
    }
  }

  /// Save data to Drift web database using DriftWebDatabaseHelper
  Future<void> _saveToDriftWebDatabase(Map<String, dynamic> userMap, Map<String, dynamic> data) async {
    print('Saving to Drift web database using DriftWebDatabaseHelper');
    print('UserMap: $userMap');
    print('Data keys: ${data.keys.toList()}');
    
    try {
      final driftHelper = DriftWebDatabaseHelper();
      
      // Save customer data
      if (userMap.isNotEmpty) {
        print('Saving customer data...');
        await driftHelper.saveCustomer(userMap);
        print('Customer data saved successfully');
      } else {
        print('No customer data to save');
      }
      
      // Handle loan data if exists
      if (data['loan'] != null && data['loan'].isNotEmpty) {
        final loanData = data['loan'] as List?;
        if (loanData != null && loanData.isNotEmpty) {
          await driftHelper.saveLoan(loanData[0]);
        }
      }

      // Handle transaction data if exists
      if (data['transaction'] != null && data['transaction'].isNotEmpty) {
        final transactionData = data['transaction'] as List?;
        if (transactionData != null && transactionData.isNotEmpty) {
          for (var transaction in transactionData) {
            await driftHelper.saveTransaction(transaction);
          }
        }
      }

      // Handle user credentials if exists
      if (data['user_credentials'] != null && data['user_credentials'].isNotEmpty) {
        final userCredentials = data['user_credentials'];
        if (userCredentials != null && userCredentials.isNotEmpty) {
          await driftHelper.saveUserCredentials(userCredentials);
        }
      }

      // Handle status list if exists
      if (data['status'] != null && data['status'].isNotEmpty) {
        final statusList = data['status'] as List?;
        if (statusList != null && statusList.isNotEmpty) {
          for (var status in statusList) {
            await driftHelper.saveStatus(status);
          }
        }
      }

      // Handle loan status data if exists
      if (data['loan_status'] != null && data['loan_status'].isNotEmpty) {
        final loanStatusData = data['loan_status'] as List?;
        if (loanStatusData != null) {
          for (var loanStatus in loanStatusData) {
            await driftHelper.saveLoanStatus(loanStatus);
          }
        }
      }

      // Handle loan schedule data if exists
      if (data['loan_schedule'] != null && data['loan_schedule'].isNotEmpty) {
        final loanScheduleData = data['loan_schedule'] as List?;
        if (loanScheduleData != null) {
          for (var loanSchedule in loanScheduleData) {
            await driftHelper.saveLoanSchedule(loanSchedule);
          }
        }
      }
      
      print('Data saved to Drift web database successfully using helper');
    } catch (e) {
      print('Error saving data to Drift web database: $e');
      rethrow;
    }
  }

  /// Save data to SQLite database (Mobile platform)
  Future<void> _saveToSQLiteDatabase(Map<String, dynamic> userMap, Map<String, dynamic> data) async {
    print('Saving to SQLite database (Mobile platform)');
    print('UserMap: $userMap');
    print('Data keys: ${data.keys.toList()}');
    
    try {
      // Save user data
      if (userMap.isNotEmpty) {
        print('Saving customer data to SQLite...');
        await DatabaseHelper.instance.insertCustomer(userMap);
        print('Customer data saved to SQLite successfully');
      } else {
        print('No customer data to save to SQLite');
      }

      // Handle loan data if exists
      if (data['loan'] != null && data['loan'].isNotEmpty) {
        final loanData = data['loan'] as List?;
        if (loanData != null && loanData.isNotEmpty) {
          final loan = {
            'id': loanData[0]['id'],
            'client_id': loanData[0]['client_id']?.toString() ?? '',
            'total_expected_repayment_derived':
                loanData[0]['total_expected_repayment_derived']?.toString() ?? '0',
            'total_repayment_derived':
                loanData[0]['total_repayment_derived']?.toString() ?? '0',
          };
          await DatabaseHelper.instance.insertLoan(loan);
        }
      }

      // Handle transaction data if exists
      if (data['transaction'] != null && data['transaction'].isNotEmpty) {
        final transactionData = data['transaction'] as List?;
        if (transactionData != null) {
          for (var transaction in transactionData) {
            print('Transaction new new: $transaction');
            await DatabaseHelper.instance.insertTransaction(transaction);
          }
        }
      }

      // Handle user credentials if exists
      if (data['user_credentials'] != null && data['user_credentials'].isNotEmpty) {
        final userCredentials = data['user_credentials'];
        if (userCredentials != null) {
          await DatabaseHelper.instance.insertUsersCredentials(userCredentials);
        }
      }

      // Handle status list if exists
      if (data['status'] != null && data['status'].isNotEmpty) {
        final statusList = data['status'] as List?;
        if (statusList != null) {
          for (var status in statusList) {
            await DatabaseHelper.instance.insertStatus(status);
          }
        }
      }

      // Handle loan status data if exists
      if (data['loan_status'] != null && data['loan_status'].isNotEmpty) {
        final loanStatusData = data['loan_status'] as List?;
        if (loanStatusData != null) {
          for (var loanStatus in loanStatusData) {
            await DatabaseHelper.instance.insertLoanStatus(loanStatus);
          }
        }
      }

      // Handle loan schedule data if exists
      if (data['loan_schedule'] != null && data['loan_schedule'].isNotEmpty) {
        final loanScheduleData = data['loan_schedule'] as List?;
        if (loanScheduleData != null) {
          for (var loanSchedule in loanScheduleData) {
            await DatabaseHelper.instance.insertLoanSchedule(loanSchedule);
          }
        }
      }
      
      print('Data saved to SQLite database successfully');
    } catch (e) {
      print('Error saving data to SQLite database: $e');
      rethrow;
    }
  }

  /// Fallback method to save data to SharedPreferences if database fails
  Future<void> _saveToSharedPreferences(Map<String, dynamic> userMap, Map<String, dynamic> data) async {
    print('Saving to SharedPreferences as fallback');
    
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Save user data to SharedPreferences
      if (userMap.isNotEmpty) {
        await prefs.setString('user_display_name', userMap['display_name'] ?? '');
        await prefs.setString('user_external_id', userMap['external_id'] ?? '');
        await prefs.setString('user_mobile_no', userMap['mobile_no'] ?? '');
        print('User data saved to SharedPreferences');
      }
      
      // Save other data as JSON strings
      if (data['loan'] != null) {
        await prefs.setString('loan_data', jsonEncode(data['loan']));
      }
      if (data['transaction'] != null) {
        await prefs.setString('transaction_data', jsonEncode(data['transaction']));
      }
      if (data['user_credentials'] != null) {
        await prefs.setString('user_credentials_data', jsonEncode(data['user_credentials']));
      }
      
      print('Data saved to SharedPreferences successfully');
    } catch (e) {
      print('Error saving to SharedPreferences: $e');
      rethrow;
    }
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return RefreshIndicator(
      onRefresh: _refreshDashboardData,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: theme.primaryColor.withOpacity(0.1),
                  child: Text(
                    _name.isNotEmpty ? _name[0].toUpperCase() : 'U',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColor.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome_back'.tr(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      _name.isNotEmpty ? _name : 'User'.tr(),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Iconsax.refresh),
                  onPressed: _refreshData,
                  tooltip: 'Refresh Data',
                ),
               
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Balance Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColor.primaryColor,
                    AppColor.primaryColor.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.primaryColor.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(
                  //   'TOTAL_LOAN_BALANCE'.tr(),
                  //   style: const TextStyle(
                  //     color: Colors.white70,
                  //     fontSize: 12,
                  //     fontWeight: FontWeight.w500,
                  //   ),
                  // ),
                  // const SizedBox(height: 8),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: Text(
                  //         _showBalance ? 'TZS $_loanBalance' : '••••••••',
                  //         style: const TextStyle(
                  //           color: Colors.white,
                  //           fontSize: 28,
                  //           fontWeight: FontWeight.bold,
                  //           letterSpacing: 0.5,
                  //         ),
                  //       ),
                  //     ),
                  //     IconButton(
                  //       icon: Icon(
                  //         _showBalance ? Iconsax.eye_slash : Iconsax.eye,
                  //         color: Colors.white,
                  //         size: 20,
                  //       ),
                  //       onPressed: () {
                  //         setState(() {
                  //           _showBalance = !_showBalance;
                  //         });
                  //       },
                  //     ),
                  //   ],
                  // ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final prefs = await SharedPreferences.getInstance();
                            final phone = prefs.getString('code_number') ?? '';
                            if (!mounted) return;
                            NavigationHelper.navigateTo(
                              context,
                              MakePayment(phone),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColor.primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: const Icon(Iconsax.money_send, size: 18),
                          label: Text('Make_Payment'.tr()),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            const SizedBox(height: 12),
            
            // Next Payment Stats
            // Row(
            //   children: [
            //     _buildStatCard(
            //       'Next_Payment'.tr(),
            //       _currencyFormat.format(double.tryParse(_nextPaymentAmount) ?? 0),
            //       Iconsax.calendar,
            //       Colors.blue,
            //     ),
            //     const SizedBox(width: 12),
            //     _buildStatCard(
            //       _isDateOverdue() ? 'Overdue_Due_Date'.tr() : 'Due_Date'.tr(),
            //       _nextPaymentDate,
            //       Iconsax.calendar_1,
            //       _isDateOverdue() ? Colors.red : Colors.green,
            //     ),
            //   ],
            // ),
            
            const SizedBox(height: 24),
            
            // Recent Transactions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent_Transactions'.tr(),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    NavigationHelper.navigateTo(
                      context,
                      const TransactionsListScreen(),
                    );
                  },
                  child: Text('View_All'.tr()),
                ),
              ],
            ),
            
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_recentTransactions.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32.0),
                child: Center(
                  child: Text(
                    'No_recent_transactions'.tr(),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              ..._recentTransactions.map((txn) => _buildTransactionItem(txn)),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> transaction) {
    print(transaction);
    final isCredit = transaction['type'] == 'credit';
    final date = DateTime.parse(transaction['created_at'] ?? DateTime.now().toString());
    
    return InkWell(
      onTap: () {
        NavigationHelper.navigateTo(
          context,
          TransactionDetailScreen(transaction: transaction),
          showLoader: false,
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isCredit 
                    ? Colors.green.withOpacity(0.1) 
                    : Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isCredit ? Iconsax.arrow_down : Iconsax.arrow_down,
                color: isCredit ? Colors.green : Colors.green,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction['description'] ?? 'Transaction',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${date.day}/${date.month}/${date.year}',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              ' ${_currencyFormat.format(transaction['amount'] ?? 0)}',
              style: TextStyle(
                color: isCredit ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Get next payment from Drift database
  Future<Map<String, dynamic>?> _getNextPaymentFromDrift() async {
    try {
      final driftDb = AppDatabase();
      final schedules = await (driftDb.select(driftDb.loanSchedule)
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
      print('Error getting next payment from Drift: $e');
      return null;
    }
  }

  /// Check if the due date has passed
  bool _isDateOverdue() {
    if (_nextPaymentDate == 'N/A' || _nextPaymentDate.isEmpty) {
      return false;
    }
    
    try {
      // Try to parse the date - handle different formats
      DateTime? dueDate;
      
      // Try different date formats
      List<String> dateFormats = [
        'yyyy-MM-dd',
        'dd/MM/yyyy',
        'MM/dd/yyyy',
        'dd-MM-yyyy',
        'yyyy/MM/dd',
      ];
      
      for (String format in dateFormats) {
        try {
          dueDate = DateFormat(format).parse(_nextPaymentDate);
          break;
        } catch (e) {
          // Continue to next format
        }
      }
      
      if (dueDate == null) {
        // If all formats fail, try parsing as ISO string
        dueDate = DateTime.tryParse(_nextPaymentDate);
      }
      
      if (dueDate == null) {
        return false;
      }
      
      // Check if the due date is before today
      final today = DateTime.now();
      final todayOnly = DateTime(today.year, today.month, today.day);
      final dueDateOnly = DateTime(dueDate.year, dueDate.month, dueDate.day);
      
      return dueDateOnly.isBefore(todayOnly);
    } catch (e) {
      print('Error parsing due date: $e');
      return false;
    }
  }

}

