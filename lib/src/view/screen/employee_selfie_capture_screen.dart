import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

/// Full-screen front camera: **6 second** countdown (6→1), then automatic capture
/// for Rekognition face compare on the portal.
class EmployeeSelfieCaptureScreen extends StatefulWidget {
  const EmployeeSelfieCaptureScreen({super.key});

  @override
  State<EmployeeSelfieCaptureScreen> createState() =>
      _EmployeeSelfieCaptureScreenState();
}

class _EmployeeSelfieCaptureScreenState extends State<EmployeeSelfieCaptureScreen> {
  CameraController? _camera;
  bool _initializing = true;
  int? _countdown;
  bool _leaving = false;

  static const int _countdownSeconds = 6;

  @override
  void initState() {
    super.initState();
    _setup();
  }

  Future<void> _showFailureDialog(String message) async {
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        icon: Icon(Icons.cancel, color: Colors.red.shade700, size: 48),
        title: Text(
          'Could not continue',
          style: TextStyle(color: Colors.red.shade900, fontWeight: FontWeight.w700),
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

  Future<void> _setup() async {
    try {
      final cams = await availableCameras();
      if (cams.isEmpty) {
        if (mounted) {
          setState(() => _initializing = false);
          await _showFailureDialog('No camera found on this device.');
          if (mounted) Navigator.of(context).pop<File?>(null);
        }
        return;
      }

      CameraDescription? front;
      for (final c in cams) {
        if (c.lensDirection == CameraLensDirection.front) {
          front = c;
          break;
        }
      }
      final selected = front ?? cams.first;

      final cam = CameraController(
        selected,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
      await cam.initialize();
      if (!mounted) {
        await cam.dispose();
        return;
      }
      setState(() {
        _camera = cam;
        _initializing = false;
      });
      await _runCountdownAndCapture();
    } catch (e) {
      if (mounted) {
        setState(() => _initializing = false);
        await _showFailureDialog('Camera error: $e');
        if (mounted) Navigator.of(context).pop<File?>(null);
      }
    }
  }

  Future<void> _runCountdownAndCapture() async {
    final cam = _camera;
    if (cam == null || !cam.value.isInitialized || _leaving) return;

    for (int i = _countdownSeconds; i >= 1; i--) {
      if (!mounted || _leaving) return;
      setState(() => _countdown = i);
      await Future<void>.delayed(const Duration(seconds: 1));
    }
    if (!mounted || _leaving) return;
    setState(() => _countdown = 0);

    try {
      final x = await cam.takePicture();
      final file = File(x.path);
      if (!await file.exists()) {
        throw StateError('Captured file missing');
      }
      if (!mounted || _leaving) return;
      Navigator.of(context).pop<File>(file);
    } catch (e) {
      if (!mounted || _leaving) return;
      await _showFailureDialog('Could not capture photo: $e');
      if (mounted) Navigator.of(context).pop<File?>(null);
    }
  }

  void _onCancel() {
    _leaving = true;
    Navigator.of(context).pop<File?>(null);
  }

  @override
  void dispose() {
    _leaving = true;
    _camera?.dispose();
    super.dispose();
  }

  /// Fills the entire screen; scales preview with [BoxFit.cover] so the face area uses maximum height.
  Widget _fullScreenPreview(CameraController c) {
    if (!c.value.isInitialized) return const SizedBox.expand();
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;
        final ar = c.value.aspectRatio;
        if (!ar.isFinite || ar <= 0) {
          return SizedBox.expand(child: CameraPreview(c));
        }
        double previewW = w;
        double previewH = w / ar;
        if (previewH < h) {
          previewH = h;
          previewW = h * ar;
        }
        return ClipRect(
          child: OverflowBox(
            maxWidth: w,
            maxHeight: h,
            alignment: Alignment.center,
            child: SizedBox(
              width: previewW,
              height: previewH,
              child: CameraPreview(c),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (_initializing)
            const ColoredBox(
              color: Colors.black,
              child: Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            )
          else if (_camera != null && _camera!.value.isInitialized)
            ColoredBox(
              color: Colors.black,
              child: _fullScreenPreview(_camera!),
            ),
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Material(
                  color: Colors.black54,
                  shape: const CircleBorder(),
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: _onCancel,
                    tooltip: 'Cancel',
                  ),
                ),
              ),
            ),
          ),
          if (_countdown != null && _countdown! > 0)
            Positioned.fill(
              child: Container(
                alignment: Alignment.center,
                color: Colors.black38,
                child: Text(
                  '$_countdown',
                  style: const TextStyle(
                    fontSize: 140,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    shadows: [
                      Shadow(blurRadius: 28, color: Colors.black87),
                    ],
                  ),
                ),
              ),
            ),
          if (_countdown == 0)
            const Positioned.fill(
              child: ColoredBox(
                color: Colors.black45,
                child: Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
            ),
          if (!_initializing && _camera != null && _camera!.value.isInitialized)
            Positioned(
              left: 16,
              right: 16,
              bottom: 24 + MediaQuery.paddingOf(context).bottom,
              child: Text(
                _countdown == null || _countdown! > 0
                    ? 'Hold still — full screen camera. Photo automatically after countdown (${_countdownSeconds}s).'
                    : 'Capturing…',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  shadows: [Shadow(blurRadius: 8, color: Colors.black)],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
