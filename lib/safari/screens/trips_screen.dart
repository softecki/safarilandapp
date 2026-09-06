import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  static const _filters = ['Upcoming', 'On Safari', 'Completed'];

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

  Future<void> _newTrip() async {
    final created = await SafariNav.push<bool>(context, const SafariTripFormScreen());
    if (!mounted) return;
    if (created == true) {
      filter = 0;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Trip created as Upcoming. Open it and start the safari when the group arrives.')),
      );
    }
    setState(() => loading = true);
    await _load();
  }

  bool _matches(Map raw, int i) {
    final state = '${raw['state']}'.toUpperCase();
    return switch (i) {
      0 => state == 'UPCOMING',
      1 => state == 'ON_SAFARI' || state.contains('FAREWELL') || state == 'APPRECIATION_OPEN',
      _ => state == 'COMPLETED' || state == 'ARCHIVED',
    };
  }

  List get filtered => trips.where((raw) => _matches(raw as Map, filter)).toList();

  int _count(int i) => trips.where((raw) => _matches(raw as Map, i)).length;

  String _stateLabel(String state) {
    return switch (state.toUpperCase()) {
      'ON_SAFARI' => 'On Safari',
      'UPCOMING' => 'Upcoming',
      'FAREWELL_PREPARATION' => 'Farewell',
      'FAREWELL_READY' => 'Farewell ready',
      'APPRECIATION_OPEN' => 'Appreciation',
      'COMPLETED' => 'Completed',
      'ARCHIVED' => 'Archived',
      _ => state.replaceAll('_', ' '),
    };
  }

  SafariChipTone _stateTone(String state) {
    return switch (state.toUpperCase()) {
      'ON_SAFARI' => SafariChipTone.gold,
      'UPCOMING' => SafariChipTone.warn,
      'COMPLETED' => SafariChipTone.success,
      'ARCHIVED' => SafariChipTone.neutral,
      _ => SafariChipTone.gold,
    };
  }

  @override
  Widget build(BuildContext context) {
    final rows = filtered;
    final nested = Navigator.canPop(context);
    return Scaffold(
      appBar: nested ? AppBar(title: const Text('Trips')) : null,
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              color: SafariTheme.gold,
              onRefresh: () async {
                setState(() => loading = true);
                await _load();
              },
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  if (!nested) _tripsBanner(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 88),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (nested) ...[
                          Row(children: [
                            Expanded(child: Text('Trips', style: Theme.of(context).textTheme.titleLarge)),
                            TextButton(onPressed: _newTrip, child: const Text('New trip')),
                          ]),
                          const SizedBox(height: 8),
                        ],
                        _filterRow(),
                        const SizedBox(height: 16),
                        if (rows.isEmpty)
                          _empty()
                        else
                          ...rows.map((raw) => _tripCard(Map<String, dynamic>.from(raw as Map))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _tripsBanner() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16, MediaQuery.paddingOf(context).top + 14, 16, 18),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [SafariTheme.maroon, SafariTheme.maroonDark],
        ),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                'TRIPS',
                style: GoogleFonts.playfairDisplay(
                  color: SafariTheme.goldSoft,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.2,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Your safaris',
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800, height: 1.1),
              ),
            ]),
          ),
          Material(
            color: SafariTheme.gold,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: _newTrip,
              borderRadius: BorderRadius.circular(12),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(children: [
                  Icon(Icons.add, size: 18, color: SafariTheme.maroonDark),
                  SizedBox(width: 4),
                  Text('New trip', style: TextStyle(color: SafariTheme.maroonDark, fontWeight: FontWeight.w800, fontSize: 13)),
                ]),
              ),
            ),
          ),
        ]),
        const SizedBox(height: 16),
        Row(children: [
          _statPill('${_count(0)}', 'Upcoming'),
          const SizedBox(width: 8),
          _statPill('${_count(1)}', 'On safari'),
          const SizedBox(width: 8),
          _statPill('${_count(2)}', 'Completed'),
        ]),
      ]),
    );
  }

  Widget _statPill(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: SafariTheme.gold.withValues(alpha: 0.35)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(value, style: const TextStyle(color: SafariTheme.goldSoft, fontWeight: FontWeight.w800, fontSize: 18)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w600)),
        ]),
      ),
    );
  }

  Widget _filterRow() {
    return Row(
      children: [
        for (var i = 0; i < _filters.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => filter = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: 9),
                decoration: BoxDecoration(
                  color: i == filter ? SafariTheme.maroon : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: i == filter ? SafariTheme.maroon : SafariTheme.cardBorder),
                ),
                child: Text(
                  '${_filters[i]} ${_count(i)}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: i == filter ? Colors.white : SafariTheme.maroon,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _empty() {
    return SafariCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Column(children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(color: SafariTheme.pillFill, shape: BoxShape.circle),
            child: const Icon(Icons.terrain_outlined, color: SafariTheme.maroon, size: 28),
          ),
          const SizedBox(height: 12),
          Text('No ${_filters[filter].toLowerCase()} trips yet', style: const TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(
            filter == 0
                ? 'New trips start here as Upcoming. Create one, then move it to On Safari when the group arrives.'
                : 'Start a safari group and issue a shopping pass for each guest.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: SafariTheme.muted, fontSize: 13),
          ),
          const SizedBox(height: 14),
          SafariGoldButton(label: 'Create a trip', onPressed: _newTrip),
        ]),
      ),
    );
  }

  Widget _tripCard(Map<String, dynamic> t) {
    final state = '${t['state']}'.toUpperCase();
    final active = state == 'ON_SAFARI';
    final guests = (t['guests'] as List?) ?? [];
    final count = safariGuestCount(t);
    final dates = [
      if (safariDate(t['start_date']).isNotEmpty) safariDate(t['start_date']),
      if (safariDate(t['end_date']).isNotEmpty) safariDate(t['end_date']),
    ].join(' – ');
    final meta = [
      if ((t['primary_nationality'] ?? '').toString().isNotEmpty) t['primary_nationality'],
      if ((t['primary_language'] ?? '').toString().isNotEmpty) t['primary_language'],
    ].join(' · ');

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SafariCard(
        goldEdge: active,
        padding: EdgeInsets.zero,
        onTap: () async {
          await SafariNav.push(context, SafariTripDetailScreen(id: t['id']));
          _load();
        },
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
            decoration: BoxDecoration(
              gradient: active
                  ? const LinearGradient(colors: [SafariTheme.maroon, SafariTheme.maroonDark])
                  : null,
              color: active ? null : SafariTheme.statFill,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(SafariTheme.cardRadius - 1)),
            ),
            child: Row(children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: active ? Colors.white.withValues(alpha: 0.12) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: active ? SafariTheme.gold.withValues(alpha: 0.5) : SafariTheme.cardBorder),
                ),
                child: Icon(Icons.terrain, color: active ? SafariTheme.goldSoft : SafariTheme.maroon, size: 22),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    t['label']?.toString() ?? 'Trip',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: active ? Colors.white : SafariTheme.black),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$count ${count == 1 ? 'guest' : 'guests'}${meta.isEmpty ? '' : ' · $meta'}',
                    style: TextStyle(color: active ? Colors.white70 : SafariTheme.muted, fontSize: 12),
                  ),
                ]),
              ),
              Icon(Icons.chevron_right, color: active ? SafariTheme.goldSoft : SafariTheme.muted),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Row(children: [
              SafariStatusChip(_stateLabel(state), tone: _stateTone(state)),
              if (dates.isNotEmpty) ...[
                const SizedBox(width: 8),
                Text(dates, style: const TextStyle(color: SafariTheme.muted, fontSize: 12)),
              ],
              const Spacer(),
              if (guests.isEmpty)
                Text('$count passes', style: const TextStyle(color: SafariTheme.muted, fontSize: 12))
              else
                _guestAvatars(guests),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _guestAvatars(List guests) {
    final shown = guests.take(5).toList();
    final extra = guests.length - shown.length;
    return Row(mainAxisSize: MainAxisSize.min, children: [
      SizedBox(
        width: 18.0 * (shown.length - 1) + 28,
        height: 28,
        child: Stack(
          children: [
            for (var i = 0; i < shown.length; i++)
              Positioned(
                left: i * 18.0,
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 12,
                    backgroundColor: SafariTheme.pillFill,
                    child: Text(
                      '${safariPassGuestNumber(Map<String, dynamic>.from(shown[i] as Map), i + 1)}',
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: SafariTheme.maroon),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      if (extra > 0)
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text('+$extra', style: const TextStyle(color: SafariTheme.muted, fontSize: 11, fontWeight: FontWeight.w700)),
        ),
    ]);
  }
}
