import 'package:flutter/material.dart';
import 'package:wicom/safari/safari_api.dart';
import 'package:wicom/safari/safari_ui.dart';

class SafariTripFormScreen extends StatefulWidget {
  const SafariTripFormScreen({super.key});

  @override
  State<SafariTripFormScreen> createState() => _SafariTripFormScreenState();
}

class _SafariTripFormScreenState extends State<SafariTripFormScreen> {
  final label = TextEditingController();
  final count = TextEditingController(text: '2');
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New trip')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          TextField(controller: label, decoration: const InputDecoration(labelText: 'Group name')),
          const SizedBox(height: 12),
          TextField(controller: count, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Guest count')),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: loading
                ? null
                : () async {
                    setState(() => loading = true);
                    try {
                      await SafariApi.post('/trips', {
                        'label': label.text.trim(),
                        'guest_count': int.tryParse(count.text) ?? 0,
                      });
                      if (context.mounted) Navigator.pop(context);
                    } catch (e) {
                      await safariError(context, e);
                    } finally {
                      if (mounted) setState(() => loading = false);
                    }
                  },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}
