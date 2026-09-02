import 'package:flutter/material.dart';
import 'package:wicom/safari/safari_api.dart';
import 'package:wicom/safari/safari_nav.dart';
import 'package:wicom/safari/safari_theme.dart';
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 72),
        child: FloatingActionButton(
          heroTag: 'safari-trips-add',
          onPressed: () async {
            await SafariNav.push(context, const SafariTripFormScreen());
            _load();
          },
          child: const Icon(Icons.add),
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              color: SafariTheme.gold,
              onRefresh: () async {
                setState(() => loading = true);
                await _load();
              },
              child: trips.isEmpty
                  ? ListView(children: const [SafariEmpty('No trips yet. Create your first group.', icon: Icons.groups_outlined)])
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
                      itemCount: trips.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (_, i) {
                        final t = trips[i] as Map;
                        return SafariCard(
                          onTap: () async {
                            await SafariNav.push(context, SafariTripDetailScreen(id: t['id']));
                            _load();
                          },
                          child: Row(children: [
                            Expanded(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(t['label']?.toString() ?? '', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                                const SizedBox(height: 4),
                                Text('${t['guests_count'] ?? t['guest_count'] ?? 0} guests', style: const TextStyle(color: SafariTheme.muted)),
                              ]),
                            ),
                            SafariStatusChip('${t['state']}', tone: SafariChipTone.neutral),
                          ]),
                        );
                      },
                    ),
            ),
    );
  }
}
