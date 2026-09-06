import 'package:flutter/material.dart';
import 'package:wicom/safari/safari_api.dart';
import 'package:wicom/safari/safari_theme.dart';
import 'package:wicom/safari/safari_ui.dart';

class SafariReviewsScreen extends StatefulWidget {
  const SafariReviewsScreen({super.key});

  @override
  State<SafariReviewsScreen> createState() => _SafariReviewsScreenState();
}

class _SafariReviewsScreenState extends State<SafariReviewsScreen> {
  List rows = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final json = await SafariApi.get('/reviews');
      rows = (SafariApi.data(json) as List?) ?? [];
    } catch (e) {
      if (mounted) await safariError(context, e);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  String _label(Map r) {
    final name = r['guest_name']?.toString() ?? '';
    if (name.isNotEmpty) return name;
    final trip = r['trip'];
    if (trip is Map && (trip['label'] ?? '').toString().isNotEmpty) return trip['label'].toString();
    return r['trip_label']?.toString().isNotEmpty == true ? r['trip_label'].toString() : 'Guest';
  }

  String _source(Map r) {
    final source = '${r['source'] ?? ''}'.toUpperCase();
    if (source == 'PROFILE_QR') return 'Profile QR';
    if (r['verified_trip'] == true || source == 'TRIP') return 'Verified trip';
    return 'Guest review';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reviews')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              color: SafariTheme.gold,
              onRefresh: () async {
                setState(() => loading = true);
                await _load();
              },
              child: rows.isEmpty
                  ? ListView(children: const [
                      SizedBox(height: 120),
                      SafariEmpty('No reviews yet. Guests can review you from your permanent QR.', icon: Icons.star_outline),
                    ])
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: rows.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (_, i) {
                        final r = rows[i] as Map;
                        final stars = int.tryParse('${r['overall'] ?? 0}') ?? 0;
                        return SafariCard(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Row(children: [
                              Expanded(child: Text(_label(r), style: const TextStyle(fontWeight: FontWeight.w800))),
                              SafariStatusChip(_source(r), tone: SafariChipTone.gold),
                            ]),
                            const SizedBox(height: 6),
                            Text(
                              '${List.filled(stars.clamp(0, 5), '★').join()}${List.filled((5 - stars).clamp(0, 5), '☆').join()}  $stars/5',
                              style: const TextStyle(color: SafariTheme.gold, fontWeight: FontWeight.w700, letterSpacing: 0.6),
                            ),
                            if ((r['comment'] ?? '').toString().isNotEmpty) ...[
                              const SizedBox(height: 6),
                              Text(r['comment'].toString()),
                            ],
                            if ((r['created_at'] ?? '').toString().isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text(safariDate(r['created_at']), style: const TextStyle(color: SafariTheme.muted, fontSize: 12)),
                            ],
                          ]),
                        );
                      },
                    ),
            ),
    );
  }
}
