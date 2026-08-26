import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wicom/safari/safari_api.dart';
import 'package:wicom/safari/safari_ui.dart';
import 'package:wicom/safari/screens/passport_screen.dart';
import 'package:wicom/safari/screens/reviews_screen.dart';
import 'package:wicom/safari/screens/settings_screen.dart';

class SafariProfileScreen extends StatelessWidget {
  const SafariProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final d = SafariApi.driver ?? {};
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SafariHero(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(d['name']?.toString() ?? '', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
              Text(d['member_no']?.toString() ?? ''),
            ]),
          ),
          ListTile(title: const Text('Guide Passport'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SafariPassportScreen()))),
          ListTile(title: const Text('Reviews'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SafariReviewsScreen()))),
          ListTile(
            title: const Text('Share profile'),
            onTap: () {
              final url = d['public_url']?.toString();
              if (url != null) Share.share(url);
            },
          ),
          ListTile(title: const Text('Settings'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SafariSettingsScreen()))),
        ],
      ),
    );
  }
}
