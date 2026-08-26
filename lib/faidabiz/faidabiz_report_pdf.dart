import 'package:easy_localization/easy_localization.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/foundation.dart';
import 'package:wicom/faidabiz/faidabiz_pdf_download_stub.dart'
    if (dart.library.html) 'package:wicom/faidabiz/faidabiz_pdf_download_web.dart'
    if (dart.library.io) 'package:wicom/faidabiz/faidabiz_pdf_download_io.dart';

class FaidaBizReportPdf {
  static Future<Uint8List> build({
    required String businessName,
    required Map<String, dynamic> report,
    required String currency,
  }) async {
    final doc = pw.Document();
    final type = report['type']?.toString() ?? 'report';
    final title = 'reports.types.$type'.tr();
    final from = report['from']?.toString() ?? '';
    final to = report['to']?.toString() ?? '';
    final summary = report['summary'] as Map<String, dynamic>? ?? {};
    final rows = (report['rows'] as List?) ?? [];
    final money = NumberFormat.currency(symbol: '$currency ', decimalDigits: 0);

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (ctx) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Safari Land Tanzania', style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
            pw.SizedBox(height: 4),
            pw.Text(businessName, style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.Text(title, style: const pw.TextStyle(fontSize: 14)),
            if (from.isNotEmpty) pw.Text('$from — $to', style: const pw.TextStyle(fontSize: 10)),
            pw.Divider(),
          ],
        ),
        footer: (ctx) => pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
            'common.page'.tr(args: ['${ctx.pageNumber}', '${ctx.pagesCount}']),
            style: const pw.TextStyle(fontSize: 9),
          ),
        ),
        build: (ctx) => [
          if (summary.isNotEmpty) ..._summaryBlocks(summary, money),
          pw.SizedBox(height: 12),
          ..._tableForType(type, rows, money),
        ],
      ),
    );

    return doc.save();
  }

  static List<pw.Widget> _summaryBlocks(Map<String, dynamic> summary, NumberFormat money) {
    final lines = <pw.Widget>[];
    summary.forEach((key, value) {
      if (value is num && (key.contains('total') || key.contains('profit') || key.contains('outstanding') || key.contains('revenue') || key.contains('amount') || key == 'sales' || key == 'expenses' || key == 'purchases')) {
        lines.add(pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(_summaryLabel(key)),
            pw.Text(money.format(value)),
          ],
        ));
      } else if (value is num) {
        lines.add(pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(_summaryLabel(key)),
            pw.Text('$value'),
          ],
        ));
      }
    });
    if (lines.isEmpty) return [];
    return [
      pw.Text('common.summary'.tr(), style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      pw.SizedBox(height: 6),
      ...lines,
      pw.SizedBox(height: 8),
    ];
  }

  static String _summaryLabel(String key) {
    final mapped = {
      'total': 'reports.total',
      'count': 'reports.count',
      'sales': 'reports.sales',
      'purchases': 'reports.purchases',
      'expenses': 'reports.expenses',
      'profit': 'reports.profit_label',
      'gross_profit': 'reports.profit_label',
      'outstanding': 'reports.outstanding',
      'total_revenue': 'reports.total_revenue',
      'total_future_profit': 'reports.profit_label',
      'sales_count': 'reports.count',
      'open_count': 'reports.count',
    };
    final k = mapped[key];
    if (k != null) return k.tr();
    return key.replaceAll('_', ' ');
  }

  static String _cell(dynamic value, [String fallback = '—']) {
    final s = value?.toString().trim() ?? '';
    if (s.isEmpty || s == 'null') return fallback;
    return s;
  }

  static List<pw.Widget> _tableForType(String type, List rows, NumberFormat money) {
    if (rows.isEmpty) {
      return [pw.Text('reports.empty'.tr())];
    }

    switch (type) {
      case 'profit':
        // Prefer localized labels (API may still send bilingual strings)
        final localized = <List<String>>[];
        for (final r in rows) {
          final m = Map<String, dynamic>.from(r as Map);
          final raw = m['label']?.toString() ?? '';
          String label;
          if (raw.toLowerCase().contains('gross') || raw.toLowerCase().contains('faida ya mauzo')) {
            label = 'reports.gross_profit'.tr();
          } else if (raw.toLowerCase().contains('purchase') || raw.toLowerCase().contains('manunuzi')) {
            label = 'reports.purchases'.tr();
          } else if (raw.toLowerCase().contains('expense') || raw.toLowerCase().contains('matumizi')) {
            label = 'reports.expenses'.tr();
          } else if (raw.toLowerCase().contains('net') || raw.toLowerCase().contains('halisi')) {
            label = 'reports.profit_label'.tr();
          } else if (raw.toLowerCase().contains('sale') || raw.toLowerCase().contains('mauzo')) {
            label = 'reports.sales'.tr();
          } else {
            label = _cell(raw, 'reports.col_item'.tr());
          }
          localized.add([label, money.format((m['amount'] as num?) ?? 0)]);
        }
        return [
          pw.TableHelper.fromTextArray(
            headers: ['reports.col_item'.tr(), 'reports.col_amount'.tr()],
            data: localized,
          ),
        ];
      case 'products':
        return [
          pw.TableHelper.fromTextArray(
            headers: ['#', 'reports.col_product'.tr(), 'reports.col_qty'.tr(), 'reports.col_revenue'.tr(), 'reports.col_profit'.tr()],
            data: rows.asMap().entries.map((e) {
              final m = Map<String, dynamic>.from(e.value as Map);
              return [
                '${e.key + 1}',
                _cell(m['name'], 'reports.no_name'.tr()),
                '${m['quantity'] ?? 0}',
                money.format((m['revenue'] as num?) ?? 0),
                money.format((m['profit'] as num?) ?? 0),
              ];
            }).toList(),
          ),
        ];
      case 'future_profit':
        return [
          pw.TableHelper.fromTextArray(
            headers: [
              'reports.col_product'.tr(),
              'reports.col_stock'.tr(),
              'reports.col_buy'.tr(),
              'reports.col_sell'.tr(),
              'reports.col_future_profit'.tr(),
            ],
            data: rows.map((r) {
              final m = Map<String, dynamic>.from(r as Map);
              final unit = _cell(m['unit'], 'pcs');
              return [
                _cell(m['name'], 'reports.no_name'.tr()),
                '${m['stock_qty'] ?? 0} $unit',
                money.format((m['buy_price'] as num?) ?? 0),
                money.format((m['sell_price'] as num?) ?? 0),
                money.format((m['future_profit'] as num?) ?? 0),
              ];
            }).toList(),
          ),
        ];
      case 'debts':
        return [
          pw.TableHelper.fromTextArray(
            headers: [
              'reports.col_customer'.tr(),
              'reports.col_owed'.tr(),
              'reports.col_paid'.tr(),
              'reports.col_balance'.tr(),
            ],
            data: rows.map((r) {
              final m = Map<String, dynamic>.from(r as Map);
              return [
                _cell(m['name'], 'reports.no_name'.tr()),
                money.format((m['owed'] as num?) ?? 0),
                money.format((m['paid'] as num?) ?? 0),
                money.format((m['balance'] as num?) ?? 0),
              ];
            }).toList(),
          ),
        ];
      case 'expenses':
        return [
          pw.TableHelper.fromTextArray(
            headers: [
              'reports.col_title'.tr(),
              'reports.col_category'.tr(),
              'reports.col_amount'.tr(),
              'reports.col_date'.tr(),
            ],
            data: rows.take(80).map((r) {
              final m = Map<String, dynamic>.from(r as Map);
              return [
                _cell(m['title'], 'reports.no_name'.tr()),
                _cell(m['category'], 'reports.no_category'.tr()),
                money.format((m['amount'] as num?) ?? 0),
                _shortDate(m['spent_at']),
              ];
            }).toList(),
          ),
        ];
      case 'purchases':
        return [
          pw.TableHelper.fromTextArray(
            headers: [
              'reports.col_id'.tr(),
              'reports.col_total'.tr(),
              'reports.col_supplier'.tr(),
              'reports.col_date'.tr(),
            ],
            data: rows.take(80).map((r) {
              final m = Map<String, dynamic>.from(r as Map);
              return [
                '${m['id'] ?? '—'}',
                money.format((m['total'] as num?) ?? 0),
                _cell(m['supplier'], 'reports.no_supplier'.tr()),
                _shortDate(m['purchased_at']),
              ];
            }).toList(),
          ),
        ];
      case 'sales':
      default:
        return [
          pw.TableHelper.fromTextArray(
            headers: [
              'reports.col_id'.tr(),
              'reports.col_total'.tr(),
              'reports.col_profit'.tr(),
              'reports.col_date'.tr(),
            ],
            data: rows.take(80).map((r) {
              final m = Map<String, dynamic>.from(r as Map);
              return [
                '${m['id'] ?? '—'}',
                money.format((m['total'] as num?) ?? 0),
                money.format((m['profit'] as num?) ?? 0),
                _shortDate(m['sold_at']),
              ];
            }).toList(),
          ),
        ];
    }
  }

  static String _shortDate(dynamic iso) {
    if (iso == null) return '—';
    try {
      return DateFormat('yyyy-MM-dd').format(DateTime.parse(iso.toString()));
    } catch (_) {
      return _cell(iso);
    }
  }

  static Future<void> sharePdf(Uint8List bytes, String filename) async {
    await downloadPdfBytes(bytes, filename);
  }

  static Future<void> downloadOrShare(Uint8List bytes, String filename) async {
    await downloadPdfBytes(bytes, filename);
  }
}

String reportPdfFilename(String type, DateTime from, DateTime to) {
  final f = DateFormat('yyyyMMdd').format(from);
  final t = DateFormat('yyyyMMdd').format(to);
  return 'faidabiz_${type}_${f}_$t.pdf';
}
