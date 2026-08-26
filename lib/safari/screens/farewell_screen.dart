import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wicom/safari/safari_api.dart';
import 'package:wicom/safari/safari_ui.dart';

class SafariFarewellScreen extends StatefulWidget {
  const SafariFarewellScreen({super.key, required this.trip});
  final Map trip;

  @override
  State<SafariFarewellScreen> createState() => _SafariFarewellScreenState();
}

class _SafariFarewellScreenState extends State<SafariFarewellScreen> {
  final text = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final id = widget.trip['id'];
    return Scaffold(
      appBar: AppBar(title: const Text('Farewell')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Private until you activate. Guests will not see drafts.'),
          TextField(controller: text, maxLines: 5, decoration: const InputDecoration(labelText: 'Group farewell message')),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: loading
                ? null
                : () async {
                    setState(() => loading = true);
                    try {
                      final json = await SafariApi.post('/trips/$id/farewells', {'source_text': text.text.trim()});
                      final f = SafariApi.data(json) as Map;
                      await SafariApi.post('/farewells/${f['id']}/approve', {'approved_text': f['approved_text'] ?? text.text});
                      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ready')));
                    } catch (e) {
                      await safariError(context, e);
                    } finally {
                      if (mounted) setState(() => loading = false);
                    }
                  },
            child: const Text('Save & approve'),
          ),
          OutlinedButton(
            onPressed: () async {
              try {
                await SafariApi.post('/trips/$id/farewells/activate');
                final url = '${SafariApi.baseUrl.replaceAll('/api/v1', '')}/f/$id';
                await Share.share('Safari Farewell: $url');
              } catch (e) {
                await safariError(context, e);
              }
            },
            child: const Text('Activate Safari Farewell'),
          ),
        ],
      ),
    );
  }
}
