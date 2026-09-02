import 'package:flutter/material.dart';
import 'package:wicom/safari/safari_api.dart';
import 'package:wicom/safari/safari_theme.dart';
import 'package:wicom/safari/safari_ui.dart';

class SafariLedgerDetailScreen extends StatefulWidget {
  const SafariLedgerDetailScreen({super.key, required this.id});
  final dynamic id;

  @override
  State<SafariLedgerDetailScreen> createState() => _SafariLedgerDetailScreenState();
}

class _SafariLedgerDetailScreenState extends State<SafariLedgerDetailScreen> {
  Map<String, dynamic>? row;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final json = await SafariApi.get('/wallet/ledger/${widget.id}');
      row = Map<String, dynamic>.from(SafariApi.data(json) as Map);
    } catch (e) {
      await safariError(context, e);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transaction')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                SafariHero(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('${row?['ledger_type']} · ${row?['direction']}', style: const TextStyle(color: SafariTheme.goldSoft)),
                    const SizedBox(height: 8),
                    Text(money(row?['amount']), style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800)),
                  ]),
                ),
                const SizedBox(height: 16),
                SafariCard(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    _kv('Reference', row?['reference']),
                    _kv('Note', row?['note']),
                    _kv('Currency', row?['currency']),
                    _kv('Created', row?['created_at']),
                  ]),
                ),
              ],
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
