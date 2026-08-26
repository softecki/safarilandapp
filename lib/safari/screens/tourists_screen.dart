import 'package:flutter/material.dart';
import 'package:wicom/safari/safari_api.dart';
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
                TextField(controller: first, decoration: const InputDecoration(labelText: 'Guest first name')),
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
                const SizedBox(height: 12),
                ...rows.map((r) => SafariCard(child: Text('${r['guest']} · ${r['pass_code']} · ${r['status']}'))),
              ],
            ),
    );
  }
}
