import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wicom/safari/safari_api.dart';
import 'package:wicom/safari/safari_ui.dart';

class SafariQrScreen extends StatefulWidget {
  const SafariQrScreen({super.key});

  @override
  State<SafariQrScreen> createState() => _SafariQrScreenState();
}

class _SafariQrScreenState extends State<SafariQrScreen> {
  List assets = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final json = await SafariApi.get('/referral-assets');
      assets = (SafariApi.data(json)['assets'] as List?) ?? [];
    } catch (e) {
      await safariError(context, e);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> _add() async {
    const sources = ['VEHICLE', 'WHATSAPP', 'MOBILE', 'BUSINESS_CARD', 'HOTEL', 'FLYER', 'OTHER'];
    final source = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) => ListView(
        children: sources.map((s) => ListTile(title: Text(s), onTap: () => Navigator.pop(ctx, s))).toList(),
      ),
    );
    if (source == null) return;
    try {
      await SafariApi.post('/referral-assets', {'source_type': source});
      await _load();
    } catch (e) {
      await safariError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My QR')),
      floatingActionButton: FloatingActionButton(onPressed: _add, child: const Icon(Icons.add)),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: assets.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                final a = assets[i] as Map;
                final url = a['url']?.toString() ?? '';
                return SafariCard(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('${a['label']} · ${a['source_type']}', style: const TextStyle(fontWeight: FontWeight.w700)),
                    Text(url, style: const TextStyle(fontSize: 12)),
                    Row(children: [
                      TextButton(onPressed: () => Clipboard.setData(ClipboardData(text: url)), child: const Text('Copy')),
                      TextButton(onPressed: () => Share.share(url), child: const Text('Share')),
                    ]),
                  ]),
                );
              },
            ),
    );
  }
}
