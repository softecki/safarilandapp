import 'package:flutter/material.dart';
import 'package:wicom/safari/safari_api.dart';
import 'package:wicom/safari/safari_nav.dart';
import 'package:wicom/safari/safari_theme.dart';
import 'package:wicom/safari/safari_ui.dart';
import 'package:wicom/safari/screens/ledger_detail_screen.dart';
import 'package:wicom/safari/screens/points_withdraw_screen.dart';

class SafariTransactionsScreen extends StatefulWidget {
  const SafariTransactionsScreen({super.key, this.ledgerType});
  final String? ledgerType;

  @override
  State<SafariTransactionsScreen> createState() => _SafariTransactionsScreenState();
}

class _SafariTransactionsScreenState extends State<SafariTransactionsScreen> {
  List items = [];
  bool loading = true;
  String? ledgerType;

  @override
  void initState() {
    super.initState();
    ledgerType = widget.ledgerType;
    _load();
  }

  DateTime? _created(Map row) => DateTime.tryParse('${row['created_at'] ?? row['paid_at'] ?? ''}');

  List _newestFirst(List rows) {
    final mapped = rows.map((raw) => Map<String, dynamic>.from(raw as Map)).toList();
    mapped.sort((a, b) {
      final da = _created(a) ?? DateTime.fromMillisecondsSinceEpoch(0);
      final db = _created(b) ?? DateTime.fromMillisecondsSinceEpoch(0);
      return db.compareTo(da);
    });
    return mapped;
  }

  Future<void> _load() async {
    setState(() => loading = true);
    try {
      if (ledgerType == 'GRATUITY') {
        final json = await SafariApi.get('/wallet/ledger?limit=100&page=1&ledger_type=GRATUITY');
        final data = SafariApi.data(json) as Map? ?? {};
        items = _newestFirst((data['items'] as List?) ?? []);
      } else {
        final json = await SafariApi.get('/points/withdrawals');
        items = _newestFirst((SafariApi.data(json) as List?) ?? []);
      }
    } catch (e) {
      await safariError(context, e);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Withdrawals')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              color: SafariTheme.gold,
              onRefresh: _load,
              child: items.isEmpty
                  ? ListView(
                      children: const [
                        SafariEmpty('No withdrawals yet.', icon: Icons.receipt_long_outlined),
                      ],
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (_, i) {
                        final row = Map<String, dynamic>.from(items[i] as Map);
                        if (ledgerType == 'GRATUITY') {
                          return SafariLedgerCard(
                            row: row,
                            onTap: () => SafariNav.push(context, SafariLedgerDetailScreen(id: row['id'])),
                          );
                        }
                        return SafariCard(
                          onTap: () => SafariNav.push(context, SafariPointsWithdrawalStatusScreen(row: row)),
                          child: Row(children: [
                            Expanded(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                const Text('Withdrawal amount', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                if (safariDate(row['created_at']).isNotEmpty)
                                  Text(safariDate(row['created_at']), style: const TextStyle(color: SafariTheme.muted, fontSize: 12)),
                              ]),
                            ),
                            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                              SafariCountUp(row['amount'], moneyFormat: true, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: SafariTheme.maroon)),
                              const SizedBox(height: 4),
                              SafariStatusChip('${row['status']}', tone: statusTone(row['status']?.toString())),
                            ]),
                          ]),
                        );
                      },
                    ),
            ),
    );
  }
}
