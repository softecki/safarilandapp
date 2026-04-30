import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../data/database_helper.dart';
import '../../utils/navigation_helper.dart';
import 'transaction_detail_screen.dart';

class TransactionsListScreen extends StatefulWidget {
  const TransactionsListScreen({super.key});

  @override
  State<TransactionsListScreen> createState() => _TransactionsListScreenState();
}

class _TransactionsListScreenState extends State<TransactionsListScreen> {
  List<Map<String, dynamic>> _transactions = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final txns = await DatabaseHelper.instance.getTransaction();
      setState(() {
        _transactions = txns;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Transactions'),
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: Colors.black,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _transactions.isEmpty
              ? const Center(child: Text('No transactions'))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (ctx, i) => _buildItem(_transactions[i]),
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemCount: _transactions.length,
                ),
    );
  }

  Widget _buildItem(Map<String, dynamic> txn) {
    final isCredit = (txn['type']?.toString().toLowerCase() == 'credit') || (txn['settlement_status']?.toString() == '3');
    final amount = txn['amount']?.toString() ?? '0';
    final date = (txn['date'] ?? txn['created_at'] ?? '').toString();
    final title = (txn['description'] ?? txn['msisdn'] ?? 'Transaction').toString();

    return InkWell(
      onTap: () => NavigationHelper.navigateTo(
        context,
        TransactionDetailScreen(transaction: txn),
        showLoader: false,
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isCredit ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(isCredit ? Iconsax.arrow_down : Iconsax.arrow_up_2, color: isCredit ? Colors.green : Colors.red, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(date, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                ],
              ),
            ),
            Text(
              (isCredit ? '+' : '-') + 'TZS $amount',
              style: TextStyle(color: isCredit ? Colors.green : Colors.red, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
