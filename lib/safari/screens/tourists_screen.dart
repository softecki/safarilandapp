import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:wicom/safari/safari_api.dart';
import 'package:wicom/safari/safari_theme.dart';
import 'package:wicom/safari/safari_ui.dart';

class SafariTouristsScreen extends StatefulWidget {
  const SafariTouristsScreen({super.key});

  @override
  State<SafariTouristsScreen> createState() => _SafariTouristsScreenState();
}

class _SafariTouristsScreenState extends State<SafariTouristsScreen> {
  List rows = [];
  final first = TextEditingController();
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    first.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tourists')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                SafariCard(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('Issue a shopping pass', style: TextStyle(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    TextField(controller: first, decoration: const InputDecoration(labelText: 'Guest first name')),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          await SafariApi.post('/passes', {'first_name': first.text.trim()});
                          first.clear();
                          await _load();
                        } catch (e) {
                          await safariError(context, e);
                        }
                      },
                      child: const Text('Create shopping pass'),
                    ),
                  ]),
                ),
                const SafariSectionTitle('Passes'),
                if (rows.isEmpty)
                  const SafariEmpty('No guests yet.')
                else
                  ...rows.map((raw) {
                    final r = Map<String, dynamic>.from(raw as Map);
                    final code = (r['token'] ?? r['pass_code'] ?? '').toString();
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: SafariCard(
                        child: Row(children: [
                          if (code.isNotEmpty)
                            QrImageView(data: code, size: 72, backgroundColor: Colors.white),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text('${r['guest']}', style: const TextStyle(fontWeight: FontWeight.w800)),
                              Text(code, style: const TextStyle(color: SafariTheme.muted, letterSpacing: 0.4)),
                            ]),
                          ),
                          SafariStatusChip('${r['status']}', tone: statusTone(r['status']?.toString())),
                        ]),
                      ),
                    );
                  }),
              ],
            ),
    );
  }
}
