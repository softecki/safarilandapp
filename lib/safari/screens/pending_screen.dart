import 'package:flutter/material.dart';
import 'package:wicom/safari/safari_api.dart';
import 'package:wicom/safari/safari_shell.dart';
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

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    try {
      final json = await SafariApi.get('/auth/me');
      driver = Map<String, dynamic>.from(SafariApi.data(json) as Map);
      SafariApi.driver = driver;
      if (driver?['status'] == 'ACTIVE' && mounted) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const SafariShell()), (_) => false);
        return;
      }
    } catch (e) {
      await safariError(context, e);
    } finally {
      if (mounted) setState(() => loading = false);
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
                    const SizedBox(height: 8),
                    Text('Status: ${driver?['status'] ?? 'PENDING'}'),
                  ]),
                ),
                const SizedBox(height: 16),
                const SafariCard(child: Text('Safari Land staff will review your profile. You will receive a permanent Driver ID when approved.')),
                const SizedBox(height: 16),
                ElevatedButton(onPressed: _refresh, child: const Text('Check status')),
                TextButton(
                  onPressed: () async {
                    await SafariApi.post('/auth/logout');
                    await SafariApi.clear();
                    if (!context.mounted) return;
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const SafariLoginScreen()), (_) => false);
                  },
                  child: const Text('Sign out', style: TextStyle(color: SafariTheme.muted)),
                ),
              ],
            ),
    );
  }
}
