import 'package:flutter/material.dart';
import 'package:wicom/safari/safari_api.dart';
import 'package:wicom/safari/safari_nav.dart';
import 'package:wicom/safari/safari_theme.dart';
import 'package:wicom/safari/safari_ui.dart';
import 'package:wicom/safari/screens/ledger_detail_screen.dart';
import 'package:wicom/safari/screens/withdraw_screen.dart';
import 'package:wicom/safari/screens/withdrawal_status_screen.dart';

class SafariWalletScreen extends StatefulWidget {
  const SafariWalletScreen({super.key});

  @override
  State<SafariWalletScreen> createState() => _SafariWalletScreenState();
}

class _SafariWalletScreenState extends State<SafariWalletScreen> {
  Map<String, dynamic>? data;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final json = await SafariApi.get('/wallet');
      data = Map<String, dynamic>.from(SafariApi.data(json) as Map);
    } catch (e) {
      await safariError(context, e);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final b = data?['balances'] as Map? ?? {};
    final ledger = (data?['ledger'] as List?) ?? [];
    final withdrawals = (data?['withdrawals'] as List?) ?? [];
    return Scaffold(
      appBar: AppBar(title: const Text('Wallet')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              color: SafariTheme.gold,
              onRefresh: () async {
                setState(() => loading = true);
                await _load();
              },
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
                children: [
                  SafariHero(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('Available commission', style: TextStyle(color: SafariTheme.goldSoft, letterSpacing: 0.6)),
                      const SizedBox(height: 8),
                      Text(money(b['available']), style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 10),
                      Text('Pending ${money(b['pending'])}  ·  Lifetime ${money(b['lifetime'])}', style: const TextStyle(color: Colors.white70)),
                      Text('Gratuity ${money(b['gratuity_available'])}', style: const TextStyle(color: Colors.white70)),
                    ]),
                  ),
                  const SizedBox(height: 14),
                  ElevatedButton(
                    onPressed: () async {
                      await SafariNav.pushUp(context, SafariWithdrawScreen(available: b['available'] ?? 0));
                      _load();
                    },
                    child: const Text('Request withdrawal'),
                  ),
                  const SafariSectionTitle('Withdrawals'),
                  if (withdrawals.isEmpty)
                    const SafariEmpty('No withdrawal requests yet.', icon: Icons.account_balance_outlined)
                  else
                    ...withdrawals.map((raw) {
                      final row = Map<String, dynamic>.from(raw as Map);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: SafariCard(
                          onTap: () => SafariNav.push(context, SafariWithdrawalStatusScreen(id: row['id'])),
                          child: Row(children: [
                            Expanded(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(row['request_no']?.toString() ?? 'Withdrawal', style: const TextStyle(fontWeight: FontWeight.w800)),
                                Text(money(row['amount']), style: const TextStyle(color: SafariTheme.muted)),
                              ]),
                            ),
                            SafariStatusChip('${row['status']}', tone: statusTone(row['status']?.toString())),
                          ]),
                        ),
                      );
                    }),
                  const SafariSectionTitle('Ledger'),
                  if (ledger.isEmpty)
                    const SafariEmpty('No wallet movements yet.', icon: Icons.receipt_long_outlined)
                  else
                    ...ledger.map((raw) {
                      final row = Map<String, dynamic>.from(raw as Map);
                      final inbound = '${row['direction']}' == 'IN';
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: SafariCard(
                          onTap: () => SafariNav.push(context, SafariLedgerDetailScreen(id: row['id'])),
                          child: Row(children: [
                            Icon(inbound ? Icons.south_west : Icons.north_east, color: inbound ? const Color(0xFF1F6B3A) : SafariTheme.maroon),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text('${row['ledger_type']} · ${row['direction']}', style: const TextStyle(fontWeight: FontWeight.w800)),
                                Text(row['note']?.toString() ?? row['reference']?.toString() ?? '', style: const TextStyle(color: SafariTheme.muted, fontSize: 12)),
                              ]),
                            ),
                            Text(money(row['amount']), style: const TextStyle(fontWeight: FontWeight.w800)),
                          ]),
                        ),
                      );
                    }),
                ],
              ),
            ),
    );
  }
}
