import 'package:flutter/material.dart';
import 'package:wicom/core/cylinder_api.dart';
import 'package:wicom/core/whatslipa_brand.dart';
import 'package:wicom/whatslipa/widgets/cylinder_lifecycle_panel.dart';
import 'package:wicom/whatslipa/widgets/whatslipa_qr_scan_panel.dart';
import 'package:wicom/whatslipa/widgets/whatslipa_ui.dart';

class CylinderScanScreen extends StatefulWidget {
  const CylinderScanScreen({super.key});

  @override
  State<CylinderScanScreen> createState() => _CylinderScanScreenState();
}

class _CylinderScanScreenState extends State<CylinderScanScreen> {
  static const _mainStages = [
    ('stock_in', 'Inventory In', Icons.add_box_outlined),
    ('stock_out', 'Inventory Out', Icons.remove_circle_outline),
    ('deliver', 'Delivered', Icons.local_shipping_outlined),
    ('return_empty', 'Empty Returned', Icons.recycling_outlined),
  ];

  static const _advancedEvents = [
    'agent_receive',
    'exchange',
    'maintenance_flag',
    'maintenance_complete',
  ];

  String _eventType = 'stock_in';
  bool _showAdvanced = false;
  bool _loading = false;
  String? _message;
  Map<String, dynamic>? _lastResult;
  Map<String, dynamic>? _lifecycle;

  Color get _accent => WhatsLipaBrand.primary;

  @override
  void initState() {
    super.initState();
    _eventType = CylinderLifecycleStages.suggestedEventType(null) ?? 'stock_in';
  }

  void _applyScanResult(Map<String, dynamic> result) {
    _lastResult = result;
    final lifecycleRaw = result['lifecycle'];
    if (lifecycleRaw is Map) {
      _lifecycle = Map<String, dynamic>.from(lifecycleRaw);
      final next = CylinderLifecycleStages.suggestedEventType(_lifecycle);
      if (next != null) _eventType = next;
    }
    _message = result['ok'] == true
        ? 'Scan recorded: ${result['cylinder']?['serial_number'] ?? ''}'
        : (result['message']?.toString() ?? 'Scan failed');
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
      setState(() => _applyScanResult(result));
    } catch (e) {
      if (!mounted) return;
      setState(() => _message = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _stageLabel(String eventType) {
    for (final stage in _mainStages) {
      if (stage.$1 == eventType) return stage.$2;
    }
    return eventType.replaceAll('_', ' ');
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
                  Text('Lifecycle stage', style: WhatsLipaUi.badgeLabel),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _mainStages.map((stage) {
                      final selected = _eventType == stage.$1;
                      return FilterChip(
                        selected: selected,
                        label: Text(stage.$2),
                        avatar: Icon(stage.$3, size: 18, color: selected ? WhatsLipaBrand.onPrimary : _accent),
                        selectedColor: _accent,
                        checkmarkColor: WhatsLipaBrand.onPrimary,
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: selected ? WhatsLipaBrand.onPrimary : Colors.black87,
                        ),
                        onSelected: _loading
                            ? null
                            : (_) => setState(() {
                                  _eventType = stage.$1;
                                  _showAdvanced = false;
                                }),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: _loading ? null : () => setState(() => _showAdvanced = !_showAdvanced),
                    icon: Icon(_showAdvanced ? Icons.expand_less : Icons.expand_more, size: 20),
                    label: Text(_showAdvanced ? 'Hide advanced events' : 'Advanced events'),
                  ),
                  if (_showAdvanced) ...[
                    DropdownButtonFormField<String>(
                      value: _advancedEvents.contains(_eventType) ? _eventType : _advancedEvents.first,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF4F8F5),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                      ),
                      items: _advancedEvents
                          .map((e) => DropdownMenuItem(value: e, child: Text(e.replaceAll('_', ' '))))
                          .toList(),
                      onChanged: _loading ? null : (v) => setState(() => _eventType = v ?? 'agent_receive'),
                    ),
                    const SizedBox(height: 8),
                  ],
                  if (_lifecycle != null) ...[
                    const SizedBox(height: 12),
                    CylinderLifecyclePanel(lifecycle: _lifecycle),
                    if (_lifecycle?['next_event_type'] != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Suggested next: ${_stageLabel(_lifecycle!['next_event_type'].toString())}',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
                      ),
                    ],
                  ],
                  const SizedBox(height: 16),
                  WhatsLipaQrScanPanel(
                    accentColor: _accent,
                    loading: _loading,
                    onScan: _submitScan,
                    submitLabel: 'Record ${_stageLabel(_eventType)}',
                    title: 'Scan to ${_stageLabel(_eventType).toLowerCase()}',
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
                          if (_lastResult!['cylinder']['lifecycle_stage'] != null)
                            Text('Stage: ${_lastResult!['cylinder']['lifecycle_stage']}'),
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
