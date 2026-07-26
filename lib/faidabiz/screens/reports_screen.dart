import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wicom/faidabiz/faidabiz_api.dart';
import 'package:wicom/faidabiz/faidabiz_report_pdf.dart';
import 'package:wicom/faidabiz/faidabiz_theme.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_chrome.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_loader.dart';

class FaidaBizReportsScreen extends StatefulWidget {
  const FaidaBizReportsScreen({super.key});

  @override
  State<FaidaBizReportsScreen> createState() => _FaidaBizReportsScreenState();
}

class _FaidaBizReportsScreenState extends State<FaidaBizReportsScreen> {
  static const _types = ['sales', 'expenses', 'purchases', 'profit', 'debts', 'products', 'future_profit'];

  String reportType = 'profit';
  late DateTime startDate;
  late DateTime endDate;
  Map<String, dynamic>? payload;
  bool loading = false;
  bool exporting = false;
  String? error;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    // Default: current month (1st → today)
    startDate = DateTime(now.year, now.month, 1);
    endDate = DateTime(now.year, now.month, now.day);
    _load();
  }

  String get _dateFmt => 'yyyy-MM-dd';

  Future<void> _pickDate({required bool isStart}) async {
    final initial = isStart ? startDate : endDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked == null) return;
    setState(() {
      if (isStart) {
        startDate = picked;
        if (startDate.isAfter(endDate)) endDate = startDate;
      } else {
        endDate = picked;
        if (endDate.isBefore(startDate)) startDate = endDate;
      }
    });
  }

  Future<void> _load() async {
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final res = await FaidaBizApi.get('/reports', query: {
        'type': reportType,
        'start_date': DateFormat(_dateFmt).format(startDate),
        'end_date': DateFormat(_dateFmt).format(endDate),
      });
      if (!mounted) return;
      setState(() => payload = res);
    } catch (e) {
      if (!mounted) return;
      setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Map<String, dynamic>? get _report => payload?['report'] as Map<String, dynamic>?;
  String get _currency => payload?['business']?['currency']?.toString() ?? 'TZS';
  String get _businessName {
    final fromPayload = payload?['business']?['name']?.toString().trim();
    if (fromPayload != null && fromPayload.isNotEmpty) return fromPayload;
    final fromUser = FaidaBizApi.user?['business']?['name']?.toString().trim();
    if (fromUser != null && fromUser.isNotEmpty) return fromUser;
    return 'FaidaBiz';
  }

  Future<void> _exportPdf({required bool share}) async {
    final report = _report;
    if (report == null) return;
    setState(() => exporting = true);
    try {
      final bytes = await FaidaBizReportPdf.build(
        businessName: _businessName,
        report: report,
        currency: _currency,
      );
      final name = reportPdfFilename(reportType, startDate, endDate);
      if (share) {
        await FaidaBizReportPdf.sharePdf(bytes, name);
      } else {
        await FaidaBizReportPdf.downloadOrShare(bytes, name);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => exporting = false);
    }
  }

  String _typeLabel(String type) => 'reports.types.$type'.tr();

  String _periodLabel() {
    final from = DateFormat.yMMMd().format(startDate);
    final to = DateFormat.yMMMd().format(endDate);
    return '${'reports.period'.tr()}: $from — $to';
  }

  @override
  Widget build(BuildContext context) {
    final report = _report;
    final summary = report?['summary'] as Map<String, dynamic>? ?? {};

    return Scaffold(
      appBar: faidaBizAppBar(title: 'nav.reports'.tr()),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [FaidaBizTheme.green, FaidaBizTheme.greenDark]),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('reports.hero_title'.tr(), style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(_businessName, style: TextStyle(color: Colors.white.withValues(alpha: 0.9))),
              ],
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: reportType,
            isExpanded: true,
            decoration: InputDecoration(
              labelText: 'reports.type'.tr(),
              border: const OutlineInputBorder(),
            ),
            items: _types
                .map((t) => DropdownMenuItem(value: t, child: Text(_typeLabel(t), overflow: TextOverflow.ellipsis)))
                .toList(),
            onChanged: (v) {
              if (v == null) return;
              setState(() => reportType = v);
            },
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _pickDate(isStart: true),
                  icon: const Icon(Icons.calendar_today, size: 18),
                  label: Text('${'reports.start_date'.tr()}\n${DateFormat.yMMMd().format(startDate)}', textAlign: TextAlign.center),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _pickDate(isStart: false),
                  icon: const Icon(Icons.event, size: 18),
                  label: Text('${'reports.end_date'.tr()}\n${DateFormat.yMMMd().format(endDate)}', textAlign: TextAlign.center),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: loading ? null : _load,
            style: FilledButton.styleFrom(
              backgroundColor: FaidaBizTheme.green,
              minimumSize: const Size.fromHeight(48),
            ),
            icon: loading
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.analytics_outlined),
            label: Text('reports.generate'.tr()),
          ),
          if (error != null) ...[
            const SizedBox(height: 12),
            Text(error!, style: const TextStyle(color: Colors.red)),
          ],
          const SizedBox(height: 20),
          if (loading)
            FaidaBizLoader.body()
          else if (report == null)
            Text('reports.empty'.tr())
          else ...[
            Text(_typeLabel(reportType), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            if (reportType == 'future_profit')
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text('reports.future_profit_note'.tr(), style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
              ),
            const SizedBox(height: 8),
            Text(_periodLabel(), style: TextStyle(color: Colors.grey.shade600)),
            const SizedBox(height: 16),
            _SummaryChips(summary: summary, currency: _currency),
            const SizedBox(height: 16),
            _ReportBody(type: reportType, report: report, currency: _currency),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: exporting ? null : () => _exportPdf(share: false),
              style: FilledButton.styleFrom(
                backgroundColor: FaidaBizTheme.green,
                minimumSize: const Size.fromHeight(48),
              ),
              icon: exporting
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.download),
              label: Text('reports.download_pdf'.tr().toUpperCase()),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: exporting ? null : () => _exportPdf(share: true),
              style: OutlinedButton.styleFrom(
                foregroundColor: FaidaBizTheme.green,
                side: const BorderSide(color: FaidaBizTheme.green, width: 1.5),
                minimumSize: const Size.fromHeight(48),
              ),
              icon: const Icon(Icons.share),
              label: Text('reports.share_pdf'.tr().toUpperCase()),
            ),
          ],
        ],
      ),
    );
  }
}

class _SummaryChips extends StatelessWidget {
  const _SummaryChips({required this.summary, required this.currency});

  final Map<String, dynamic> summary;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final chips = <Widget>[];
    void addChip(String label, dynamic value, {bool asMoney = false}) {
      if (value == null) return;
      final display = asMoney ? FaidaBizTheme.money(value, currency: currency) : value.toString();
      if (display.trim().isEmpty || display == 'null') return;
      chips.add(Chip(
        label: Text('$label: $display'),
        backgroundColor: FaidaBizTheme.green.withValues(alpha: 0.1),
      ));
    }

    addChip('reports.total'.tr(), summary['total'], asMoney: true);
    addChip('reports.count'.tr(), summary['count'] ?? summary['sales_count'] ?? summary['open_count']);
    addChip('reports.sales'.tr(), summary['sales'], asMoney: true);
    addChip('reports.purchases'.tr(), summary['purchases'], asMoney: true);
    addChip('reports.expenses'.tr(), summary['expenses'], asMoney: true);
    addChip(
      'reports.profit_label'.tr(),
      summary['profit'] ?? summary['gross_profit'] ?? summary['total_future_profit'],
      asMoney: true,
    );
    addChip('reports.outstanding'.tr(), summary['outstanding'], asMoney: true);
    addChip('reports.total_revenue'.tr(), summary['total_revenue'], asMoney: true);
    addChip('reports.paid'.tr(), summary['payments_in_period'], asMoney: true);

    if (chips.isEmpty) return const SizedBox.shrink();
    return Wrap(spacing: 8, runSpacing: 8, children: chips);
  }
}

String _safeText(dynamic value, [String? fallback]) {
  final s = value?.toString().trim() ?? '';
  if (s.isEmpty || s == 'null' || s == 'undefined') {
    return fallback ?? '—';
  }
  return s;
}

String _fmtDate(dynamic iso) {
  if (iso == null) return '—';
  try {
    return DateFormat.yMMMd().add_Hm().format(DateTime.parse(iso.toString()).toLocal());
  } catch (_) {
    return _safeText(iso);
  }
}

String _joinParts(List<String?> parts) {
  return parts
      .map((p) => p?.trim() ?? '')
      .where((p) => p.isNotEmpty && p != 'null' && p != '—')
      .join(' · ');
}

class _ReportBody extends StatelessWidget {
  const _ReportBody({required this.type, required this.report, required this.currency});

  final String type;
  final Map<String, dynamic> report;
  final String currency;

  String _money(dynamic v) => FaidaBizTheme.money(v, currency: currency);

  @override
  Widget build(BuildContext context) {
    final rows = (report['rows'] as List?) ?? [];
    if (rows.isEmpty) {
      return Text('reports.empty'.tr(), style: TextStyle(color: Colors.grey.shade600));
    }

    switch (type) {
      case 'profit':
        final s = report['summary'] as Map<String, dynamic>? ?? {};
        final profitRows = [
          {'label': 'reports.sales'.tr(), 'amount': s['sales'] ?? 0},
          {'label': 'reports.gross_profit'.tr(), 'amount': s['gross_profit'] ?? 0},
          {'label': 'reports.purchases'.tr(), 'amount': s['purchases'] ?? 0},
          {'label': 'reports.expenses'.tr(), 'amount': s['expenses'] ?? 0},
          {'label': 'reports.profit_label'.tr(), 'amount': s['profit'] ?? 0, 'highlight': true},
        ];
        return Column(
          children: profitRows.map((m) {
            final highlight = m['highlight'] == true;
            return Card(
              child: ListTile(
                title: Text(
                  m['label']!.toString(),
                  style: TextStyle(fontWeight: highlight ? FontWeight.bold : FontWeight.w500),
                ),
                trailing: Text(
                  _money(m['amount']),
                  style: TextStyle(
                    fontWeight: highlight ? FontWeight.bold : FontWeight.w600,
                    color: highlight ? FaidaBizTheme.green : null,
                  ),
                ),
              ),
            );
          }).toList(),
        );
      case 'products':
        return Column(
          children: rows.asMap().entries.map((e) {
            final p = Map<String, dynamic>.from(e.value as Map);
            final name = _safeText(p['name'], 'reports.no_name'.tr());
            final qty = p['quantity'] ?? 0;
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: FaidaBizTheme.green,
                  foregroundColor: Colors.white,
                  child: Text('${e.key + 1}'),
                ),
                title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text('${'reports.qty'.tr()}: $qty · ${'reports.col_profit'.tr()}: ${_money(p['profit'])}'),
                trailing: Text(_money(p['revenue']), style: const TextStyle(fontWeight: FontWeight.w700)),
              ),
            );
          }).toList(),
        );
      case 'future_profit':
        return Column(
          children: rows.map((r) {
            final p = Map<String, dynamic>.from(r as Map);
            final name = _safeText(p['name'], 'reports.no_name'.tr());
            final unit = _safeText(p['unit'], 'pcs');
            final stock = p['stock_qty'] ?? 0;
            return Card(
              child: ListTile(
                title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(
                  '${'reports.col_stock'.tr()}: $stock $unit · ${'reports.margin'.tr()}: ${_money(p['margin_per_unit'])}',
                ),
                trailing: Text(
                  _money(p['future_profit']),
                  style: const TextStyle(fontWeight: FontWeight.bold, color: FaidaBizTheme.green),
                ),
              ),
            );
          }).toList(),
        );
      case 'debts':
        return Column(
          children: rows.map((r) {
            final d = Map<String, dynamic>.from(r as Map);
            final name = _safeText(d['name'], 'reports.no_name'.tr());
            final phone = _safeText(d['phone'], 'reports.no_phone'.tr());
            return Card(
              child: ListTile(
                title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(
                  '$phone · ${'reports.col_owed'.tr()}: ${_money(d['owed'])} · ${'reports.paid'.tr()}: ${_money(d['paid'])}',
                ),
                trailing: Text(
                  _money(d['balance']),
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
                ),
              ),
            );
          }).toList(),
        );
      case 'expenses':
        return Column(
          children: rows.map((r) {
            final e = Map<String, dynamic>.from(r as Map);
            final title = _safeText(e['title'], 'reports.no_name'.tr());
            final category = _safeText(e['category'], 'reports.no_category'.tr());
            final by = e['user_name'] != null && '${e['user_name']}'.trim().isNotEmpty
                ? '${'reports.recorded_by'.tr()} ${_safeText(e['user_name'])}'
                : null;
            return Card(
              child: ListTile(
                title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(_joinParts([category, by, _fmtDate(e['spent_at'])])),
                trailing: Text(_money(e['amount']), style: const TextStyle(fontWeight: FontWeight.w700)),
              ),
            );
          }).toList(),
        );
      case 'purchases':
        return Column(
          children: rows.map((r) {
            final p = Map<String, dynamic>.from(r as Map);
            final items = (p['items'] as List?) ?? [];
            final names = items
                .map((i) => _safeText((i as Map)['product_name']))
                .where((n) => n != '—')
                .join(', ');
            final title = names.isNotEmpty
                ? names
                : 'reports.purchase_n'.tr(args: ['${p['id'] ?? ''}']);
            final supplier = _safeText(p['supplier'], 'reports.no_supplier'.tr());
            final by = p['user_name'] != null && '${p['user_name']}'.trim().isNotEmpty
                ? '${'reports.recorded_by'.tr()} ${_safeText(p['user_name'])}'
                : null;
            return Card(
              child: ListTile(
                title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(_joinParts([supplier, by, _fmtDate(p['purchased_at'])])),
                trailing: Text(_money(p['total']), style: const TextStyle(fontWeight: FontWeight.w700)),
              ),
            );
          }).toList(),
        );
      case 'sales':
      default:
        return Column(
          children: rows.map((r) {
            final s = Map<String, dynamic>.from(r as Map);
            final items = (s['items'] as List?) ?? [];
            final names = items
                .map((i) => _safeText((i as Map)['product_name']))
                .where((n) => n != '—')
                .join(', ');
            final title = names.isNotEmpty
                ? names
                : 'reports.sale_n'.tr(args: ['${s['id'] ?? ''}']);
            final by = s['user_name'] != null && '${s['user_name']}'.trim().isNotEmpty
                ? '${'reports.recorded_by'.tr()} ${_safeText(s['user_name'])}'
                : null;
            final pay = s['payment_method'] != null && '${s['payment_method']}'.trim().isNotEmpty
                ? _safeText(s['payment_method']).toUpperCase()
                : null;
            return Card(
              child: ListTile(
                title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(_joinParts([by, pay, _fmtDate(s['sold_at'])])),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(_money(s['total']), style: const TextStyle(fontWeight: FontWeight.w700)),
                    Text(
                      '${'reports.col_profit'.tr()}: ${_money(s['profit'])}',
                      style: const TextStyle(fontSize: 12, color: FaidaBizTheme.green),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
    }
  }
}
