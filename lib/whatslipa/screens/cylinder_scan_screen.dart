import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:wicom/core/cylinder_api.dart';
import 'package:wicom/whatslipa/widgets/whatslipa_ui.dart';

class CylinderScanScreen extends StatefulWidget {
  const CylinderScanScreen({super.key});

  @override
  State<CylinderScanScreen> createState() => _CylinderScanScreenState();
}

class _CylinderScanScreenState extends State<CylinderScanScreen> {
  static const _accent = Color(0xFFD4AF37);

  final _manualController = TextEditingController();
  String _eventType = 'deliver';
  bool _loading = false;
  String? _message;
  bool _useCamera = true;
  Map<String, dynamic>? _lastResult;

  static const _events = [
    'stock_in',
    'stock_out',
    'agent_receive',
    'deliver',
    'return_empty',
    'exchange',
    'maintenance_flag',
    'maintenance_complete',
  ];

  @override
  void dispose() {
    _manualController.dispose();
    super.dispose();
  }

  Future<void> _submitScan(String payload) async {
    if (payload.trim().isEmpty) return;
    setState(() {
      _loading = true;
      _message = null;
    });
    try {
      final result = await CylinderApi.scan(
        qrPayload: payload.trim(),
        eventType: _eventType,
        clientNonce: DateTime.now().millisecondsSinceEpoch.toString(),
      );
      if (!mounted) return;
      setState(() {
        _lastResult = result;
        _message = result['ok'] == true
            ? 'Scan recorded: ${result['cylinder']?['serial_number'] ?? ''}'
            : (result['message']?.toString() ?? 'Scan failed');
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _message = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WhatsLipaStyledAppBar(title: 'Cylinder QR Scan', accentColor: _accent),
      body: WhatsLipaScreenBackground(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            WhatsLipaGlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Event type', style: WhatsLipaUi.badgeLabel.copyWith(color: _accent)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _eventType,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF4F8F5),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                    ),
                    items: _events.map((e) => DropdownMenuItem(value: e, child: Text(e.replaceAll('_', ' ')))).toList(),
                    onChanged: _loading ? null : (v) => setState(() => _eventType = v ?? 'deliver'),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _loading ? null : () => setState(() => _useCamera = true),
                          icon: const Icon(Icons.photo_camera_outlined),
                          label: const Text('Camera'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _loading ? null : () => setState(() => _useCamera = false),
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
                      child: SizedBox(
                        height: 260,
                        child: MobileScanner(
                          onDetect: (capture) {
                            for (final b in capture.barcodes) {
                              final raw = b.rawValue;
                              if (raw != null && raw.isNotEmpty && !_loading) {
                                _submitScan(raw);
                                break;
                              }
                            }
                          },
                        ),
                      ),
                    )
                  else ...[
                    WhatsLipaInputField(
                      controller: _manualController,
                      hint: 'QR payload / UUID / Serial',
                      prefixIcon: Icons.qr_code_2_rounded,
                    ),
                    const SizedBox(height: 14),
                    WhatsLipaPrimaryButton(
                      label: _loading ? 'Processing…' : 'Record scan',
                      loading: _loading,
                      onPressed: _loading ? null : () => _submitScan(_manualController.text),
                    ),
                  ],
                  if (_message != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      _message!,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: _message!.startsWith('Scan recorded') ? Colors.green.shade800 : Colors.red.shade800,
                      ),
                    ),
                  ],
                  if (_lastResult?['cylinder'] != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: _accent.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Serial: ${_lastResult!['cylinder']['serial_number']}',
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                          Text('Status: ${_lastResult!['cylinder']['current_status']}'),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
