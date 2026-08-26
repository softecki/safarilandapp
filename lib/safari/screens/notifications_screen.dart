import 'package:flutter/material.dart';
import 'package:wicom/safari/safari_api.dart';
import 'package:wicom/safari/safari_ui.dart';

class SafariNotificationsScreen extends StatefulWidget {
  const SafariNotificationsScreen({super.key});

  @override
  State<SafariNotificationsScreen> createState() => _SafariNotificationsScreenState();
}

class _SafariNotificationsScreenState extends State<SafariNotificationsScreen> {
  List rows = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final json = await SafariApi.get('/notifications');
      rows = (SafariApi.data(json) as List?) ?? [];
      if (mounted) setState(() {});
    } catch (e) {
      await safariError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView(
        children: rows
            .map((r) => ListTile(
                  title: Text(r['title']?.toString() ?? ''),
                  subtitle: Text(r['body']?.toString() ?? ''),
                  onTap: () => SafariApi.post('/notifications/${r['id']}/read'),
                ))
            .toList(),
      ),
    );
  }
}
