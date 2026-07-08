import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:wicom/core/app_color.dart';
import 'package:wicom/whatslipa/camera/whatslipa_camera_access.dart';
import 'package:wicom/whatslipa/navigation/whatslipa_route_observer.dart';
import 'package:wicom/whatslipa/widgets/whatslipa_ui.dart';

/// Web vs mobile behaviour for QR scanning in WhatsLipa.
class WhatsLipaQrScanSupport {
  WhatsLipaQrScanSupport._();

  static bool get isWeb => kIsWeb;

  /// Camera scanning is the default on web and native.
  static bool defaultUseCamera(BuildContext context) => true;

  static String webBannerMessage(BuildContext context) {
    if (!kIsWeb) return '';
    return 'Tap "Allow camera access" when prompted. Camera scanning requires HTTPS (secure connection).';
  }

  static String friendlyCameraError(Object? error) {
    final msg = error?.toString().toLowerCase() ?? '';
    if (msg.contains('permission') ||
        msg.contains('denied') ||
        msg.contains('notallowed') ||
        msg.contains('not allowed')) {
      return 'Camera access was denied. Allow the camera in your device or browser settings, or use Manual entry.';
    }
    if (msg.contains('notfound') ||
        msg.contains('no camera') ||
        msg.contains('devices not found')) {
      return 'No camera was found on this device. Use Manual entry instead.';
    }
    if (msg.contains('secure') ||
        msg.contains('https') ||
        msg.contains('insecure')) {
      return 'Camera requires a secure HTTPS connection. Use Manual entry or open the app on an https:// URL.';
    }
    if (msg.contains('unsupported') || msg.contains('not supported')) {
      return 'This browser does not support camera scanning here. Use Manual entry.';
    }
    if (msg.contains('in use') ||
        msg.contains('busy') ||
        msg.contains('notreadable') ||
        msg.contains('not readable')) {
      return 'The camera is in use by another screen. Close other scanners and tap Retry.';
    }
    return 'Camera is unavailable right now. Allow camera access, tap Retry, or switch to Manual entry.';
  }

  static String permissionMessage(WhatsLipaCameraAccessResult result) {
    return switch (result) {
      WhatsLipaCameraAccessResult.granted => '',
      WhatsLipaCameraAccessResult.denied =>
        'Camera access is required to scan QR codes. Tap Allow camera access to continue.',
      WhatsLipaCameraAccessResult.permanentlyDenied =>
        'Camera access is blocked. Open settings to allow the camera, or use Manual entry.',
    };
  }
}

/// Shared camera / manual QR capture panel with web-aware defaults and errors.
class WhatsLipaQrScanPanel extends StatefulWidget {
  const WhatsLipaQrScanPanel({
    super.key,
    required this.accentColor,
    required this.loading,
    required this.onScan,
    required this.submitLabel,
    this.title,
    this.manualHint = 'QR payload / UUID / Serial',
  });

  final Color accentColor;
  final bool loading;
  final ValueChanged<String> onScan;
  final String submitLabel;
  final String? title;
  final String manualHint;

  @override
  State<WhatsLipaQrScanPanel> createState() => _WhatsLipaQrScanPanelState();
}

class _WhatsLipaQrScanPanelState extends State<WhatsLipaQrScanPanel>
    with WidgetsBindingObserver, RouteAware {
  final _manualController = TextEditingController();
  MobileScannerController? _scannerController;
  bool _useCamera = true;
  bool _startingCamera = false;
  bool _isActive = true;
  bool _permissionBlocked = false;
  bool _permissionPermanentlyDenied = false;
  String? _cameraError;
  ModalRoute<void>? _route;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _scheduleScannerStart(requestPermission: true));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is ModalRoute<void> && route != _route) {
      whatsLipaRouteObserver.unsubscribe(this);
      _route = route;
      whatsLipaRouteObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    whatsLipaRouteObserver.unsubscribe(this);
    WidgetsBinding.instance.removeObserver(this);
    _manualController.dispose();
    _disposeController();
    super.dispose();
  }

  @override
  void deactivate() {
    _isActive = false;
    _pauseScanner();
    super.deactivate();
  }

  @override
  void activate() {
    super.activate();
    _isActive = true;
    if (_useCamera) {
      _scheduleScannerStart(requestPermission: false);
    }
  }

  @override
  void didPushNext() {
    _isActive = false;
    _pauseScanner();
  }

  @override
  void didPopNext() {
    _isActive = true;
    if (_useCamera) {
      _scheduleScannerStart(requestPermission: false);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_useCamera) return;
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      _pauseScanner();
      return;
    }
    if (state == AppLifecycleState.resumed && _isActive) {
      _scheduleScannerStart(requestPermission: false);
    }
  }

  void _scheduleScannerStart({required bool requestPermission}) {
    Future<void>.delayed(const Duration(milliseconds: 300), () {
      if (!mounted || !_isActive || !_useCamera) return;
      _startScanner(requestPermission: requestPermission);
    });
  }

  void _ensureController() {
    _scannerController ??= MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
      autoStart: false,
    );
  }

  Future<void> _disposeController() async {
    final controller = _scannerController;
    _scannerController = null;
    if (controller == null) return;
    try {
      await controller.stop();
    } catch (_) {}
    await controller.dispose();
  }

  Future<void> _pauseScanner() async {
    try {
      await _scannerController?.stop();
    } catch (_) {}
  }

  Future<bool> _ensureCameraPermission({required bool requestPermission}) async {
    if (kIsWeb) return true;

    var access = await WhatsLipaCameraAccess.status();
    if (access == WhatsLipaCameraAccessResult.granted) {
      if (mounted) {
        setState(() {
          _permissionBlocked = false;
          _permissionPermanentlyDenied = false;
        });
      }
      return true;
    }

    if (requestPermission && access == WhatsLipaCameraAccessResult.denied) {
      access = await WhatsLipaCameraAccess.request();
    }

    if (!mounted) return false;

    if (access == WhatsLipaCameraAccessResult.granted) {
      setState(() {
        _permissionBlocked = false;
        _permissionPermanentlyDenied = false;
        _cameraError = null;
      });
      return true;
    }

    setState(() {
      _permissionBlocked = true;
      _permissionPermanentlyDenied = access == WhatsLipaCameraAccessResult.permanentlyDenied;
      _cameraError = WhatsLipaQrScanSupport.permissionMessage(access);
    });
    return false;
  }

  Future<void> _startScanner({required bool requestPermission, bool resetController = false}) async {
    if (!_useCamera || !mounted || !_isActive) return;

    setState(() {
      _startingCamera = true;
      if (!requestPermission) _cameraError = null;
    });

    if (resetController) {
      await _disposeController();
    }

    final allowed = await _ensureCameraPermission(requestPermission: requestPermission);
    if (!allowed || !mounted || !_isActive || !_useCamera) {
      if (mounted) setState(() => _startingCamera = false);
      return;
    }

    _ensureController();
    try {
      await _scannerController?.start();
      if (mounted) {
        setState(() {
          _cameraError = null;
          _permissionBlocked = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _cameraError = WhatsLipaQrScanSupport.friendlyCameraError(e);
        });
      }
    } finally {
      if (mounted) setState(() => _startingCamera = false);
    }
  }

  Future<void> _setUseCamera(bool value) async {
    if (_useCamera == value) return;
    if (!value) {
      await _disposeController();
      if (!mounted) return;
      setState(() {
        _useCamera = false;
        _cameraError = null;
        _permissionBlocked = false;
        _permissionPermanentlyDenied = false;
      });
      return;
    }
    setState(() {
      _useCamera = true;
      _cameraError = null;
    });
    await _startScanner(requestPermission: true);
  }

  Future<void> _retryCamera() => _startScanner(requestPermission: true, resetController: true);

  Future<void> _requestCameraAccess() => _startScanner(requestPermission: true, resetController: true);

  Future<void> _openCameraSettings() async {
    await WhatsLipaCameraAccess.openSettings();
    if (!mounted) return;
    _scheduleScannerStart(requestPermission: false);
  }

  void _handleDetect(BarcodeCapture capture) {
    if (widget.loading) return;
    for (final barcode in capture.barcodes) {
      final raw = barcode.rawValue;
      if (raw != null && raw.isNotEmpty) {
        widget.onScan(raw);
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final webBanner = WhatsLipaQrScanSupport.webBannerMessage(context);
    final showCameraActions = _useCamera && (_cameraError != null || _permissionBlocked);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.title != null) ...[
          Text(widget.title!, style: WhatsLipaUi.sectionTitle),
          const SizedBox(height: 14),
        ],
        if (WhatsLipaQrScanSupport.isWeb && webBanner.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: widget.accentColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: widget.accentColor.withValues(alpha: 0.2)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline_rounded, size: 20, color: widget.accentColor),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    webBanner,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: widget.accentColor.withValues(alpha: 0.95),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: widget.loading || _startingCamera ? null : () => _setUseCamera(true),
                style: _useCamera
                    ? OutlinedButton.styleFrom(
                        backgroundColor: widget.accentColor.withValues(alpha: 0.1),
                        foregroundColor: widget.accentColor,
                      )
                    : null,
                icon: const Icon(Icons.photo_camera_outlined),
                label: const Text('Camera'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: widget.loading ? null : () => _setUseCamera(false),
                style: !_useCamera
                    ? OutlinedButton.styleFrom(
                        backgroundColor: widget.accentColor.withValues(alpha: 0.1),
                        foregroundColor: widget.accentColor,
                      )
                    : null,
                icon: const Icon(Icons.keyboard_outlined),
                label: const Text('Manual'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        if (_useCamera)
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: ColoredBox(
              color: Colors.black,
              child: SizedBox(
                height: 260,
                child: _startingCamera || _scannerController == null
                    ? const Center(child: CircularProgressIndicator(color: Colors.white))
                    : MobileScanner(
                        controller: _scannerController,
                        onDetect: _handleDetect,
                        errorBuilder: (context, error, child) {
                          final message = WhatsLipaQrScanSupport.friendlyCameraError(
                            error.errorDetails?.message ?? error,
                          );
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (mounted && _cameraError != message) {
                              setState(() => _cameraError = message);
                            }
                          });
                          return _CameraErrorView(
                            accent: widget.accentColor,
                            message: message,
                            onAllowCamera: _requestCameraAccess,
                            onRetry: _retryCamera,
                            onOpenSettings: _permissionPermanentlyDenied ? _openCameraSettings : null,
                            onUseManual: () => _setUseCamera(false),
                          );
                        },
                      ),
              ),
            ),
          )
        else ...[
          WhatsLipaInputField(
            controller: _manualController,
            hint: widget.manualHint,
            prefixIcon: Icons.qr_code_2_rounded,
          ),
          const SizedBox(height: 14),
          WhatsLipaPrimaryButton(
            label: widget.loading ? 'Processing…' : widget.submitLabel,
            loading: widget.loading,
            onPressed: widget.loading ? null : () => widget.onScan(_manualController.text),
          ),
        ],
        if (showCameraActions) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.videocam_off_outlined, color: Colors.red.shade700, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _cameraError!,
                    style: TextStyle(color: Colors.red.shade800, fontSize: 13, height: 1.35),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.icon(
                onPressed: _startingCamera ? null : _requestCameraAccess,
                style: FilledButton.styleFrom(
                  backgroundColor: widget.accentColor,
                  foregroundColor: AppColor.textPrimary,
                ),
                icon: const Icon(Icons.photo_camera_front_outlined),
                label: Text(kIsWeb ? 'Allow camera access' : 'Allow camera'),
              ),
              OutlinedButton.icon(
                onPressed: _startingCamera ? null : _retryCamera,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Retry'),
              ),
              if (_permissionPermanentlyDenied && !kIsWeb)
                OutlinedButton.icon(
                  onPressed: _startingCamera ? null : _openCameraSettings,
                  icon: const Icon(Icons.settings_outlined),
                  label: const Text('Open settings'),
                ),
              TextButton.icon(
                onPressed: () => _setUseCamera(false),
                icon: const Icon(Icons.keyboard_outlined),
                label: const Text('Manual entry'),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _CameraErrorView extends StatelessWidget {
  const _CameraErrorView({
    required this.accent,
    required this.message,
    required this.onAllowCamera,
    required this.onRetry,
    required this.onUseManual,
    this.onOpenSettings,
  });

  final Color accent;
  final String message;
  final VoidCallback onAllowCamera;
  final VoidCallback onRetry;
  final VoidCallback onUseManual;
  final VoidCallback? onOpenSettings;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1A1A1A),
      padding: const EdgeInsets.all(20),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.videocam_off_outlined, size: 48, color: Colors.white.withValues(alpha: 0.85)),
          const SizedBox(height: 14),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.9), height: 1.4),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: onAllowCamera,
            style: FilledButton.styleFrom(backgroundColor: accent, foregroundColor: AppColor.textPrimary),
            icon: const Icon(Icons.photo_camera_front_outlined),
            label: Text(kIsWeb ? 'Allow camera access' : 'Allow camera'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: onRetry,
            style: OutlinedButton.styleFrom(foregroundColor: Colors.white),
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Retry'),
          ),
          if (onOpenSettings != null) ...[
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: onOpenSettings,
              style: OutlinedButton.styleFrom(foregroundColor: Colors.white70),
              icon: const Icon(Icons.settings_outlined),
              label: const Text('Open settings'),
            ),
          ],
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: onUseManual,
            style: TextButton.styleFrom(foregroundColor: Colors.white70),
            icon: const Icon(Icons.keyboard_outlined),
            label: const Text('Use Manual entry'),
          ),
        ],
      ),
    );
  }
}
