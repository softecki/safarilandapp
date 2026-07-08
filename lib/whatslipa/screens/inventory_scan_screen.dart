import 'package:flutter/material.dart';
import 'package:wicom/core/cylinder_api.dart';
import 'package:wicom/core/whatslipa_brand.dart';
import 'package:wicom/core/whatslipa_session.dart';
import 'package:wicom/whatslipa/screens/cylinder_scan_screen.dart';
import 'package:wicom/whatslipa/widgets/cylinder_lifecycle_panel.dart';
import 'package:wicom/whatslipa/widgets/whatslipa_qr_scan_panel.dart';
import 'package:wicom/whatslipa/widgets/whatslipa_ui.dart';

class InventoryScanScreen extends StatefulWidget {
  const InventoryScanScreen({super.key});

  @override
  State<InventoryScanScreen> createState() => _InventoryScanScreenState();
}

class _InventoryScanScreenState extends State<InventoryScanScreen> {
  bool _loadingContext = true;
  bool _loadingScan = false;
  String? _error;
  String? _message;
  Map<String, dynamic>? _summary;
  List<dynamic> _stock = [];
  String _mode = 'stock_in';
  Map<String, dynamic>? _lastResult;
  Map<String, dynamic>? _lifecycle;

  Color get _accent => WhatsLipaBrand.primary;

  static const _scanModes = [
    ('stock_in', 'Stock In', Icons.add_box_outlined),
    ('stock_out', 'Stock Out', Icons.remove_circle_outline),
    ('deliver', 'Delivered', Icons.local_shipping_outlined),
    ('return_empty', 'Returned', Icons.recycling_outlined),
    ('review', 'Review', Icons.inventory_2_outlined),
  ];

  @override
  void initState() {
    super.initState();
    _loadContext();
  }

  Future<void> _loadContext() async {
    setState(() {
      _loadingContext = true;
      _error = null;
    });
    try {
      final slug = await WhatsLipaSession.tenantSlug;
      if (slug == null || slug.isEmpty) {
        throw Exception('No organization selected. Sign out and sign in again.');
      }

      final contextRes = await CylinderApi.scanContext();
      final stockRes = await CylinderApi.myStock();

      if (!mounted) return;
      setState(() {
        _summary = contextRes['summary'] is Map
            ? Map<String, dynamic>.from(contextRes['summary'] as Map)
            : null;
        _stock = stockRes['stock'] is List ? stockRes['stock'] as List : [];
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loadingContext = false);
    }
  }

  void _applyScanResult(Map<String, dynamic> result) {
    _lastResult = result;
    final lifecycleRaw = result['lifecycle'];
    if (lifecycleRaw is Map) {
      _lifecycle = Map<String, dynamic>.from(lifecycleRaw);
      final next = CylinderLifecycleStages.suggestedEventType(_lifecycle);
      if (next != null && _mode != 'review') _mode = next;
    }
    _message = result['ok'] == true
        ? '${_modeLabel(_mode)} recorded: ${result['cylinder']?['serial_number'] ?? ''}'
        : (result['message']?.toString() ?? 'Scan failed');
  }

  Future<void> _submitScan(String payload) async {
    if (payload.trim().isEmpty || _mode == 'review') return;
    setState(() {
      _loadingScan = true;
      _message = null;
    });
    try {
      final result = await CylinderApi.scan(
        qrPayload: payload.trim(),
        eventType: _mode,
        clientNonce: DateTime.now().millisecondsSinceEpoch.toString(),
      );
      if (!mounted) return;
      setState(() => _applyScanResult(result));
      await _loadContext();
    } catch (e) {
      if (!mounted) return;
      setState(() => _message = e.toString());
    } finally {
      if (mounted) setState(() => _loadingScan = false);
    }
  }

  String _modeLabel(String mode) => switch (mode) {
        'stock_in' => 'Stock in',
        'stock_out' => 'Stock out',
        'deliver' => 'Delivered',
        'return_empty' => 'Empty returned',
        _ => mode,
      };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WhatsLipaStyledAppBar(
        title: 'Inventory Scan',
        accentColor: _accent,
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            tooltip: 'Advanced cylinder scan',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (_) => const CylinderScanScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadingContext ? null : _loadContext,
          ),
        ],
      ),
      body: WhatsLipaScreenBackground(
        child: _loadingContext
            ? Center(child: CircularProgressIndicator(color: _accent))
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (_error != null)
                    WhatsLipaGlassCard(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      child: Text(_error!, style: TextStyle(color: Colors.red.shade800)),
                    ),
                  FutureBuilder<String?>(
                    future: WhatsLipaSession.tenantName,
                    builder: (context, snap) {
                      final org = snap.data;
                      if (org == null || org.isEmpty) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          org,
                          style: TextStyle(fontWeight: FontWeight.w700, color: _accent.withValues(alpha: 0.9)),
                        ),
                      );
                    },
                  ),
                  if (_summary != null) _SummaryCard(summary: _summary!, accent: _accent),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _scanModes.map((mode) {
                      final selected = _mode == mode.$1;
                      return FilterChip(
                        selected: selected,
                        label: Text(mode.$2),
                        avatar: Icon(mode.$3, size: 18, color: selected ? WhatsLipaBrand.onPrimary : _accent),
                        selectedColor: _accent,
                        checkmarkColor: WhatsLipaBrand.onPrimary,
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: selected ? WhatsLipaBrand.onPrimary : Colors.black87,
                        ),
                        onSelected: _loadingScan
                            ? null
                            : (_) => setState(() => _mode = mode.$1),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  if (_mode == 'review') ...[
                    Text('My stock (${_stock.length})', style: WhatsLipaUi.sectionTitle),
                    const SizedBox(height: 10),
                    if (_stock.isEmpty)
                      const WhatsLipaEmptyState(
                        icon: Icons.inventory_2_outlined,
                        title: 'No stock yet',
                        message: 'Scanned cylinders assigned to you will appear here.',
                      )
                    else
                      ..._stock.map((item) {
                        final row = item is Map ? Map<String, dynamic>.from(item) : <String, dynamic>{};
                        final cylinder = row['cylinder'] is Map ? row['cylinder'] as Map : row;
                        final lifecycle = cylinder['lifecycle'] is Map
                            ? Map<String, dynamic>.from(cylinder['lifecycle'] as Map)
                            : null;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: WhatsLipaUi.glassCard(borderTint: _accent),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: _accent.withValues(alpha: 0.12),
                                      child: Icon(Icons.propane_tank_outlined, color: _accent),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            cylinder['serial_number']?.toString() ?? 'Cylinder',
                                            style: const TextStyle(fontWeight: FontWeight.w700),
                                          ),
                                          Text(cylinder['current_status']?.toString() ?? ''),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                if (lifecycle != null) ...[
                                  const SizedBox(height: 10),
                                  CylinderLifecyclePanel(lifecycle: lifecycle, compact: true),
                                ],
                              ],
                            ),
                          ),
                        );
                      }),
                  ] else
                    WhatsLipaGlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (_lifecycle != null) ...[
                            CylinderLifecyclePanel(lifecycle: _lifecycle),
                            const SizedBox(height: 16),
                          ],
                          WhatsLipaQrScanPanel(
                            accentColor: _accent,
                            loading: _loadingScan,
                            onScan: _submitScan,
                            submitLabel: 'Record ${_modeLabel(_mode)}',
                            title: 'Scan to ${_modeLabel(_mode).toLowerCase()}',
                          ),
                          if (_message != null) ...[
                            const SizedBox(height: 16),
                            Text(
                              _message!,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: _message!.contains('recorded') ? Colors.green.shade800 : Colors.red.shade800,
                              ),
                            ),
                          ],
                          if (_lastResult?['cylinder'] != null) ...[
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: _accent.withValues(alpha: 0.08),
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
                            if (_lifecycle != null) ...[
                              const SizedBox(height: 12),
                              CylinderLifecyclePanel(lifecycle: _lifecycle, title: 'Updated journey'),
                            ],
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

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.summary, required this.accent});

  final Map<String, dynamic> summary;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final entries = summary.entries.where((e) => e.value != null).toList();
    if (entries.isEmpty) return const SizedBox.shrink();

    return WhatsLipaGlassCard(
      margin: const EdgeInsets.only(bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Inventory summary', style: WhatsLipaUi.sectionTitle),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: entries.map((e) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_label(e.key)}: ${e.value}',
                  style: TextStyle(fontWeight: FontWeight.w700, color: accent.withValues(alpha: 0.95)),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  String _label(String key) => key.replaceAll('_', ' ');
}
