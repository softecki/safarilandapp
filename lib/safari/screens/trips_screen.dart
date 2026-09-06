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
  int filter = 0;
  static const _filters = ['On Safari', 'Upcoming', 'Completed'];

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

  List get filtered {
    return trips.where((raw) {
      final state = '${(raw as Map)['state']}'.toUpperCase();
      return switch (filter) {
        0 => state == 'ON_SAFARI' || state.contains('FAREWELL') || state == 'APPRECIATION_OPEN',
        1 => state == 'UPCOMING',
        _ => state == 'COMPLETED' || state == 'ARCHIVED',
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final rows = filtered;
    return Scaffold(
      appBar: Navigator.canPop(context) ? AppBar(title: const Text('Trips')) : null,
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              color: SafariTheme.gold,
              onRefresh: () async {
                setState(() => loading = true);
                await _load();
              },
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 96),
                children: [
                  Row(children: [
                    Expanded(child: Text('Trips', style: Theme.of(context).textTheme.headlineMedium)),
                    TextButton(
                      onPressed: () async {
                        await SafariNav.push(context, const SafariTripFormScreen());
                        _load();
                      },
                      child: const Text('New trip'),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  SafariFilterTabs(tabs: _filters, index: filter, onChanged: (i) => setState(() => filter = i)),
                  const SizedBox(height: 14),
                  if (rows.isEmpty)
                    SafariEmpty('No ${_filters[filter].toLowerCase()} trips yet.', icon: Icons.groups_outlined)
                  else
                    ...rows.map((raw) {
                      final t = Map<String, dynamic>.from(raw as Map);
                      final guests = (t['guests'] as List?) ?? [];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: SafariCard(
                          goldEdge: '${t['state']}' == 'ON_SAFARI',
                          onTap: () async {
                            await SafariNav.push(context, SafariTripDetailScreen(id: t['id']));
                            _load();
                          },
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Row(children: [
                              Expanded(
                                child: Text(t['label']?.toString() ?? 'Trip', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                              ),
                              SafariStatusChip('${t['state']}'.replaceAll('_', ' '), tone: SafariChipTone.gold),
                            ]),
                            const SizedBox(height: 6),
                            Text(
                              '${t['guests_count'] ?? t['guest_count'] ?? guests.length} guests · ${t['primary_nationality'] ?? t['primary_language'] ?? 'Group'}',
                              style: const TextStyle(color: SafariTheme.muted, fontSize: 13),
                            ),
                            if (guests.isNotEmpty) ...[
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 6,
                                children: guests.take(6).map((g) {
                                  final name = safariGuestName(g);
                                  return CircleAvatar(
                                    radius: 14,
                                    backgroundColor: SafariTheme.pillFill,
                                    child: Text(safariInitials(name), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: SafariTheme.maroon)),
                                  );
                                }).toList(),
                              ),
                            ],
                          ]),
                        ),
                      );
                    }),
                ],
              ),
            ),
    );
  }
}
