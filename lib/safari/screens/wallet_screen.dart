import 'package:flutter/material.dart';
import 'package:wicom/safari/safari_api.dart';
import 'package:wicom/safari/safari_nav.dart';
import 'package:wicom/safari/safari_theme.dart';
import 'package:wicom/safari/safari_ui.dart';
import 'package:wicom/safari/screens/ledger_detail_screen.dart';
import 'package:wicom/safari/screens/withdraw_screen.dart';
import 'package:wicom/safari/screens/withdrawal_status_screen.dart';
import 'package:wicom/safari/screens/points_withdraw_screen.dart';

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
    final rewards = Map<String, dynamic>.from(data?['rewards'] as Map? ?? {});
    final amounts = Map<String, dynamic>.from(rewards['amounts'] as Map? ?? {});
    final points = Map<String, dynamic>.from(rewards['points'] as Map? ?? {});
    final pointsWithdrawals = (data?['points_withdrawals'] as List?) ?? [];
    final payoutOpts = Map<String, dynamic>.from(data?['points_payout_options'] as Map? ?? {});
    final banks = (payoutOpts['banks'] as List?) ?? [];
    final mnos = (payoutOpts['mnos'] as List?) ?? [];
    final ledger = (data?['ledger'] as List?) ?? [];
    final withdrawals = (data?['withdrawals'] as List?) ?? [];
    final loan = amounts['loan_tsh'];
    final loanN = loan is num ? loan.toInt() : int.tryParse('$loan') ?? 0;
    final net = amounts['net_tsh'];
    final netN = net is num ? net.toInt() : int.tryParse('$net') ?? 0;
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
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                children: [
                  SafariHero(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(
                        loanN > 0 ? 'Net amount' : 'Total amount',
                        style: const TextStyle(color: SafariTheme.goldSoft, letterSpacing: 0.6),
                      ),
                      const SizedBox(height: 8),
                      SafariCountUp(
                        amounts['net_tsh'] ?? 0,
                        moneyFormat: true,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: netN < 0 ? const Color(0xFFFFB4AB) : Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        loanN > 0
                            ? 'Gross ${money(amounts['gross_tsh'])}  ·  Loan ${money(amounts['loan_tsh'])}'
                            : 'Entry + Sales points in TZS',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 14),
                  Row(children: [
                    Expanded(child: SafariCard(child: _amountStat('Sales amount', amounts['sales_tsh'], sub: points['sales'], pts: true))),
                    const SizedBox(width: 10),
                    Expanded(child: SafariCard(child: _amountStat('Entry amount', amounts['entry_tsh'], sub: points['entry'], pts: true))),
                  ]),
                  const SizedBox(height: 8),
                  Row(children: [
                    Expanded(child: SafariCard(child: _amountStat('Gross total', amounts['gross_tsh']))),
                    const SizedBox(width: 10),
                    Expanded(child: SafariCard(child: _amountStat('Net withdrawable', amounts['net_tsh']))),
                  ]),
                  const SizedBox(height: 14),
                  ElevatedButton(
                    onPressed: () async {
                      await SafariNav.pushUp(
                        context,
                        SafariWithdrawScreen(
                          available: amounts['net_tsh'] ?? 0,
                          banks: banks,
                          mnos: mnos,
                        ),
                      );
                      _load();
                    },
                    child: const Text('Withdrawal'),
                  ),
                  const SafariSectionTitle('Withdrawals'),
                  if (pointsWithdrawals.isEmpty && withdrawals.isEmpty)
                    const SafariEmpty('No withdrawals yet.', icon: Icons.payments_outlined)
                  else ...[
                    ...pointsWithdrawals.map((raw) {
                      final row = Map<String, dynamic>.from(raw as Map);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: SafariCard(
                          onTap: () => SafariNav.push(context, SafariPointsWithdrawalStatusScreen(row: row)),
                          child: Row(children: [
                            Expanded(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                SafariCountUp(row['amount'], moneyFormat: true, style: const TextStyle(fontWeight: FontWeight.w800, color: SafariTheme.maroon, fontSize: 16)),
                                Text(
                                  '${row['payout_type'] == 'BANK' ? row['bank_name'] : row['mno_name']}',
                                  style: const TextStyle(color: SafariTheme.muted, fontSize: 12),
                                ),
                              ]),
                            ),
                            SafariStatusChip('${row['status']}', tone: statusTone(row['status']?.toString())),
                          ]),
                        ),
                      );
                    }),
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
                                SafariCountUp(row['amount'], moneyFormat: true, style: const TextStyle(color: SafariTheme.muted, fontSize: 13)),
                              ]),
                            ),
                            SafariStatusChip('${row['status']}', tone: statusTone(row['status']?.toString())),
                          ]),
                        ),
                      );
                    }),
                  ],
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
                            SafariCountUp(row['amount'], moneyFormat: true, style: const TextStyle(fontWeight: FontWeight.w800, color: SafariTheme.maroon, fontSize: 16)),
                          ]),
                        ),
                      );
                    }),
                ],
              ),
            ),
    );
  }

  Widget _amountStat(String label, dynamic value, {dynamic sub, bool pts = false}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(color: SafariTheme.muted, fontSize: 12, fontWeight: FontWeight.w600)),
      const SizedBox(height: 6),
      SafariCountUp(value, moneyFormat: true, style: const TextStyle(fontWeight: FontWeight.w800, color: SafariTheme.maroon, fontSize: 16)),
      if (sub != null) ...[
        const SizedBox(height: 4),
        SafariCountUp(sub, suffix: pts ? ' pts' : '', style: const TextStyle(color: SafariTheme.muted, fontSize: 11)),
      ],
    ]);
  }
}
