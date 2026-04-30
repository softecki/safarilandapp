import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class GateSelfieCaptureScreen extends StatefulWidget {
  const GateSelfieCaptureScreen({super.key, this.seconds = 4});

  final int seconds;

  @override
  State<GateSelfieCaptureScreen> createState() =>
      _GateSelfieCaptureScreenState();
}

class _GateSelfieCaptureScreenState extends State<GateSelfieCaptureScreen> {
  CameraController? _controller;
  bool _capturing = false;
  int _remaining = 4;

  @override
  void initState() {
    super.initState();
    _remaining = widget.seconds;
    _initCamera();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      final front = cameras
          .where((c) => c.lensDirection == CameraLensDirection.front)
          .toList();
      final selected = front.isNotEmpty ? front.first : cameras.first;
      final controller = CameraController(selected, ResolutionPreset.medium,
          enableAudio: false);
      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() => _controller = controller);
      _startCountdown();
    } catch (_) {
      if (!mounted) return;
      Navigator.of(context).pop<File?>(null);
    }
  }

  Future<void> _startCountdown() async {
    while (mounted && _remaining > 0) {
      await Future<void>.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      setState(() => _remaining -= 1);
    }
    if (!mounted) return;
    await _takePicture();
  }

  Future<void> _takePicture() async {
    final c = _controller;
    if (c == null || !c.value.isInitialized || _capturing) return;
    setState(() => _capturing = true);
    try {
      final file = await c.takePicture();
      if (!mounted) return;
      Navigator.of(context).pop<File>(File(file.path));
    } catch (_) {
      if (!mounted) return;
      Navigator.of(context).pop<File?>(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = _controller;
    return Scaffold(
      appBar: AppBar(title: const Text('Face Verification')),
      body: c == null || !c.value.isInitialized
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Positioned.fill(child: CameraPreview(c)),
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 24,
                  child: Card(
                    color: Colors.black.withValues(alpha: 0.65),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        _capturing
                            ? 'Capturing selfie...'
                            : 'Look at the camera. Photo in ${_remaining}s',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
