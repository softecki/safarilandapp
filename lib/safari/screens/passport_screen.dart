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
    final goals = (data?['goals'] as List?) ?? (d['goals'] as List?) ?? [];
    return Scaffold(
      appBar: AppBar(title: const Text('Guide Passport')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                SafariHero(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('${d['name'] ?? ''}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 6),
                    Text('${d['member_no'] ?? ''} · ${data?['verified_rating'] ?? '—'} / 5', style: const TextStyle(color: SafariTheme.goldSoft)),
                    Text('${data?['verified_review_count'] ?? 0} verified reviews', style: const TextStyle(color: Colors.white70)),
                  ]),
                ),
                if (goals.isNotEmpty) ...[
                  const SafariSectionTitle('Goals'),
                  SafariCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: goals.map((g) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text('• $g'),
                      )).toList(),
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                if (d['public_url'] != null)
                  ElevatedButton(onPressed: () => Share.share(d['public_url'].toString()), child: const Text('Share profile')),
              ],
            ),
    );
  }
}
