import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wicom/faidabiz/faidabiz_api.dart';
import 'package:wicom/faidabiz/faidabiz_report_pdf.dart';
import 'package:wicom/faidabiz/faidabiz_theme.dart';
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
  String get _businessName =>
      payload?['business']?['name']?.toString() ?? FaidaBizApi.user?['business']?['name']?.toString() ?? 'FaidaBiz';

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

  @override
  Widget build(BuildContext context) {
    final report = _report;
    final summary = report?['summary'] as Map<String, dynamic>? ?? {};

    return Scaffold(
      appBar: AppBar(
        title: Text('nav.reports'.tr()),
        actions: [
          if (report != null)
            IconButton(
              tooltip: 'reports.share_pdf'.tr(),
              onPressed: exporting ? null : () => _exportPdf(share: true),
              icon: exporting
                  ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.share),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
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
            decoration: InputDecoration(
              labelText: 'reports.type'.tr(),
              border: const OutlineInputBorder(),
            ),
            items: _types
                .map((t) => DropdownMenuItem(value: t, child: Text(_typeLabel(t))))
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
          if (report != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: exporting ? null : () => _exportPdf(share: false),
                    icon: const Icon(Icons.download),
                    label: Text('reports.download_pdf'.tr()),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: exporting ? null : () => _exportPdf(share: true),
                    icon: const Icon(Icons.share),
                    label: Text('reports.share_pdf'.tr()),
                  ),
                ),
              ],
            ),
          ],
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
            Text(report['title']?.toString() ?? _typeLabel(reportType),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            if (report['note'] != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(report['note'].toString(), style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
              ),
            const SizedBox(height: 8),
            Text('${report['from']} — ${report['to']}', style: TextStyle(color: Colors.grey.shade600)),
            const SizedBox(height: 16),
            _SummaryChips(summary: summary, currency: _currency, type: reportType),
            const SizedBox(height: 16),
            _ReportBody(type: reportType, report: report, currency: _currency),
          ],
        ],
      ),
    );
  }
}

class _SummaryChips extends StatelessWidget {
  const _SummaryChips({required this.summary, required this.currency, required this.type});

  final Map<String, dynamic> summary;
  final String currency;
  final String type;

  @override
  Widget build(BuildContext context) {
    final chips = <Widget>[];
    void addChip(String label, dynamic value, {bool money = false}) {
      if (value == null) return;
      chips.add(Chip(
        label: Text('$label: ${money ? FaidaBizTheme.money(value) : value}'),
        backgroundColor: FaidaBizTheme.green.withValues(alpha: 0.1),
      ));
    }

    addChip('reports.total'.tr(), summary['total'], money: summary['total'] is num);
    addChip('reports.count'.tr(), summary['count'] ?? summary['sales_count'] ?? summary['open_count']);
    addChip('reports.profit_label'.tr(), summary['profit'] ?? summary['gross_profit'] ?? summary['total_future_profit'], money: true);
    addChip('reports.outstanding'.tr(), summary['outstanding'], money: true);
    addChip('reports.total_revenue'.tr(), summary['total_revenue'], money: true);

    if (chips.isEmpty) return const SizedBox.shrink();
    return Wrap(spacing: 8, runSpacing: 8, children: chips);
  }
}

class _ReportBody extends StatelessWidget {
  const _ReportBody({required this.type, required this.report, required this.currency});

  final String type;
  final Map<String, dynamic> report;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final rows = (report['rows'] as List?) ?? [];
    if (rows.isEmpty) {
      return Text('reports.empty'.tr(), style: TextStyle(color: Colors.grey.shade600));
    }

    switch (type) {
      case 'profit':
        return Column(
          children: rows.map((r) {
            final m = Map<String, dynamic>.from(r as Map);
            final highlight = m['highlight'] == true;
            return Card(
              child: ListTile(
                title: Text(m['label']?.toString() ?? '', style: TextStyle(fontWeight: highlight ? FontWeight.bold : FontWeight.normal)),
                trailing: Text(
                  FaidaBizTheme.money(m['amount']),
                  style: TextStyle(
                    fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
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
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: FaidaBizTheme.green,
                  foregroundColor: Colors.white,
                  child: Text('${e.key + 1}'),
                ),
                title: Text(p['name']?.toString() ?? ''),
                subtitle: Text('${'reports.qty'.tr()}: ${p['quantity']}'),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(FaidaBizTheme.money(p['revenue'])),
                    Text(FaidaBizTheme.money(p['profit']), style: const TextStyle(fontSize: 12, color: FaidaBizTheme.green)),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      case 'future_profit':
        return Column(
          children: rows.map((r) {
            final p = Map<String, dynamic>.from(r as Map);
            return Card(
              child: ListTile(
                title: Text(p['name']?.toString() ?? ''),
                subtitle: Text('${p['stock_qty']} ${p['unit']} · ${'reports.margin'.tr()}: ${FaidaBizTheme.money(p['margin_per_unit'])}'),
                trailing: Text(
                  FaidaBizTheme.money(p['future_profit']),
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
            return Card(
              child: ListTile(
                title: Text(d['name']?.toString() ?? ''),
                subtitle: Text(d['phone']?.toString() ?? ''),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(FaidaBizTheme.money(d['balance']), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
                    Text('${'reports.paid'.tr()}: ${FaidaBizTheme.money(d['paid'])}', style: const TextStyle(fontSize: 11)),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      case 'expenses':
        return Column(
          children: rows.map((r) {
            final e = Map<String, dynamic>.from(r as Map);
            return Card(
              child: ListTile(
                title: Text(e['title']?.toString() ?? ''),
                subtitle: Text([e['category'], e['user_name']].where((x) => x != null && '$x'.isNotEmpty).join(' · ')),
                trailing: Text(FaidaBizTheme.money(e['amount'])),
              ),
            );
          }).toList(),
        );
      case 'purchases':
        return Column(
          children: rows.map((r) {
            final p = Map<String, dynamic>.from(r as Map);
            final items = (p['items'] as List?) ?? [];
            final names = items.map((i) => (i as Map)['product_name']).join(', ');
            return Card(
              child: ListTile(
                title: Text(names.isEmpty ? '#${p['id']}' : names),
                subtitle: Text(p['supplier']?.toString() ?? ''),
                trailing: Text(FaidaBizTheme.money(p['total'])),
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
            final names = items.map((i) => (i as Map)['product_name']).join(', ');
            return Card(
              child: ListTile(
                title: Text(names.isEmpty ? '#${s['id']}' : names),
                subtitle: Text(s['user_name']?.toString() ?? ''),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(FaidaBizTheme.money(s['total'])),
                    Text(FaidaBizTheme.money(s['profit']), style: const TextStyle(fontSize: 12, color: FaidaBizTheme.green)),
                  ],
                ),
              ),
            );
          }).toList(),
        );
    }
  }
}
