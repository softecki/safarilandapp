import 'package:flutter/material.dart';
import 'package:wicom/safari/safari_api.dart';
import 'package:wicom/safari/safari_nav.dart';
import 'package:wicom/safari/safari_theme.dart';
import 'package:wicom/safari/safari_ui.dart';
import 'package:wicom/safari/screens/farewell_screen.dart';
import 'package:wicom/safari/screens/notifications_screen.dart';
import 'package:wicom/safari/screens/passport_screen.dart';
import 'package:wicom/safari/screens/story_screen.dart';
import 'package:wicom/safari/screens/tourists_screen.dart';
import 'package:wicom/safari/screens/transactions_screen.dart';
import 'package:wicom/safari/screens/trip_detail_screen.dart';
import 'package:wicom/safari/screens/withdraw_screen.dart';

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
      final token = SafariApi.token;
      if (token != null && SafariApi.driver != null) {
        await SafariApi.saveAuth(token, SafariApi.driver!);
      }
    } catch (e) {
      await safariError(context, e);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Map<String, dynamic> _map(dynamic raw) => Map<String, dynamic>.from(raw as Map? ?? {});

  Future<void> _coming(Map trip) async {
    final count = TextEditingController(text: '${trip['guest_count'] ?? trip['guests_count'] ?? 1}');
    final ok = await safariSheet<bool>(
      context,
      Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("I'm Coming to Safari Land", style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        Text(trip['label']?.toString() ?? 'Current trip', style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        TextField(controller: count, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Guest count')),
        const SizedBox(height: 16),
        ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Notify Safari Land')),
      ]),
    );
    if (ok != true) return;
    try {
      await SafariApi.post('/trips/${trip['id']}/coming', {
        'guest_count': int.tryParse(count.text) ?? safariGuestCount(trip),
        'eta_at': DateTime.now().add(const Duration(hours: 2)).toIso8601String(),
      });
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Safari Land notified')));
    } catch (e) {
      await safariError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final wallet = home?['wallet'] as Map? ?? {};
    final rewards = _map(home?['rewards']);
    final points = _map(rewards['points']);
    final trips = (home?['trips'] as List?) ?? [];
    final current = trips.cast<dynamic>().map((e) => _map(e)).firstWhere(
          (t) => '${t['state']}' == 'ON_SAFARI',
          orElse: () => trips.isNotEmpty ? _map(trips.first) : <String, dynamic>{},
        );
    final amounts = _map(rewards['amounts']);
    final availablePoints = amounts['net_tsh'] ?? wallet['available'] ?? 0;
    final activity = ((home?['recent_points_withdrawals'] as List?) ?? (home?['recent_transactions'] as List?) ?? []).toList();
    final referred = home?['pass_count'] ?? 0;

    return Scaffold(
      body: loading
          ? Column(
              children: [
                SafariStickyHeader(
                  onNotify: () => SafariNav.push(context, const SafariNotificationsScreen()),
                ),
                const Expanded(child: Center(child: CircularProgressIndicator())),
              ],
            )
          : RefreshIndicator(
              color: SafariTheme.gold,
              onRefresh: () async {
                setState(() => loading = true);
                await _load();
              },
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  SafariStickyHeader(
                    onNotify: () => SafariNav.push(context, const SafariNotificationsScreen()),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 88),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                  SafariWalletHero(
                    label: 'Available points',
                    amount: availablePoints,
                    actionLabel: 'Withdraw',
                    onAction: () => SafariNav.pushUp(
                      context,
                      SafariWithdrawScreen(available: availablePoints),
                    ),
                    stats: [
                      ('Guests referred', qtyFmt(referred)),
                      ('Lifetime', qtyFmt(points['total'] ?? wallet['lifetime'])),
                      ('Points', qtyFmt(points['total'])),
                    ],
                  ),
                  const SizedBox(height: 14),
                  SafariActionGrid(children: [
                    SafariActionTile(icon: Icons.confirmation_number_outlined, label: 'Create Pass', onTap: () => SafariNav.push(context, const SafariTouristsScreen())),
                    SafariActionTile(icon: Icons.qr_code_2, label: 'My QR', onTap: () => SafariTabs.go(SafariTabs.qr)),
                    SafariActionTile(
                      icon: Icons.directions_car_outlined,
                      label: "I'm Coming",
                      onTap: current.isEmpty ? () => safariError(context, 'Create a trip first') : () => _coming(current),
                    ),
                  ]),
                  if (current.isNotEmpty) ...[
                    SafariSectionTitle('Current Safari', action: 'View trip', onAction: () => SafariNav.push(context, SafariTripDetailScreen(id: current['id']))),
                    SafariCard(
                      goldEdge: true,
                      onTap: () => SafariNav.push(context, SafariTripDetailScreen(id: current['id'])),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          SafariStatusChip('${current['state']}'.replaceAll('_', ' '), tone: SafariChipTone.gold),
                          const Spacer(),
                          Text('${safariGuestCount(current)} guests', style: const TextStyle(color: SafariTheme.muted, fontSize: 12)),
                        ]),
                        const SizedBox(height: 10),
                        Text(current['label']?.toString() ?? 'Trip', style: Theme.of(context).textTheme.titleMedium),
                        if ((current['itinerary'] ?? current['primary_nationality'] ?? '').toString().isNotEmpty)
                          Text(
                            '${current['primary_nationality'] ?? ''} · ${current['primary_language'] ?? ''}',
                            style: const TextStyle(color: SafariTheme.muted),
                          ),
                        const SizedBox(height: 12),
                        Row(children: [
                          Expanded(child: SafariAltButton(label: 'Capture Story', onPressed: () => SafariNav.push(context, SafariStoryScreen(tripId: current['id'])))),
                          const SizedBox(width: 8),
                          Expanded(child: SafariGoldButton(label: 'Farewell', onPressed: () => SafariNav.pushUp(context, SafariFarewellScreen(trip: current)))),
                        ]),
                      ]),
                    ),
                  ],
                  const SafariSectionTitle('Quick tools'),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 9,
                    crossAxisSpacing: 9,
                    childAspectRatio: 1.75,
                    children: [
                      SafariFeatureTile(
                        title: 'Safari Story',
                        subtitle: 'Voice, photos, AI polish',
                        onTap: current.isEmpty ? () => safariError(context, 'Create a trip first') : () => SafariNav.push(context, SafariStoryScreen(tripId: current['id'])),
                      ),
                      SafariFeatureTile(
                        title: 'Farewell Studio',
                        subtitle: 'Private messages for guests',
                        onTap: current.isEmpty ? () => safariError(context, 'Create a trip first') : () => SafariNav.pushUp(context, SafariFarewellScreen(trip: current)),
                      ),
                      SafariFeatureTile(title: 'Guide Passport', subtitle: 'Profile & reputation', onTap: () => SafariNav.push(context, const SafariPassportScreen())),
                      SafariFeatureTile(title: 'Wallet', subtitle: 'Points & withdrawals', onTap: () => SafariTabs.go(SafariTabs.wallet)),
                    ],
                  ),
                  SafariSectionTitle('Recent activity', action: 'More', onAction: () => SafariNav.push(context, const SafariTransactionsScreen())),
                  if (activity.isEmpty)
                    const SafariEmpty('No points withdrawals yet.', icon: Icons.receipt_long_outlined)
                  else
                    ...activity.take(5).map((raw) {
                      final row = _map(raw);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: SafariCard(
                          child: Row(children: [
                            const Icon(Icons.payments_outlined, color: SafariTheme.gold),
                            const SizedBox(width: 10),
                            Expanded(child: Text(ledgerTypeLabel(row['ledger_type'] ?? 'POINTS'), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
                            SafariCountUp(row['amount'], moneyFormat: true, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: SafariTheme.maroon)),
                          ]),
                        ),
                      );
                    }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
