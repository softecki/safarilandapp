import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import '../../../core/app_color.dart';
import '../../../core/app_data.dart';
import '../../../generated/assets.dart';
import '../../data/database_helper.dart';
import '../widget/custom_button.dart';
import '../widget/custom_text_field.dart';
import '../widget/dropdown.dart';
import 'home_screen.dart';
import 'make_payment_screen.dart';


class DashboardScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}
class _ProfileScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>>? transactions;
  List<Map<String, dynamic>>? charge;
  String amount = '0';
  String name = '';
  bool isLoading = true;
  bool _showAmount = false;
  Timer? _refreshTimer;

  final currencyFormatter = NumberFormat("#,##0.00");
  final dateFormatter = DateFormat("dd MMM yyyy");
  final timeFormatter = DateFormat("HH:mm:ss");

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchFirstStudent();
    _startAutoRefresh();
  }

  Future<void> _fetchFirstStudent() async {

    String balance =
    await DatabaseHelper.instance.getBalance();
    final prefs = await SharedPreferences.getInstance();
    String? current_student = prefs.getString('code_number');

    String name_ =
    await DatabaseHelper.instance.getName(current_student!);

    List<Map<String, dynamic>> transaction =
    await DatabaseHelper.instance.getTransaction();

    List<Map<String, dynamic>> chargeList =
    await DatabaseHelper.instance.getCharge();


    if (balance.isNotEmpty) {
      var rawAmount = balance;
      double amountText = double.tryParse(rawAmount.toString()) ?? 0;
      amount = NumberFormat('#,###').format(amountText);
      name = name_;
    }
    if (transaction.isNotEmpty) {
      transactions = transaction;
    }

    if (chargeList.isNotEmpty) {
      charge = chargeList;
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        elevation: 0,
        title: Text("", style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.grey[300]),
          onPressed: () {},
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white,
                      offset: Offset(-5, -5),
                      blurRadius: 15,
                    ),
                    BoxShadow(
                      color: Colors.grey.shade500,
                      offset: Offset(5, 5),
                      blurRadius: 15,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey[300],
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade500,
                                    offset: Offset(4, 4),
                                    blurRadius: 10,
                                  ),
                                  BoxShadow(
                                    color: Colors.white,
                                    offset: Offset(-4, -4),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                backgroundImage: AssetImage("assets/profile.jpg"),
                                radius: 22,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Hello "+name,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                const Text("Welcome back",
                                    style: TextStyle(
                                        color: Colors.black54, fontSize: 12)),
                              ],
                            ),
                          ],
                        ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black54),
            tooltip: "Refresh Transactions",
            onPressed: _refreshTransactions,
          ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Text("YOUR LOAN BALANCE",
                        style:
                        TextStyle(color: Colors.black54, fontSize: 12)),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Text(_showAmount ? "\TZS $amount" : "\TZS ****",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 28,
                                fontWeight: FontWeight.bold)),
                        SizedBox(width: 10),
                        IconButton(
                          icon: Icon(
                            _showAmount ? Icons.remove_red_eye : Icons.remove_red_eye_outlined,
                            color: Colors.black38, size: 20),
                          onPressed: () {
                            setState(() {
                              _showAmount = !_showAmount;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              isLoading
                  ? const Center(
                child: CircularProgressIndicator(),
              )
                  : Padding(
                padding: const EdgeInsets.all(2),
                child:  _neumorphicButton("PAY LOAN", () async {
                  final prefs = await SharedPreferences.getInstance();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MakePayment(prefs.getString('code_number')!),
                    ),
                  );
                })

              ),

              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: const [
                    Text("Recent Transactions",
                        style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ...transactions?.map((txn) {
                String receiver = txn['msisdn'] ?? 'Unknown';
                String status = txn['status'] ?? '0';
                String settlement_status = txn['settlement_status'] ?? '0';
                double amountValue =
                    double.tryParse(txn['amount'].toString()) ?? 0;
                String amountFormatted =
                    "TZS ${currencyFormatter.format(amountValue)}";
                DateTime dateTime =
                    DateTime.tryParse(txn['created_at'].toString()) ??
                        DateTime.now();
                String date = dateFormatter.format(dateTime);
                String time = timeFormatter.format(dateTime);
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white,
                          offset: Offset(-3, -3),
                          blurRadius: 6,
                        ),
                        BoxShadow(
                          color: Colors.grey.shade500,
                          offset: Offset(3, 3),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                      leading: CircleAvatar(
                        radius: 18,
                        backgroundColor: settlement_status.toString() == '3'
                            ? Colors.green
                            : status.toString() == '3'
                            ? Colors.yellowAccent.shade700
                            : Colors.redAccent,
                        child: Icon(Icons.monetization_on,
                            color: Colors.white, size: 18),
                      ),
                      title: Text(
                        "$receiver (${settlement_status.toString() == '3' ? "Completed" : status.toString() == '3' ? "Processing" : "Pending"})",
                        style: TextStyle(fontSize: 14),
                      ),
                      subtitle: Text(time,
                          style:
                          TextStyle(fontSize: 12, color: Colors.grey[600])),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(amountFormatted,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14)),
                          SizedBox(height: 2),
                          Text(date,
                              style: TextStyle(
                                  fontSize: 11, color: Colors.grey[600])),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList() ??
                  [const Text("No transactions available.")],
            ],
          ),
        ),
      ),
    );
  }

  Widget _neumorphicButton(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.white,
              offset: Offset(-4, -4),
              blurRadius: 8,
            ),
            BoxShadow(
              color: Colors.grey.shade500,
              offset: Offset(4, 4),
              blurRadius: 8,
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(color: Colors.green[900], fontSize: 16,fontWeight: FontWeight.bold, ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  void _startAutoRefresh() {
    _refreshTimer = Timer.periodic(Duration(minutes: 1), (timer) async {
      if (transactions != null && transactions!.any((txn) {
        final status = int.tryParse(txn['status']?.toString() ?? '0') ?? 0;
        return status < 3;
      })) {
        await _refreshTransactions();
      }
    });
  }

  Future<void> _refreshTransactions() async {
    try {
      setState(() {
        isLoading = true;
      });
      final prefs =  await SharedPreferences.getInstance();
      String? phone = prefs.getString('code_number');
      final url = Uri.parse(AppData.url+'/transactionsUpdate');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'phone': phone,
        }),
      );
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final transactionData = responseBody['data']['transaction'];
        final loanData = responseBody['data']['loan'];
        final mechant_charge_configurations = responseBody['data']['mechant_charge_configurations'];
        final loan = {
          'id': loanData[0]['id'],
          'client_id': loanData[0]['client_id'].toString(),
          'total_expected_repayment_derived': loanData[0]['total_expected_repayment_derived'].toString(),
          'total_repayment_derived': loanData[0]['total_repayment_derived'].toString(),
        };
        await DatabaseHelper.instance.clearTransactions();
        if(transactionData != null) {
          for (var transaction in transactionData) {
            await DatabaseHelper.instance.insertTransaction(transaction);
          }
        }
        await DatabaseHelper.instance.insertLoan(loan);
        if(mechant_charge_configurations != null) {
          for (var charge in mechant_charge_configurations) {
            await DatabaseHelper.instance.insertCharge(charge);
          }
        }
        await _fetchFirstStudent();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Transactions updated successfully."),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Failed to update transactions. ({response.statusCode})"),
              backgroundColor: Colors.red,
            ),
          );
        }
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error updating transactions: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
      setState(() {
        isLoading = false;
      });
    }
  }
}

class TransactionListScreen extends StatefulWidget {
  const TransactionListScreen({Key? key}) : super(key: key);

  @override
  State<TransactionListScreen> createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  List<Map<String, dynamic>> transactions = [];
  bool loading = true;
  final currencyFormatter = NumberFormat("#,##0.00");
  final dateTimeFormatter = DateFormat("dd/MM/yyyy hh:mm a");
  final dateFormatter = DateFormat("dd MMM yyyy");
  DateTime? startDate;
  DateTime? endDate;
  bool _loading = true;

  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTransactions();
    // After 5 seconds, check if still empty
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && transactions.isEmpty) {
        setState(() {
          loading = false;
        });
      }
    });
  }

  Future<void> _loadTransactions({DateTime? from, DateTime? to}) async {
    final data = await DatabaseHelper.instance.getTransaction();

    if (from != null && to != null) {
      // transactions = data.where((txn) {
      //   final createdAt = DateTime.tryParse(txn['created_at'].toString());
      //   if (createdAt == null) return false;
      //   return createdAt.isAfter(from.subtract(const Duration(days: 1))) &&
      //       createdAt.isBefore(to.add(const Duration(days: 1)));
      // }).toList();

      transactions = data.where((txn) {
        final createdAt = DateTime.tryParse(txn['created_at'].toString());
        if (createdAt == null) return false;
        return createdAt.isAfter(from.subtract(const Duration(days: 1))) &&
            createdAt.isBefore(to.add(const Duration(days: 1)));
      }).toList();
    } else {
      transactions = data;
    }

    setState(() {});
  }

  Future<void> _pickDate(BuildContext context, TextEditingController controller, bool isStartDate) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );

    if (picked != null) {
      controller.text = dateFormatter.format(picked);
      setState(() {
        if (isStartDate) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        // backgroundColor: const Color(0xFFff0000),
        title: const Text(
          "Transactions",
          style: TextStyle(color: Colors.blue, fontSize: 18),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.grey[300]),
          onPressed: () {},
        ),
      ),
      body: Column(
        children: [
          /// Start Date Field - Sunken Design
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white,
                    offset: Offset(-3, -3),
                    blurRadius: 6,
                  ),
                  BoxShadow(
                    color: Colors.grey.shade500,
                    offset: Offset(3, 3),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Flexible(
                    child: TextFormField(
                      controller: _startDateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "Start Date",
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      onTap: () => _pickDate(context, _startDateController, true),
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// End Date + Search Button - Sunken Design
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white,
                    offset: Offset(-3, -3),
                    blurRadius: 6,
                  ),
                  BoxShadow(
                    color: Colors.grey.shade500,
                    offset: Offset(3, 3),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Flexible(
                    child: TextFormField(
                      controller: _endDateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "End Date",
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      onTap: () => _pickDate(context, _endDateController, false),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => _loadTransactions(from: startDate, to: endDate),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    child: const Text("Search"),
                  ),
                ],
              ),
            ),
          ),

          Expanded(child:     transactions.isEmpty
              ? const Center(child: Text("No data"))
              : ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: transactions.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final txn = transactions[index];
              String status = txn['status'] ?? '0';
              String settlement_status = txn['settlement_status'] ?? '0';
              String receiver = txn['msisdn'] ?? 'Unknown';
              double amountValue = double.tryParse(txn['amount'].toString()) ?? 0;
              String amountFormatted =
                  "TZS ${currencyFormatter.format(amountValue)}";

              DateTime dateTime = DateTime.tryParse(txn['created_at'].toString()) ??
                  DateTime.now();
              String dateTimeStr = dateTimeFormatter.format(dateTime);

              return Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.8),
                      offset: const Offset(-4, -4),
                      blurRadius: 6,
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(4, 4),
                      blurRadius: 6,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        // color: Colors.green[600],
                        boxShadow: [
                          // BoxShadow(
                          //   color: Colors.green.shade700,
                          //   offset: const Offset(2, 2),
                          //   blurRadius: 4,
                          // ),
                          // BoxShadow(
                          //   color: Colors.green.shade300,
                          //   offset: const Offset(-2, -2),
                          //   blurRadius: 4,
                          // ),
                        ],
                      ),
                      // leading: CircleAvatar(
                      //   radius: 18,
                      //   backgroundColor: settlement_status.toString() == '3'
                      //       ? Colors.green
                      //       : status.toString() == '3'
                      //       ? Colors.yellowAccent.shade700
                      //       : Colors.redAccent,
                      //   child: Icon(Icons.monetization_on,
                      //       color: Colors.white, size: 18),
                      // ),
                      // title: Text(
                      //   "$receiver (${settlement_status.toString() == '3' ? "Completed" : status.toString() == '3' ? "Processing" : "Pending"})",
                      //   style: TextStyle(fontSize: 14),
                      // ),
                      padding: const EdgeInsets.all(8),
                      child: CircleAvatar(
                          radius: 18,
                          backgroundColor: settlement_status.toString() == '3'
                              ? Colors.green
                              : status.toString() == '3'
                              ? Colors.yellowAccent.shade700
                              : Colors.redAccent,
                          child: Icon(Icons.monetization_on,
                              color: Colors.white, size: 18),
                        ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            receiver,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            dateTimeStr,
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 13),
                          ),
                      Text(
                          " (${settlement_status.toString() == '3' ? "Completed" : status.toString() == '3' ? "Processing" : "Pending"})",
                          style: TextStyle(fontSize: 14),
                        )
                        ],
                      ),
                    ),
                    Text(
                      "+$amountFormatted",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),)
        ],
      )
          // loading
          // ? const Center(child: CircularProgressIndicator())



    );
  }
}

