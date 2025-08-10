import 'package:easy_localization/easy_localization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wicom/core/app_color.dart';
import 'package:wicom/generated/assets.dart';
import 'package:wicom/src/view/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wicom/src/view/screen/reset_password_screen.dart';
import '../../../core/app_data.dart';
import '../../data/database_helper.dart';
import '../../static.dart';
import '../widget/custom_text_button.dart';
import 'account_setup.dart';
import 'otp.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscureText = true;
  bool _showPasswordField = false;

  @override
  void initState() {
    super.initState();
    _checkUserCredentials();
  }

  void _checkUserCredentials() async {
    final hasCred = await DatabaseHelper.instance.hasUserCredentials();
    setState(() {
      _showPasswordField = hasCred;
    });
  }

  Future<void> login(BuildContext context) async {
    if(phoneController.text.length < 10){
      if (phoneController.text.length < 10) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Enter_full_phone_number'.tr())),
        );
        await Future.delayed(Duration(milliseconds: 500));
        return;
      }
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: AppColor.primaryColor,),
      ),
    );
    final url = Uri.parse(AppData.url+'/login');
    final info = await PackageInfo.fromPlatform();
    final versionCode = info.buildNumber;  // this is the +5 part
    final versionName = info.version;
    try {
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
    print(response.body);
    if (response.statusCode == 200) {
      final prefs =  await SharedPreferences.getInstance();

      final responseBody = jsonDecode(response.body);
      print(responseBody);
      final userData = responseBody['data']['user'];
      final loanData = responseBody['data']['loan'];
      final transactionData = responseBody['data']['transaction'];
      final accountSetup = responseBody['data']['account_setup'];
      final statusList = responseBody['data']['status'];
      final user_credentials = responseBody['data']['user_credentials'];
      final mechant_charge_configurations = responseBody['data']['mechant_charge_configurations'];
      prefs.setString('control_number', userData['external_id'].toString()??'0');
      prefs.setString('code_number', userData['mobile_no'].toString()??'0');
      final data = {
        // 'id': userData['id'],
        'display_name': userData['display_name'],
        'mobile_no': userData['mobile_no'].toString(),
        'external_id': userData['external_id'].toString(),
      };

        await DatabaseHelper.instance.insertCustomer(data);

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

      if(user_credentials != null) {
          await DatabaseHelper.instance.insertUsersCredentials(user_credentials);
      }

      if(mechant_charge_configurations != null) {
        for (var charge in mechant_charge_configurations) {
          await DatabaseHelper.instance.insertCharge(charge);
        }
      }

      if(statusList != null) {
        for (var status in statusList) {
          await DatabaseHelper.instance.insertStatus(status);
        }
      }


      if(accountSetup != null){
      for(var account in accountSetup ) {
        await DatabaseHelper.instance.insertAccount(account);
      }}
      print("testtest");
      print(user_credentials['otp_verified']);
      var otpVerified = user_credentials['otp_verified'];
      if (otpVerified == null || otpVerified == 'null' || otpVerified.toString() == '0') {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => VerifyOtpScreen(userData['mobile_no'].toString())));
      }

      String message = 'Login_Successful'.tr();
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text(message)),
      );
      constant().isItLogged = true;
      Navigator.of(context).pop();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else if (response.statusCode == 201) {
      // Handle case where user is not registered
      final errorMsg = jsonDecode(response.body)['message'] ?? 'User not registered';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            errorMsg,
            style: TextStyle(color: Colors.white), // White text
          ),
          backgroundColor: Colors.red, // Red background
          behavior: SnackBarBehavior.floating, // Optional: makes it float
        ),
      );
      Navigator.of(context).pop();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ResetPasswordScreen( phone: phoneController.text,
          oldPassword: passwordController.text,)),
      );

    } else {

      final errorMsg = jsonDecode(response.body)['message'] ??jsonDecode(response.body)['data']['message']?? 'Login Failed';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            errorMsg,
            style: TextStyle(color: Colors.white), // White text
          ),
          backgroundColor: Colors.green, // Red background
          behavior: SnackBarBehavior.floating, // Optional: makes it float
        ),
      );
      Navigator.of(context).pop();

    }
    } catch (e) {
      print('Error: $e');
      Navigator.of(context).pop(); // Remove loader on error
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
  }

  void showLanguageSwitcher(BuildContext context) {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    showMenu<Locale>(
      context: context,
      position: RelativeRect.fromLTRB(100, 100, 0, 0), // Adjust based on your UI
      items: [
        PopupMenuItem<Locale>(
          value: Locale('en'),
          child: Text('English'),
        ),
        PopupMenuItem<Locale>(
          value: Locale('sw'),
          child: Text('Swahili'),
        ),
      ],
    ).then((Locale? selectedLocale) {
      if (selectedLocale != null) {
        context.setLocale(selectedLocale);
      }
    });
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
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  // Light shadow (top-left)
                  BoxShadow(
                    color: Colors.white.withOpacity(0.8),
                    offset: Offset(-5, -5),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                  // Dark shadow (bottom-right)
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
                  Assets.imagesWicom,
                  fit: BoxFit.cover,
                ),
              ),
            )
,
            const Text(
              "",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 👇 Inset (sunken) TextField inside Neumorphic container
            if (_showPasswordField)
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
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
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

            // 👇 Raised (embossed) Login Button
            GestureDetector(
              onTap: () => login(context),
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
                  'LOGIN'.tr(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // Terms and Sign Up row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomTextButton(
                  text: 'language'.tr(),
                  onPressed: () => showLanguageSwitcher(context),
                  icon: Icons.language,
                  textColor: Colors.black54,
                ),
                // CustomTextButton(
                //   text: 'Sign_Up'.tr(),
                //   onPressed: () => Navigator.push(
                //       context, MaterialPageRoute(builder: (context) => RegisterScreen())),
                //   icon: Icons.person_add,
                //   textColor: AppColor.primaryColor,
                // ),
              ],
            ),

            ],
          ),
        ),
      ),
    );
  }
}

class LanguageSwitcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Locale>(
      icon: Icon(Icons.language),
      onSelected: (Locale locale) {
        context.setLocale(locale);
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<Locale>>[
        PopupMenuItem<Locale>(
          value: Locale('en'),
          child: Text('English'),
        ),
        PopupMenuItem<Locale>(
          value: Locale('sw'),
          child: Text('Swahili'),
        ),
      ],
    );
  }
}
