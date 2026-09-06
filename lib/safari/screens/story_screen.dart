import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wicom/safari/safari_api.dart';
import 'package:wicom/safari/safari_nav.dart';
import 'package:wicom/safari/safari_theme.dart';
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
  final location = TextEditingController();
  final photos = <XFile>[];
  Map<String, dynamic>? story;
  String? draft;
  bool loading = false;

  @override
  void dispose() {
    text.dispose();
    title.dispose();
    location.dispose();
    super.dispose();
  }

  Future<void> _pick() async {
    if (photos.length >= 6) {
      await safariError(context, 'You can attach up to 6 photos.');
      return;
    }
    final source = await safariSheet<ImageSource>(
      context,
      Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Add a photo', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.photo_camera_outlined), title: const Text('Camera'), onTap: () => Navigator.pop(context, ImageSource.camera)),
        ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.photo_library_outlined), title: const Text('Gallery'), onTap: () => Navigator.pop(context, ImageSource.gallery)),
      ]),
    );
    if (source == null) return;
    final picked = await ImagePicker().pickImage(source: source, imageQuality: 78, maxWidth: 1600);
    if (picked != null) setState(() => photos.add(picked));
  }

  String _cleaned(Map story) {
    final variants = (story['variants'] as List?) ?? [];
    final cleaned = variants.whereType<Map>().where((v) => '${v['kind']}' == 'cleaned' || '${v['language']}' == 'en');
    if (cleaned.isNotEmpty) return '${cleaned.first['body'] ?? ''}';
    return story['approved_text']?.toString() ?? story['source_text']?.toString() ?? '';
  }

  Future<void> _process() async {
    setState(() => loading = true);
    try {
      final created = await SafariApi.post('/trips/${widget.tripId}/stories', {
        'title': title.text.trim(),
        'source_text': text.text.trim(),
        'source_language': 'en',
        'destination_label': location.text.trim(),
        'visibility': 'PRIVATE',
      });
      story = Map<String, dynamic>.from(SafariApi.data(created) as Map);
      for (final photo in photos) {
        final bytes = await photo.readAsBytes();
        final name = photo.name.isEmpty ? 'photo.jpg' : photo.name;
        await SafariApi.request(
          'POST',
          '/stories/${story!['id']}/media',
          fields: {'kind': 'photo'},
          files: [
            http.MultipartFile.fromBytes('file', bytes, filename: name, contentType: MediaType('image', 'jpeg')),
          ],
        );
      }
      final processed = await SafariApi.post('/stories/${story!['id']}/process');
      story = Map<String, dynamic>.from(SafariApi.data(processed) as Map);
      draft = _cleaned(story!);
      if (!mounted) return;
      setState(() {});
      await safariSheet<void>(
        context,
        Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('AI draft', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 10),
          Text(draft!.isEmpty ? 'No draft yet. You can still save the original note.' : draft!, style: const TextStyle(height: 1.45)),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Review & approve')),
        ]),
      );
    } catch (e) {
      await safariError(context, e);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> _approve() async {
    if (story == null) return;
    try {
      await SafariApi.post('/stories/${story!['id']}/approve', {
        'approved_text': draft ?? text.text.trim(),
        'publish': true,
        'public': false,
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved to Memory Book')));
        Navigator.pop(context);
      }
    } catch (e) {
      await safariError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Safari Story')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
        children: [
          Text('Capture the moment', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 4),
          const Text('Type the voice note, add up to 6 photos, then let AI clean the wording.', style: TextStyle(color: SafariTheme.muted, fontSize: 13)),
          const SizedBox(height: 16),
          TextField(controller: title, decoration: const InputDecoration(labelText: 'Title')),
          const SizedBox(height: 12),
          TextField(controller: text, maxLines: 6, decoration: const InputDecoration(labelText: 'Voice note', hintText: 'Say what happened, who was there, and why it mattered.')),
          const SizedBox(height: 12),
          TextField(controller: location, decoration: const InputDecoration(labelText: 'Location', hintText: 'Serengeti, Ngorongoro, camp name…')),
          const SizedBox(height: 16),
          Row(children: [
            const Expanded(child: Text('Photos', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
            Text('${photos.length}/6', style: const TextStyle(color: SafariTheme.muted)),
          ]),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ...photos.asMap().entries.map((e) => Stack(children: [
                    Container(
                      width: 88,
                      height: 88,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: SafariTheme.statFill, borderRadius: BorderRadius.circular(14)),
                      child: Text(e.value.name.isEmpty ? 'Photo ${e.key + 1}' : e.value.name, maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10)),
                    ),
                    Positioned(
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        onPressed: () => setState(() => photos.removeAt(e.key)),
                      ),
                    ),
                  ])),
              if (photos.length < 6)
                InkWell(
                  onTap: _pick,
                  child: Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(color: SafariTheme.altFill, borderRadius: BorderRadius.circular(14)),
                    child: const Icon(Icons.add_a_photo_outlined, color: SafariTheme.maroon),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          SafariLoadingButton(label: loading ? 'Processing…' : 'Clean with AI', loading: loading, onPressed: _process),
          if (story != null) ...[
            const SizedBox(height: 16),
            SafariCard(child: Text(draft?.isNotEmpty == true ? draft! : 'Original note saved. Approve to add it to the Memory Book.')),
            const SizedBox(height: 12),
            SafariGoldButton(label: 'Approve for Memory Book', onPressed: _approve),
          ],
        ],
      ),
    );
  }
}
