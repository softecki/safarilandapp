import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../core/app_color.dart';
import '../../../core/app_data.dart';
import '../../../generated/assets.dart';
import '../widget/custom_button.dart';
import '../widget/custom_text_field.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final TextEditingController emailController = TextEditingController();

  Future<void> sendResetLink(BuildContext context) async {
    final url = Uri.parse(AppData.url+'/register');
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: AppColor.primaryColor,),
      ),
    );
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': emailController.text}),
    );

    print(response.body);
    if (response.statusCode == 200) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP has been sent. Check your SMS!')),
      );
      Navigator.pop(context); // Go back to login
    } else {
      Navigator.of(context).pop();
      final errorMsg = jsonDecode(response.body)['message'] ?? 'Failed to send OTP SMS';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMsg)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [  Image.asset(
            Assets.imagesNalopa,
            height: 100,
            width: 100,
            fit: BoxFit.cover,
          ),
            const SizedBox(height: 20),
            const Text(
              "Welcome at",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text(
              "St Anorld Janssen School!",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),
            CustomTextField(
              hintText: "Enter your Phone number",
              icon: Icons.phone,
              controller: emailController,
            ),

            const SizedBox(height: 20),
            CustomButton(
              onPressed: () => sendResetLink(context),
              text:'Click to Get OTP',
            ),
          ],
        ),
      ),
    );
  }
}
