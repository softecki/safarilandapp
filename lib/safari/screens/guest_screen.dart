import 'package:flutter/material.dart';
import 'package:wicom/safari/safari_api.dart';
import 'package:wicom/safari/safari_nav.dart';
import 'package:wicom/safari/safari_theme.dart';
import 'package:wicom/safari/safari_ui.dart';
import 'package:wicom/safari/screens/login_screen.dart';

class SafariGuestScreen extends StatelessWidget {
  const SafariGuestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final d = SafariApi.driver ?? {};
    return Scaffold(
      appBar: AppBar(title: const Text('Guest')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          SafariHero(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(d['name']?.toString() ?? 'Guest', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              const SafariStatusChip('GUEST', tone: SafariChipTone.gold),
            ]),
          ),
          const SizedBox(height: 16),
          const SafariCard(
            child: Text('This account is a guest, not a driver-guide. Driver tools such as trips, QR passes and wallet are not available.'),
          ),
          const SizedBox(height: 16),
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
