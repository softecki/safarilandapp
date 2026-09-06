import 'package:flutter/material.dart';
import 'package:wicom/safari/safari_api.dart';
import 'package:wicom/safari/safari_nav.dart';
import 'package:wicom/safari/safari_theme.dart';
import 'package:wicom/safari/safari_ui.dart';
import 'package:wicom/safari/screens/notification_detail_screen.dart';

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
      if (mounted) await safariError(context, e);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> _open(Map r) async {
    await SafariNav.push(context, SafariNotificationDetailScreen(notification: Map<String, dynamic>.from(r)));
    if (!mounted) return;
    setState(() => loading = true);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
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
                      SafariEmpty('You are all caught up.', icon: Icons.notifications_none),
                    ])
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: rows.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (_, i) {
                        final r = rows[i] as Map;
                        final unread = safariNotificationUnread(r);
                        final body = r['body']?.toString() ?? '';
                        return SafariCard(
                          onTap: () => _open(r),
                          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Expanded(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Row(children: [
                                  Expanded(child: Text(r['title']?.toString() ?? '', style: TextStyle(fontWeight: unread ? FontWeight.w800 : FontWeight.w600))),
                                  if (unread) SafariStatusChip('NEW', tone: SafariChipTone.gold),
                                ]),
                                if (body.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text(body, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: SafariTheme.muted)),
                                ],
                                if ((r['created_at'] ?? '').toString().isNotEmpty) ...[
                                  const SizedBox(height: 6),
                                  Text(safariDate(r['created_at']), style: const TextStyle(color: SafariTheme.muted, fontSize: 12)),
                                ],
                              ]),
                            ),
                            const Icon(Icons.chevron_right, color: SafariTheme.muted),
                          ]),
                        );
                      },
                    ),
            ),
    );
  }
}
