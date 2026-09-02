import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wicom/safari/safari_api.dart';
import 'package:wicom/safari/safari_nav.dart';
import 'package:wicom/safari/safari_theme.dart';
import 'package:wicom/safari/safari_ui.dart';
import 'package:wicom/safari/screens/login_screen.dart';
import 'package:wicom/safari/screens/passport_screen.dart';
import 'package:wicom/safari/screens/profile_edit_screen.dart';
import 'package:wicom/safari/screens/reviews_screen.dart';

class SafariProfileScreen extends StatelessWidget {
  const SafariProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final d = SafariApi.driver ?? {};
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: [
          SafariHero(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(d['name']?.toString() ?? '', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text(d['member_no']?.toString() ?? 'Pending ID', style: const TextStyle(color: SafariTheme.goldSoft)),
              if (d['company'] != null) Text('${d['company']}', style: const TextStyle(color: Colors.white70)),
            ]),
          ),
          const SizedBox(height: 12),
          SafariCard(
            onTap: () => SafariNav.push(context, const SafariProfileEditScreen()),
            child: const Row(children: [
              Icon(Icons.edit_outlined, color: SafariTheme.maroon),
              SizedBox(width: 12),
              Expanded(child: Text('Edit profile, goals & payout', style: TextStyle(fontWeight: FontWeight.w700))),
              Icon(Icons.chevron_right, color: SafariTheme.muted),
            ]),
          ),
          const SizedBox(height: 10),
          SafariCard(
            onTap: () => SafariNav.push(context, const SafariPassportScreen()),
            child: const Row(children: [
              Icon(Icons.menu_book_outlined, color: SafariTheme.maroon),
              SizedBox(width: 12),
              Expanded(child: Text('Guide Passport', style: TextStyle(fontWeight: FontWeight.w700))),
              Icon(Icons.chevron_right, color: SafariTheme.muted),
            ]),
          ),
          const SizedBox(height: 10),
          SafariCard(
            onTap: () => SafariNav.push(context, const SafariReviewsScreen()),
            child: const Row(children: [
              Icon(Icons.star_outline, color: SafariTheme.maroon),
              SizedBox(width: 12),
              Expanded(child: Text('Reviews', style: TextStyle(fontWeight: FontWeight.w700))),
              Icon(Icons.chevron_right, color: SafariTheme.muted),
            ]),
          ),
          const SizedBox(height: 10),
          SafariCard(
            onTap: () {
              final url = d['public_url']?.toString();
              if (url != null) Share.share(url);
            },
            child: const Row(children: [
              Icon(Icons.ios_share, color: SafariTheme.maroon),
              SizedBox(width: 12),
              Expanded(child: Text('Share profile', style: TextStyle(fontWeight: FontWeight.w700))),
              Icon(Icons.chevron_right, color: SafariTheme.muted),
            ]),
          ),
          const SizedBox(height: 10),
          SafariCard(
            onTap: () async {
              try {
                await SafariApi.post('/auth/logout');
              } catch (_) {}
              await SafariApi.clear();
              if (!context.mounted) return;
              SafariNav.reset(context, const SafariLoginScreen());
            },
            child: const Row(children: [
              Icon(Icons.logout, color: SafariTheme.maroon),
              SizedBox(width: 12),
              Expanded(child: Text('Sign out', style: TextStyle(fontWeight: FontWeight.w700))),
            ]),
          ),
        ],
      ),
    );
  }
}
