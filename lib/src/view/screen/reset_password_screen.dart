import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/app_color.dart';
import '../../../core/app_data.dart';
import '../../../generated/assets.dart';
import '../../data/database_helper.dart';
import '../widget/custom_text_button.dart';
import 'account_setup.dart';
import 'home_screen.dart';
import 'otp.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String phone;
  final String oldPassword;
  const ResetPasswordScreen({Key? key, required this.phone, required this.oldPassword}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController = TextEditingController();
  bool isLoading = false;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  Future<void> resetPassword(BuildContext context) async {
    if (newPasswordController.text.isEmpty || confirmNewPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter and confirm your new password.')),
      );
      return;
    }
    if (newPasswordController.text != confirmNewPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match.')),
      );
      return;
    }
    setState(() { isLoading = true; });
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: AppColor.primaryColor,),
      ),
    );
    final url = Uri.parse(AppData.url+'/login');
    final info = await PackageInfo.fromPlatform();
    final versionCode = info.buildNumber;
    final versionName = info.version;
    // DeviceInfo is not used here, but can be added if needed
    try {
      final Map<String, dynamic> body = {
        'phone': widget.phone,
        'password': widget.oldPassword,
        'new_password': newPasswordController.text,
        'confirm_new_password': confirmNewPasswordController.text,
        'version_name': versionName,
        'version_code': versionCode,
        // 'imei': androidInfo.id, // Add if needed
      };
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      final responseBody = jsonDecode(response.body);
      print(responseBody);
      if (response.statusCode == 200) {
        final prefs =  await SharedPreferences.getInstance();
        final userData = responseBody['data']['user'];
        final loanData = responseBody['data']['loan'];
        prefs.setString('code_number', userData['mobile_no']);
        final transactionData = responseBody['data']['transaction'];
        final statusList = responseBody['data']['status'];
        final user_credentials = responseBody['data']['user_credentials'];
        prefs.setString('control_number', userData['external_id'].toString()??'0');
        prefs.setString('code_number', userData['mobile_no'].toString()??'0');
        print("1");
        DatabaseHelper.instance.clearTransactions();
        final data = {
          // 'id': userData['id'],
          'display_name': userData['display_name'],
          'mobile_no': userData['mobile_no'].toString(),
          'external_id': userData['external_id'].toString(),
        };

        await DatabaseHelper.instance.insertCustomer(data);
        print("2");
        final loan = {
          'id': loanData[0]['id'],
          'client_id': loanData[0]['client_id'].toString(),
          'total_expected_repayment_derived': loanData[0]['total_expected_repayment_derived'].toString(),
          'total_repayment_derived': loanData[0]['total_repayment_derived'].toString(),
        };
        await DatabaseHelper.instance.insertLoan(loan);

        if(transactionData != null) {
          for (var transaction in transactionData) {
            await DatabaseHelper.instance.insertTransaction(transaction);
          }
        }
        print("3");
        if(statusList != null) {
          for (var status in statusList) {
            await DatabaseHelper.instance.insertStatus(status);
          }
        }
        if(user_credentials != null) {
          print("user_credentials: $user_credentials");
          // for (var users in user_credentials) {
            await DatabaseHelper.instance.insertUsersCredentials(user_credentials);
          // }
        }
        print("4");
        // if(user_credentials['otp_verified'].toString()=='0' || user_credentials['otp_verified']==null){
        //   Navigator.pushReplacement(
        //       context, MaterialPageRoute(builder: (context) => VerifyOtpScreen(widget.phone)));
        // }

        print("5");
        String message = 'Password reset successful.';
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text(message)),
        );
        Navigator.of(context).pop();
        setState(() { isLoading = false; });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else if(response.statusCode == 202){
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => VerifyOtpScreen(widget.phone)));
      }
       else {
        final errorMsg = responseBody['message'] ?? responseBody['data']?['message'] ?? 'Password reset failed';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              errorMsg,
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.of(context).pop();
        setState(() { isLoading = false; });
      }
    } catch (e) {
      Navigator.of(context).pop();
      setState(() { isLoading = false; });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.8),
                      offset: Offset(-5, -5),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                    BoxShadow(
                      color: Colors.white.withOpacity(0.8),
                      offset: Offset(5, 5),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    Assets.imagesMalipoMtandao1,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const Text(
                "",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Sign_in_with_your_Phone_Number'.tr(),
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
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
                  keyboardType: TextInputType.text,
                  controller: newPasswordController,
                  obscureText: _obscureNewPassword,
                  decoration: InputDecoration(
                    hintText: 'Enter new Password',
                    prefixIcon: Icon(Icons.password),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureNewPassword ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureNewPassword = !_obscureNewPassword;
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
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
                  keyboardType: TextInputType.text,
                  controller: confirmNewPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    hintText: 'Confirm new Password',
                    prefixIcon: Icon(Icons.password),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                ),
              ),
              // Removed new password and confirm new password fields
              const SizedBox(height: 25),
              GestureDetector(
                onTap: () => resetPassword(context),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 80, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade600,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.shade700,
                        offset: Offset(4, 4),
                        blurRadius: 6,
                      ),
                      BoxShadow(
                        color: Colors.red.shade400,
                        offset: Offset(-2, -2),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Text(
                    'RESET PASSWORD',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );

    // return Scaffold(
    //   appBar: AppBar(title: Text('Reset Password')),
    //   body: Padding(
    //     padding: const EdgeInsets.all(20.0),
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         TextField(
    //           controller: newPasswordController,
    //           obscureText: true,
    //           decoration: InputDecoration(
    //             labelText: 'New Password',
    //             prefixIcon: Icon(Icons.lock_outline),
    //           ),
    //         ),
    //         SizedBox(height: 16),
    //         TextField(
    //           controller: confirmNewPasswordController,
    //           obscureText: true,
    //           decoration: InputDecoration(
    //             labelText: 'Confirm New Password',
    //             prefixIcon: Icon(Icons.lock),
    //           ),
    //         ),
    //         SizedBox(height: 32),
    //         isLoading
    //             ? CircularProgressIndicator()
    //             : ElevatedButton(
    //                 onPressed: resetPassword,
    //                 child: Text('Reset Password'),
    //               ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
