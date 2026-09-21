import 'package:flutter/material.dart';
import 'package:wicom/safari/safari_api.dart';
import 'package:wicom/safari/safari_nav.dart';
import 'package:wicom/safari/safari_theme.dart';
import 'package:wicom/safari/safari_ui.dart';
import 'package:wicom/safari/screens/points_withdraw_screen.dart';
import 'package:wicom/safari/screens/transactions_screen.dart';
import 'package:wicom/safari/screens/withdraw_screen.dart';

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
    final available = amounts['net_tsh'] ?? balances['available'] ?? 0;

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
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Wallet', style: SafariTheme.display(size: 28)),
                        const SizedBox(height: 4),
                        const Text('Available points, withdrawals, and referral activity.', style: TextStyle(color: SafariTheme.muted, fontSize: 13)),
                      ]),
                    ),
                  SafariWalletHero(
                    label: 'Available points',
                    amount: available,
                    actionLabel: 'Withdraw points',
                    onAction: () async {
                      await SafariNav.pushUp(
                        context,
                        SafariWithdrawScreen(available: available, banks: banks, mnos: mnos),
                      );
                      _load();
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(children: [
                    Expanded(child: SafariStatBox(value: qtyFmt(points['entry']), label: 'Entry points')),
                    const SizedBox(width: 8),
                    Expanded(child: SafariStatBox(value: qtyFmt(points['sales']), label: 'Sales points')),
                    const SizedBox(width: 8),
                    Expanded(child: SafariStatBox(value: qtyFmt(points['total']), label: 'Total points')),
                  ]),
                  SafariSectionTitle('Points withdrawals', action: 'All activity', onAction: () => SafariNav.push(context, const SafariTransactionsScreen())),
                  if (pointsWithdrawals.isEmpty)
                    const SafariEmpty('No points withdrawals yet.', icon: Icons.payments_outlined)
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
                ],
              ),
            ),
    );
  }
}
