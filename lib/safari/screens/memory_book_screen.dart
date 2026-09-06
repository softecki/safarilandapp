import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wicom/safari/safari_api.dart';
import 'package:wicom/safari/safari_theme.dart';
import 'package:wicom/safari/safari_ui.dart';

class SafariMemoryBookScreen extends StatefulWidget {
  const SafariMemoryBookScreen({super.key, required this.tripId});
  final dynamic tripId;

  @override
  State<SafariMemoryBookScreen> createState() => _SafariMemoryBookScreenState();
}

class _SafariMemoryBookScreenState extends State<SafariMemoryBookScreen> {
  Map<String, dynamic>? trip;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final json = await SafariApi.get('/trips/${widget.tripId}');
      trip = Map<String, dynamic>.from(SafariApi.data(json) as Map);
    } catch (e) {
      await safariError(context, e);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  List get stories => (trip?['stories'] as List?) ?? [];

  String _body(Map story) {
    final variants = (story['variants'] as List?) ?? [];
    final cleaned = variants.whereType<Map>().where((v) => '${v['kind']}' == 'cleaned' || '${v['language']}' == 'en');
    if (cleaned.isNotEmpty) return '${cleaned.first['body'] ?? ''}';
    return story['approved_text']?.toString() ?? story['source_text']?.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final url = '${SafariApi.guestBase()}/m/${widget.tripId}';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memory Book'),
        actions: [
          IconButton(onPressed: () => Share.share('Safari Memory Book: $url'), icon: const Icon(Icons.ios_share)),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              color: SafariTheme.gold,
              onRefresh: () async {
                setState(() => loading = true);
                await _load();
              },
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 28),
                children: [
                  Text(trip?['label']?.toString() ?? 'Memory Book', style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 6),
                  const Text('Approved stories stay with this safari. Guests see them after you share the Memory Book.', style: TextStyle(color: SafariTheme.muted)),
                  const SizedBox(height: 16),
                  if (stories.isEmpty)
                    const SafariEmpty('No stories yet. Capture one from this trip.', icon: Icons.auto_stories_outlined)
                  else
                    ...stories.map((raw) {
                      final story = Map<String, dynamic>.from(raw as Map);
                      final media = ((story['media'] as List?) ?? []).whereType<Map>().where((m) => '${m['kind']}' == 'photo');
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: SafariCard(
                          goldEdge: true,
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Row(children: [
                              Expanded(child: Text(story['title']?.toString().isNotEmpty == true ? story['title'].toString() : 'Story', style: const TextStyle(fontWeight: FontWeight.w800))),
                              SafariStatusChip('${story['status']}', tone: statusTone('${story['status']}')),
                            ]),
                            if ((story['destination_label'] ?? '').toString().isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text('${story['destination_label']}', style: const TextStyle(color: SafariTheme.muted, fontSize: 12)),
                            ],
                            const SizedBox(height: 8),
                            Text(_body(story)),
                            if (media.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text('${media.length} photo${media.length == 1 ? '' : 's'}', style: const TextStyle(color: SafariTheme.gold, fontWeight: FontWeight.w700, fontSize: 12)),
                            ],
                          ]),
                        ),
                      );
                    }),
                ],
              ),
            ),
    );
  }
}
