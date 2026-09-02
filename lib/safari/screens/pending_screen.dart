import 'package:flutter/material.dart';
import 'package:wicom/safari/safari_api.dart';
import 'package:wicom/safari/safari_gate.dart';
import 'package:wicom/safari/safari_nav.dart';
import 'package:wicom/safari/safari_theme.dart';
import 'package:wicom/safari/safari_ui.dart';
import 'package:wicom/safari/screens/login_screen.dart';

class SafariPendingScreen extends StatefulWidget {
  const SafariPendingScreen({super.key});

  @override
  State<SafariPendingScreen> createState() => _SafariPendingScreenState();
}

class _SafariPendingScreenState extends State<SafariPendingScreen> {
  Map<String, dynamic>? driver;
  bool loading = true;
  bool checking = false;

  @override
  void initState() {
    super.initState();
    _refresh(initial: true);
  }

  Future<void> _refresh({bool initial = false}) async {
    if (initial) {
      setState(() => loading = true);
    } else {
      setState(() => checking = true);
    }
    try {
      final json = await SafariApi.get('/auth/me');
      driver = Map<String, dynamic>.from(SafariApi.data(json) as Map);
      SafariApi.driver = driver;
      if (mounted && (SafariGate.isGuest || driver?['status'] == 'ACTIVE')) {
        SafariNav.reset(context, SafariGate.home());
        return;
      }
    } catch (e) {
      await safariError(context, e);
    } finally {
      if (mounted) setState(() {
        loading = false;
        checking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verification')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(24),
              children: [
                SafariHero(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(driver?['name']?.toString() ?? 'Guide', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 10),
                    SafariStatusChip('${driver?['status'] ?? 'PENDING'}', tone: statusTone(driver?['status']?.toString())),
                  ]),
                ),
                const SizedBox(height: 16),
                const SafariCard(child: Text('Safari Land Tanzania staff will review your profile. You will receive a permanent Driver ID when approved.')),
                const SizedBox(height: 16),
                SafariLoadingButton(label: 'Check status', loading: checking, onPressed: () => _refresh()),
                TextButton(
                  onPressed: () async {
                    try {
                      await SafariApi.post('/auth/logout');
                    } catch (_) {}
                    await SafariApi.clear();
                    if (!context.mounted) return;
                    SafariNav.reset(context, const SafariLoginScreen());
                  },
                  child: const Text('Sign out', style: TextStyle(color: SafariTheme.muted)),
                ),
              ],
            ),
    );
  }
}
