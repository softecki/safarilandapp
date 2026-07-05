import 'package:flutter/material.dart';
import 'package:wicom/core/cylinder_api.dart';
import 'package:wicom/whatslipa/widgets/whatslipa_qr_scan_panel.dart';
import 'package:wicom/whatslipa/widgets/whatslipa_ui.dart';

class CylinderScanScreen extends StatefulWidget {
  const CylinderScanScreen({super.key});

  @override
  State<CylinderScanScreen> createState() => _CylinderScanScreenState();
}

class _CylinderScanScreenState extends State<CylinderScanScreen> {
  static const _accent = Color(0xFFD4AF37);

  String _eventType = 'deliver';
  bool _loading = false;
  String? _message;
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
                    items: _events
                        .map((e) => DropdownMenuItem(value: e, child: Text(e.replaceAll('_', ' '))))
                        .toList(),
                    onChanged: _loading ? null : (v) => setState(() => _eventType = v ?? 'deliver'),
                  ),
                  const SizedBox(height: 16),
                  WhatsLipaQrScanPanel(
                    accentColor: _accent,
                    loading: _loading,
                    onScan: _submitScan,
                    submitLabel: 'Record scan',
                  ),
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
