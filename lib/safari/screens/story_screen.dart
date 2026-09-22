import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wicom/safari/safari_api.dart';
import 'package:wicom/safari/safari_theme.dart';
import 'package:wicom/safari/safari_ui.dart';

class SafariStoryScreen extends StatefulWidget {
  const SafariStoryScreen({super.key, required this.tripId});
  final dynamic tripId;

  @override
  State<SafariStoryScreen> createState() => _SafariStoryScreenState();
}

class _SafariStoryScreenState extends State<SafariStoryScreen> {
  static const _steps = ['Capture', 'Guest', 'Review'];
  int step = 0;
  final text = TextEditingController();
  final title = TextEditingController();
  final location = TextEditingController();
  final whatsapp = TextEditingController();
  final email = TextEditingController();
  final photos = <XFile>[];
  Map<String, dynamic>? story;
  final narration = TextEditingController();
  bool loading = false;

  @override
  void dispose() {
    text.dispose();
    title.dispose();
    location.dispose();
    whatsapp.dispose();
    email.dispose();
    narration.dispose();
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

  Future<void> _goGuest() async {
    if (text.text.trim().isEmpty) {
      await safariError(context, 'Add a voice note or a few lines about what happened.');
      return;
    }
    setState(() => step = 1);
  }

  Future<void> _process() async {
    if (text.text.trim().isEmpty) {
      await safariError(context, 'Add a voice note or story text first.');
      return;
    }
    if (email.text.trim().isEmpty || !email.text.contains('@')) {
      await safariError(context, 'Enter the guest email.');
      return;
    }
    if (safariWhatsAppDigits(whatsapp.text.trim()) == null) {
      await safariError(context, 'Enter the guest WhatsApp number.');
      return;
    }
    setState(() => loading = true);
    try {
      final created = await SafariApi.post('/trips/${widget.tripId}/stories', {
        'title': title.text.trim(),
        'source_text': text.text.trim(),
        'source_language': 'en',
        'destination_label': location.text.trim(),
        'visibility': 'PRIVATE',
        'guest_whatsapp': whatsapp.text.trim(),
        'guest_email': email.text.trim(),
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
      narration.text = _cleaned(story!);
      if (!mounted) return;
      setState(() => step = 2);
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
        'approved_text': narration.text.trim().isNotEmpty ? narration.text.trim() : text.text.trim(),
        'publish': true,
        'public': false,
      });
      final url = '${SafariApi.guestBase()}/m/${widget.tripId}';
      final opened = await safariOpenWhatsApp(whatsapp.text.trim(), 'Safari Story from your guide: $url');
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(opened ? 'Saved. Opening WhatsApp…' : 'Saved to Memory Book')));
      Navigator.pop(context);
    } catch (e) {
      if (!context.mounted) return;
      await safariError(context, e);
    }
  }

  Widget _photoTile(int i, XFile file) {
    return FutureBuilder(
      future: file.readAsBytes(),
      builder: (context, snap) {
        final image = snap.hasData
            ? Image.memory(snap.data!, width: 88, height: 88, fit: BoxFit.cover)
            : Container(
                width: 88,
                height: 88,
                alignment: Alignment.center,
                color: SafariTheme.sand,
                child: const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)),
              );
        return Stack(children: [
          ClipRRect(borderRadius: BorderRadius.circular(14), child: image),
          Positioned(
            right: 0,
            child: IconButton(
              icon: const Icon(Icons.close, size: 18, color: Colors.white),
              style: IconButton.styleFrom(backgroundColor: SafariTheme.darkEarth.withValues(alpha: 0.55), minimumSize: const Size(36, 36)),
              onPressed: () => setState(() => photos.removeAt(i)),
            ),
          ),
        ]);
      },
    );
  }

  Widget _capture() {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text('Capture the moment', style: SafariTheme.display(size: 26)),
      const SizedBox(height: 6),
      const Text('Photos and a short note first. Guest details come next, then you review the narration.', style: TextStyle(color: SafariTheme.muted, fontSize: 14)),
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
          ...photos.asMap().entries.map((e) => _photoTile(e.key, e.value)),
          if (photos.length < 6)
            InkWell(
              onTap: _pick,
              child: Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(color: SafariTheme.sand, borderRadius: BorderRadius.circular(14), border: Border.all(color: SafariTheme.cardBorder)),
                child: const Icon(Icons.add_a_photo_outlined, color: SafariTheme.wine),
              ),
            ),
        ],
      ),
      const SizedBox(height: 16),
      TextField(controller: text, maxLines: 6, decoration: const InputDecoration(labelText: 'What happened *', hintText: 'Say what happened, who was there, and why it mattered.')),
      const SizedBox(height: 12),
      TextField(controller: title, decoration: const InputDecoration(labelText: 'Title', hintText: 'Optional')),
      const SizedBox(height: 12),
      TextField(controller: location, decoration: const InputDecoration(labelText: 'Location', hintText: 'Serengeti, Ngorongoro, camp name…')),
      const SizedBox(height: 20),
      SafariLoadingButton(label: 'Continue to guest', loading: false, onPressed: _goGuest),
    ]);
  }

  Widget _guest() {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text('Who is this for?', style: SafariTheme.display(size: 26)),
      const SizedBox(height: 6),
      const Text('The Memory Book link is emailed and opened on WhatsApp after you approve the narration.', style: TextStyle(color: SafariTheme.muted, fontSize: 14)),
      const SizedBox(height: 16),
      TextField(controller: email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Guest email *')),
      const SizedBox(height: 12),
      TextField(controller: whatsapp, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Guest WhatsApp *', hintText: '07xx or +255…')),
      const SizedBox(height: 20),
      SafariLoadingButton(label: loading ? 'Writing narration…' : 'Create narration', loading: loading, onPressed: _process),
    ]);
  }

  Widget _review() {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text('Review narration', style: SafariTheme.display(size: 26)),
      const SizedBox(height: 6),
      const Text('Edit if needed, then save. This is what the guest will read.', style: TextStyle(color: SafariTheme.muted, fontSize: 14)),
      const SizedBox(height: 16),
      SafariCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SafariStatusChip('Review', tone: SafariChipTone.warn),
          const SizedBox(height: 10),
          TextField(
            controller: narration,
            maxLines: 10,
            decoration: InputDecoration(
              labelText: 'ChatGPT narration',
              hintText: narration.text.isEmpty ? 'No narration yet. Add a ChatGPT API key under portal Settings → ChatGPT.' : null,
            ),
          ),
        ]),
      ),
      const SizedBox(height: 12),
      SafariGoldButton(label: 'Save narration, email & WhatsApp', onPressed: _approve),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: step == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && step > 0) setState(() => step--);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Safari Story'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (step > 0) {
                setState(() => step--);
              } else {
                Navigator.maybePop(context);
              }
            },
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
          children: [
            SafariStepBar(steps: _steps, index: step, onBack: (i) => setState(() => step = i)),
            const SizedBox(height: 18),
            if (step == 0) _capture() else if (step == 1) _guest() else _review(),
          ],
        ),
      ),
    );
  }
}
