import 'package:flutter/material.dart';
import 'package:wicom/safari/safari_api.dart';
import 'package:wicom/safari/safari_theme.dart';
import 'package:wicom/safari/safari_ui.dart';
import 'package:wicom/safari/screens/notifications_screen.dart';
import 'package:wicom/safari/screens/tourists_screen.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const SafariLogo(height: 34),
        actions: [
          IconButton(
            icon: Badge(isLabelVisible: (home?['unread_notifications'] ?? 0) > 0, child: const Icon(Icons.notifications_outlined)),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SafariNotificationsScreen())),
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                setState(() => loading = true);
                await _load();
              },
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  SafariHero(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(driver['name']?.toString() ?? '', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                      Text(driver['member_no']?.toString() ?? 'Pending ID', style: const TextStyle(color: Colors.white70)),
                      const SizedBox(height: 8),
                      Text('Status ${driver['status']}'),
                    ]),
                  ),
                  const SizedBox(height: 12),
                  Row(children: [
                    Expanded(child: SafariCard(child: Column(children: [const Text('Available'), Text(money(wallet['available']), style: const TextStyle(fontWeight: FontWeight.w800, color: SafariTheme.maroon))]))),
                    const SizedBox(width: 8),
                    Expanded(child: SafariCard(child: Column(children: [const Text('Pending'), Text(money(wallet['pending']), style: const TextStyle(fontWeight: FontWeight.w800, color: SafariTheme.maroon))]))),
                  ]),
                  const SizedBox(height: 12),
                  SafariCard(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SafariTouristsScreen())),
                    child: Text('Tourists & passes · ${home?['pass_count'] ?? 0}'),
                  ),
                ],
              ),
            ),
    );
  }
}
