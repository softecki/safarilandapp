import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/app_color.dart';



class PaymentReceiptScreen extends StatelessWidget {
  String title;
  String date;
  String amount;
  String transaction_id;
  String full_name;
  String account_number;
  // Sample Payment Details


  PaymentReceiptScreen( this.title,this.date,this.amount,this.transaction_id,this.full_name,this.account_number);

  @override
  Widget build(BuildContext context) {
    final Map<String, String> paymentDetails = {
      "Receipt No": transaction_id,
      "Name": full_name,
      "Bank Account": account_number,
      "Amount Paid": "TZS "+NumberFormat('#,##0').format(double.parse(amount)),
      "Payment Method": "Bank Transfer",
      "Date Received": date,
      // "Operator": "Admin - Jane Smith",
      "Status": "Confirmed",
    };
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        title: Text(
          "Fees Payments",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: () {

          },
        ),
        actions: [
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Receipt Container
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 5),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Center(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColor.primaryColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  // Details
                  ...paymentDetails.entries.map((entry) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(entry.key,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                        Text(entry.value, style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  )),
                  SizedBox(height: 10),

                  // Status Badge
                  Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 5, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "Payment Confirmed",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800]),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),

                  // Download & Print Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // ElevatedButton.icon(
                      //   onPressed: () {}, // Future Download Function
                      //   icon: Icon(Icons.download),
                      //   label: Text("Download"),
                      //   style: ElevatedButton.styleFrom(
                      //       backgroundColor: Colors.blue),
                      // ),
                      // ElevatedButton.icon(
                      //   onPressed: () {}, // Future Print Function
                      //   icon: Icon(Icons.print),
                      //   label: Text("Print"),
                      //   style: ElevatedButton.styleFrom(
                      //       backgroundColor: AppColor.primaryColor),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
