import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:wicom/src/services/gate_scan_queue_service.dart';
import 'package:wicom/src/services/gate_sync_service.dart';
import 'package:wicom/src/view/screen/gate_selfie_capture_screen.dart';

class GateScanScreen extends StatefulWidget {
  const GateScanScreen({super.key});

  @override
  State<GateScanScreen> createState() => _GateScanScreenState();
}

class _GateScanScreenState extends State<GateScanScreen> {
  final GateScanQueueService _queueService = GateScanQueueService();
  final GateSyncService _syncService = GateSyncService();
  MobileScannerController? _controller;
  bool _busy = false;
  String _status = 'Ready to scan employee card QR.';

  @override
  void initState() {
    super.initState();
    _controller =
        MobileScannerController(detectionSpeed: DetectionSpeed.noDuplicates);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await _controller?.start();
      } catch (_) {}
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<Position?> _currentPosition() async {
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) return null;
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) return null;
    return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  String _newLocalRef() {
    final rnd = Random().nextInt(999999);
    return '${DateTime.now().millisecondsSinceEpoch}-$rnd';
  }

  Future<void> _resumeScanner() async {
    if (!mounted) return;
    setState(() => _status = 'Ready to scan employee card QR.');
    final c = _controller;
    if (c == null) return;
    try {
      await c.stop();
    } catch (_) {}
    try {
      await c.start();
    } catch (_) {}
  }

  Future<void> _showScanSuccessDialog() async {
    if (!mounted) return;
    final green = Colors.green.shade700;
    final greenDark = Colors.green.shade900;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          contentPadding: const EdgeInsets.fromLTRB(24, 28, 24, 12),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: green, size: 80),
              const SizedBox(height: 20),
              Text(
                'Scanned successful',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: greenDark,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Attendance was saved and synced to the server.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, height: 1.35, color: green),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          actions: [
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(ctx).pop(),
                style: FilledButton.styleFrom(
                  backgroundColor: green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('OK',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        );
      },
    );
    await _resumeScanner();
  }

  Future<void> _showSyncIssueDialog(
      {required String title,
      required String body,
      required bool isError}) async {
    if (!mounted) return;
    final color = isError ? Colors.red.shade700 : Colors.orange.shade800;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          contentPadding: const EdgeInsets.fromLTRB(24, 28, 24, 12),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(isError ? Icons.error_outline : Icons.warning_amber_rounded,
                  color: color, size: 64),
              const SizedBox(height: 16),
              Text(title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, color: color)),
              const SizedBox(height: 12),
              Text(body,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14, height: 1.35, color: Colors.grey.shade800)),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          actions: [
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(ctx).pop(),
                style: FilledButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('OK',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        );
      },
    );
    await _resumeScanner();
  }

  Future<void> _handleCode(String raw) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final now = DateTime.now();
      setState(() => _status = 'Opening front camera...');
      final scanner = _controller;
      if (scanner != null) {
        try {
          await scanner.stop();
        } catch (_) {}
      }

      final selfieFile = await Navigator.push<File?>(
        context,
        MaterialPageRoute<File?>(
          builder: (_) => const GateSelfieCaptureScreen(seconds: 4),
        ),
      );
      if (!mounted) return;
      if (selfieFile == null) {
        setState(() => _status = 'Selfie capture cancelled.');
        await _resumeScanner();
        return;
      }
      final selfieBase64 = base64Encode(await selfieFile.readAsBytes());

      Position? pos;
      try {
        pos = await _currentPosition();
      } catch (e) {
        if (!mounted) return;
        setState(() {
          _status =
              'Location is required for this scan. Enable GPS, grant location permission in system settings, then try again. ($e)';
        });
        return;
      }
      final localRef = _newLocalRef();
      await _queueService.enqueueScan(
        localRef: localRef,
        qrToken: raw.trim(),
        scannedAtDevice: now.toUtc().toIso8601String(),
        deviceId: 'gate-device',
        lat: pos?.latitude,
        lng: pos?.longitude,
        faceImageBase64: selfieBase64,
      );
      if (!mounted) return;
      setState(() => _status = 'Syncing to server...');

      final summary = await _syncService.syncPending(latestLocalRef: localRef);
      if (!mounted) return;

      setState(() => _busy = false);

      if (summary.failed == 0 && summary.succeeded > 0) {
        if (summary.faceSummary != null && summary.faceSummary!.isNotEmpty) {
          setState(() => _status = summary.faceSummary!);
        }
        await _showScanSuccessDialog();
      } else if (summary.succeeded > 0 && summary.failed > 0) {
        setState(() {
          _status =
              'Synced: ${summary.succeeded} ok, ${summary.failed} failed.${summary.faceSummary != null ? ' ${summary.faceSummary}' : ''}';
        });
        await _showSyncIssueDialog(
          title: 'Partially synced',
          body:
              '${summary.succeeded} scan(s) synced, ${summary.failed} failed.${summary.message != null ? '\n${summary.message}' : ''}\nTap OK to scan another card.',
          isError: false,
        );
      } else {
        final msg = summary.message ?? 'Sync failed.';
        setState(() => _status = msg);
        await _showSyncIssueDialog(
          title: 'Sync failed',
          body: '$msg\nTap OK to try scanning again.',
          isError: true,
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _status = 'Could not save or sync scan: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Employee Card')),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: (capture) {
              if (_busy) return;
              final barcodes = capture.barcodes;
              if (barcodes.isEmpty) return;
              final raw = barcodes.first.rawValue;
              if (raw == null || raw.isEmpty) return;
              _handleCode(raw);
            },
            errorBuilder: (context, error, child) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Camera unavailable: ${error.errorDetails?.message ?? error}. '
                    'Allow camera access in browser settings and use HTTPS.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              );
            },
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: Neumorphic(
              style: NeumorphicStyle(
                depth: 8,
                color: const Color(0xD91A2228),
                boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(18)),
              ),
              padding: const EdgeInsets.all(14),
              child: Text(
                _status,
                style: const TextStyle(color: Colors.white, height: 1.35),
              ),
            ),
          ),
          if (_busy)
            const Positioned.fill(
              child: IgnorePointer(
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
    );
  }
}
