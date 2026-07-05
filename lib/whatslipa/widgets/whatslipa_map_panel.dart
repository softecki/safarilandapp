import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wicom/core/whatslipa_local_db.dart';
import 'package:wicom/core/whatslipa_maps_init.dart';
import 'package:wicom/core/whatslipa_maps_log.dart';
import 'package:wicom/whatslipa/widgets/whatslipa_theme.dart';

/// Google Map with a visible error state when the API key is missing or tiles fail to load.
class WhatsLipaMapPanel extends StatefulWidget {
  const WhatsLipaMapPanel({
    super.key,
    required this.initialTarget,
    required this.markers,
    this.polylines = const {},
    this.zoom = 13,
    this.onMapCreated,
    this.myLocationEnabled = true,
    this.navigationMode = false,
    this.onUserMapGesture,
    this.logContext = 'map',
  });

  final LatLng initialTarget;
  final Set<Marker> markers;
  final Set<Polyline> polylines;
  final double zoom;
  final void Function(GoogleMapController controller)? onMapCreated;
  final bool myLocationEnabled;
  final bool navigationMode;
  final VoidCallback? onUserMapGesture;
  final String logContext;

  @override
  State<WhatsLipaMapPanel> createState() => _WhatsLipaMapPanelState();
}

class _WhatsLipaMapPanelState extends State<WhatsLipaMapPanel> {
  String? _mapsKey;
  WhatsLipaMapsInitResult? _initResult;
  bool _bootstrapDone = false;
  bool _tilesLoaded = false;
  bool _timedOut = false;
  String? _mapWidgetError;
  bool _showLog = false;

  @override
  void initState() {
    super.initState();
    WhatsLipaMapsLog.info('${widget.logContext}: WhatsLipaMapPanel init');
    _bootstrap();
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted && !_tilesLoaded && _initResult?.ok == true) {
        WhatsLipaMapsLog.warn(
          '${widget.logContext}: map tiles did not load within 10s — likely API key restriction or Maps JavaScript API disabled',
        );
        setState(() => _timedOut = true);
      }
    });
  }

  Future<void> _bootstrap() async {
    final key = await WhatsLipaLocalDb.getGoogleMapsApiKey();
    final init = await initWhatsLipaGoogleMaps();
    if (!mounted) return;
    setState(() {
      _mapsKey = key;
      _initResult = init;
      _bootstrapDone = true;
    });
    WhatsLipaMapsLog.info('${widget.logContext}: bootstrap done — ${init.summary}');
  }

  @override
  Widget build(BuildContext context) {
    if (!_bootstrapDone) {
      return Center(
        child: CircularProgressIndicator(color: WhatsLipaTheme.primary),
      );
    }

    final keyMissing = _mapsKey == null || _mapsKey!.isEmpty;
    final initFailed = _initResult != null && !_initResult!.ok;
    final showError = keyMissing || initFailed || _timedOut || _mapWidgetError != null;

    if (showError) {
      return _errorOverlay(
        keyMissing: keyMissing,
        initFailed: initFailed,
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: widget.initialTarget,
            zoom: widget.navigationMode ? 15.5 : widget.zoom,
            tilt: widget.navigationMode ? 45 : 0,
          ),
          markers: widget.markers,
          polylines: widget.polylines,
          myLocationEnabled: widget.myLocationEnabled,
          myLocationButtonEnabled: widget.myLocationEnabled && !widget.navigationMode,
          compassEnabled: widget.navigationMode,
          trafficEnabled: widget.navigationMode,
          mapToolbarEnabled: false,
          onCameraMoveStarted: widget.onUserMapGesture,
          onMapCreated: (controller) {
            WhatsLipaMapsLog.info('${widget.logContext}: GoogleMap onMapCreated');
            widget.onMapCreated?.call(controller);
            if (mounted) setState(() => _tilesLoaded = true);
          },
        ),
      ],
    );
  }

  Widget _errorOverlay({required bool keyMissing, required bool initFailed}) {
    final title = keyMissing
        ? 'Google Maps API key not configured'
        : initFailed
            ? 'Google Maps could not initialize'
            : _mapWidgetError != null
                ? 'Google Maps error'
                : 'Google Maps could not load';

    final body = keyMissing
        ? 'Sign in while online so the app can sync the map key from your portal.'
        : initFailed
            ? (_initResult?.summary ?? 'Web Maps plugin failed.')
            : kIsWeb
                ? 'On Flutter web you must enable Maps JavaScript API (not only Maps SDK for Android). Add this website to HTTP referrer restrictions for your API key.'
                : 'The map key may be invalid or restricted. Enable billing and the correct Maps SDK for your platform.';

    return Container(
      color: Colors.white.withValues(alpha: 0.96),
      padding: const EdgeInsets.all(20),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.map_outlined, size: 48, color: WhatsLipaTheme.primary),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                body,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: Colors.black54, height: 1.4),
              ),
              if (_mapWidgetError != null) ...[
                const SizedBox(height: 8),
                Text(
                  _mapWidgetError!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, color: Color(0xFFB91C1C)),
                ),
              ],
              if (kIsWeb) ...[
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => setState(() => _showLog = !_showLog),
                  child: Text(_showLog ? 'Hide diagnostic log' : 'Show diagnostic log (also in browser console)'),
                ),
                if (_showLog) ...[
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SelectableText(
                      WhatsLipaMapsLog.recentLines.join('\n'),
                      style: const TextStyle(fontSize: 10, fontFamily: 'monospace', height: 1.35),
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}
