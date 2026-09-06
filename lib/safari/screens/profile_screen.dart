import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wicom/safari/safari_api.dart';
import 'package:wicom/safari/safari_nav.dart';
import 'package:wicom/safari/safari_theme.dart';
import 'package:wicom/safari/safari_ui.dart';
import 'package:wicom/safari/screens/login_screen.dart';
import 'package:wicom/safari/screens/passport_screen.dart';
import 'package:wicom/safari/screens/profile_edit_screen.dart';
import 'package:wicom/safari/screens/reviews_screen.dart';
import 'package:wicom/safari/screens/settings_screen.dart';

class SafariProfileScreen extends StatelessWidget {
  const SafariProfileScreen({super.key});

  Future<void> _preview(BuildContext context) async {
    final url = SafariApi.driver?['public_url']?.toString();
    if (url == null || url.isEmpty) {
      await safariError(context, 'Public profile is not ready yet.');
      return;
    }
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      await safariError(context, 'Could not open profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    final d = SafariApi.driver ?? {};
    final name = d['name']?.toString() ?? 'Guide';
    final languages = safariCsv(d['languages']);
    final destinations = safariCsv(d['destinations']);
    final specialties = safariCsv(d['specialties']);
    final goals = safariCsv(d['goals']);
    final dream = goals.isNotEmpty ? goals.first : 'Set the next chapter you are working toward.';

    return Scaffold(
      appBar: Navigator.canPop(context) ? AppBar(title: const Text('Profile')) : null,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 96),
        children: [
          if (!Navigator.canPop(context))
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text('Guide Passport', style: Theme.of(context).textTheme.headlineMedium),
            ),
          SafariCard(
            child: Column(children: [
              CircleAvatar(
                radius: 36,
                backgroundColor: SafariTheme.pillFill,
                backgroundImage: (d['photo_url']?.toString().isNotEmpty ?? false) ? NetworkImage(d['photo_url'].toString()) : null,
                child: (d['photo_url']?.toString().isNotEmpty ?? false)
                    ? null
                    : Text(safariInitials(name), style: const TextStyle(fontWeight: FontWeight.w800, color: SafariTheme.maroon, fontSize: 22)),
              ),
              const SizedBox(height: 12),
              Text(name, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 4),
              Text(d['member_no']?.toString() ?? 'Pending ID', style: const TextStyle(color: SafariTheme.gold, fontWeight: FontWeight.w700)),
              if (d['company'] != null) Text('${d['company']}', style: const TextStyle(color: SafariTheme.muted)),
              if ((d['licence_ref'] ?? '').toString().isNotEmpty)
                Text('Licence ${d['licence_ref']}', style: const TextStyle(color: SafariTheme.muted, fontSize: 12)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                alignment: WrapAlignment.center,
                children: [
                  if (d['experience_years'] != null) SafariStatusChip('${d['experience_years']} yrs', tone: SafariChipTone.gold),
                  ...languages.map((l) => SafariStatusChip(l)),
                ],
              ),
            ]),
          ),
          const SizedBox(height: 12),
          SafariDreamCard(
            title: dream,
            body: goals.length > 1 ? goals.skip(1).join(' · ') : 'Guests see this on your public passport.',
            onEdit: () => SafariNav.push(context, const SafariProfileEditScreen()),
          ),
          if (destinations.isNotEmpty || specialties.isNotEmpty) ...[
            const SafariSectionTitle('Portfolio'),
            SafariCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                if (destinations.isNotEmpty) ...[
                  const Text('Destinations', style: TextStyle(color: SafariTheme.muted, fontSize: 12, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Text(destinations.join(' · ')),
                  const SizedBox(height: 12),
                ],
                if (specialties.isNotEmpty) ...[
                  const Text('Specialties', style: TextStyle(color: SafariTheme.muted, fontSize: 12, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Text(specialties.join(' · ')),
                ],
              ]),
            ),
          ],
          const SafariSectionTitle('Account'),
          _row(context, Icons.edit_outlined, 'Edit profile, goals & payout', () => SafariNav.push(context, const SafariProfileEditScreen())),
          _row(context, Icons.menu_book_outlined, 'Guide Passport', () => SafariNav.push(context, const SafariPassportScreen())),
          _row(context, Icons.star_outline, 'Reviews', () => SafariNav.push(context, const SafariReviewsScreen())),
          _row(context, Icons.visibility_outlined, 'Preview public profile', () => _preview(context)),
          _row(context, Icons.ios_share, 'Share profile', () {
            final url = d['public_url']?.toString();
            if (url != null) Share.share(url);
          }),
          _row(context, Icons.settings_outlined, 'Settings', () => SafariNav.push(context, const SafariSettingsScreen())),
          _row(context, Icons.logout, 'Sign out', () async {
            try {
              await SafariApi.post('/auth/logout');
            } catch (_) {}
            await SafariApi.clear();
            if (!context.mounted) return;
            SafariNav.reset(context, const SafariLoginScreen());
          }),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SafariCard(
        onTap: onTap,
        child: Row(children: [
          Icon(icon, color: SafariTheme.maroon),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700))),
          const Icon(Icons.chevron_right, color: SafariTheme.muted),
        ]),
      ),
    );
  }
}
