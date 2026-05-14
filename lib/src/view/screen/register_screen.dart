import 'package:easy_localization/easy_localization.dart';
import 'package:wicom/src/view/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wicom/src/view/screen/login_screen.dart';
import 'dart:convert';
import '../../../core/app_color.dart';
import '../../../core/app_data.dart';
import '../../../generated/assets.dart';
import '../widget/dropdown.dart';
import 'account_setup.dart';
import 'otp.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nidaController = TextEditingController();

  Future<void> register(BuildContext context) async {
    if(phoneController.text.length < 10){
      if (phoneController.text.length < 10) {
        // Show error first before popping
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
    final url = Uri.parse(AppData.url+'/onboarding');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'phone': phoneController.text,
        'nida': nidaController.text,
      }),
    );
    print(response.body);
    if (response.statusCode == 200) {
      final user = {
        'phone': phoneController.text,
        'nida': nidaController.text,
      };

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('User_Registered'.tr())));

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => VerifyOtpScreen(phoneController.text)));
    } else {
      final errorMsg = jsonDecode(response.body)['message'] ?? 'Registration_Failed'.tr();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMsg)),
      );
      Navigator.of(context).pop();

    }

  }

    @override
    Widget build(BuildContext context) {

      return Scaffold(
        backgroundColor: Colors.blue.shade50,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 180,
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
                    Assets.imagesLogo,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  'registration_form'.tr(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                ),
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
                  controller: phoneController,
                  decoration: InputDecoration(
                    hintText: 'Phone_number'.tr(),
                    prefixIcon: Icon(Icons.call),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),

              const SizedBox(height: 25),
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
                  controller: nidaController,
                  decoration: InputDecoration(
                    hintText: 'Enter_your_NIDA'.tr(),
                    prefixIcon: Icon(Icons.perm_identity_outlined),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // 👇 Raised (embossed) Login Button
              GestureDetector(
                onTap: () => register(context),
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
                    'Click_to_get_OTP'.tr(),
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
            ],
          ),
        ),
      );

    }


}

