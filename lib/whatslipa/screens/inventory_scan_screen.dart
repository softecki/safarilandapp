import 'package:flutter/material.dart';
import 'package:wicom/core/app_color.dart';
import 'package:wicom/core/cylinder_api.dart';
import 'package:wicom/core/whatslipa_brand.dart';
import 'package:wicom/core/whatslipa_session.dart';
import 'package:wicom/whatslipa/screens/cylinder_scan_screen.dart';
import 'package:wicom/whatslipa/widgets/cylinder_lifecycle_panel.dart';
import 'package:wicom/whatslipa/widgets/whatslipa_branded_loader.dart';
import 'package:wicom/whatslipa/widgets/whatslipa_qr_scan_panel.dart';
import 'package:wicom/whatslipa/widgets/whatslipa_scan_result_dialog.dart';
import 'package:wicom/whatslipa/widgets/whatslipa_ui.dart';

enum _QrPayloadType { cylinder, valveSeal }

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
  String? _pendingCylinderPayload;
  String? _pendingCylinderLabel;

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
        throw Exception(
            'No organization selected. Sign out and sign in again.');
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

  Future<void> _showScanPopup({
    required String message,
    required bool success,
    String? detail,
  }) {
    return showWhatsLipaScanResultDialog(
      context: context,
      message: message,
      success: success,
      detail: detail,
      accentColor: _accent,
    );
  }

  Future<void> _submitScan(String payload) async {
    if (payload.trim().isEmpty || _mode == 'review') return;
    final trimmed = payload.trim();
    final payloadType = _detectPayloadType(trimmed);

    if (_mode == 'stock_in') {
      if (_pendingCylinderPayload == null) {
        if (payloadType == _QrPayloadType.valveSeal) {
          await _showScanPopup(
            success: false,
            message: 'Scan cylinder QR first.',
            detail: 'Inventory in requires cylinder QR then valve seal QR.',
          );
          return;
        }
        setState(() {
          _pendingCylinderPayload = trimmed;
          _pendingCylinderLabel = _extractCylinderLabel(trimmed);
          _message =
              'Cylinder captured. Now scan valve seal QR to complete inventory in.';
        });
        await _showScanPopup(
          success: true,
          message: 'Cylinder captured successfully.',
          detail: 'Now scan the valve seal QR for inventory-in.',
        );
        return;
      }

      if (payloadType == _QrPayloadType.cylinder) {
        setState(() {
          _pendingCylinderPayload = trimmed;
          _pendingCylinderLabel = _extractCylinderLabel(trimmed);
          _message =
              'Cylinder updated. Now scan valve seal QR to complete inventory in.';
        });
        await _showScanPopup(
          success: true,
          message: 'Cylinder updated.',
          detail: 'Now scan the valve seal QR.',
        );
        return;
      }
    } else if (_mode != 'return_empty' &&
        payloadType == _QrPayloadType.cylinder) {
      await _showScanPopup(
        success: false,
        message: 'Scan valve seal QR for this action.',
        detail:
            'For ${_modeLabel(_mode).toLowerCase()}, use valve seal QR only.',
      );
      return;
    }

    setState(() {
      _loadingScan = true;
      _message = null;
    });
    try {
      final result = await CylinderApi.scan(
        qrPayload:
            _mode == 'stock_in' ? _pendingCylinderPayload ?? trimmed : trimmed,
        secondaryQrPayload: _mode == 'stock_in' ? trimmed : null,
        eventType: _mode,
        clientNonce: DateTime.now().millisecondsSinceEpoch.toString(),
      );
      if (!mounted) return;
      setState(() => _applyScanResult(result));
      if (_mode == 'stock_in') {
        setState(() {
          _pendingCylinderPayload = null;
          _pendingCylinderLabel = null;
        });
      }
      final ok = result['ok'] == true;
      final serial = result['cylinder']?['serial_number']?.toString();
      final status = result['cylinder']?['current_status']?.toString();
      final sealCode = result['seal_code']?.toString();
      await _showScanPopup(
        success: ok,
        message: _message ?? (ok ? 'Scan recorded' : 'Scan failed'),
        detail: [
          if (serial != null && serial.isNotEmpty) 'Serial: $serial',
          if (status != null && status.isNotEmpty) 'Status: $status',
          if (sealCode != null && sealCode.isNotEmpty) 'Seal: $sealCode',
          'Action: ${_modeLabel(_mode)}',
        ].join('\n'),
      );
      await _loadContext();
    } catch (e) {
      if (!mounted) return;
      setState(() => _message = e.toString());
      await _showScanPopup(success: false, message: e.toString());
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

  _QrPayloadType _detectPayloadType(String payload) {
    final value = payload.trim();
    if (RegExp(r'/qr/seal/', caseSensitive: false).hasMatch(value) ||
        RegExp(r'^VS-[A-Z0-9\-]+$', caseSensitive: false).hasMatch(value)) {
      return _QrPayloadType.valveSeal;
    }
    return _QrPayloadType.cylinder;
  }

  String _extractCylinderLabel(String payload) {
    final value = payload.trim();
    final serialMatch = RegExp(r'/qr/cylinder/([^/?#]+)', caseSensitive: false)
        .firstMatch(value);
    if (serialMatch != null && serialMatch.groupCount > 0) {
      return serialMatch.group(1) ?? 'Cylinder';
    }
    return value.length > 28 ? '${value.substring(0, 28)}…' : value;
  }

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
              MaterialPageRoute<void>(
                  builder: (_) => const CylinderScanScreen()),
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
            ? const Center(
                child: WhatsLipaBrandedLoaderPanel(
                  message: 'Loading inventory…',
                  compact: true,
                  showLogo: true,
                ),
              )
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (_error != null)
                    WhatsLipaGlassCard(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      child: Text(_error!,
                          style: TextStyle(color: Colors.red.shade800)),
                    ),
                  FutureBuilder<String?>(
                    future: WhatsLipaSession.tenantName,
                    builder: (context, snap) {
                      final org = snap.data;
                      if (org == null || org.isEmpty)
                        return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          org,
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: _accent.withValues(alpha: 0.9)),
                        ),
                      );
                    },
                  ),
                  if (_summary != null)
                    _SummaryCard(summary: _summary!, accent: _accent),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _scanModes.map((mode) {
                      final selected = _mode == mode.$1;
                      return FilterChip(
                        selected: selected,
                        label: Text(mode.$2),
                        avatar: Icon(mode.$3,
                            size: 18,
                            color:
                                selected ? WhatsLipaBrand.onPrimary : _accent),
                        selectedColor: _accent,
                        checkmarkColor: WhatsLipaBrand.onPrimary,
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: selected
                              ? WhatsLipaBrand.onPrimary
                              : Colors.black87,
                        ),
                        onSelected: _loadingScan
                            ? null
                            : (_) => setState(() {
                                  _mode = mode.$1;
                                  _pendingCylinderPayload = null;
                                  _pendingCylinderLabel = null;
                                }),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  if (_mode == 'review') ...[
                    Text('My stock (${_stock.length})',
                        style: WhatsLipaUi.sectionTitle),
                    const SizedBox(height: 10),
                    if (_stock.isEmpty)
                      const WhatsLipaEmptyState(
                        icon: Icons.inventory_2_outlined,
                        title: 'No stock yet',
                        message:
                            'Scanned cylinders assigned to you will appear here.',
                      )
                    else
                      ..._stock.map((item) {
                        final row = item is Map
                            ? Map<String, dynamic>.from(item)
                            : <String, dynamic>{};
                        final cylinder = row['cylinder'] is Map
                            ? row['cylinder'] as Map
                            : row;
                        final lifecycle = cylinder['lifecycle'] is Map
                            ? Map<String, dynamic>.from(
                                cylinder['lifecycle'] as Map)
                            : null;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration:
                              WhatsLipaUi.glassCard(borderTint: _accent),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor:
                                          _accent.withValues(alpha: 0.12),
                                      child: Icon(Icons.propane_tank_outlined,
                                          color: _accent),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            cylinder['serial_number']
                                                    ?.toString() ??
                                                'Cylinder',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Text(cylinder['current_status']
                                                  ?.toString() ??
                                              ''),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                if (lifecycle != null) ...[
                                  const SizedBox(height: 10),
                                  CylinderLifecyclePanel(
                                      lifecycle: lifecycle, compact: true),
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
                            submitLabel: _mode == 'stock_in' &&
                                    _pendingCylinderPayload == null
                                ? 'Scan cylinder first'
                                : 'Record ${_modeLabel(_mode)}',
                            title: _mode == 'stock_in'
                                ? (_pendingCylinderPayload == null
                                    ? 'Scan cylinder QR to start inventory in'
                                    : 'Now scan valve seal QR')
                                : (_mode == 'return_empty'
                                    ? 'Scan cylinder QR to ${_modeLabel(_mode).toLowerCase()}'
                                    : 'Scan valve seal QR to ${_modeLabel(_mode).toLowerCase()}'),
                          ),
                          if (_mode == 'stock_in' &&
                              _pendingCylinderPayload != null) ...[
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: _accent.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: _accent.withValues(alpha: 0.16)),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.check_circle_outline,
                                      color: _accent),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'Cylinder selected: ${_pendingCylinderLabel ?? 'Captured'}\nScan valve seal QR to finish.',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          height: 1.35),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          if (_message != null) ...[
                            const SizedBox(height: 16),
                            Text(
                              _message!,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: _message!.contains('recorded')
                                    ? Colors.green.shade800
                                    : Colors.red.shade800,
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
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w800),
                                  ),
                                  Text(
                                      'Status: ${_lastResult!['cylinder']['current_status']}'),
                                  if (_lastResult!['cylinder']
                                          ['lifecycle_stage'] !=
                                      null)
                                    Text(
                                        'Stage: ${_lastResult!['cylinder']['lifecycle_stage']}'),
                                ],
                              ),
                            ),
                            if (_lifecycle != null) ...[
                              const SizedBox(height: 12),
                              CylinderLifecyclePanel(
                                  lifecycle: _lifecycle,
                                  title: 'Updated journey'),
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

  static const _metricOrder = [
    'total',
    'filled',
    'empty',
    'with_customer',
    'maintenance',
    'decommissioned',
    'recent_scans_24h',
  ];

  static const _metricLabels = {
    'total': 'Total cylinders',
    'filled': 'Filled',
    'empty': 'Empty',
    'with_customer': 'With customer',
    'maintenance': 'In maintenance',
    'decommissioned': 'Decommissioned',
    'recent_scans_24h': 'Scans (24h)',
  };

  static const _statusLabels = {
    'at_depot': 'At depot',
    'with_agent': 'With agent',
    'with_customer': 'With customer',
    'in_transit': 'In transit',
    'maintenance': 'Maintenance',
    'decommissioned': 'Decommissioned',
    'lost': 'Lost',
  };

  @override
  Widget build(BuildContext context) {
    final metrics = _metricOrder
        .where((key) => summary[key] != null)
        .map((key) => MapEntry(key, summary[key]))
        .toList();
    final statusRows = _statusRows();

    if (metrics.isEmpty && statusRows.isEmpty) return const SizedBox.shrink();

    return WhatsLipaGlassCard(
      margin: const EdgeInsets.only(bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Inventory summary', style: WhatsLipaUi.sectionTitle),
          if (metrics.isNotEmpty) ...[
            const SizedBox(height: 14),
            LayoutBuilder(
              builder: (context, constraints) {
                final columns = constraints.maxWidth >= 520 ? 3 : 2;
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: metrics.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: columns == 3 ? 1.55 : 1.45,
                  ),
                  itemBuilder: (context, index) {
                    final entry = metrics[index];
                    return _MetricTile(
                      label: _metricLabels[entry.key] ?? _label(entry.key),
                      value: _formatValue(entry.value),
                      accent: accent,
                    );
                  },
                );
              },
            ),
          ],
          if (statusRows.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text('By status', style: WhatsLipaUi.badgeLabel),
            const SizedBox(height: 10),
            ...statusRows.map(
              (row) => _StatusRow(
                label: row.label,
                value: row.value,
                accent: accent,
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<_StatusEntry> _statusRows() {
    final raw = summary['by_status'];
    if (raw is! Map) return const [];

    final rows = raw.entries
        .map((e) => _StatusEntry(
              label:
                  _statusLabels[e.key.toString()] ?? _label(e.key.toString()),
              value: _formatValue(e.value),
            ))
        .toList()
      ..sort((a, b) => a.label.compareTo(b.label));

    return rows;
  }

  String _label(String key) {
    return key.replaceAll('_', ' ').split(' ').map((part) {
      if (part.isEmpty) return part;
      return '${part[0].toUpperCase()}${part.substring(1)}';
    }).join(' ');
  }

  String _formatValue(dynamic value) {
    if (value == null) return '—';
    if (value is num)
      return value == value.roundToDouble()
          ? '${value.toInt()}'
          : value.toString();
    return value.toString();
  }
}

class _StatusEntry {
  const _StatusEntry({required this.label, required this.value});

  final String label;
  final String value;
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.value,
    required this.accent,
  });

  final String label;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accent.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              height: 1.25,
              color: accent.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              height: 1,
              color: accent.withValues(alpha: 0.98),
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  const _StatusRow({
    required this.label,
    required this.value,
    required this.accent,
  });

  final String label;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accent.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColor.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            constraints: const BoxConstraints(minWidth: 36),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            alignment: Alignment.center,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: accent.withValues(alpha: 0.95),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
