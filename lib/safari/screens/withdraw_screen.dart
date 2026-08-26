import 'package:flutter/material.dart';
import 'package:wicom/safari/safari_api.dart';
import 'package:wicom/safari/safari_ui.dart';

class SafariWithdrawScreen extends StatefulWidget {
  const SafariWithdrawScreen({super.key, required this.available});
  final dynamic available;

  @override
  State<SafariWithdrawScreen> createState() => _SafariWithdrawScreenState();
}

class _SafariWithdrawScreenState extends State<SafariWithdrawScreen> {
  final amount = TextEditingController();
  final account = TextEditingController();
  String method = 'MPESA';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Withdraw')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text('Available ${money(widget.available)}'),
          TextField(controller: amount, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Amount TZS')),
          const SizedBox(height: 8),
          DropdownButtonFormField(
            value: method,
            items: const [
              DropdownMenuItem(value: 'MPESA', child: Text('M-Pesa')),
              DropdownMenuItem(value: 'BANK', child: Text('Bank')),
            ],
            onChanged: (v) => setState(() => method = v ?? 'MPESA'),
          ),
          TextField(controller: account, decoration: const InputDecoration(labelText: 'Account / phone')),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: loading
                ? null
                : () async {
                    setState(() => loading = true);
                    try {
                      await SafariApi.post('/wallet/withdrawals', {
                        'amount': int.tryParse(amount.text) ?? 0,
                        'payout_method': method,
                        'payout_account': account.text.trim(),
                      });
                      if (context.mounted) Navigator.pop(context);
                    } catch (e) {
                      await safariError(context, e);
                    } finally {
                      if (mounted) setState(() => loading = false);
                    }
                  },
            child: const Text('Submit request'),
          ),
        ],
      ),
    );
  }
}
