import 'package:flutter/material.dart';
import 'package:wicom/safari/safari_api.dart';
import 'package:wicom/safari/safari_theme.dart';
import 'package:wicom/safari/safari_ui.dart';

class SafariWithdrawalStatusScreen extends StatefulWidget {
  const SafariWithdrawalStatusScreen({super.key, required this.id, this.initial});
  final dynamic id;
  final Map<String, dynamic>? initial;

  @override
  State<SafariWithdrawalStatusScreen> createState() => _SafariWithdrawalStatusScreenState();
}

class _SafariWithdrawalStatusScreenState extends State<SafariWithdrawalStatusScreen> {
  Map<String, dynamic>? row;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    row = widget.initial;
    _load();
  }

  Future<void> _load() async {
    try {
      final json = await SafariApi.get('/wallet/withdrawals/${widget.id}');
      row = Map<String, dynamic>.from(SafariApi.data(json) as Map);
    } catch (e) {
      await safariError(context, e);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = row?['status']?.toString() ?? 'REQUESTED';
    return Scaffold(
      appBar: AppBar(title: const Text('Withdrawal')),
      body: loading && row == null
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              color: SafariTheme.gold,
              onRefresh: _load,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  SafariHero(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(row?['request_no']?.toString() ?? 'Withdrawal', style: const TextStyle(color: SafariTheme.goldSoft)),
                      const SizedBox(height: 8),
                      Text(money(row?['amount']), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 10),
                      SafariStatusChip(status, tone: statusTone(status)),
                    ]),
                  ),
                  const SizedBox(height: 16),
                  SafariCard(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      _kv('Method', row?['payout_method']),
                      _kv('Account', row?['payout_account']),
                      _kv('Provider ref', row?['external_reference']),
                      _kv('Note', row?['admin_note']),
                      const SizedBox(height: 4),
                      const Text(
                        'Paid only after finance confirmation or a signed payment webhook. Pending and processing are not success.',
                        style: TextStyle(color: SafariTheme.muted, fontSize: 13),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(onPressed: _load, child: const Text('Refresh status')),
                ],
              ),
            ),
    );
  }

  Widget _kv(String k, dynamic v) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(k, style: const TextStyle(color: SafariTheme.muted, fontSize: 12, fontWeight: FontWeight.w600)),
        Text('${v ?? '—'}', style: const TextStyle(fontWeight: FontWeight.w700)),
      ]),
    );
  }
}
