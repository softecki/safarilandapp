import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wicom/safari/safari_api.dart';
import 'package:wicom/safari/safari_theme.dart';
import 'package:wicom/safari/safari_ui.dart';

class SafariPassportScreen extends StatefulWidget {
  const SafariPassportScreen({super.key});

  @override
  State<SafariPassportScreen> createState() => _SafariPassportScreenState();
}

class _SafariPassportScreenState extends State<SafariPassportScreen> {
  Map<String, dynamic>? data;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final json = await SafariApi.get('/passport');
      data = Map<String, dynamic>.from(SafariApi.data(json) as Map);
    } catch (e) {
      await safariError(context, e);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final d = data?['driver'] as Map? ?? {};
    final goals = safariCsv(data?['goals'] ?? d['goals']);
    final languages = safariCsv(d['languages']);
    final destinations = safariCsv(d['destinations']);
    final stories = (data?['stories'] as List?) ?? [];
    return Scaffold(
      appBar: AppBar(title: const Text('Guide Passport')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 28),
              children: [
                SafariCard(
                  child: Column(children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: SafariTheme.pillFill,
                      child: Text(safariInitials(d['name']), style: const TextStyle(color: SafariTheme.maroon, fontWeight: FontWeight.w800, fontSize: 22)),
                    ),
                    const SizedBox(height: 10),
                    Text('${d['name'] ?? ''}', style: Theme.of(context).textTheme.headlineSmall),
                    Text('${d['member_no'] ?? ''} · ${data?['verified_rating'] ?? '—'} / 5', style: const TextStyle(color: SafariTheme.gold, fontWeight: FontWeight.w700)),
                    Text('${data?['verified_review_count'] ?? 0} verified reviews', style: const TextStyle(color: SafariTheme.muted)),
                    if (languages.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Wrap(spacing: 6, children: languages.map((l) => SafariStatusChip(l, tone: SafariChipTone.gold)).toList()),
                    ],
                  ]),
                ),
                if (goals.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  SafariDreamCard(title: goals.first, body: goals.length > 1 ? goals.skip(1).join(' · ') : 'The next chapter guests can celebrate with you.'),
                ],
                if (destinations.isNotEmpty) ...[
                  const SafariSectionTitle('Destinations'),
                  SafariCard(child: Text(destinations.join(' · '))),
                ],
                if (stories.isNotEmpty) ...[
                  const SafariSectionTitle('Public stories'),
                  ...stories.take(4).map((raw) {
                    final story = Map<String, dynamic>.from(raw as Map);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: SafariCard(child: Text(story['title']?.toString() ?? 'Story', style: const TextStyle(fontWeight: FontWeight.w700))),
                    );
                  }),
                ],
                const SizedBox(height: 12),
                if (d['public_url'] != null)
                  ElevatedButton(onPressed: () => Share.share(d['public_url'].toString()), child: const Text('Share profile')),
              ],
            ),
    );
  }
}
