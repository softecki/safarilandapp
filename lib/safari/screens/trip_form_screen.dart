import 'package:flutter/material.dart';
import 'package:wicom/safari/safari_passes.dart';
import 'package:wicom/safari/safari_theme.dart';
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
  void dispose() {
    label.dispose();
    count.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = label.text.trim();
    final guests = int.tryParse(count.text.trim()) ?? 0;
    if (name.isEmpty) {
      await safariError(context, 'Enter a group name.');
      return;
    }
    if (guests < 1) {
      await safariError(context, 'Guest count must be at least 1.');
      return;
    }
    setState(() => loading = true);
    try {
      await SafariPasses.createTripWithPasses(label: name, guestCount: guests);
      if (context.mounted) Navigator.pop(context, true);
    } catch (e) {
      await safariError(context, e);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New trip')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            'Enter the group name and how many guests are on this safari. One shopping pass is created for each guest.',
            style: TextStyle(color: SafariTheme.muted),
          ),
          const SizedBox(height: 16),
          TextField(controller: label, decoration: const InputDecoration(labelText: 'Group name')),
          const SizedBox(height: 12),
          TextField(controller: count, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Guest count')),
          const SizedBox(height: 20),
          SafariLoadingButton(label: 'Create trip & passes', loading: loading, onPressed: _save),
        ],
      ),
    );
  }
}
