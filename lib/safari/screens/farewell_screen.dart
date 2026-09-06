import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wicom/safari/safari_api.dart';
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
  final guestName = TextEditingController();
  final guestEmail = TextEditingController();
  final guestWhatsapp = TextEditingController();
  Map<String, dynamic>? trip;
  bool loading = false;
  bool activating = false;
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
    guestName.dispose();
    guestEmail.dispose();
    guestWhatsapp.dispose();
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

  void _selectGuest(dynamic id) {
    setState(() => selectedGuestId = id);
    if (id == null) return;
    for (final raw in guests) {
      final g = Map<String, dynamic>.from(raw as Map);
      if ('${g['id']}' != '$id') continue;
      guestName.text = safariGuestName(g);
      final tourist = g['tourist'];
      final email = tourist is Map ? tourist['email'] : g['email'];
      guestEmail.text = email?.toString() ?? '';
      guestWhatsapp.text = safariGuestPhone(g) ?? safariGuestPhone(_existingFor(id)) ?? '';
      break;
    }
  }

  Future<void> _save() async {
    if (guestName.text.trim().isEmpty || guestEmail.text.trim().isEmpty || safariWhatsAppDigits(guestWhatsapp.text.trim()) == null) {
      await safariError(context, 'Enter the guest name, email, and WhatsApp number.');
      return;
    }
    setState(() => loading = true);
    try {
      final json = await SafariApi.post('/trips/${widget.trip['id']}/farewells', {
        'source_text': text.text.trim(),
        'trip_guest_id': selectedGuestId,
        'guest_name': guestName.text.trim(),
        'guest_email': guestEmail.text.trim(),
        'guest_whatsapp': guestWhatsapp.text.trim(),
        'language': 'en',
      });
      final f = SafariApi.data(json) as Map;
      await SafariApi.post('/farewells/${f['id']}/approve', {'approved_text': f['approved_text'] ?? text.text});
      text.clear();
      await _load();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Farewell saved. Activate to email and WhatsApp the guest.')));
    } catch (e) {
      await safariError(context, e);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> _activate() async {
    setState(() => activating = true);
    try {
      final json = await SafariApi.post('/trips/${widget.trip['id']}/farewells/activate');
      final data = Map<String, dynamic>.from(SafariApi.data(json) as Map? ?? {});
      final sent = data['emails_sent'] ?? 0;
      final url = '${SafariApi.guestBase()}/f/${widget.trip['id']}';
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(sent is num && sent > 0 ? 'Farewell emailed to $sent guest${sent == 1 ? '' : 's'}.' : 'Farewell activated.')),
        );
      }
      var phone = guestWhatsapp.text.trim();
      if (safariWhatsAppDigits(phone) == null) {
        for (final raw in farewells) {
          final found = safariGuestPhone(raw);
          if (found != null) {
            phone = found;
            break;
          }
        }
      }
      final opened = await safariOpenWhatsApp(phone, 'Safari Farewell from your guide: $url');
      if (!opened) await Share.share('Safari Farewell: $url');
      await _load();
    } catch (e) {
      await safariError(context, e);
    } finally {
      if (mounted) setState(() => activating = false);
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
                    const Text('Enter the guest name, email, and WhatsApp. Activate emails them and opens WhatsApp.', style: TextStyle(fontSize: 13)),
                  ]),
                ),
                const SafariSectionTitle('Guest'),
                if (guests.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ChoiceChip(
                          label: const Text('New guest'),
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
                            onSelected: (_) => _selectGuest(id),
                          );
                        }),
                      ],
                    ),
                  ),
                TextField(controller: guestName, textCapitalization: TextCapitalization.words, decoration: const InputDecoration(labelText: 'Guest name')),
                const SizedBox(height: 12),
                TextField(controller: guestEmail, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Guest email')),
                const SizedBox(height: 12),
                TextField(controller: guestWhatsapp, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Guest WhatsApp', hintText: '07xx or +255…')),
                const SizedBox(height: 16),
                if (existing != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: SafariCard(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        SafariStatusChip('${existing['status']}', tone: statusTone('${existing['status']}')),
                        const SizedBox(height: 8),
                        Text(existing['guest_name']?.toString() ?? safariGuestName(existing)),
                        if ((existing['guest_email'] ?? '').toString().isNotEmpty)
                          Text('${existing['guest_email']}', style: const TextStyle(color: SafariTheme.muted, fontSize: 12)),
                        if ((existing['guest_whatsapp'] ?? '').toString().isNotEmpty)
                          Text('${existing['guest_whatsapp']}', style: const TextStyle(color: SafariTheme.muted, fontSize: 12)),
                        const SizedBox(height: 8),
                        Text(existing['approved_text']?.toString() ?? existing['source_text']?.toString() ?? ''),
                      ]),
                    ),
                  ),
                TextField(
                  controller: text,
                  maxLines: 7,
                  decoration: const InputDecoration(
                    labelText: 'Farewell message',
                    hintText: 'Thank them for the days you shared. Keep it personal.',
                  ),
                ),
                const SizedBox(height: 16),
                SafariLoadingButton(label: loading ? 'Saving…' : 'Save & approve', loading: loading, onPressed: _save),
                const SizedBox(height: 8),
                SafariGoldButton(label: activating ? 'Sending…' : 'Activate, email & WhatsApp', onPressed: activating ? null : _activate),
              ],
            ),
    );
  }
}
