import 'package:flutter/material.dart';
import 'package:wicom/safari/safari_api.dart';
import 'package:wicom/safari/safari_ui.dart';

class SafariStoryScreen extends StatefulWidget {
  const SafariStoryScreen({super.key, required this.tripId});
  final dynamic tripId;

  @override
  State<SafariStoryScreen> createState() => _SafariStoryScreenState();
}

class _SafariStoryScreenState extends State<SafariStoryScreen> {
  final text = TextEditingController();
  final title = TextEditingController();
  Map<String, dynamic>? story;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Safari Story')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(controller: title, decoration: const InputDecoration(labelText: 'Title')),
          const SizedBox(height: 8),
          TextField(controller: text, maxLines: 6, decoration: const InputDecoration(labelText: 'Voice notes as text')),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: loading
                ? null
                : () async {
                    setState(() => loading = true);
                    try {
                      final created = await SafariApi.post('/trips/${widget.tripId}/stories', {
                        'title': title.text.trim(),
                        'source_text': text.text.trim(),
                        'source_language': 'en',
                      });
                      story = Map<String, dynamic>.from(SafariApi.data(created) as Map);
                      final processed = await SafariApi.post('/stories/${story!['id']}/process');
                      story = Map<String, dynamic>.from(SafariApi.data(processed) as Map);
                      if (mounted) setState(() {});
                    } catch (e) {
                      await safariError(context, e);
                    } finally {
                      if (mounted) setState(() => loading = false);
                    }
                  },
            child: Text(loading ? 'Processing…' : 'Clean with AI'),
          ),
          if (story != null) ...[
            const SizedBox(height: 12),
            SafariCard(child: Text((story!['variants'] as List?)?.cast<Map>().where((v) => v['kind'] == 'cleaned').map((v) => v['body']).join('\n') ?? story!['source_text']?.toString() ?? '')),
            ElevatedButton(
              onPressed: () async {
                try {
                  await SafariApi.post('/stories/${story!['id']}/approve', {'publish': true, 'public': false});
                  if (context.mounted) Navigator.pop(context);
                } catch (e) {
                  await safariError(context, e);
                }
              },
              child: const Text('Approve for Memory Book'),
            ),
          ],
        ],
      ),
    );
  }
}
