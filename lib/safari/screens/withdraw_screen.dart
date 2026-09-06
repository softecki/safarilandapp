import 'package:flutter/material.dart';
import 'package:wicom/safari/safari_api.dart';
import 'package:wicom/safari/safari_nav.dart';
import 'package:wicom/safari/safari_theme.dart';
import 'package:wicom/safari/safari_ui.dart';
import 'package:wicom/safari/screens/points_withdraw_screen.dart';
import 'package:wicom/safari/screens/withdrawal_status_screen.dart';

class SafariWithdrawScreen extends StatefulWidget {
  const SafariWithdrawScreen({
    super.key,
    required this.available,
    this.banks = const [],
    this.mnos = const [],
    this.commissionMode = false,
  });
  final dynamic available;
  final List banks;
  final List mnos;
  final bool commissionMode;

  @override
  State<SafariWithdrawScreen> createState() => _SafariWithdrawScreenState();
}

class _SafariWithdrawScreenState extends State<SafariWithdrawScreen> {
  final amount = TextEditingController();
  final account = TextEditingController();
  final mobile = TextEditingController();
  String payout = 'MNO';
  String? bank;
  String? mno;
  bool loading = false;
  int typed = 0;

  int get availableN {
    final v = widget.available;
    return v is num ? v.round() : int.tryParse('$v') ?? 0;
  }

  int get remaining => (availableN - typed).clamp(0, availableN);

  List<String> get banks {
    final fromApi = widget.banks.map((e) => '$e').where((e) => e.isNotEmpty).toList();
    return fromApi.isNotEmpty
        ? fromApi
        : const ['CRDB', 'NMB', 'NBC', 'Equity Bank', 'Stanbic', 'Absa', 'DTB', 'Bank of Africa', 'Access Bank', 'Azania', 'Exim', 'KCB', 'Other'];
  }

  List<String> get mnos {
    final fromApi = widget.mnos.map((e) => '$e').where((e) => e.isNotEmpty).toList();
    return fromApi.isNotEmpty
        ? fromApi
        : const ['M-Pesa', 'Tigo Pesa', 'Airtel Money', 'HaloPesa', 'T-Pesa'];
  }

  @override
  void initState() {
    super.initState();
    bank = banks.first;
    mno = mnos.first;
    amount.addListener(() {
      setState(() => typed = int.tryParse(amount.text.trim()) ?? 0);
    });
  }

  @override
  void dispose() {
    amount.dispose();
    account.dispose();
    mobile.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (typed <= 0 || typed > availableN) {
      await safariError(context, Exception('Enter an amount up to ${money(availableN)}'));
      return;
    }
    setState(() => loading = true);
    try {
      if (widget.commissionMode) {
        final method = payout == 'BANK'
            ? 'BANK'
            : switch (mno) {
                'Tigo Pesa' => 'TIGOPESA',
                'Airtel Money' => 'AIRTEL',
                _ => 'MPESA',
              };
        final json = await SafariApi.post('/wallet/withdrawals', {
          'amount': typed,
          'payout_method': method,
          'payout_account': payout == 'BANK' ? account.text.trim() : mobile.text.trim(),
        });
        final row = Map<String, dynamic>.from(SafariApi.data(json) as Map);
        if (!mounted) return;
        await SafariNav.replace(context, SafariWithdrawalStatusScreen(id: row['id'], initial: row));
        return;
      }
      final json = await SafariApi.post('/points/withdrawals', {
        'amount': typed,
        'payout_type': payout,
        if (payout == 'BANK') ...{
          'bank_name': bank,
          'account_number': account.text.trim(),
        },
        if (payout == 'MNO') ...{
          'mno_name': mno,
          'mobile_number': mobile.text.trim(),
        },
      });
      final row = Map<String, dynamic>.from(SafariApi.data(json) as Map);
      if (!mounted) return;
      await SafariNav.replace(context, SafariPointsWithdrawalStatusScreen(row: row));
    } catch (e) {
      await safariError(context, e);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final over = typed > availableN;
    return Scaffold(
      appBar: AppBar(title: const Text('Points withdrawal')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          SafariHero(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Available', style: TextStyle(color: SafariTheme.goldSoft)),
              const SizedBox(height: 6),
              SafariCountUp(availableN, moneyFormat: true, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white)),
              const SizedBox(height: 10),
              Text('Remaining  ${money(remaining)}', style: TextStyle(color: over ? const Color(0xFFFFB4AB) : Colors.white70, fontWeight: FontWeight.w700)),
              if (typed > 0)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text('Requesting ${money(typed)}', style: const TextStyle(color: SafariTheme.goldSoft, fontSize: 13)),
                ),
            ]),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: amount,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Amount TZS',
              helperText: over ? 'Amount is more than available' : 'Available ${money(availableN)}',
              helperStyle: TextStyle(color: over ? const Color(0xFFB3261E) : SafariTheme.muted),
            ),
          ),
          const SizedBox(height: 12),
          RadioListTile<String>(
            value: 'MNO',
            groupValue: payout,
            title: const Text('Mobile money (MNO)'),
            onChanged: (v) => setState(() => payout = v!),
          ),
          RadioListTile<String>(
            value: 'BANK',
            groupValue: payout,
            title: const Text('Bank account'),
            onChanged: (v) => setState(() => payout = v!),
          ),
          if (payout == 'MNO') ...[
            DropdownButtonFormField<String>(
              value: mnos.contains(mno) ? mno : null,
              items: mnos.map((n) => DropdownMenuItem(value: n, child: Text(n))).toList(),
              onChanged: (v) => setState(() => mno = v),
              decoration: const InputDecoration(labelText: 'MNO'),
            ),
            const SizedBox(height: 12),
            TextField(controller: mobile, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Mobile number')),
          ] else ...[
            DropdownButtonFormField<String>(
              value: banks.contains(bank) ? bank : null,
              items: banks.map((n) => DropdownMenuItem(value: n, child: Text(n))).toList(),
              onChanged: (v) => setState(() => bank = v),
              decoration: const InputDecoration(labelText: 'Bank name'),
            ),
            const SizedBox(height: 12),
            TextField(controller: account, decoration: const InputDecoration(labelText: 'Account number')),
          ],
          const SizedBox(height: 20),
          SafariLoadingButton(label: 'Submit', loading: loading, onPressed: _submit),
        ],
      ),
    );
  }
}
