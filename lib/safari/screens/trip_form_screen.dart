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
          SafariCard(
            goldEdge: true,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Row(children: [
                Text('Starting status', style: TextStyle(fontWeight: FontWeight.w800)),
                SizedBox(width: 8),
                SafariStatusChip('Upcoming', tone: SafariChipTone.warn),
              ]),
              const SizedBox(height: 8),
              const Text(
                'A new trip always starts as Upcoming. Change it to On Safari when the group arrives, then Completed when the safari ends.',
                style: TextStyle(color: SafariTheme.muted, fontSize: 13, height: 1.4),
              ),
              const SizedBox(height: 14),
              const _StatusPath(),
            ]),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: label,
            decoration: const InputDecoration(
              labelText: 'Group name',
              hintText: 'Serengeti Trip',
            ),
          ),
          const SizedBox(height: 12),
          TextField(controller: count, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Guest count')),
          const SizedBox(height: 20),
          SafariLoadingButton(label: 'Create as Upcoming', loading: loading, onPressed: _save),
        ],
      ),
    );
  }
}

class _StatusPath extends StatelessWidget {
  const _StatusPath();

  @override
  Widget build(BuildContext context) {
    const steps = [
      ('1', 'Upcoming', true),
      ('2', 'On Safari', false),
      ('3', 'Completed', false),
    ];
    Widget step(String n, String label, bool current) {
      return Column(children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: current ? SafariTheme.gold : SafariTheme.altFill,
          child: Text(
            n,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: current ? SafariTheme.maroonDark : SafariTheme.muted,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: current ? SafariTheme.maroon : SafariTheme.muted,
          ),
        ),
      ]);
    }

    Widget line() => Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 18),
        color: SafariTheme.gold.withValues(alpha: 0.45),
      ),
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        step(steps[0].$1, steps[0].$2, steps[0].$3),
        line(),
        step(steps[1].$1, steps[1].$2, steps[1].$3),
        line(),
        step(steps[2].$1, steps[2].$2, steps[2].$3),
      ],
    );
  }
}
