import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wicom/safari/safari_api.dart';
import 'package:wicom/safari/safari_nav.dart';
import 'package:wicom/safari/safari_theme.dart';
import 'package:wicom/safari/safari_ui.dart';

class SafariFarewellScreen extends StatefulWidget {
  const SafariFarewellScreen({super.key, required this.trip});
  final Map trip;

  @override
  State<SafariFarewellScreen> createState() => _SafariFarewellScreenState();
}

class _SafariFarewellScreenState extends State<SafariFarewellScreen> {
  final text = TextEditingController();
  Map<String, dynamic>? trip;
  bool loading = false;
  bool fetching = true;
  dynamic selectedGuestId;

  @override
  void initState() {
    super.initState();
    trip = Map<String, dynamic>.from(widget.trip);
    _load();
  }

  @override
  void dispose() {
    text.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final json = await SafariApi.get('/trips/${widget.trip['id']}');
      trip = Map<String, dynamic>.from(SafariApi.data(json) as Map);
    } catch (e) {
      await safariError(context, e);
    } finally {
      if (mounted) setState(() => fetching = false);
    }
  }

  List get guests => (trip?['guests'] as List?) ?? [];
  List get farewells => (trip?['farewells'] as List?) ?? [];

  Map? _existingFor(dynamic guestId) {
    for (final raw in farewells) {
      final row = raw as Map;
      if (guestId == null && (row['is_group'] == true || row['trip_guest_id'] == null)) return row;
      if ('${row['trip_guest_id']}' == '$guestId') return row;
    }
    return null;
  }

  Future<void> _save() async {
    setState(() => loading = true);
    try {
      final json = await SafariApi.post('/trips/${widget.trip['id']}/farewells', {
        'source_text': text.text.trim(),
        'trip_guest_id': selectedGuestId,
        'language': 'en',
      });
      final f = SafariApi.data(json) as Map;
      await SafariApi.post('/farewells/${f['id']}/approve', {'approved_text': f['approved_text'] ?? text.text});
      text.clear();
      await _load();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Farewell saved privately')));
    } catch (e) {
      await safariError(context, e);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> _activate() async {
    try {
      await SafariApi.post('/trips/${widget.trip['id']}/farewells/activate');
      final url = '${SafariApi.guestBase()}/f/${widget.trip['id']}';
      await Share.share('Safari Farewell: $url');
      await _load();
    } catch (e) {
      await safariError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final existing = _existingFor(selectedGuestId);
    return Scaffold(
      appBar: AppBar(title: const Text('Farewell Studio')),
      body: fetching
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
              children: [
                SafariFarewellHero(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(trip?['label']?.toString() ?? 'Farewell', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    const Text('Private until you activate. Each guest can receive their own message.', style: TextStyle(fontSize: 13)),
                  ]),
                ),
                const SafariSectionTitle('Who is this for?'),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ChoiceChip(
                      label: const Text('Whole group'),
                      selected: selectedGuestId == null,
                      selectedColor: SafariTheme.goldSoft,
                      onSelected: (_) => setState(() => selectedGuestId = null),
                    ),
                    ...guests.map((raw) {
                      final g = raw as Map;
                      final id = g['id'];
                      return ChoiceChip(
                        label: Text(safariGuestName(g)),
                        selected: '$selectedGuestId' == '$id',
                        selectedColor: SafariTheme.goldSoft,
                        onSelected: (_) => setState(() => selectedGuestId = id),
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 16),
                if (existing != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: SafariCard(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        SafariStatusChip('${existing['status']}', tone: statusTone('${existing['status']}')),
                        const SizedBox(height: 8),
                        Text(existing['approved_text']?.toString() ?? existing['source_text']?.toString() ?? ''),
                      ]),
                    ),
                  ),
                TextField(
                  controller: text,
                  maxLines: 7,
                  decoration: InputDecoration(
                    labelText: selectedGuestId == null ? 'Group farewell' : 'Private message',
                    hintText: 'Thank them for the days you shared. Keep it personal.',
                  ),
                ),
                const SizedBox(height: 16),
                SafariLoadingButton(label: loading ? 'Saving…' : 'Save & approve', loading: loading, onPressed: _save),
                const SizedBox(height: 8),
                SafariGoldButton(label: 'Activate Safari Farewell', onPressed: _activate),
              ],
            ),
    );
  }
}
