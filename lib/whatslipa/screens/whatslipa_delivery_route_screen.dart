import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wicom/core/whatslipa_api.dart';
import 'package:wicom/core/whatslipa_maps_init.dart';
import 'package:wicom/core/whatslipa_maps_log.dart';
import 'package:wicom/whatslipa/widgets/whatslipa_map_panel.dart';
import 'package:wicom/whatslipa/widgets/whatslipa_theme.dart';

class WhatsLipaDeliveryRouteScreen extends StatefulWidget {
  const WhatsLipaDeliveryRouteScreen({super.key, required this.orderIds});

  final List<int> orderIds;

  @override
  State<WhatsLipaDeliveryRouteScreen> createState() => _WhatsLipaDeliveryRouteScreenState();
}

class _WhatsLipaDeliveryRouteScreenState extends State<WhatsLipaDeliveryRouteScreen> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  List<Map<String, dynamic>> _stops = [];
  List<List<LatLng>> _completedLegPaths = [];
  List<LatLng> _activeLegPoints = [];
  List<LatLng> _upcomingPoints = [];
  List<int> _missingCoordOrderIds = [];
  LatLng? _riderPos;
  double _heading = 0;
  int _currentStop = 0;
  bool _loading = true;
  bool _navigationLive = false;
  bool _followRider = true;
  bool _refreshingLeg = false;
  String? _directionsUrl;
  String? _loadError;
  int? _legDistanceM;
  int? _legDurationS;
  int? _totalDistanceM;
  int? _totalDurationS;
  LatLng? _lastLegRefreshPos;
  DateTime? _lastLegRefreshAt;
  StreamSubscription<Position>? _posSub;
  Timer? _legRefreshDebounce;

  static const _legRefreshMinMeters = 35.0;
  static const _legRefreshMinSeconds = 25;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _posSub?.cancel();
    _legRefreshDebounce?.cancel();
    super.dispose();
  }

  static double? _asDouble(dynamic v) {
    if (v == null) return null;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    if (v is String) return double.tryParse(v);
    return null;
  }

  List<LatLng> _parsePolyline(dynamic raw) {
    if (raw is! List) return [];
    return raw
        .whereType<Map>()
        .map((p) {
          final lat = _asDouble(p['latitude']);
          final lng = _asDouble(p['longitude']);
          if (lat == null || lng == null) return null;
          return LatLng(lat, lng);
        })
        .whereType<LatLng>()
        .toList();
  }

  static String _formatDistance(int? meters) {
    if (meters == null || meters <= 0) return '—';
    if (meters < 1000) return '$meters m';
    return '${(meters / 1000).toStringAsFixed(1)} km';
  }

  static String _formatDuration(int? seconds) {
    if (seconds == null || seconds <= 0) return '—';
    if (seconds < 60) return '$seconds sec';
    return '${(seconds / 60).round()} min';
  }

  double _distanceMeters(LatLng a, LatLng b) {
    const r = 6371000.0;
    final dLat = (b.latitude - a.latitude) * math.pi / 180;
    final dLng = (b.longitude - a.longitude) * math.pi / 180;
    final lat1 = a.latitude * math.pi / 180;
    final lat2 = b.latitude * math.pi / 180;
    final h = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1) * math.cos(lat2) * math.sin(dLng / 2) * math.sin(dLng / 2);
    return 2 * r * math.asin(math.sqrt(h));
  }

  Future<LatLng?> _resolveRiderPosition() async {
    if (!await Geolocator.isLocationServiceEnabled()) return null;
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      return null;
    }
    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.bestForNavigation),
      );
      _heading = pos.heading >= 0 ? pos.heading : _heading;
      return LatLng(pos.latitude, pos.longitude);
    } catch (e) {
      WhatsLipaMapsLog.warn('getCurrentPosition failed: $e');
      return null;
    }
  }

  Future<void> _init() async {
    WhatsLipaMapsLog.clear();
    final mapsInit = await initWhatsLipaGoogleMaps();
    if (!mapsInit.ok) {
      _loadError = mapsInit.summary;
    }

    final riderPos = await _resolveRiderPosition();
    if (riderPos != null) {
      _riderPos = riderPos;
      _lastLegRefreshPos = riderPos;
    }

    await _loadRoutePlan(riderPos);

    if (mounted) {
      setState(() {
        _loading = false;
        _navigationLive = _stops.isNotEmpty && _loadError == null;
      });
    }

    _startLiveTracking();
  }

  void _startLiveTracking() {
    _posSub?.cancel();
    _posSub = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 8,
      ),
    ).listen(
      (pos) async {
        final next = LatLng(pos.latitude, pos.longitude);
        if (pos.heading >= 0) _heading = pos.heading;
        _riderPos = next;

        try {
          await WhatsLipaApi.postRiderLocation(pos.latitude, pos.longitude);
        } catch (_) {}

        _scheduleActiveLegRefresh(next);
        if (mounted) {
          _buildMapOverlays();
          if (_followRider) _followRiderCamera();
        }
      },
      onError: (e) => WhatsLipaMapsLog.warn('GPS stream: $e'),
    );
  }

  void _scheduleActiveLegRefresh(LatLng pos) {
    if (!_navigationLive || _currentStop >= _stops.length) return;

    final last = _lastLegRefreshPos;
    final lastAt = _lastLegRefreshAt;
    final moved = last == null ? true : _distanceMeters(last, pos) >= _legRefreshMinMeters;
    final timedOut = lastAt == null || DateTime.now().difference(lastAt).inSeconds >= _legRefreshMinSeconds;
    if (!moved && !timedOut) return;

    _legRefreshDebounce?.cancel();
    _legRefreshDebounce = Timer(const Duration(milliseconds: 600), () {
      _refreshActiveLeg(pos);
    });
  }

  Future<void> _refreshActiveLeg(LatLng from) async {
    if (_currentStop >= _stops.length || _refreshingLeg) return;
    final stop = _stops[_currentStop];
    final destLat = _asDouble(stop['latitude']);
    final destLng = _asDouble(stop['longitude']);
    if (destLat == null || destLng == null) return;

    setState(() => _refreshingLeg = true);
    try {
      final data = await WhatsLipaApi.deliveryRouteActiveLeg(
        originLat: from.latitude,
        originLng: from.longitude,
        destLat: destLat,
        destLng: destLng,
      );
      _activeLegPoints = _parsePolyline(data['polyline']);
      _legDistanceM = (data['distance_meters'] as num?)?.toInt();
      _legDurationS = (data['duration_seconds'] as num?)?.toInt();
      _lastLegRefreshPos = from;
      _lastLegRefreshAt = DateTime.now();
      if (mounted) _buildMapOverlays();
    } catch (e) {
      WhatsLipaMapsLog.warn('Active leg refresh: $e');
    } finally {
      if (mounted) setState(() => _refreshingLeg = false);
    }
  }

  Future<void> _loadRoutePlan(LatLng? riderPos) async {
    try {
      final plan = await WhatsLipaApi.deliveryRoutePlan(
        orderIds: widget.orderIds,
        originLat: riderPos?.latitude,
        originLng: riderPos?.longitude,
        currentStopIndex: _currentStop,
      );

      final originRaw = plan['origin'];
      if (originRaw is Map && riderPos == null) {
        final o = Map<String, dynamic>.from(originRaw);
        final lat = _asDouble(o['latitude']);
        final lng = _asDouble(o['longitude']);
        if (lat != null && lng != null) {
          _riderPos = LatLng(lat, lng);
        }
      }

      _stops = (plan['stops'] is List ? plan['stops'] as List : [])
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .where((s) => _asDouble(s['latitude']) != null && _asDouble(s['longitude']) != null)
          .toList();

      _missingCoordOrderIds = (plan['missing_coordinates_order_ids'] as List?)
              ?.map((e) => int.tryParse('$e') ?? 0)
              .where((id) => id > 0)
              .toList() ??
          [];

      _directionsUrl = plan['google_maps_directions_url']?.toString();
      _activeLegPoints = _parsePolyline(plan['active_leg_polyline']);
      _upcomingPoints = _parsePolyline(plan['upcoming_polyline']);
      _legDistanceM = (plan['active_leg_distance_meters'] as num?)?.toInt();
      _legDurationS = (plan['active_leg_duration_seconds'] as num?)?.toInt();
      _totalDistanceM = (plan['route_distance_meters'] as num?)?.toInt();
      _totalDurationS = (plan['route_duration_seconds'] as num?)?.toInt();

      if (_stops.isEmpty) {
        _loadError = _missingCoordOrderIds.isNotEmpty
            ? 'Orders without GPS: ${_missingCoordOrderIds.join(', ')}'
            : 'No delivery stops with coordinates.';
      }

      _buildMapOverlays();
      if (_followRider && _riderPos != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _followRiderCamera());
      } else {
        _fitOverview();
      }
    } catch (e, st) {
      _loadError = '$e';
      WhatsLipaMapsLog.error('Route plan failed', err: e, stack: st);
    }
  }

  void _buildMapOverlays() {
    final primary = WhatsLipaTheme.primary;
    final markers = <Marker>{};

    if (_riderPos != null) {
      markers.add(Marker(
        markerId: const MarkerId('rider'),
        position: _riderPos!,
        rotation: _heading,
        flat: true,
        anchor: const Offset(0.5, 0.5),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        zIndex: 3,
        infoWindow: const InfoWindow(title: 'You · Live'),
      ));
    }

    for (var i = 0; i < _stops.length; i++) {
      final s = _stops[i];
      final lat = _asDouble(s['latitude'])!;
      final lng = _asDouble(s['longitude'])!;
      final isCurrent = i == _currentStop;
      final isDone = i < _currentStop;
      markers.add(Marker(
        markerId: MarkerId('stop_${s['order_id'] ?? i}'),
        position: LatLng(lat, lng),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          isDone
              ? BitmapDescriptor.hueViolet
              : isCurrent
                  ? BitmapDescriptor.hueOrange
                  : BitmapDescriptor.hueRed,
        ),
        zIndex: isCurrent ? 2 : 1,
        infoWindow: InfoWindow(
          title: s['label']?.toString() ?? 'Stop ${i + 1}',
          snippet: isDone ? 'Delivered' : (isCurrent ? 'Next stop' : 'Upcoming'),
        ),
      ));
    }

    final polylines = <Polyline>{};
    for (var i = 0; i < _completedLegPaths.length; i++) {
      final path = _completedLegPaths[i];
      if (path.length < 2) continue;
      polylines.add(Polyline(
        polylineId: PolylineId('completed_$i'),
        points: path,
        color: Colors.grey.shade500,
        width: 4,
        zIndex: 0,
      ));
    }
    if (_upcomingPoints.length >= 2) {
      polylines.add(Polyline(
        polylineId: const PolylineId('upcoming'),
        points: _upcomingPoints,
        color: primary.withValues(alpha: 0.35),
        width: 5,
        zIndex: 1,
      ));
    }
    if (_activeLegPoints.length >= 2) {
      polylines.add(Polyline(
        polylineId: const PolylineId('active_leg'),
        points: _activeLegPoints,
        color: primary,
        width: 7,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        jointType: JointType.round,
        zIndex: 2,
      ));
    } else if (_riderPos != null && _currentStop < _stops.length) {
      final s = _stops[_currentStop];
      final lat = _asDouble(s['latitude']);
      final lng = _asDouble(s['longitude']);
      if (lat != null && lng != null) {
        polylines.add(Polyline(
          polylineId: const PolylineId('active_fallback'),
          points: [_riderPos!, LatLng(lat, lng)],
          color: primary,
          width: 5,
          patterns: [PatternItem.dash(16), PatternItem.gap(8)],
          zIndex: 2,
        ));
      }
    }

    if (mounted) {
      setState(() {
        _markers = markers;
        _polylines = polylines;
      });
    }
  }

  Future<void> _followRiderCamera() async {
    final c = _mapController;
    final pos = _riderPos;
    if (c == null || pos == null) return;
    await c.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: pos,
          zoom: 16.5,
          tilt: 50,
          bearing: _heading,
        ),
      ),
    );
  }

  Future<void> _fitOverview() async {
    final c = _mapController;
    if (c == null) return;
    final points = <LatLng>[];
    if (_riderPos != null) points.add(_riderPos!);
    points.addAll(_activeLegPoints);
    points.addAll(_upcomingPoints);
    for (final s in _stops) {
      final lat = _asDouble(s['latitude']);
      final lng = _asDouble(s['longitude']);
      if (lat != null && lng != null) points.add(LatLng(lat, lng));
    }
    if (points.isEmpty) return;
    if (points.length == 1) {
      await c.animateCamera(CameraUpdate.newLatLngZoom(points.first, 14));
      return;
    }
    var minLat = points.first.latitude;
    var maxLat = points.first.latitude;
    var minLng = points.first.longitude;
    var maxLng = points.first.longitude;
    for (final p in points) {
      minLat = math.min(minLat, p.latitude);
      maxLat = math.max(maxLat, p.latitude);
      minLng = math.min(minLng, p.longitude);
      maxLng = math.max(maxLng, p.longitude);
    }
    try {
      await c.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(minLat, minLng),
            northeast: LatLng(maxLat, maxLng),
          ),
          64,
        ),
      );
    } catch (_) {}
  }

  Future<void> _advanceStop() async {
    if (_activeLegPoints.length >= 2) {
      _completedLegPaths.add(List<LatLng>.from(_activeLegPoints));
    }
    if (_currentStop < _stops.length - 1) {
      setState(() => _currentStop++);
      _activeLegPoints = [];
      _upcomingPoints = [];
      _legDistanceM = null;
      _legDurationS = null;
      _lastLegRefreshPos = _riderPos;
      _lastLegRefreshAt = null;
      await _loadRoutePlan(_riderPos);
      if (_riderPos != null) await _refreshActiveLeg(_riderPos!);
    } else if (mounted) {
      Navigator.pop(context, true);
    }
  }

  Future<void> _openExternalMaps() async {
    if (_directionsUrl == null || _directionsUrl!.isEmpty) return;
    final uri = Uri.parse(_directionsUrl!);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _confirmCurrent() async {
    if (_currentStop >= _stops.length) return;
    final orderId = int.tryParse('${_stops[_currentStop]['order_id']}');
    if (orderId == null) return;
    try {
      await WhatsLipaApi.completeDelivery(orderId);
      await _advanceStop();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  Future<void> _markUndelivered() async {
    if (_currentStop >= _stops.length) return;
    final orderId = int.tryParse('${_stops[_currentStop]['order_id']}');
    if (orderId == null) return;
    try {
      await WhatsLipaApi.cancelDelivery(orderId);
      await _advanceStop();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = WhatsLipaTheme.primary;
    final initial = _riderPos ??
        (_stops.isNotEmpty
            ? LatLng(_asDouble(_stops.first['latitude'])!, _asDouble(_stops.first['longitude'])!)
            : const LatLng(-6.783333, 39.216667));
    final current = _currentStop < _stops.length ? _stops[_currentStop] : null;

    return Scaffold(
      appBar: WhatsLipaTheme.appBar(
        title: 'Live navigation',
        actions: [
          if (_directionsUrl != null && _directionsUrl!.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.open_in_new),
              tooltip: 'Open in Google Maps',
              onPressed: _openExternalMaps,
            ),
        ],
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator(color: primary))
          : Stack(
              children: [
                Column(
                  children: [
                    if (_loadError != null)
                      Material(
                        color: Colors.orange.shade50,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(_loadError!, style: const TextStyle(fontSize: 13)),
                        ),
                      ),
                    Expanded(
                      child: Stack(
                        children: [
                          WhatsLipaMapPanel(
                            logContext: 'delivery-route',
                            initialTarget: initial,
                            markers: _markers,
                            polylines: _polylines,
                            navigationMode: _navigationLive,
                            myLocationEnabled: true,
                            onUserMapGesture: () {
                              if (_followRider) setState(() => _followRider = false);
                            },
                            onMapCreated: (c) {
                              _mapController = c;
                              if (_followRider && _riderPos != null) {
                                _followRiderCamera();
                              } else {
                                _fitOverview();
                              }
                            },
                          ),
                          if (_navigationLive)
                            Positioned(
                              top: 12,
                              left: 12,
                              right: 12,
                              child: Material(
                                elevation: 3,
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.black87,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: const BoxDecoration(
                                          color: Colors.greenAccent,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'LIVE · Stop ${_currentStop + 1} of ${_stops.length}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                      if (_refreshingLeg)
                                        const SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white70,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          if (!_followRider)
                            Positioned(
                              right: 12,
                              bottom: 12,
                              child: FloatingActionButton.small(
                                backgroundColor: Colors.white,
                                foregroundColor: primary,
                                onPressed: () {
                                  setState(() => _followRider = true);
                                  _followRiderCamera();
                                },
                                child: const Icon(Icons.my_location),
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (current != null) _buildNavSheet(context, current, primary),
                  ],
                ),
              ],
            ),
    );
  }

  Widget _buildNavSheet(BuildContext context, Map<String, dynamic> current, Color primary) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatDuration(_legDurationS),
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: primary,
                      height: 1,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _formatDistance(_legDistanceM),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        if (_totalDistanceM != null)
                          Text(
                            'Total trip: ${_formatDistance(_totalDistanceM)} · ${_formatDuration(_totalDurationS)}',
                            style: const TextStyle(fontSize: 11, color: Colors.black54),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'To next stop',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                current['label']?.toString() ?? 'Order',
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
              ),
              if (current['address'] != null)
                Text(
                  current['address'].toString(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _markUndelivered,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red.shade700,
                        side: BorderSide(color: Colors.red.shade300),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Undelivered', style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: FilledButton(
                      onPressed: _confirmCurrent,
                      style: FilledButton.styleFrom(
                        backgroundColor: primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Confirm delivered', style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
