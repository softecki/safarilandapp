import 'package:flutter/material.dart';
import 'package:wicom/safari/safari_api.dart';
import 'package:wicom/safari/safari_brand.dart';
import 'package:wicom/safari/safari_nav.dart';
import 'package:wicom/safari/safari_theme.dart';
import 'package:wicom/safari/safari_ui.dart';
import 'package:wicom/safari/screens/notifications_screen.dart';
import 'package:wicom/safari/screens/passport_screen.dart';
import 'package:wicom/safari/screens/tourists_screen.dart';
import 'package:wicom/safari/screens/trip_detail_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    final driver = home?['driver'] as Map? ?? SafariApi.driver ?? {};
    final wallet = home?['wallet'] as Map? ?? {};
    final trips = (home?['trips'] as List?) ?? [];
    final goals = (driver['goals'] as List?) ?? [];
    final tier = _tierCategory(driver, wallet);
    final stars = (tier['stars'] is num) ? (tier['stars'] as num).toInt() : 1;
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
                                          '${tier['label'] ?? 'Silver'}',
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
                                if ((driver['member_no'] ?? '').toString().isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  SafariStatusChip(driver['member_no'].toString(), tone: SafariChipTone.gold),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(children: [
                    Expanded(child: SafariCard(child: _miniStat('Available', money(wallet['available'])))),
                    const SizedBox(width: 10),
                    Expanded(child: SafariCard(child: _miniStat('Pending', money(wallet['pending'])))),
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
                  const SafariSectionTitle('Recent trips'),
                  if (trips.isEmpty)
                    const SafariEmpty('No trips yet. Start one from the Trips tab.', icon: Icons.groups_outlined)
                  else
                    ...trips.take(5).map((raw) {
                      final t = Map<String, dynamic>.from(raw as Map);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: SafariCard(
                          onTap: () => SafariNav.push(context, SafariTripDetailScreen(id: t['id'])),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Text(t['label']?.toString() ?? 'Trip', style: const TextStyle(fontWeight: FontWeight.w800)),
                                  Text('${t['guest_count'] ?? 0} guests', style: const TextStyle(color: SafariTheme.muted, fontSize: 13)),
                                ]),
                              ),
                              SafariStatusChip('${t['state'] ?? ''}', tone: SafariChipTone.neutral),
                            ],
                          ),
                        ),
                      );
                    }),
                ],
              ),
            ),
    );
  }

  Widget _miniStat(String label, String value) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(color: SafariTheme.muted, fontSize: 12, fontWeight: FontWeight.w600)),
      const SizedBox(height: 6),
      Text(value, style: const TextStyle(fontWeight: FontWeight.w800, color: SafariTheme.maroon, fontSize: 16)),
    ]);
  }
}
