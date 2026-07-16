import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/foundation.dart';

class FaidaBizReportPdf {
  static Future<Uint8List> build({
    required String businessName,
    required Map<String, dynamic> report,
    required String currency,
  }) async {
    final doc = pw.Document();
    final type = report['type']?.toString() ?? 'report';
    final title = report['title']?.toString() ?? type;
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
            pw.Text('FaidaBiz', style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
            pw.SizedBox(height: 4),
            pw.Text(businessName, style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.Text(title, style: const pw.TextStyle(fontSize: 14)),
            if (from.isNotEmpty) pw.Text('$from — $to', style: const pw.TextStyle(fontSize: 10)),
            pw.Divider(),
          ],
        ),
        footer: (ctx) => pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text('Page ${ctx.pageNumber} / ${ctx.pagesCount}', style: const pw.TextStyle(fontSize: 9)),
        ),
        build: (ctx) => [
          if (summary.isNotEmpty) ..._summaryBlocks(summary, money, type),
          pw.SizedBox(height: 12),
          ..._tableForType(type, rows, money),
        ],
      ),
    );

    return doc.save();
  }

  static List<pw.Widget> _summaryBlocks(Map<String, dynamic> summary, NumberFormat money, String type) {
    final lines = <pw.Widget>[];
    summary.forEach((key, value) {
      if (value is num && (key.contains('total') || key.contains('profit') || key.contains('outstanding') || key.contains('revenue') || key.contains('amount') || key == 'sales' || key == 'expenses' || key == 'purchases')) {
        lines.add(pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(key.replaceAll('_', ' ')),
            pw.Text(money.format(value)),
          ],
        ));
      } else if (value is num) {
        lines.add(pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(key.replaceAll('_', ' ')),
            pw.Text('$value'),
          ],
        ));
      }
    });
    if (lines.isEmpty) return [];
    return [pw.Text('Summary', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)), pw.SizedBox(height: 6), ...lines, pw.SizedBox(height: 8)];
  }

  static List<pw.Widget> _tableForType(String type, List rows, NumberFormat money) {
    if (rows.isEmpty) {
      return [pw.Text('No data for this period.')];
    }

    switch (type) {
      case 'profit':
        return [
          pw.TableHelper.fromTextArray(
            headers: ['Item', 'Amount'],
            data: rows.map((r) {
              final m = Map<String, dynamic>.from(r as Map);
              return [m['label']?.toString() ?? '', money.format((m['amount'] as num?) ?? 0)];
            }).toList(),
          ),
        ];
      case 'products':
        return [
          pw.TableHelper.fromTextArray(
            headers: ['#', 'Product', 'Qty', 'Revenue', 'Profit'],
            data: rows.asMap().entries.map((e) {
              final m = Map<String, dynamic>.from(e.value as Map);
              return [
                '${e.key + 1}',
                m['name']?.toString() ?? '',
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
            headers: ['Product', 'Stock', 'Buy', 'Sell', 'Future profit'],
            data: rows.map((r) {
              final m = Map<String, dynamic>.from(r as Map);
              return [
                m['name']?.toString() ?? '',
                '${m['stock_qty'] ?? 0} ${m['unit'] ?? ''}',
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
            headers: ['Customer', 'Owed', 'Paid', 'Balance'],
            data: rows.map((r) {
              final m = Map<String, dynamic>.from(r as Map);
              return [
                m['name']?.toString() ?? '',
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
            headers: ['Title', 'Category', 'Amount', 'Date'],
            data: rows.take(80).map((r) {
              final m = Map<String, dynamic>.from(r as Map);
              return [
                m['title']?.toString() ?? '',
                m['category']?.toString() ?? '',
                money.format((m['amount'] as num?) ?? 0),
                _shortDate(m['spent_at']),
              ];
            }).toList(),
          ),
        ];
      case 'purchases':
        return [
          pw.TableHelper.fromTextArray(
            headers: ['ID', 'Total', 'Supplier', 'Date'],
            data: rows.take(80).map((r) {
              final m = Map<String, dynamic>.from(r as Map);
              return [
                '${m['id'] ?? ''}',
                money.format((m['total'] as num?) ?? 0),
                m['supplier']?.toString() ?? '',
                _shortDate(m['purchased_at']),
              ];
            }).toList(),
          ),
        ];
      case 'sales':
      default:
        return [
          pw.TableHelper.fromTextArray(
            headers: ['ID', 'Total', 'Profit', 'Date'],
            data: rows.take(80).map((r) {
              final m = Map<String, dynamic>.from(r as Map);
              return [
                '${m['id'] ?? ''}',
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
    if (iso == null) return '';
    try {
      return DateFormat('yyyy-MM-dd').format(DateTime.parse(iso.toString()));
    } catch (_) {
      return iso.toString();
    }
  }

  static Future<void> sharePdf(Uint8List bytes, String filename) async {
    await Printing.sharePdf(bytes: bytes, filename: filename);
  }

  static Future<void> downloadOrShare(Uint8List bytes, String filename) async {
    if (kIsWeb) {
      await Printing.sharePdf(bytes: bytes, filename: filename);
      return;
    }
    await sharePdf(bytes, filename);
  }
}

String reportPdfFilename(String type, DateTime from, DateTime to) {
  final f = DateFormat('yyyyMMdd').format(from);
  final t = DateFormat('yyyyMMdd').format(to);
  return 'faidabiz_${type}_${f}_$t.pdf';
}
