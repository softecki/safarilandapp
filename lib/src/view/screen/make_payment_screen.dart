import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../core/app_color.dart';
import '../../../core/app_data.dart';
import '../../../generated/assets.dart';
import '../../data/database_helper.dart';
import '../../data/drift_web_database_helper.dart';
import '../widget/custom_button.dart';
import '../widget/custom_text_field.dart';
import '../widget/dropdown.dart';
import 'home_screen.dart';

class MakePayment extends StatefulWidget {
  final String phone;
  MakePayment(String this.phone, {super.key});

  @override
  _MakePaymentState createState() => _MakePaymentState();
}

class _MakePaymentState extends State<MakePayment> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController selectedServiceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguageCode = prefs.getString('selected_language_code');
      
      if (savedLanguageCode != null && mounted) {
        context.setLocale(Locale(savedLanguageCode));
      } else {
        // Default to Swahili if no preference is saved
        if (mounted) {
          context.setLocale(Locale('sw'));
        }
      }
    } catch (e) {
      print('Error loading saved language: $e');
      // Fallback to Swahili on error
      if (mounted) {
        context.setLocale(Locale('sw'));
      }
    }
  }

  @override
  void dispose() {
    phoneController.dispose();
    amountController.dispose();
    selectedServiceController.dispose();
    super.dispose();
  }

  String generateReferenceNumberWithPrefix(String prefix) {
    final now = DateTime.now();
    final formatted = '${now.day.toString().padLeft(2, '0')}'
        '${now.hour.toString().padLeft(2, '0')}'
        '${now.minute.toString().padLeft(2, '0')}'
        '${now.second.toString().padLeft(2, '0')}';
    return '$prefix$formatted';
  }
  Future<void> register(BuildContext context) async {

    if(phoneController.text.length < 10){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Enter_full_phonenumber_to_proceed".tr(),
            style: const TextStyle(color: Colors.white), // White text
          ),
          backgroundColor: Colors.red, // Red background
          behavior: SnackBarBehavior.floating, // Optional: makes it float
        ),
      );
      return;
    }

    if(int.parse(amountController.text) < 1000){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Enter_correct_amount_above_1000_TZS".tr(),
            style: const TextStyle(color: Colors.white), // White text
          ),
          backgroundColor: Colors.red, // Red background
          behavior: SnackBarBehavior.floating, // Optional: makes it float
        ),
      );
      return;
    }

    if(selectedServiceController.text.length < 2){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Select_Payment_Service".tr(),
            style: const TextStyle(color: Colors.white), // White text
          ),
          backgroundColor: Colors.red, // Red background
          behavior: SnackBarBehavior.floating, // Optional: makes it float
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: AppColor.primaryColor,),
      ),
    );
    final url = Uri.parse(AppData.url+'/transaction');
    String referenceNumber = generateReferenceNumberWithPrefix("MTPW");
    final requestPayload = {
      'sender_account': phoneController.text,
      'amount': amountController.text,
      'phone': widget.phone,
      'reference':referenceNumber,
      'service': selectedServiceController.text,
    };
    
    print('=== TRANSACTION REQUEST ===');
    print('URL: $url');
    print('Request Payload: ${jsonEncode(requestPayload)}');
    
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestPayload),
    );
    
    print('=== TRANSACTION RESPONSE ===');
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');
    print('Response Headers: ${response.headers}');
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      final transactionData = responseBody['data']['transaction'];
      final balanceData = responseBody['data']['balance'];
      if(transactionData != null) {
        for (var transaction in transactionData) {
          await DatabaseHelper.instance.insertTransaction(transaction);
        }
      }

      if(balanceData != null) {
        for (var balance in balanceData) {
          await DatabaseHelper.instance.insertBalance(balance);
        }
      }

      // Start progress dialog and check payment status
      _showProgressDialog(context, referenceNumber, widget.phone);
    } else {
      Navigator.of(context).pop();
      final errorMsg = jsonDecode(response.body)['message'] ?? 'Registration_Failed'.tr();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMsg)),
      );
    }
  }

  void _showProgressDialog(BuildContext context, String referenceNumber, String phone) {
    Navigator.of(context).pop(); // Close the loading dialog
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ProgressDialog(
          referenceNumber: referenceNumber,
          phone: phone,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade300,
        title: Text(
          "",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              // Sunken Image Container
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: Offset(-3, -3),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                    BoxShadow(
                      color: Colors.white.withOpacity(0.9),
                      offset: Offset(3, 3),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Image.asset(
                  Assets.imagesMalipoMtandao1,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),


              Text(
                "Make_your_sale_securely_and_conveniently_with_Malipo_Mtandao_Simply_select_a_payment_service_then_enter_your_number_and_the_amount".tr(),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 15),
              MobileMoneyDropdown(selectedServiceController),
              const SizedBox(height: 15),
              // Sunken Phone Input
              _buildSunkenField(
                child: CustomTextField(
                  hintText: "Enter_Phone_number".tr(),
                  icon: Icons.phone,
                  controller: phoneController,
                  keyboardType: TextInputType.number,
                ),
              ),

              const SizedBox(height: 15),

              // Sunken Amount Input
              _buildSunkenField(
                child: CustomTextField(
                  hintText: "Enter_Amount".tr(),
                  icon: Icons.money_sharp,
                  controller: amountController,
                  keyboardType: TextInputType.number,
                ),
              ),

              const SizedBox(height: 15),

              // Sunken Button
              _buildSunkenField(
                child: CustomButton(
                  onPressed: () => register(context),
                  text: 'Pay'.tr(),
                ),
              ),
            ],
          ),
        ),
      ),
    );

     }

  Widget _buildSunkenField({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: Offset(-3, -3),
            blurRadius: 6,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.9),
            offset: Offset(3, 3),
            blurRadius: 6,
            spreadRadius: 1,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: child,
    );
  }

}

class ProgressDialog extends StatefulWidget {
  final String referenceNumber;
  final String phone;
  const ProgressDialog({Key? key, required this.referenceNumber, required this.phone}) : super(key: key);

  @override
  _ProgressDialogState createState() => _ProgressDialogState();
}

class _ProgressDialogState extends State<ProgressDialog> {
  String status = 'Processing'.tr() + '...';
  int elapsedSeconds = 0;
  Timer? _timer;
  Timer? _statusTimer;
  Timer? _settlementTimer;
  bool _isCheckingSettlement = false;

  @override
  void initState() {
    super.initState();
    _startStatusCheck();
    _startElapsedTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _statusTimer?.cancel();
    _settlementTimer?.cancel();
    super.dispose();
  }

  /// Platform-specific database storage function
  /// Uses SQLite for mobile (Android/iOS) and Drift for web
  Future<void> _saveUserDataToDatabase(Map<String, dynamic>? userMap, Map<String, dynamic> data) async {
    try {
      // Platform check
      final isWeb = kIsWeb;
      
      if (isWeb) {
        // Web platform - Use DriftWebDatabaseHelper
        await _saveToDriftWebDatabase(userMap, data);
      } else {
        // Mobile platform - Use SQLite database
        await _saveToSQLiteDatabase(userMap, data);
      }
    } catch (e) {
      print('Error saving data to database: $e');
    }
  }

  /// Save data to Drift web database
  Future<void> _saveToDriftWebDatabase(Map<String, dynamic>? userMap, Map<String, dynamic> data) async {
    try {
      final driftHelper = DriftWebDatabaseHelper();
      
      // Save customer data
      if (userMap != null && userMap.isNotEmpty) {
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
      
      print('Data saved to Drift web database successfully');
    } catch (e) {
      print('Error saving to Drift web database: $e');
    }
  }

  /// Save data to SQLite database (Mobile platform)
  Future<void> _saveToSQLiteDatabase(Map<String, dynamic>? userMap, Map<String, dynamic> data) async {
    try {
      // Save user data
      if (userMap != null && userMap.isNotEmpty) {
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
      print('Error saving to SQLite database: $e');
    }
  }

  void _startElapsedTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        elapsedSeconds++;
      });
      
      // Check for timeout after 3 minutes (180 seconds)
      if (elapsedSeconds >= 180) {
        _handleTimeout();
      }
    });
  }

  void _startStatusCheck() {
    _checkStatus();
    _statusTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      _checkStatus();
    });
  }

  Future<void> _checkStatus() async {
    try {
      final url = Uri.parse(AppData.url + '/checkStatus');
      final requestPayload = {
        'reference': widget.referenceNumber,
        'phone': widget.phone,
      };
      
      print('=== CHECK STATUS REQUEST ===');
      print('URL: $url');
      print('Request Payload: ${jsonEncode(requestPayload)}');
      
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestPayload),
      );
      
      print('=== CHECK STATUS RESPONSE ===');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      print('Response Headers: ${response.headers}');
      
      final responseBody = jsonDecode(response.body);
      print('Parsed Response Body: $responseBody');
      if (response.statusCode == 200) {
        
        final paymentStatus = responseBody['data']['payment_status'];
        final transactionId = responseBody['data']['transaction_id'];
        final loanSchedule = responseBody['data']['loan_schedule'];
        final loan = responseBody['data']['loan'];
        final transactions = responseBody['data']['transactions'];
        
        setState(() {
          if (transactionId != null) {
            status = '${'Status'.tr()}: $paymentStatus\n${'Transaction_ID'.tr()}: $transactionId';
          } else {
            status = '${'Status'.tr()}: $paymentStatus';
          }
        });

        if (paymentStatus == 'completed') {
          await _saveUserDataToDatabase(null, responseBody['data']);
          _handleSuccess();
          // _startSettlementCheck();
        }
      } else {
        setState(() {
          status = 'Error_checking_status'.tr();
        });
      }
    } catch (e) {
      setState(() {
        status = '${'Error'.tr()}: $e';
      });
    }
  }

  void _startSettlementCheck() {
    _isCheckingSettlement = true;
    _statusTimer?.cancel(); // Stop payment status checking
    _settlementTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      _checkSettlementStatus();
    });
    _checkSettlementStatus(); // Check immediately
  }

  Future<void> _checkSettlementStatus() async {
    try {
      final url = Uri.parse(AppData.url + '/settlementStatus');
      final requestPayload = {
        'reference': widget.referenceNumber,
        'phone': widget.phone,
      };
      
      print('=== CHECK SETTLEMENT STATUS REQUEST ===');
      print('URL: $url');
      print('Request Payload: ${jsonEncode(requestPayload)}');
      
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestPayload),
      );

      print('=== CHECK SETTLEMENT STATUS RESPONSE ===');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      print('Response Headers: ${response.headers}');

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        print('Parsed Settlement Status Response: $responseBody');
        final settlementStatus = responseBody['data']['settlement_status'];
        
        setState(() {
          status = '${'Payment_completed_Checking_settlement'.tr()}...\n${'Settlement'.tr()}: $settlementStatus';
        });

        if (settlementStatus == 'completed') {
          // Save updated data to database when settlement is completed
          await _saveUserDataToDatabase(null, responseBody['data']);
          _settlementTimer?.cancel();
          _handleSuccess();
        }
      } else {
        setState(() {
          status = 'Error_checking_settlement_status'.tr();
        });
      }
    } catch (e) {
      setState(() {
        status = '${'Settlement_check_error'.tr()}: $e';
      });
    }
  }

  void _handleSuccess() {
    _timer?.cancel();
    _statusTimer?.cancel();
    _settlementTimer?.cancel();
    
    Navigator.of(context).pop();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Payment_completed_successfully".tr(),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(builder: (context) => HomeScreen())
    );
  }

  void _handleTimeout() {
    _timer?.cancel();
    _statusTimer?.cancel();
    _settlementTimer?.cancel();
    
    Navigator.of(context).pop();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isCheckingSettlement 
            ? "Settlement_timeout_Please_check_your_transaction_status_later".tr()
            : "Payment_timeout_Please_check_your_transaction_status_later".tr(),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(builder: (context) => HomeScreen())
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: AppColor.primaryColor),
          SizedBox(height: 20),
          Text(
            status,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            '${'Reference'.tr()}: ${widget.referenceNumber}',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            '${'Elapsed'.tr()}: ${elapsedSeconds}s',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            'Please_wait_while_we_process_your_payment'.tr(),
            style: const TextStyle(fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
