import 'package:flutter/material.dart';
import 'package:wicom/safari/safari_api.dart';
import 'package:wicom/safari/safari_nav.dart';
import 'package:wicom/safari/safari_ui.dart';
import 'package:wicom/safari/screens/farewell_screen.dart';
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
    return Scaffold(
      appBar: AppBar(title: Text(trip!['label']?.toString() ?? 'Trip')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SafariCard(
            child: Row(children: [
              const Expanded(child: Text('Trip state', style: TextStyle(fontWeight: FontWeight.w700))),
              SafariStatusChip(state, tone: SafariChipTone.neutral),
            ]),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              final eta = DateTime.now().add(const Duration(hours: 2)).toIso8601String();
              try {
                await SafariApi.post('/trips/${widget.id}/coming', {
                  'guest_count': trip!['guest_count'] ?? guests.length,
                  'eta_at': eta,
                });
                await _load();
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
          const SafariSectionTitle('Guests'),
          ...guests.map((g) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: SafariCard(child: Text((g['alias'] ?? g['tourist']?['first_name'] ?? 'Guest').toString())),
              )),
          TextField(controller: guestName, decoration: const InputDecoration(labelText: 'Add guest first name')),
          TextButton(
            onPressed: () async {
              try {
                await SafariApi.post('/trips/${widget.id}/guests', {'first_name': guestName.text.trim()});
                guestName.clear();
                await _load();
              } catch (e) {
                await safariError(context, e);
              }
            },
            child: const Text('Add guest'),
          ),
          ElevatedButton(
            onPressed: () => SafariNav.push(context, SafariStoryScreen(tripId: widget.id)),
            child: const Text('Capture story'),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => SafariNav.pushUp(context, SafariFarewellScreen(trip: trip!)),
            child: const Text('Farewell workspace'),
          ),
        ],
      ),
    );
  }
}
