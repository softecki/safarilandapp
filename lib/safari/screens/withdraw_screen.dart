import 'package:flutter/material.dart';
import 'package:wicom/safari/safari_api.dart';
import 'package:wicom/safari/safari_nav.dart';
import 'package:wicom/safari/safari_theme.dart';
import 'package:wicom/safari/safari_ui.dart';
import 'package:wicom/safari/screens/withdrawal_status_screen.dart';

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
  void dispose() {
    amount.dispose();
    account.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => loading = true);
    try {
      final json = await SafariApi.post('/wallet/withdrawals', {
        'amount': int.tryParse(amount.text) ?? 0,
        'payout_method': method,
        'payout_account': account.text.trim(),
      });
      final row = Map<String, dynamic>.from(SafariApi.data(json) as Map);
      if (!mounted) return;
      await SafariNav.replace(context, SafariWithdrawalStatusScreen(id: row['id'], initial: row));
    } catch (e) {
      await safariError(context, e);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Withdraw')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          SafariHero(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Available to withdraw', style: TextStyle(color: SafariTheme.goldSoft)),
              const SizedBox(height: 6),
              Text(money(widget.available), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              const Text('Finance must approve, then the payout API confirms. This screen will not show Paid until that happens.', style: TextStyle(color: Colors.white70, fontSize: 12)),
            ]),
          ),
          const SizedBox(height: 16),
          TextField(controller: amount, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Amount TZS')),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: method,
            decoration: const InputDecoration(labelText: 'Payout method'),
            items: const [
              DropdownMenuItem(value: 'MPESA', child: Text('M-Pesa')),
              DropdownMenuItem(value: 'TIGOPESA', child: Text('Tigo Pesa')),
              DropdownMenuItem(value: 'AIRTEL', child: Text('Airtel Money')),
              DropdownMenuItem(value: 'BANK', child: Text('Bank transfer')),
            ],
            onChanged: (v) => setState(() => method = v ?? 'MPESA'),
          ),
          const SizedBox(height: 12),
          TextField(controller: account, decoration: const InputDecoration(labelText: 'Account / phone')),
          const SizedBox(height: 20),
          SafariLoadingButton(label: 'Submit request', loading: loading, onPressed: _submit),
        ],
      ),
    );
  }
}
