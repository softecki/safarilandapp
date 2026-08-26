import 'package:flutter/material.dart';
import 'package:wicom/safari/safari_api.dart';
import 'package:wicom/safari/safari_ui.dart';
import 'package:wicom/safari/screens/trip_detail_screen.dart';
import 'package:wicom/safari/screens/trip_form_screen.dart';

class SafariTripsScreen extends StatefulWidget {
  const SafariTripsScreen({super.key});

  @override
  State<SafariTripsScreen> createState() => _SafariTripsScreenState();
}

class _SafariTripsScreenState extends State<SafariTripsScreen> {
  List trips = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final json = await SafariApi.get('/trips');
      trips = (SafariApi.data(json) as List?) ?? [];
    } catch (e) {
      await safariError(context, e);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trips')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => const SafariTripFormScreen()));
          _load();
        },
        child: const Icon(Icons.add),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: trips.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) {
                final t = trips[i] as Map;
                return SafariCard(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SafariTripDetailScreen(id: t['id']))),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(t['label']?.toString() ?? '', style: const TextStyle(fontWeight: FontWeight.w700)),
                    Text('${t['state']} · ${t['guests_count'] ?? t['guest_count'] ?? 0} guests'),
                  ]),
                );
              },
            ),
    );
  }
}
