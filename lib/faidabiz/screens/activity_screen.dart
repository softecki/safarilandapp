import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wicom/faidabiz/faidabiz_api.dart';
import 'package:wicom/faidabiz/faidabiz_theme.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_loader.dart';

class FaidaBizActivityScreen extends StatefulWidget {
  const FaidaBizActivityScreen({super.key});

  @override
  State<FaidaBizActivityScreen> createState() => _FaidaBizActivityScreenState();
}

class _FaidaBizActivityScreenState extends State<FaidaBizActivityScreen> {
  List items = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => loading = true);
    try {
      final res = await FaidaBizApi.get('/activity');
      final page = res['data'] as Map<String, dynamic>?;
      items = (page?['data'] as List?) ?? [];
    } catch (_) {}
    if (mounted) setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('settings.activity'.tr())),
      body: loading
          ? FaidaBizLoader.body()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (_, i) {
                final m = items[i] as Map<String, dynamic>;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(m['title']?.toString() ?? ''),
                  subtitle: Text('${m['occurred_at'] ?? ''}\n${m['description'] ?? ''}'),
                  isThreeLine: true,
                  trailing: m['amount'] != null
                      ? Text(FaidaBizTheme.money(m['amount']), style: const TextStyle(fontWeight: FontWeight.w600))
                      : null,
                );
              },
            ),
    );
  }
}
