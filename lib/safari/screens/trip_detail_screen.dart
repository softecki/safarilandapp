import 'package:flutter/material.dart';
import 'package:wicom/safari/safari_api.dart';
import 'package:wicom/safari/safari_ui.dart';
import 'package:wicom/safari/screens/story_screen.dart';
import 'package:wicom/safari/screens/farewell_screen.dart';

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
  Widget build(BuildContext context) {
    if (loading || trip == null) {
      return Scaffold(appBar: AppBar(), body: const Center(child: CircularProgressIndicator()));
    }
    final guests = (trip!['guests'] as List?) ?? [];
    return Scaffold(
      appBar: AppBar(title: Text(trip!['label']?.toString() ?? 'Trip')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SafariCard(child: Text('State: ${trip!['state']}')),
          const SizedBox(height: 8),
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
          const SizedBox(height: 12),
          const Text('Guests', style: TextStyle(fontWeight: FontWeight.w700)),
          ...guests.map((g) => ListTile(title: Text((g['alias'] ?? g['tourist']?['first_name'] ?? 'Guest').toString()))),
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
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SafariStoryScreen(tripId: widget.id))),
            child: const Text('Capture story'),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SafariFarewellScreen(trip: trip!))),
            child: const Text('Farewell workspace'),
          ),
        ],
      ),
    );
  }
}
