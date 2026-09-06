import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wicom/safari/safari_api.dart';
import 'package:wicom/safari/safari_passes.dart';
import 'package:wicom/safari/safari_theme.dart';
import 'package:wicom/safari/safari_ui.dart';

class SafariTouristsScreen extends StatefulWidget {
  const SafariTouristsScreen({super.key});

  @override
  State<SafariTouristsScreen> createState() => _SafariTouristsScreenState();
}

class _SafariTouristsScreenState extends State<SafariTouristsScreen> {
  List rows = [];
  final group = TextEditingController();
  final count = TextEditingController(text: '2');
  bool loading = true;
  bool creating = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    group.dispose();
    count.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final json = await SafariApi.get('/tourists');
      rows = (SafariApi.data(json) as List?) ?? [];
    } catch (e) {
      await safariError(context, e);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  String _code(Map r) => (r['pass_code'] ?? r['token'] ?? '').toString();

  String _passUrl(Map r) => SafariPasses.urlFor(r);

  Future<void> _share(Map r) async {
    final url = _passUrl(r);
    if (url.isEmpty) {
      await safariError(context, 'This pass has no share link yet.');
      return;
    }
    final guest = '${r['guest'] ?? 'your guest'}';
    await Share.share('Safari Land shopping pass for $guest: $url');
  }

  Future<void> _copy(Map r) async {
    final url = _passUrl(r);
    if (url.isEmpty) return;
    await Clipboard.setData(ClipboardData(text: url));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Shopping pass link copied')));
  }

  Future<void> _create() async {
    final name = group.text.trim();
    final guests = int.tryParse(count.text.trim()) ?? 0;
    if (name.isEmpty) {
      await safariError(context, 'Enter a group name.');
      return;
    }
    if (guests < 1) {
      await safariError(context, 'Guest count must be at least 1.');
      return;
    }
    setState(() => creating = true);
    try {
      await SafariPasses.createTripWithPasses(label: name, guestCount: guests);
      group.clear();
      await _load();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$guests shopping ${guests == 1 ? 'pass' : 'passes'} created for $name')),
        );
      }
    } catch (e) {
      await safariError(context, e);
    } finally {
      if (mounted) setState(() => creating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Pass')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                SafariCard(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('Create shopping passes', style: TextStyle(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    const Text('One pass is issued for each guest in the group.', style: TextStyle(color: SafariTheme.muted, fontSize: 12)),
                    const SizedBox(height: 10),
                    TextField(controller: group, decoration: const InputDecoration(labelText: 'Group name')),
                    const SizedBox(height: 12),
                    TextField(controller: count, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Guest count')),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: creating ? null : _create,
                      child: Text(creating ? 'Creating…' : 'Create Pass'),
                    ),
                  ]),
                ),
                const SafariSectionTitle('Passes'),
                if (rows.isEmpty)
                  const SafariEmpty('No passes yet.')
                else
                  ...rows.map((raw) {
                    final r = Map<String, dynamic>.from(raw as Map);
                    final code = _code(r);
                    final url = _passUrl(r);
                    final status = safariPassStatus(r['status']);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: SafariCard(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            if (url.isNotEmpty)
                              QrImageView(data: url, size: 72, backgroundColor: Colors.white),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text('${r['guest']}', style: const TextStyle(fontWeight: FontWeight.w800)),
                                if ((r['trip_label'] ?? '').toString().isNotEmpty)
                                  Text('${r['trip_label']}', style: const TextStyle(color: SafariTheme.muted, fontSize: 12)),
                                Text(code, style: const TextStyle(color: SafariTheme.muted, letterSpacing: 0.4, fontSize: 12)),
                                const SizedBox(height: 8),
                                SafariStatusChip(status, tone: statusTone(r['status']?.toString())),
                              ]),
                            ),
                          ]),
                          const SizedBox(height: 4),
                          Row(children: [
                            TextButton.icon(
                              onPressed: url.isEmpty ? null : () => _share(r),
                              icon: const Icon(Icons.ios_share, size: 16),
                              label: const Text('Share'),
                            ),
                            TextButton.icon(
                              onPressed: url.isEmpty ? null : () => _copy(r),
                              icon: const Icon(Icons.copy, size: 16),
                              label: const Text('Copy link'),
                            ),
                          ]),
                        ]),
                      ),
                    );
                  }),
              ],
            ),
    );
  }
}
