import 'package:flutter/material.dart';
import 'package:wicom/safari/safari_api.dart';
import 'package:wicom/safari/safari_theme.dart';
import 'package:wicom/safari/safari_ui.dart';

class SafariNotificationsScreen extends StatefulWidget {
  const SafariNotificationsScreen({super.key});

  @override
  State<SafariNotificationsScreen> createState() => _SafariNotificationsScreenState();
}

class _SafariNotificationsScreenState extends State<SafariNotificationsScreen> {
  List rows = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final json = await SafariApi.get('/notifications');
      rows = (SafariApi.data(json) as List?) ?? [];
    } catch (e) {
      await safariError(context, e);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : rows.isEmpty
              ? const Center(child: SafariEmpty('You are all caught up.', icon: Icons.notifications_none))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: rows.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) {
                    final r = rows[i] as Map;
                    final unread = r['read_at'] == null;
                    return SafariCard(
                      onTap: () async {
                        await SafariApi.post('/notifications/${r['id']}/read');
                        await _load();
                      },
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          Expanded(child: Text(r['title']?.toString() ?? '', style: const TextStyle(fontWeight: FontWeight.w800))),
                          if (unread) SafariStatusChip('NEW', tone: SafariChipTone.gold),
                        ]),
                        const SizedBox(height: 4),
                        Text(r['body']?.toString() ?? '', style: const TextStyle(color: SafariTheme.muted)),
                      ]),
                    );
                  },
                ),
    );
  }
}
