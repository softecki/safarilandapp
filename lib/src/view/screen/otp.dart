import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../core/app_color.dart';
import '../../../core/app_data.dart';
import '../../../generated/assets.dart';
import 'account_setup.dart';

class VerifyOtpScreen extends StatelessWidget {
  final String phone;
  VerifyOtpScreen(String this.phone, {super.key});
  final TextEditingController otpController = TextEditingController();

  Future<void> register(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: AppColor.primaryColor,),
      ),
    );
    final url = Uri.parse(AppData.url+'/otpverification');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'otp': otpController.text,
        'phone':phone
      }),
    );
    print(response.body);
    if (response.statusCode == 200) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("User Verified!")));

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => AccountSetup(phone)));
      // Navigator.pop(context); // Go back to login after success
    } else {
      Navigator.of(context).pop();
      final errorMsg = jsonDecode(response.body)['message'] ?? 'Registration Failed';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMsg)),
      );
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
            Image.asset(
              Assets.imagesLogo,
              height: 100,
              width: 220,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),
            const Text(
              "Welcome at",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              AppData.School_name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                controller: otpController,
                decoration: InputDecoration(
                  hintText: 'Enter OTP Number',
                  prefixIcon: Icon(Icons.call),
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
                  'Verify',
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