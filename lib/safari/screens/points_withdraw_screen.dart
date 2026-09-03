import 'package:flutter/material.dart';
import 'package:wicom/safari/safari_api.dart';
import 'package:wicom/safari/safari_nav.dart';
import 'package:wicom/safari/safari_theme.dart';
import 'package:wicom/safari/safari_ui.dart';

class SafariPointsWithdrawScreen extends StatefulWidget {
  const SafariPointsWithdrawScreen({
    super.key,
    required this.entryPoints,
    required this.salesPoints,
    required this.netTsh,
    this.banks = const [],
    this.mnos = const [],
  });

  final int entryPoints;
  final int salesPoints;
  final dynamic netTsh;
  final List banks;
  final List mnos;

  @override
  State<SafariPointsWithdrawScreen> createState() => _SafariPointsWithdrawScreenState();
}

class _SafariPointsWithdrawScreenState extends State<SafariPointsWithdrawScreen> {
  late final TextEditingController entry;
  late final TextEditingController sales;
  late final TextEditingController account;
  late final TextEditingController mobile;
  String payout = 'MNO';
  String? bank;
  String? mno;
  bool loading = false;

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
    entry = TextEditingController(text: '${widget.entryPoints}');
    sales = TextEditingController(text: '${widget.salesPoints}');
    account = TextEditingController();
    mobile = TextEditingController();
    bank = banks.isNotEmpty ? banks.first : null;
    mno = mnos.isNotEmpty ? mnos.first : null;
  }

  @override
  void dispose() {
    entry.dispose();
    sales.dispose();
    account.dispose();
    mobile.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => loading = true);
    try {
      final json = await SafariApi.post('/points/withdrawals', {
        'entry_points': int.tryParse(entry.text.trim()) ?? 0,
        'sales_points': int.tryParse(sales.text.trim()) ?? 0,
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
    return Scaffold(
      appBar: AppBar(title: const Text('Withdraw points')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          SafariCard(
            child: Text(
              'Net withdrawable ${money(widget.netTsh)}. Same formula as the portal: entry × entry rate + sales × sales rate, minus loan.',
              style: const TextStyle(color: SafariTheme.muted, fontSize: 13),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: entry,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Entry points (max ${widget.entryPoints})'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: sales,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Sales points (max ${widget.salesPoints})'),
          ),
          const SizedBox(height: 16),
          const Text('Deposit to', style: TextStyle(fontWeight: FontWeight.w800)),
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
            TextField(
              controller: mobile,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Mobile number'),
            ),
          ] else ...[
            DropdownButtonFormField<String>(
              value: banks.contains(bank) ? bank : null,
              items: banks.map((n) => DropdownMenuItem(value: n, child: Text(n))).toList(),
              onChanged: (v) => setState(() => bank = v),
              decoration: const InputDecoration(labelText: 'Bank name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: account,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(labelText: 'Account number'),
            ),
          ],
          const SizedBox(height: 20),
          SafariLoadingButton(loading: loading, label: 'Submit withdrawal', onPressed: _submit),
        ],
      ),
    );
  }
}

class SafariPointsWithdrawalStatusScreen extends StatelessWidget {
  const SafariPointsWithdrawalStatusScreen({super.key, required this.row});
  final Map<String, dynamic> row;

  @override
  Widget build(BuildContext context) {
    final receipt = row['receipt_url']?.toString();
    return Scaffold(
      appBar: AppBar(title: const Text('Withdrawal status')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          SafariCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SafariStatusChip('${row['status']}', tone: statusTone(row['status']?.toString())),
              const SizedBox(height: 10),
              Text(money(row['amount']), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text('Entry ${qtyFmt(row['entry_points'])} pts · Sales ${qtyFmt(row['sales_points'])} pts'),
              const SizedBox(height: 8),
              if ('${row['payout_type']}' == 'BANK')
                Text('${row['bank_name']} · ${row['account_number']}')
              else
                Text('${row['mno_name']} · ${row['mobile_number']}'),
              if ((row['transaction_number'] ?? '').toString().isNotEmpty) ...[
                const SizedBox(height: 8),
                Text('Txn ${row['transaction_number']}', style: const TextStyle(fontWeight: FontWeight.w700)),
              ],
              if ((row['admin_note'] ?? '').toString().isNotEmpty) ...[
                const SizedBox(height: 8),
                Text('${row['admin_note']}'),
              ],
            ]),
          ),
          if (receipt != null && receipt.isNotEmpty) ...[
            const SizedBox(height: 12),
            SafariCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Receipt', style: TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                Image.network(receipt, fit: BoxFit.contain),
              ]),
            ),
          ],
        ],
      ),
    );
  }
}
