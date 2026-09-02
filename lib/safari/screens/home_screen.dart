import 'package:flutter/material.dart';
import 'package:wicom/safari/safari_api.dart';
import 'package:wicom/safari/safari_brand.dart';
import 'package:wicom/safari/safari_nav.dart';
import 'package:wicom/safari/safari_theme.dart';
import 'package:wicom/safari/safari_ui.dart';
import 'package:wicom/safari/screens/ledger_detail_screen.dart';
import 'package:wicom/safari/screens/notifications_screen.dart';
import 'package:wicom/safari/screens/passport_screen.dart';
import 'package:wicom/safari/screens/tourists_screen.dart';
import 'package:wicom/safari/screens/transactions_screen.dart';

class SafariHomeScreen extends StatefulWidget {
  const SafariHomeScreen({super.key});

  @override
  State<SafariHomeScreen> createState() => _SafariHomeScreenState();
}

class _SafariHomeScreenState extends State<SafariHomeScreen> {
  Map<String, dynamic>? home;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final json = await SafariApi.get('/home');
      home = Map<String, dynamic>.from(SafariApi.data(json) as Map);
      SafariApi.driver = Map<String, dynamic>.from(home?['driver'] as Map? ?? SafariApi.driver ?? {});
    } catch (e) {
      await safariError(context, e);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Map<String, dynamic> _tierCategory(Map driver, Map wallet) {
    final fromApi = home?['tier_category'] as Map? ?? driver['tier_category'] as Map? ?? home?['loyalty'] as Map? ?? driver['loyalty'] as Map?;
    if (fromApi != null) return Map<String, dynamic>.from(fromApi);
    final lifetime = wallet['lifetime'];
    final n = lifetime is num ? lifetime.toInt() : int.tryParse('$lifetime') ?? 0;
    if (n >= 5000000) return {'key': 'PLATINUM', 'label': 'Platinum', 'stars': 3, 'level': 'Highest'};
    if (n >= 1000000) return {'key': 'GOLD', 'label': 'Gold', 'stars': 2, 'level': 'Premium'};
    return {'key': 'SILVER', 'label': 'Silver', 'stars': 1, 'level': 'Basic'};
  }

  Map<String, dynamic> _map(dynamic raw) => Map<String, dynamic>.from(raw as Map? ?? {});

  @override
  Widget build(BuildContext context) {
    final driver = home?['driver'] as Map? ?? SafariApi.driver ?? {};
    final wallet = home?['wallet'] as Map? ?? {};
    final rewards = _map(home?['rewards']);
    final points = _map(rewards['points']);
    final amounts = _map(rewards['amounts']);
    final counts = _map(rewards['counts']);
    final tierInfo = _map(rewards['tier']);
    final currentTier = _map(tierInfo['current']);
    final nextTier = _map(tierInfo['next']);
    final promo = rewards['promo'] is Map ? _map(rewards['promo']) : <String, dynamic>{};
    final tokens = ((rewards['recent_tokens'] as List?) ?? []).where((raw) {
      final code = '${(raw as Map)['token']}'.toUpperCase();
      return code.startsWith('AG-');
    }).toList();
    final entries = (rewards['recent_entries'] as List?) ?? [];
    final transactions = ((home?['recent_transactions'] as List?) ?? [])
        .where((raw) => '${(raw as Map)['ledger_type']}'.toUpperCase() == 'COMMISSION')
        .toList();
    final goals = (driver['goals'] as List?) ?? [];
    final tier = _tierCategory(driver, wallet);
    final stars = (tier['stars'] is num) ? (tier['stars'] as num).toInt() : 1;
    final hasRewards = rewards.isNotEmpty;
    final loan = amounts['loan_tsh'];
    final loanN = loan is num ? loan.toInt() : int.tryParse('$loan') ?? 0;
    final net = amounts['net_tsh'];
    final netN = net is num ? net.toInt() : int.tryParse('$net') ?? 0;
    final tierName = (currentTier['name'] ?? '').toString();
    final heroTier = tierName.isNotEmpty ? tierName : '${tier['label'] ?? 'Silver'}';
    final progress = (tierInfo['progress'] is num) ? (tierInfo['progress'] as num).toDouble() : 0;

    return Scaffold(
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              color: SafariTheme.gold,
              onRefresh: () async {
                setState(() => loading = true);
                await _load();
              },
              child: ListView(
                padding: EdgeInsets.fromLTRB(16, MediaQuery.paddingOf(context).top + 4, 16, 96),
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: Badge(
                        isLabelVisible: (home?['unread_notifications'] ?? 0) > 0,
                        child: const Icon(Icons.notifications_outlined),
                      ),
                      onPressed: () => SafariNav.push(context, const SafariNotificationsScreen()),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.asset(
                            SafariBrand.logoAsset,
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                            errorBuilder: (_, __, ___) => const ColoredBox(color: SafariTheme.maroon),
                          ),
                        ),
                        Positioned.fill(
                          child: ColoredBox(color: SafariTheme.maroonDark.withValues(alpha: 0.58)),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
                          child: DefaultTextStyle.merge(
                            style: const TextStyle(color: Colors.white),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Expanded(
                                      child: Text(
                                        'Welcome',
                                        style: TextStyle(
                                          color: SafariTheme.goldSoft,
                                          letterSpacing: 1.4,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          heroTier,
                                          style: const TextStyle(
                                            color: SafariTheme.goldSoft,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 13,
                                            letterSpacing: 1.2,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: List.generate(
                                            stars.clamp(1, 3),
                                            (_) => const Padding(
                                              padding: EdgeInsets.only(left: 2),
                                              child: Icon(Icons.star_rounded, size: 16, color: SafariTheme.gold),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  driver['name']?.toString() ?? 'Guide',
                                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
                                ),
                                if ((driver['member_no'] ?? rewards['card_number'] ?? '').toString().isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  SafariStatusChip(
                                    (driver['member_no'] ?? rewards['card_number']).toString(),
                                    tone: SafariChipTone.gold,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (hasRewards) ...[
                    if (tierName.isNotEmpty && (nextTier['name'] ?? '').toString().isNotEmpty) ...[
                      const SizedBox(height: 14),
                      SafariCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${qtyFmt(tierInfo['points_needed'])} points to ${nextTier['name']}',
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: (progress / 100).clamp(0, 1),
                                minHeight: 8,
                                color: SafariTheme.gold,
                                backgroundColor: const Color(0xFFE4D9CC),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (promo.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      SafariCard(
                        child: Text(
                          '+${qtyFmt(promo['bonus_points'])} bonus pts from ${qtyFmt(promo['application_count'])} promo application(s)',
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                        ),
                      ),
                    ],
                    const SizedBox(height: 14),
                    Row(children: [
                      Expanded(
                        child: SafariCard(
                          child: _miniStat('Total points', qtyFmt(points['total']), sub: 'Entry + Sales'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SafariCard(
                          child: _miniStat(
                            loanN > 0 ? 'Net amount' : 'Total amount',
                            money(amounts['net_tsh']),
                            sub: loanN > 0 ? 'Gross ${money(amounts['gross_tsh'])}' : 'Tanzanian Shillings',
                            valueColor: netN < 0 ? const Color(0xFFB3261E) : SafariTheme.maroon,
                          ),
                        ),
                      ),
                    ]),
                    const SizedBox(height: 8),
                    Row(children: [
                      Expanded(
                        child: SafariCard(
                          child: _miniStat('Entry points', qtyFmt(points['entry']), sub: money(amounts['entry_tsh'])),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SafariCard(
                          child: _miniStat('Sales points', qtyFmt(points['sales']), sub: money(amounts['sales_tsh'])),
                        ),
                      ),
                    ]),
                    const SizedBox(height: 8),
                    SafariCard(
                      child: Column(
                        children: [
                          _breakdownRow('Gross total', money(amounts['gross_tsh'])),
                          if (loanN > 0) _breakdownRow('Loan balance', '− ${money(amounts['loan_tsh'])}', danger: true),
                          _breakdownRow('Net withdrawable', money(amounts['net_tsh']), bold: true),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(children: [
                      Expanded(child: SafariCard(child: _miniStat('Reward tokens', qtyFmt(counts['tokens_used'])))),
                      const SizedBox(width: 10),
                      Expanded(child: SafariCard(child: _miniStat('Entries', qtyFmt(counts['entries'])))),
                    ]),
                    const SizedBox(height: 8),
                    Row(children: [
                      Expanded(child: SafariCard(child: _miniStat('Withdrawals', qtyFmt(counts['withdrawals'])))),
                      const SizedBox(width: 10),
                      Expanded(child: SafariCard(child: _miniStat('Loans', qtyFmt(counts['loans'])))),
                    ]),
                    if ((counts['missed_tokens'] ?? 0) != 0 || (counts['missed_entries'] ?? 0) != 0) ...[
                      const SizedBox(height: 8),
                      Row(children: [
                        Expanded(child: SafariCard(child: _miniStat('Missed tokens', qtyFmt(counts['missed_tokens'])))),
                        const SizedBox(width: 10),
                        Expanded(child: SafariCard(child: _miniStat('Missed entries', qtyFmt(counts['missed_entries'])))),
                      ]),
                    ],
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8, top: 12),
                      child: Text(
                        'Reward tokens',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: SafariTheme.black),
                      ),
                    ),
                    if (tokens.isEmpty)
                      const SafariEmpty('No reward tokens yet.', icon: Icons.confirmation_number_outlined)
                    else
                      ...tokens.take(8).map((raw) {
                        final row = _map(raw);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: SafariCard(
                            child: Row(
                              children: [
                                const Icon(Icons.qr_code_2, color: SafariTheme.gold),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('${row['token'] ?? ''}', style: const TextStyle(fontWeight: FontWeight.w800)),
                                      Text(
                                        safariDate(row['day']),
                                        style: const TextStyle(color: SafariTheme.muted, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(money(row['sales_amount']), style: const TextStyle(fontWeight: FontWeight.w800)),
                              ],
                            ),
                          ),
                        );
                      }),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8, top: 4),
                      child: Text(
                        'Recent entries',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: SafariTheme.black),
                      ),
                    ),
                    if (entries.isEmpty)
                      const SafariEmpty('No entries yet.', icon: Icons.login_outlined)
                    else
                      ...entries.take(8).map((raw) {
                        final row = _map(raw);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: SafariCard(
                            child: Row(
                              children: [
                                const Icon(Icons.login, color: SafariTheme.maroon),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    safariDate(row['day']),
                                    style: const TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                ),
                                Text('${qtyFmt(row['points'])} pts', style: const TextStyle(fontWeight: FontWeight.w800)),
                              ],
                            ),
                          ),
                        );
                      }),
                    const SizedBox(height: 6),
                  ],
                  const SizedBox(height: 8),
                  Row(children: [
                    Expanded(child: SafariCard(child: _miniStat('Commission available', money(wallet['available'])))),
                    const SizedBox(width: 10),
                    Expanded(child: SafariCard(child: _miniStat('Commission pending', money(wallet['pending'])))),
                  ]),
                  const SizedBox(height: 8),
                  Row(children: [
                    Expanded(
                      child: SafariActionTile(
                        icon: Icons.confirmation_number_outlined,
                        label: 'Passes',
                        onTap: () => SafariNav.push(context, const SafariTouristsScreen()),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SafariActionTile(
                        icon: Icons.menu_book_outlined,
                        label: 'Passport',
                        onTap: () => SafariNav.push(context, const SafariPassportScreen()),
                      ),
                    ),
                  ]),
                  if (goals.isNotEmpty) ...[
                    const SafariSectionTitle('Goals'),
                    SafariCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: goals
                            .map((g) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(children: [
                                    const Icon(Icons.flag_outlined, size: 16, color: SafariTheme.gold),
                                    const SizedBox(width: 8),
                                    Expanded(child: Text('$g')),
                                  ]),
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8, top: 8),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Recent commissions',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: SafariTheme.black),
                          ),
                        ),
                        if (transactions.isNotEmpty)
                          TextButton(
                            onPressed: () => SafariNav.push(
                              context,
                              const SafariTransactionsScreen(ledgerType: 'COMMISSION'),
                            ),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              foregroundColor: SafariTheme.maroon,
                              textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                            ),
                            child: const Text('More'),
                          ),
                      ],
                    ),
                  ),
                  if (transactions.isEmpty)
                    const SafariEmpty('No commissions yet.', icon: Icons.receipt_long_outlined)
                  else
                    ...transactions.take(8).map((raw) {
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

  Widget _miniStat(String label, String value, {String? sub, Color? valueColor}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(color: SafariTheme.muted, fontSize: 12, fontWeight: FontWeight.w600)),
      const SizedBox(height: 6),
      Text(value, style: TextStyle(fontWeight: FontWeight.w800, color: valueColor ?? SafariTheme.maroon, fontSize: 16)),
      if (sub != null && sub.isNotEmpty) ...[
        const SizedBox(height: 4),
        Text(sub, style: const TextStyle(color: SafariTheme.muted, fontSize: 11)),
      ],
    ]);
  }

  Widget _breakdownRow(String label, String value, {bool bold = false, bool danger = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
                fontSize: bold ? 14 : 13,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: danger ? const Color(0xFFB3261E) : SafariTheme.black,
            ),
          ),
        ],
      ),
    );
  }
}
