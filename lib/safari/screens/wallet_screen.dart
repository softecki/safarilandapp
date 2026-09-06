import 'package:flutter/material.dart';
import 'package:wicom/safari/safari_api.dart';
import 'package:wicom/safari/safari_nav.dart';
import 'package:wicom/safari/safari_theme.dart';
import 'package:wicom/safari/safari_ui.dart';
import 'package:wicom/safari/screens/ledger_detail_screen.dart';
import 'package:wicom/safari/screens/points_withdraw_screen.dart';
import 'package:wicom/safari/screens/transactions_screen.dart';
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
    final balances = Map<String, dynamic>.from(data?['balances'] as Map? ?? {});
    final rewards = Map<String, dynamic>.from(data?['rewards'] as Map? ?? {});
    final amounts = Map<String, dynamic>.from(rewards['amounts'] as Map? ?? {});
    final points = Map<String, dynamic>.from(rewards['points'] as Map? ?? {});
    final pointsWithdrawals = (data?['points_withdrawals'] as List?) ?? [];
    final payoutOpts = Map<String, dynamic>.from(data?['points_payout_options'] as Map? ?? {});
    final banks = (payoutOpts['banks'] as List?) ?? [];
    final mnos = (payoutOpts['mnos'] as List?) ?? [];
    final ledger = (data?['ledger'] as List?) ?? [];
    final withdrawals = (data?['withdrawals'] as List?) ?? [];
    final available = balances['available'] ?? amounts['net_tsh'] ?? 0;

    return Scaffold(
      appBar: Navigator.canPop(context) ? AppBar(title: const Text('Wallet')) : null,
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              color: SafariTheme.gold,
              onRefresh: () async {
                setState(() => loading = true);
                await _load();
              },
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 88),
                children: [
                  if (!Navigator.canPop(context))
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text('Wallet', style: Theme.of(context).textTheme.titleLarge),
                    ),
                  SafariWalletHero(
                    label: 'Available commission',
                    amount: available,
                    actionLabel: 'Withdraw commission',
                    onAction: () async {
                      await SafariNav.pushUp(
                        context,
                        SafariWithdrawScreen(available: available, banks: banks, mnos: mnos, commissionMode: true),
                      );
                      _load();
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(children: [
                    Expanded(child: SafariStatBox(value: money(balances['pending']), label: 'Pending')),
                    const SizedBox(width: 8),
                    Expanded(child: SafariStatBox(value: money(balances['gratuity_available']), label: 'Gratuity')),
                    const SizedBox(width: 8),
                    Expanded(child: SafariStatBox(value: qtyFmt(points['total']), label: 'Points')),
                  ]),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () async {
                      await SafariNav.pushUp(
                        context,
                        SafariWithdrawScreen(available: amounts['net_tsh'] ?? 0, banks: banks, mnos: mnos),
                      );
                      _load();
                    },
                    child: const Text('Withdraw points'),
                  ),
                  SafariSectionTitle('Withdrawals', action: 'All activity', onAction: () => SafariNav.push(context, const SafariTransactionsScreen())),
                  if (pointsWithdrawals.isEmpty && withdrawals.isEmpty)
                    const SafariEmpty('No withdrawals yet.', icon: Icons.payments_outlined)
                  else ...[
                    ...withdrawals.map((raw) {
                      final row = Map<String, dynamic>.from(raw as Map);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: SafariCard(
                          onTap: () => SafariNav.push(context, SafariWithdrawalStatusScreen(id: row['id'])),
                          child: Row(children: [
                            Expanded(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(row['request_no']?.toString() ?? 'Commission', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                SafariCountUp(row['amount'], moneyFormat: true, style: const TextStyle(color: SafariTheme.muted, fontSize: 13)),
                              ]),
                            ),
                            SafariStatusChip('${row['status']}', tone: statusTone(row['status']?.toString())),
                          ]),
                        ),
                      );
                    }),
                    ...pointsWithdrawals.map((raw) {
                      final row = Map<String, dynamic>.from(raw as Map);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: SafariCard(
                          onTap: () => SafariNav.push(context, SafariPointsWithdrawalStatusScreen(row: row)),
                          child: Row(children: [
                            Expanded(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                const Text('Points', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                SafariCountUp(row['amount'], moneyFormat: true, style: const TextStyle(color: SafariTheme.muted, fontSize: 13)),
                              ]),
                            ),
                            SafariStatusChip('${row['status']}', tone: statusTone(row['status']?.toString())),
                          ]),
                        ),
                      );
                    }),
                  ],
                  const SafariSectionTitle('Recent ledger'),
                  if (ledger.isEmpty)
                    const SafariEmpty('No wallet movements yet.', icon: Icons.receipt_long_outlined)
                  else
                    ...ledger.take(8).map((raw) {
                      final row = Map<String, dynamic>.from(raw as Map);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: SafariLedgerCard(
                          row: row,
                          onTap: () => SafariNav.push(context, SafariLedgerDetailScreen(id: row['id'])),
                        ),
                      );
                    }),
                ],
              ),
            ),
    );
  }
}
