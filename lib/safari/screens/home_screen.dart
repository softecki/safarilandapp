import 'package:flutter/material.dart';
import 'package:wicom/safari/safari_api.dart';
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

  @override
  Widget build(BuildContext context) {
    final driver = home?['driver'] as Map? ?? SafariApi.driver ?? {};
    final wallet = home?['wallet'] as Map? ?? {};
    final trips = (home?['trips'] as List?) ?? [];
    final goals = (driver['goals'] as List?) ?? [];
    return Scaffold(
      appBar: AppBar(
        title: const SafariLogo(height: 34),
        actions: [
          IconButton(
            icon: Badge(
              isLabelVisible: (home?['unread_notifications'] ?? 0) > 0,
              child: const Icon(Icons.notifications_outlined),
            ),
            onPressed: () => SafariNav.push(context, const SafariNotificationsScreen()),
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              color: SafariTheme.gold,
              onRefresh: () async {
                setState(() => loading = true);
                await _load();
              },
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
                children: [
                  SafariHero(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('Welcome back', style: TextStyle(color: SafariTheme.goldSoft, letterSpacing: 1.4, fontSize: 12, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 6),
                      Text(driver['name']?.toString() ?? 'Guide', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 8),
                      Row(children: [
                        SafariStatusChip(driver['member_no']?.toString() ?? 'Pending ID', tone: SafariChipTone.gold),
                        const SizedBox(width: 8),
                        SafariStatusChip('${driver['status'] ?? 'PENDING'}', tone: statusTone(driver['status']?.toString())),
                      ]),
                    ]),
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
