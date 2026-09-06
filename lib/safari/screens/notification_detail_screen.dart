import 'package:flutter/material.dart';
import 'package:wicom/safari/safari_api.dart';
import 'package:wicom/safari/safari_theme.dart';
import 'package:wicom/safari/safari_ui.dart';

class SafariNotificationDetailScreen extends StatefulWidget {
  const SafariNotificationDetailScreen({super.key, required this.notification});
  final Map notification;

  @override
  State<SafariNotificationDetailScreen> createState() => _SafariNotificationDetailScreenState();
}

class _SafariNotificationDetailScreenState extends State<SafariNotificationDetailScreen> {
  late Map data;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    data = Map<String, dynamic>.from(widget.notification);
    _open();
  }

  Future<void> _open() async {
    try {
      final json = await SafariApi.get('/notifications/${widget.notification['id']}');
      data = Map<String, dynamic>.from(SafariApi.data(json) as Map);
    } catch (_) {
      try {
        await SafariApi.post('/notifications/${widget.notification['id']}/read');
      } catch (_) {}
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = data['title']?.toString() ?? 'Notification';
    final body = data['body']?.toString() ?? '';
    final when = safariDateTime(data['created_at'] ?? data['updated_at']);

    return Scaffold(
      appBar: AppBar(title: const Text('Notification')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              children: [
                SafariCard(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const SafariStatusChip('Read', tone: SafariChipTone.gold),
                    const SizedBox(height: 10),
                    Text(title, style: Theme.of(context).textTheme.titleLarge),
                    if (when.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(when, style: const TextStyle(color: SafariTheme.muted, fontSize: 12)),
                    ],
                    const SizedBox(height: 14),
                    Text(body.isEmpty ? 'No extra details.' : body, style: const TextStyle(height: 1.45, fontSize: 15)),
                  ]),
                ),
              ],
            ),
    );
  }
}
