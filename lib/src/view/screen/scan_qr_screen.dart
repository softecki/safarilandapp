import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:wicom/core/app_color.dart';
import 'package:wicom/core/attendance_api.dart';
import 'package:wicom/core/attendance_session.dart';
import 'package:wicom/src/view/screen/employee_selfie_capture_screen.dart';
import 'package:wicom/src/view/widgets/neumorphic_widgets.dart';
import 'dart:math';

class ScanQrScreen extends StatefulWidget {
  const ScanQrScreen({super.key});

  @override
  State<ScanQrScreen> createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends State<ScanQrScreen> {
  bool _busy = false;
  String? _status;
  MobileScannerController? _controller;

  String _newLocalRef() {
    final rnd = Random().nextInt(999999);
    return '${DateTime.now().millisecondsSinceEpoch}-$rnd';
  }

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _controller = MobileScannerController(
        detectionSpeed: DetectionSpeed.noDuplicates,
      );
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _showScanFailureDialog(String message) async {
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        icon: Icon(Icons.cancel, color: Colors.red.shade700, size: 48),
        title: Text(
          'Scan not completed',
          style: TextStyle(
            color: Colors.red.shade900,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: SingleChildScrollView(
          child: Text(
            message,
            style: TextStyle(color: Colors.grey.shade800, height: 1.35),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleCode(String raw) async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _status = 'Reading gate QR…';
    });
    try {
      try {
        await _controller?.stop();
      } catch (_) {}

      final authToken = await AttendanceSession.token;
      final tenantSlug = await AttendanceSession.tenantSlug;
      if (authToken == null ||
          authToken.isEmpty ||
          tenantSlug == null ||
          tenantSlug.isEmpty) {
        throw Exception('Session expired. Sign in again.');
      }

      final gatePayload = AttendanceApi.parseGateQrPayload(raw);
      if (gatePayload.tenantSlug != tenantSlug) {
        throw Exception('This gate QR is for another organization.');
      }

      if (!mounted) return;
      setState(() => _status = 'Prepare for face check…');

      final selfie = await Navigator.of(context).push<File?>(
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (_) => const EmployeeSelfieCaptureScreen(),
        ),
      );
      if (selfie == null) {
        throw Exception('Face capture cancelled.');
      }

      setState(() => _status = 'Getting location…');
      final position = await _currentPosition();

      setState(() => _status = 'Verifying face and recording attendance…');
      final result = await AttendanceApi.submitEmployeeGateScan(
        authToken: authToken,
        scannerToken: gatePayload.token,
        tenantSlug: tenantSlug,
        localRef: _newLocalRef(),
        deviceId: 'mobile-app',
        lat: position.latitude,
        lng: position.longitude,
        selfieImage: selfie,
      );
      final msg = result['message']?.toString() ?? 'Done';
      final status = result['status']?.toString() ?? '';
      if (!mounted) return;
      setState(() => _status = msg);

      final fv = result['face_verification'];
      if (fv is Map && fv['matched'] == true && fv['similarity'] != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '$msg (match ${fv['similarity']}%)',
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      }

      if (status == 'ok' || status == 'already_recorded') {
        Navigator.pop(context);
      }
    } on AttendanceApiException catch (e) {
      if (!mounted) return;
      setState(() => _status = e.message);
      await _showScanFailureDialog(e.message);
    } catch (e) {
      if (!mounted) return;
      setState(() => _status = e.toString());
      await _showScanFailureDialog(e.toString());
    } finally {
      try {
        await _controller?.start();
      } catch (_) {}
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<Position> _currentPosition() async {
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) {
      throw Exception('Location service is disabled. Turn on GPS to continue.');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw Exception('Location permission is required for attendance scan.');
    }

    return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Scan QR'),
          backgroundColor: AppColor.primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
        body: NeuScreenCanvas(
          child: const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'QR scanning is available on the Android or iOS build of Softecki FaceAccess. Web preview does not include the camera scanner.',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Gate QR'),
        backgroundColor: AppColor.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
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
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 32,
            child: Neumorphic(
              style: NeumorphicStyle(
                depth: 8,
                color: const Color(0xD91A2228),
                boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(18)),
              ),
              padding: const EdgeInsets.all(16),
              child: Text(
                _status ??
                    'Scan the gate QR code. You will see a 6 second countdown, then a selfie is taken automatically for face verification on the server. GPS is required.',
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
