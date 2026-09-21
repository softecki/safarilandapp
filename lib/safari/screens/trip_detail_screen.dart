import 'package:flutter/material.dart';
import 'package:wicom/safari/safari_api.dart';
import 'package:wicom/safari/safari_nav.dart';
import 'package:wicom/safari/safari_passes.dart';
import 'package:wicom/safari/safari_theme.dart';
import 'package:wicom/safari/safari_ui.dart';
import 'package:wicom/safari/screens/farewell_screen.dart';
import 'package:wicom/safari/screens/memory_book_screen.dart';
import 'package:wicom/safari/screens/story_screen.dart';

const _nextStates = {
  'UPCOMING': ['ON_SAFARI'],
  'ON_SAFARI': ['FAREWELL_PREPARATION'],
  'FAREWELL_PREPARATION': ['FAREWELL_READY'],
  'FAREWELL_READY': ['APPRECIATION_OPEN'],
  'APPRECIATION_OPEN': ['COMPLETED'],
  'COMPLETED': ['ARCHIVED'],
};

const _stateLabels = {
  'ON_SAFARI': 'Start safari',
  'FAREWELL_PREPARATION': 'Prepare farewell',
  'FAREWELL_READY': 'Mark farewell ready',
  'APPRECIATION_OPEN': 'Open appreciation',
  'COMPLETED': 'Complete trip',
  'ARCHIVED': 'Archive',
};

String _statusName(String state) {
  return switch (state.toUpperCase()) {
    'UPCOMING' => 'Upcoming',
    'ON_SAFARI' => 'On Safari',
    'FAREWELL_PREPARATION' => 'Farewell',
    'FAREWELL_READY' => 'Farewell ready',
    'APPRECIATION_OPEN' => 'Appreciation',
    'COMPLETED' => 'Completed',
    'ARCHIVED' => 'Archived',
    _ => state.replaceAll('_', ' '),
  };
}

SafariChipTone _statusTone(String state) {
  return switch (state.toUpperCase()) {
    'UPCOMING' => SafariChipTone.warn,
    'ON_SAFARI' => SafariChipTone.gold,
    'COMPLETED' => SafariChipTone.success,
    'ARCHIVED' => SafariChipTone.neutral,
    _ => SafariChipTone.gold,
  };
}

class SafariTripDetailScreen extends StatefulWidget {
  const SafariTripDetailScreen({super.key, required this.id});
  final dynamic id;

  @override
  State<SafariTripDetailScreen> createState() => _SafariTripDetailScreenState();
}

class _SafariTripDetailScreenState extends State<SafariTripDetailScreen> {
  Map<String, dynamic>? trip;
  bool loading = true;
  final guestName = TextEditingController();

  Future<void> _load() async {
    try {
      final json = await SafariApi.get('/trips/${widget.id}');
      trip = Map<String, dynamic>.from(SafariApi.data(json) as Map);
    } catch (e) {
      await safariError(context, e);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    guestName.dispose();
    super.dispose();
  }

  Future<void> _advance(String state) async {
    try {
      await SafariApi.post('/trips/${widget.id}/state', {'state': state});
      await _load();
    } catch (e) {
      await safariError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading || trip == null) {
      return Scaffold(appBar: AppBar(), body: const Center(child: CircularProgressIndicator()));
    }
    final guests = (trip!['guests'] as List?) ?? [];
    final state = '${trip!['state']}';
    final next = _nextStates[state] ?? const <String>[];
    final guestCount = safariGuestCount(trip);
    return Scaffold(
      appBar: AppBar(title: Text(trip!['label']?.toString() ?? 'Trip')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
        children: [
          Text('Trip command center', style: SafariTheme.display(size: 24)),
          const SizedBox(height: 4),
          const Text('State, guests, story, memory book, farewell and passes in one place.', style: TextStyle(color: SafariTheme.muted, fontSize: 13)),
          const SizedBox(height: 14),
          SafariCard(
            goldEdge: state == 'ON_SAFARI',
            child: Column(children: [
              Row(children: [
                const Expanded(child: Text('Trip state', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
                SafariStatusChip(_statusName(state), tone: _statusTone(state)),
              ]),
              const SizedBox(height: 10),
              Row(children: [
                const Expanded(child: Text('Guest count', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
                Text('$guestCount guests', style: const TextStyle(fontWeight: FontWeight.w700, color: SafariTheme.maroon)),
              ]),
            ]),
          ),
          const SizedBox(height: 12),
          SafariActionGrid(children: [
            SafariActionTile(
              icon: Icons.auto_stories_outlined,
              label: 'Story',
              onTap: () => SafariNav.push(context, SafariStoryScreen(tripId: widget.id)),
            ),
            SafariActionTile(
              icon: Icons.menu_book_outlined,
              label: 'Memory Book',
              onTap: () => SafariNav.push(context, SafariMemoryBookScreen(tripId: widget.id)),
            ),
            SafariActionTile(
              icon: Icons.favorite_outline,
              label: 'Farewell',
              onTap: () => SafariNav.pushUp(context, SafariFarewellScreen(trip: trip!)),
            ),
          ]),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () async {
              final eta = DateTime.now().add(const Duration(hours: 2)).toIso8601String();
              try {
                await SafariApi.post('/trips/${widget.id}/coming', {
                  'guest_count': trip!['guest_count'] ?? guests.length,
                  'eta_at': eta,
                });
                await _load();
                if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Safari Land notified')));
              } catch (e) {
                await safariError(context, e);
              }
            },
            child: const Text("I'm coming"),
          ),
          for (final s in next) ...[
            const SizedBox(height: 8),
            OutlinedButton(onPressed: () => _advance(s), child: Text(_stateLabels[s] ?? s)),
          ],
          SafariSectionTitle('Passes · $guestCount guests'),
          if (guests.isEmpty)
            const SafariEmpty('Create a pass for this safari.', icon: Icons.confirmation_number_outlined)
          else
            ...guests.asMap().entries.map((entry) {
              final row = Map<String, dynamic>.from(entry.value as Map);
              final sign = safariPassGuestSign(row, entry.key + 1);
              final name = safariGuestName(row);
              final pass = Map<String, dynamic>.from(row['pass'] as Map? ?? {});
              final status = safariPassStatus(pass['status'] ?? row['status']);
              final code = (pass['pass_code'] ?? '').toString();
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: SafariCard(
                  padding: const EdgeInsets.all(14),
                  child: Row(children: [
                    CircleAvatar(
                      backgroundColor: SafariTheme.pillFill,
                      child: Text('${safariPassGuestNumber(row, entry.key + 1)}', style: const TextStyle(color: SafariTheme.maroon, fontWeight: FontWeight.w800)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(sign, style: const TextStyle(fontWeight: FontWeight.w700)),
                        if (name.isNotEmpty && name.toLowerCase() != sign.toLowerCase())
                          Text(name, style: const TextStyle(color: SafariTheme.muted, fontSize: 12)),
                        if (code.isNotEmpty)
                          Text(code, style: const TextStyle(color: SafariTheme.muted, fontSize: 12, letterSpacing: 0.4)),
                      ]),
                    ),
                    SafariStatusChip(status, tone: statusTone(pass['status']?.toString() ?? row['status']?.toString())),
                  ]),
                ),
              );
            }),
          TextField(controller: guestName, decoration: const InputDecoration(labelText: 'Optional guest name')),
          TextButton(
            onPressed: () async {
              try {
                final typed = guestName.text.trim();
                await SafariPasses.addPassToTrip(
                  widget.id,
                  firstName: typed.isEmpty ? 'Guest ${guests.length + 1}' : typed,
                  groupName: trip!['label']?.toString(),
                );
                guestName.clear();
                await _load();
              } catch (e) {
                await safariError(context, e);
              }
            },
            child: const Text('Create Pass'),
          ),
        ],
      ),
    );
  }
}
