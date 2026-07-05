import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:wicom/core/app_color.dart';
import 'package:wicom/whatslipa/widgets/whatslipa_ui.dart';

/// Web vs mobile behaviour for QR scanning in WhatsLipa.
class WhatsLipaQrScanSupport {
  WhatsLipaQrScanSupport._();

  static const double desktopWebBreakpoint = 768;

  static bool get isWeb => kIsWeb;

  static bool isDesktopWeb(BuildContext context) {
    if (!kIsWeb) return false;
    return MediaQuery.sizeOf(context).width >= desktopWebBreakpoint;
  }

  /// Desktop web defaults to manual; phone web and native default to camera.
  static bool defaultUseCamera(BuildContext context) {
    if (!kIsWeb) return true;
    return !isDesktopWeb(context);
  }

  static String webBannerMessage(BuildContext context) {
    if (!kIsWeb) return '';
    if (isDesktopWeb(context)) {
      return 'Web on desktop: paste or type the code below, or switch to Camera if you have a webcam.';
    }
    return 'Allow camera access when your browser asks. The site must use HTTPS (not plain HTTP).';
  }

  static String friendlyCameraError(Object? error) {
    final msg = error?.toString().toLowerCase() ?? '';
    if (msg.contains('permission') ||
        msg.contains('denied') ||
        msg.contains('notallowed') ||
        msg.contains('not allowed')) {
      return 'Camera access was denied. Allow the camera in your browser settings, or use Manual entry.';
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
    return 'Camera is unavailable right now. Switch to Manual entry or retry after allowing camera access.';
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

class _WhatsLipaQrScanPanelState extends State<WhatsLipaQrScanPanel> {
  final _manualController = TextEditingController();
  MobileScannerController? _scannerController;
  late bool _useCamera;
  bool _initializedMode = false;
  String? _cameraError;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initializedMode) {
      _useCamera = WhatsLipaQrScanSupport.defaultUseCamera(context);
      _initializedMode = true;
    }
  }

  @override
  void dispose() {
    _manualController.dispose();
    _scannerController?.dispose();
    super.dispose();
  }

  void _ensureController() {
    _scannerController ??= MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
    );
  }

  void _disposeController() {
    _scannerController?.dispose();
    _scannerController = null;
  }

  void _setUseCamera(bool value) {
    setState(() {
      _useCamera = value;
      _cameraError = null;
      if (value) {
        _ensureController();
      } else {
        _disposeController();
      }
    });
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
    if (_useCamera) {
      _ensureController();
    }

    final webBanner = WhatsLipaQrScanSupport.webBannerMessage(context);

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
                Icon(
                  WhatsLipaQrScanSupport.isDesktopWeb(context)
                      ? Icons.laptop_mac_rounded
                      : Icons.info_outline_rounded,
                  size: 20,
                  color: widget.accentColor,
                ),
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
                onPressed: widget.loading ? null : () => _setUseCamera(true),
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
                child: _scannerController == null
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
        if (_cameraError != null && _useCamera) ...[
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
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => _setUseCamera(false),
              icon: const Icon(Icons.keyboard_outlined),
              label: const Text('Switch to Manual entry'),
            ),
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
    required this.onUseManual,
  });

  final Color accent;
  final String message;
  final VoidCallback onUseManual;

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
            onPressed: onUseManual,
            style: FilledButton.styleFrom(backgroundColor: accent, foregroundColor: AppColor.textPrimary),
            icon: const Icon(Icons.keyboard_outlined),
            label: const Text('Use Manual entry'),
          ),
        ],
      ),
    );
  }
}
