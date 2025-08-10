import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../core/app_color.dart';
import '../../../core/app_data.dart';
import '../../../generated/assets.dart';
import '../widget/dropdown.dart';
import 'login_screen.dart';

class AccountSetup extends StatefulWidget {
  final String phone;
  const AccountSetup(String this.phone,{super.key});

  @override
  _AccountSetupState createState() => _AccountSetupState(phone);
}

class _AccountSetupState extends State<AccountSetup> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController selectInstitutionController = TextEditingController();

  String selectedPayment = 'Mobile Money';
  String selectedBank = 'CRDB';
  final String phone;
  _AccountSetupState(String this.phone);

  Future<void> register(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) =>
      const Center(
        child: CircularProgressIndicator(color: AppColor.primaryColor),
      ),
    );

    final url = Uri.parse(AppData.url + '/accountsetup');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'paymentType': selectedPayment,
        'accountNumber': phoneController.text,
        'selectedBank':  selectInstitutionController.text,
        'phone':phone,
        'beneficiary_account_name':'Filbert Nyakunga'
      }),
    );
    print(response.body);
    if (response.statusCode == 200) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Account Has been created!")));

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(title: const Text('Account Setup')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
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

            Text('Kindly fill out the form to set up your account for receiving collections following successful payments.'),
            const SizedBox(height: 20),

            // Raised Dropdown for Payment Method
            _buildRaisedDropdown(
              hint: 'Select Payment Method',
              icon: Icons.payments_outlined,
              value: selectedPayment,
              items: ['Mobile Money', 'Bank'],
              onChanged: (val) => setState(() => selectedPayment = val!),
            ),
            const SizedBox(height: 15),

            // Bank Dropdown if selected
            if (selectedPayment == 'Mobile Money')(
                MobileMoneyDropdown(selectInstitutionController)
            ),
            if (selectedPayment == 'Bank')(
                BankDropdown(selectInstitutionController)
            ),
            const SizedBox(height: 15),

            // Conditional Text Field
            _buildRaisedTextField(
              controller: phoneController,
              hintText: selectedPayment == 'Mobile Money'
                  ? 'Enter your Mobile Number'
                  : 'Enter your Account Number',
              icon: selectedPayment == 'Mobile Money'
                  ? Icons.phone
                  : Icons.account_balance,
            ),


            const SizedBox(height: 20),
            _buildRaisedButton(
              text: 'Submit',
              onPressed: () => register(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRaisedDropdown({
    required String hint,
    required IconData icon,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      // color: Colors.blue.shade50,
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(3, 3),
            blurRadius: 6,
          ),
          const BoxShadow(
            color: Colors.white,
            offset: Offset(-3, -3),
            blurRadius: 6,
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          icon: const Icon(Icons.keyboard_arrow_down),
          isExpanded: true,
          hint: Row(
            children: [
              Icon(icon, color: Colors.grey),
              const SizedBox(width: 10),
              Text(hint),
            ],
          ),
          items: items.map((e) {
            return DropdownMenuItem(value: e, child: Text(e));
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildRaisedTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          const BoxShadow(
            color: Colors.white,
            offset: Offset(-3, -3),
            blurRadius: 6,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(3, 3),
            blurRadius: 6,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(icon),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        keyboardType: TextInputType.text,
      ),
    );
  }

  Widget _buildRaisedButton({required String text, required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: Colors.red.shade600,
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}