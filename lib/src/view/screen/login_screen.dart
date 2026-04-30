import 'package:easy_localization/easy_localization.dart';
import 'package:wicom/core/app_color.dart';
import 'package:wicom/src/view/screen/home_screen.dart';
import 'package:wicom/src/view/screen/change_pin_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/app_data.dart';
import '../../data/database_helper.dart';
import '../../data/drift_web_database_helper.dart';
import '../../static.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController secondPhoneController = TextEditingController();
  bool _obscureText = true;
  bool _showSecondPhoneForm = false;

  @override
  void initState() {
    super.initState();
    _checkUserCredentials();
  }

  void _checkUserCredentials() async {
    // Load saved language preference
    await _loadSavedLanguage();
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
          // Save the default preference
          await prefs.setString('selected_language_code', 'sw');
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

  /// Platform-specific database storage function
  /// Uses SQLite for mobile (Android/iOS) and Drift for web
  Future<void> _saveUserDataToDatabase(Map<String, dynamic> userMap, Map<String, dynamic> data) async {
    try {
      // Platform check
      final isWeb = kIsWeb;
      print("Platform check - isWeb: $isWeb");
      
      if (isWeb) {
        // Web platform - Use DriftWebDatabaseHelper
        try {
          await _saveToDriftWebDatabase(userMap, data);
        } catch (e) {
          await _saveToSharedPreferences(userMap, data);
        }
      } else {
        // Mobile platform - Use SQLite database
        await _saveToSQLiteDatabase(userMap, data);
      }
    } catch (e) {
      print('Error saving data to database: $e');
      // Continue with login even if database save fails
    }
  }

  /// Save data to Drift web database using DriftWebDatabaseHelper (clean approach like betap)
  Future<void> _saveToDriftWebDatabase(Map<String, dynamic> userMap, Map<String, dynamic> data) async {
    
    
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

      // Handle support tickets data if exists
      if (data['support_tickets'] != null && data['support_tickets'].isNotEmpty) {
      final supportTicketsData = data['support_tickets'] as List?;
      if (supportTicketsData != null) {
        for (var supportTicket in supportTicketsData) {
          await driftHelper.saveSupportTicket(supportTicket);
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

    try {
      // Save user data
      if (userMap.isNotEmpty) {
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
    print("transactionData");
    print(transactionData);
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
    }}

    // Handle loan status data if exists
    if (data['loan_status'] != null && data['loan_status'].isNotEmpty) {
    final loanStatusData = data['loan_status'] as List?;
    if (loanStatusData != null) {
      for (var loanStatus in loanStatusData) {
        await DatabaseHelper.instance.insertLoanStatus(loanStatus);
      }
    }}

    // Handle loan schedule data if exists
    if (data['loan_schedule'] != null && data['loan_schedule'].isNotEmpty) {
    final loanScheduleData = data['loan_schedule'] as List?;
    if (loanScheduleData != null) {
      for (var loanSchedule in loanScheduleData) {
        await DatabaseHelper.instance.insertLoanSchedule(loanSchedule);
      }
    }}

    // Handle support tickets data if exists
    if (data['support_tickets'] != null && data['support_tickets'].isNotEmpty) {
    final supportTicketsData = data['support_tickets'] as List?;
    if (supportTicketsData != null) {
      for (var supportTicket in supportTicketsData) {
        await DatabaseHelper.instance.insertSupportTicket(supportTicket);
      }
    }}
    
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

  Future<void> login(BuildContext context) async {
    // Validate phone number
    if (phoneController.text.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Enter_full_phone_number'.tr())),
      );
      return;
    }

    // Show loading dialog
    if (!context.mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(
          color: AppColor.primaryColor,
        ),
      ),
    );

    try {
      final url = Uri.parse('${AppData.url}/login');
      final info = await PackageInfo.fromPlatform();
      final versionCode = info.buildNumber;
      final versionName = info.version;
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'phone': phoneController.text,
          'password': passwordController.text,
          'version_name': versionName,
          'version_code': versionCode,
        }),
      );

      if (!context.mounted) return;
      // Safely dismiss loading dialog
      if (Navigator.of(context, rootNavigator: true).canPop()) {
        Navigator.of(context, rootNavigator: true).pop();
      }

     
    

      final responseBody = jsonDecode(response.body);

      // Handle response code 210 - Password sent via SMS
      if (response.statusCode == 210) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseBody['message'] ?? 'Password has been sent to your phone number. Please check your SMS and login again.'),
              backgroundColor: Colors.blue,
              duration: Duration(seconds: 5),
            ),
          );
        }
        return;
      }

      // Handle response code 404 - Phone not found, requires second phone
      if (response.statusCode == 404 && responseBody['code'] == 'PHONE_NOT_FOUND') {
        if (mounted) {
          setState(() {
            _showSecondPhoneForm = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseBody['message'] ?? 'Phone number not found. Please provide your second registered phone number.'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 5),
            ),
          );
        }
        return;
      }

      // Handle response code 410 - Invalid password
      if (response.statusCode == 410) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseBody['message'] ?? 'Invalid Password. Please check your SMS for password and login again.'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 5),
            ),
          );
        }
        return;
      }

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        final data = responseBody['data'];

        if (data == null) {
          throw Exception('No_data_in_response'.tr());
        }

        final userData = data['user'];
        if (userData == null) {
          throw Exception('User_data_not_found_in_response'.tr());
        }

        // Save user data to shared preferences
        await prefs.setString(
            'control_number', userData['external_id']?.toString() ?? '0');
        await prefs.setString(
            'code_number', userData['mobile_no']?.toString() ?? '0');
        
        // Save display name, email, and loan amounts for dashboard and profile display
        await prefs.setString(
            'display_name', userData['display_name']?.toString() ?? '');
        await prefs.setString(
            'email', userData['email']?.toString() ?? '');
        await prefs.setString(
            'loan_amount', userData['loan_amount']?.toString() ?? '0');
        await prefs.setString(
            'remain_loan_amount', userData['remain_loan_amount']?.toString() ?? '0');
        
        // Store login credentials for refresh functionality
        await prefs.setString('saved_phone', phoneController.text);
        await prefs.setString('saved_password', passwordController.text);
     
        final staffStatus = data['staff'] ?? false;
        await prefs.setBool('is_staff', staffStatus);

        // Prepare user data for local storage
        final userMap = {
          'display_name': userData['display_name']?.toString() ?? '',
          'mobile_no': userData['mobile_no']?.toString() ?? '',
          'external_id': userData['external_id']?.toString() ?? '',
          'loan_amount': userData['loan_amount']?.toString() ?? '0',
          'remain_loan_amount': userData['remain_loan_amount']?.toString() ?? '0',
        };
        
        // Log the data being saved for debugging
        print('Saving user data to database:');
        print('display_name: ${userMap['display_name']}');
        print('mobile_no: ${userMap['mobile_no']}');
        print('external_id: ${userMap['external_id']}');
        print('loan_amount: ${userMap['loan_amount']}');
        print('remain_loan_amount: ${userMap['remain_loan_amount']}');       

        
        // Save to local database with platform-specific handling
        await _saveUserDataToDatabase(userMap, data);

        // Check if PIN must be changed
        final mustChangePin = data['must_change_pin'] ?? false;
        
        // Login successful
        if (!context.mounted) return;
        
        if (mustChangePin == true) {
          // Navigate to change PIN screen instead of home
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ChangePinScreen(
                phone: phoneController.text,
                currentPin: passwordController.text,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login_Successful'.tr())),
          );
          // Update login state and navigate to home
          constant().isItLogged = true;
          
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        // Safely dismiss loading dialog
        if (Navigator.of(context, rootNavigator: true).canPop()) {
          Navigator.of(context, rootNavigator: true).pop();
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${'An_error_occurred'.tr()}: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> registerSecondPhone(BuildContext context) async {
    // Validate inputs
    if (phoneController.text.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Enter_full_phone_number'.tr())),
      );
      return;
    }

    if (secondPhoneController.text.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your second registered phone number with Softecki FaceAccess.')),
      );
      return;
    }

    if (passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your password.')),
      );
      return;
    }

    // Show loading dialog
    if (!context.mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(
          color: AppColor.primaryColor,
        ),
      ),
    );

    try {
      final url = Uri.parse('${AppData.url}/register-second-phone');
      final info = await PackageInfo.fromPlatform();
      final versionCode = info.buildNumber;
      final versionName = info.version;
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'first_phone': phoneController.text,
          'second_phone': secondPhoneController.text,
          'password': passwordController.text,
          'version_name': versionName,
          'version_code': versionCode,
        }),
      );

      if (!context.mounted) return;
      // Safely dismiss loading dialog
      if (Navigator.of(context, rootNavigator: true).canPop()) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      final responseBody = jsonDecode(response.body);

      // Handle response code 210 - Password sent via SMS
      if (response.statusCode == 210) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseBody['message'] ?? 'Password has been sent to your phone number. Please check your SMS and login again.'),
              backgroundColor: Colors.blue,
              duration: Duration(seconds: 5),
            ),
          );
        }
        return;
      }

      // Handle response code 404 - Second phone not found
      if (response.statusCode == 404) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseBody['message'] ?? 'Second phone number not found. Please ensure you are using the correct registered phone number with Softecki FaceAccess.'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 5),
            ),
          );
        }
        return;
      }

      // Handle response code 410 - Invalid password
      if (response.statusCode == 410) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseBody['message'] ?? 'Invalid Password. Please check your password and try again.'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 5),
            ),
          );
        }
        return;
      }

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        final data = responseBody['data'];

        if (data == null) {
          throw Exception('No_data_in_response'.tr());
        }

        final userData = data['user'];
        if (userData == null) {
          throw Exception('User_data_not_found_in_response'.tr());
        }

        // Save user data to shared preferences
        await prefs.setString(
            'control_number', userData['external_id']?.toString() ?? '0');
        await prefs.setString(
            'code_number', userData['mobile_no']?.toString() ?? '0');
        
        // Save display name, email, and loan amounts for dashboard and profile display
        await prefs.setString(
            'display_name', userData['display_name']?.toString() ?? '');
        await prefs.setString(
            'email', userData['email']?.toString() ?? '');
        await prefs.setString(
            'loan_amount', userData['loan_amount']?.toString() ?? '0');
        await prefs.setString(
            'remain_loan_amount', userData['remain_loan_amount']?.toString() ?? '0');
        
        // Store login credentials for refresh functionality
        await prefs.setString('saved_phone', phoneController.text);
        await prefs.setString('saved_password', passwordController.text);
     
        final staffStatus = data['staff'] ?? false;
        await prefs.setBool('is_staff', staffStatus);

        // Prepare user data for local storage
        final userMap = {
          'display_name': userData['display_name']?.toString() ?? '',
          'mobile_no': userData['mobile_no']?.toString() ?? '',
          'external_id': userData['external_id']?.toString() ?? '',
          'loan_amount': userData['loan_amount']?.toString() ?? '0',
          'remain_loan_amount': userData['remain_loan_amount']?.toString() ?? '0',
        };
        
        // Log the data being saved for debugging
        print('Saving user data to database:');
        print('display_name: ${userMap['display_name']}');
        print('mobile_no: ${userMap['mobile_no']}');
        print('external_id: ${userMap['external_id']}');
        print('loan_amount: ${userMap['loan_amount']}');
        print('remain_loan_amount: ${userMap['remain_loan_amount']}');       

        
        // Save to local database with platform-specific handling
        await _saveUserDataToDatabase(userMap, data);

        // Check if PIN must be changed
        final mustChangePin = data['must_change_pin'] ?? false;
        
        // Hide second phone form
        setState(() {
          _showSecondPhoneForm = false;
        });
        
        // Login successful
        if (!context.mounted) return;
        
        if (mustChangePin == true) {
          // Navigate to change PIN screen instead of home
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ChangePinScreen(
                phone: phoneController.text,
                currentPin: passwordController.text,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login_Successful'.tr())),
          );
          // Update login state and navigate to home
          constant().isItLogged = true;
          
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        // Safely dismiss loading dialog
        if (Navigator.of(context, rootNavigator: true).canPop()) {
          Navigator.of(context, rootNavigator: true).pop();
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${'An_error_occurred'.tr()}: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _showForgotPasswordDialog(BuildContext context) async {
    final TextEditingController forgotPhoneController = TextEditingController();
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Forgot_Password'.tr()),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Enter_your_phone_number_to_receive_a_new_password'.tr(),
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white,
                          offset: Offset(-3, -3),
                          blurRadius: 6,
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          offset: Offset(3, 3),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: forgotPhoneController,
                      keyboardType: TextInputType.phone,
                      enabled: !isLoading,
                      decoration: InputDecoration(
                        hintText: 'Phone_number'.tr(),
                        prefixIcon: Icon(Icons.call),
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          Navigator.of(context).pop();
                        },
                  child: Text('Cancel'.tr()),
                ),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (forgotPhoneController.text.length < 9) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Enter_full_phone_number'.tr()),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          setState(() {
                            isLoading = true;
                          });

                          try {
                            await _requestPasswordReset(
                                context, forgotPhoneController.text);
                            if (context.mounted) {
                              Navigator.of(context).pop();
                            }
                          } catch (e) {
                            if (context.mounted) {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryColor,
                  ),
                  child: isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text('Send'.tr()),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _requestPasswordReset(
      BuildContext context, String phone) async {
    // Show loading dialog
    if (!context.mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(
          color: AppColor.primaryColor,
        ),
      ),
    );

    try {
      final url = Uri.parse('${AppData.url}/forgot-password');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'phone': phone,
        }),
      );

      if (!context.mounted) return;
      // Safely dismiss loading dialog
      if (Navigator.of(context, rootNavigator: true).canPop()) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseBody['message'] ??
                'New password has been sent to your phone number. Please check your SMS and login again.'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 5),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseBody['message'] ?? 'An_error_occurred'.tr()),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        // Safely dismiss loading dialog
        if (Navigator.of(context, rootNavigator: true).canPop()) {
          Navigator.of(context, rootNavigator: true).pop();
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${'An_error_occurred'.tr()}: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 130,
                width: 130,
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.8),
                      offset: const Offset(-5, -5),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      offset: const Offset(5, 5),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.verified_user_rounded,
                  size: 64,
                  color: Colors.blue,
                ),
              ),
              Text(
                AppData.appDisplayName,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'Sign_in_with_your_Phone_Number'.tr(),
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 20),

              // 👇 Inset (sunken) TextField inside Neumorphic container
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white,
                      offset: Offset(-3, -3),
                      blurRadius: 6,
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: Offset(3, 3),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: TextField(
                  keyboardType: TextInputType.phone,
                  controller: phoneController,
                  decoration: InputDecoration(
                    hintText: 'Phone_number'.tr(),
                    prefixIcon: Icon(Icons.call),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 👇 Second Phone Number field - shown when first phone doesn't exist
              if (_showSecondPhoneForm) ...[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white,
                        offset: Offset(-3, -3),
                        blurRadius: 6,
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        offset: Offset(3, 3),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: TextField(
                    keyboardType: TextInputType.phone,
                    controller: secondPhoneController,
                    decoration: InputDecoration(
                    hintText: 'Second phone number (registered with Softecki FaceAccess)',
                      prefixIcon: Icon(Icons.call),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // 👇 Password field - always visible
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white,
                      offset: Offset(-3, -3),
                      blurRadius: 6,
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: Offset(3, 3),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: TextField(
                  controller: passwordController,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    hintText: 'Password'.tr(),
                    prefixIcon: Icon(Icons.password),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // 👇 Raised (embossed) Login/Submit Button
              GestureDetector(
                onTap: () => _showSecondPhoneForm ? registerSecondPhone(context) : login(context),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 80, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.green.shade600,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.shade700,
                        offset: Offset(4, 4),
                        blurRadius: 6,
                      ),
                      BoxShadow(
                        color: Colors.green.shade400,
                        offset: Offset(-2, -2),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Text(
                    _showSecondPhoneForm ? 'SUBMIT'.tr() : 'LOGIN'.tr(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // Forgot Password button
              TextButton(
                onPressed: () => _showForgotPasswordDialog(context),
                child: Text(
                  'Forgot_Password'.tr(),
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Terms and Sign Up row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PopupMenuButton<Locale>(
                    icon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.language, color: Colors.black54),
                        SizedBox(width: 4),
                        Text(
                          'language'.tr(),
                          style: TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                    onSelected: (Locale locale) async {
                      // Save language preference
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setString('selected_language_code', locale.languageCode);
                      
                      // Update locale
                      if (mounted) {
                        context.setLocale(locale);
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem<Locale>(
                        value: Locale('en'),
                        child: Row(
                          children: [
                            const Icon(Icons.language, size: 20),
                            const SizedBox(width: 8),
                            Text('English'.tr()),
                            if (Localizations.localeOf(context).languageCode == 'en')
                              const Spacer(),
                            if (Localizations.localeOf(context).languageCode == 'en')
                              const Icon(Icons.check, color: Colors.green, size: 20),
                          ],
                        ),
                      ),
                      PopupMenuItem<Locale>(
                        value: Locale('sw'),
                        child: Row(
                          children: [
                            const Icon(Icons.language, size: 20),
                            const SizedBox(width: 8),
                            Text('Swahili'.tr()),
                            if (Localizations.localeOf(context).languageCode == 'sw')
                              const Spacer(),
                            if (Localizations.localeOf(context).languageCode == 'sw')
                              const Icon(Icons.check, color: Colors.green, size: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

