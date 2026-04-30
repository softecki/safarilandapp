import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:wicom/core/app_color.dart';
import 'package:wicom/core/attendance_api.dart';
import 'package:wicom/core/attendance_session.dart';
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
  final ImagePicker _imagePicker = ImagePicker();

  String _newLocalRef() {
    final rnd = Random().nextInt(999999);
    return '${DateTime.now().millisecondsSinceEpoch}-$rnd';
  }

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _controller =
          MobileScannerController(detectionSpeed: DetectionSpeed.normal);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _handleCode(String raw) async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _status = 'Sending scan…';
    });
    try {
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
      final selfie = await _captureSelfie();
      if (selfie == null) {
        throw Exception('Selfie capture cancelled.');
      }
      final position = await _currentPosition();

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
      if (!mounted) return;
      setState(() => _status = msg);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      if ((result['status']?.toString() ?? '') == 'ok') {
        Navigator.pop(context);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _status = e.toString());
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<File?> _captureSelfie() async {
    setState(() => _status = 'Open selfie camera...');
    final photo = await _imagePicker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
      imageQuality: 75,
      maxWidth: 1080,
    );
    if (photo == null) return null;
    return File(photo.path);
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
            foregroundColor: Colors.white),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'QR scanning is available on the Android or iOS build of Softecki FaceAccess. Web preview does not include the camera scanner.',
              textAlign: TextAlign.center,
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
            child: Card(
              color: Colors.black.withValues(alpha: 0.65),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  _status ??
                      'Point the camera at the gate QR code. GPS location is sent with this attendance scan.',
                  style: const TextStyle(color: Colors.white),
                ),
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
