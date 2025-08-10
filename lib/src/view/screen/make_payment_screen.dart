import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../core/app_color.dart';
import '../../../core/app_data.dart';
import '../../../generated/assets.dart';
import '../../data/database_helper.dart';
import '../widget/custom_button.dart';
import '../widget/custom_text_field.dart';
import '../widget/dropdown.dart';
import 'home_screen.dart';

class MakePayment extends StatelessWidget {
  final String phone;
  MakePayment(String this.phone, {super.key});
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController selectedServiceController = TextEditingController();

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
            "Enter full phonenumber to proceed",
            style: TextStyle(color: Colors.white), // White text
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
            "Enter correct amount above 1000 TZS",
            style: TextStyle(color: Colors.white), // White text
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
            "Select Payment Service",
            style: TextStyle(color: Colors.white), // White text
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
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'sender_account': phoneController.text,
        'amount': amountController.text,
        'phone':phone,
        'reference':generateReferenceNumberWithPrefix("MTPW"),
        'service': selectedServiceController.text,
      }),
    );
    print(response.body);
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Your Request has been received. We are processing",
            style: TextStyle(color: Colors.white), // White text
          ),
          backgroundColor: Colors.green, // Red background
          behavior: SnackBarBehavior.floating, // Optional: makes it float
        ),
      );

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
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


              const Text(
                "Make your sale securely and conveniently with Malipo Mtandao. Simply select a payment service, then enter the customer’s number and the amount.",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),textAlign: TextAlign.center,
              ),

              const SizedBox(height: 15),
              MobileMoneyDropdown(selectedServiceController),
              const SizedBox(height: 15),
              // Sunken Phone Input
              _buildSunkenField(
                child: CustomTextField(
                  hintText: "Enter Phone number",
                  icon: Icons.phone,
                  controller: phoneController,
                  keyboardType: TextInputType.number,
                ),
              ),

              const SizedBox(height: 15),

              // Sunken Amount Input
              _buildSunkenField(
                child: CustomTextField(
                  hintText: "Enter Amount",
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
                  text: 'Pay',
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // return Scaffold(
    //   appBar: AppBar(
    //     backgroundColor: AppColor.primaryColor,
    //     title: Text(
    //       "Make Sale",
    //       style: TextStyle(color: Colors.white, fontSize: 18),
    //     ),
    //   ),
    //   body: SingleChildScrollView( // ✅ Allows scrolling to prevent overflow
    //     child: Padding(
    //       padding: const EdgeInsets.all(20.0),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.center, // Aligns content to the left
    //         children: [
    //
    //           Image.asset(
    //             Assets.imagesTicketMtandao,
    //             height: 100,
    //             width: 100,
    //             fit: BoxFit.cover,
    //           ),
    //           const SizedBox(height: 20),
    //           const Text(
    //             "Make a sale",
    //             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    //           ),
    //
    //
    //           const SizedBox(height: 15),
    //           CustomTextField(
    //             hintText: "Enter Phone number",
    //             icon: Icons.phone,
    //             controller: phoneController,
    //             keyboardType: TextInputType.number,
    //           ),
    //           const SizedBox(height: 15),
    //           CustomTextField(
    //             hintText: "Enter Amount",
    //             icon: Icons.money_sharp,
    //             controller: amountController,
    //             keyboardType: TextInputType.number,
    //           ),
    //
    //           const SizedBox(height: 15),
    //           CustomButton(
    //             onPressed: () => register(context),
    //             text: 'Pay',
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
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
