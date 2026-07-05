import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:wicom/core/cylinder_api.dart';
import 'package:wicom/core/whatslipa_session.dart';
import 'package:wicom/whatslipa/screens/cylinder_scan_screen.dart';
import 'package:wicom/whatslipa/widgets/whatslipa_ui.dart';

class InventoryScanScreen extends StatefulWidget {
  const InventoryScanScreen({super.key});

  @override
  State<InventoryScanScreen> createState() => _InventoryScanScreenState();
}

class _InventoryScanScreenState extends State<InventoryScanScreen> {
  static const _accent = Color(0xFFCA8A04);

  bool _loadingContext = true;
  bool _loadingScan = false;
  String? _error;
  String? _message;
  Map<String, dynamic>? _summary;
  List<dynamic> _stock = [];
  String _mode = 'stock_in';
  final _manualController = TextEditingController();
  bool _useCamera = true;
  Map<String, dynamic>? _lastResult;

  @override
  void initState() {
    super.initState();
    _loadContext();
  }

  @override
  void dispose() {
    _manualController.dispose();
    super.dispose();
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
      setState(() {
        _lastResult = result;
        _message = result['ok'] == true
            ? '${_modeLabel(_mode)} recorded: ${result['cylinder']?['serial_number'] ?? ''}'
            : (result['message']?.toString() ?? 'Scan failed');
      });
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
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'stock_in', label: Text('Stock In'), icon: Icon(Icons.add_box_outlined)),
                      ButtonSegment(value: 'stock_out', label: Text('Stock Out'), icon: Icon(Icons.remove_circle_outline)),
                      ButtonSegment(value: 'review', label: Text('Review'), icon: Icon(Icons.inventory_2_outlined)),
                    ],
                    selected: {_mode},
                    onSelectionChanged: _loadingScan
                        ? null
                        : (values) => setState(() => _mode = values.first),
                  ),
                  const SizedBox(height: 16),
                  if (_mode == 'review') ...[
                    Text('My stock (${_stock.length})', style: WhatsLipaUi.sectionTitle),
                    const SizedBox(height: 10),
                    if (_stock.isEmpty)
                      WhatsLipaEmptyState(
                        icon: Icons.inventory_2_outlined,
                        title: 'No stock yet',
                        message: 'Scanned cylinders assigned to you will appear here.',
                      )
                    else
                      ..._stock.map((item) {
                        final row = item is Map ? Map<String, dynamic>.from(item) : <String, dynamic>{};
                        final cylinder = row['cylinder'] is Map ? row['cylinder'] as Map : row;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: WhatsLipaUi.glassCard(borderTint: _accent),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: _accent.withValues(alpha: 0.12),
                              child: Icon(Icons.propane_tank_outlined, color: _accent),
                            ),
                            title: Text(
                              cylinder['serial_number']?.toString() ?? 'Cylinder',
                              style: const TextStyle(fontWeight: FontWeight.w700),
                            ),
                            subtitle: Text(cylinder['current_status']?.toString() ?? ''),
                          ),
                        );
                      }),
                  ] else
                    WhatsLipaGlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text('Scan to ${_modeLabel(_mode).toLowerCase()}', style: WhatsLipaUi.sectionTitle),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: _loadingScan ? null : () => setState(() => _useCamera = true),
                                  icon: const Icon(Icons.photo_camera_outlined),
                                  label: const Text('Camera'),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: _loadingScan ? null : () => setState(() => _useCamera = false),
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
                                    if (_loadingScan) return;
                                    for (final b in capture.barcodes) {
                                      final raw = b.rawValue;
                                      if (raw != null && raw.isNotEmpty) {
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
                              label: _loadingScan ? 'Processing…' : 'Record ${_modeLabel(_mode)}',
                              loading: _loadingScan,
                              onPressed: _loadingScan ? null : () => _submitScan(_manualController.text),
                            ),
                          ],
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
