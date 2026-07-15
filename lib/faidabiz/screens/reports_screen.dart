import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wicom/faidabiz/faidabiz_api.dart';
import 'package:wicom/faidabiz/faidabiz_theme.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_loader.dart';

class FaidaBizReportsScreen extends StatefulWidget {
  const FaidaBizReportsScreen({super.key});

  @override
  State<FaidaBizReportsScreen> createState() => _FaidaBizReportsScreenState();
}

class _FaidaBizReportsScreenState extends State<FaidaBizReportsScreen> {
  String period = 'month';
  Map<String, dynamic>? data;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => loading = true);
    try {
      data = await FaidaBizApi.get('/reports', query: {'period': period});
    } catch (_) {}
    if (mounted) setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final sales = data?['sales_report'] as Map<String, dynamic>? ?? {};
    final top = (data?['top_products'] as List?) ?? [];

    return Scaffold(
      appBar: AppBar(title: Text('nav.reports'.tr())),
      body: loading
          ? FaidaBizLoader.body()
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                SegmentedButton<String>(
                  segments: [
                    ButtonSegment(value: 'today', label: Text('reports.today'.tr())),
                    ButtonSegment(value: 'week', label: Text('reports.week'.tr())),
                    ButtonSegment(value: 'month', label: Text('reports.month'.tr())),
                  ],
                  selected: {period},
                  onSelectionChanged: (s) {
                    period = s.first;
                    _load();
                  },
                ),
                const SizedBox(height: 20),
                Text('reports.sales'.tr(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(FaidaBizTheme.money(sales['sales']), style: const TextStyle(fontSize: 28, color: FaidaBizTheme.green, fontWeight: FontWeight.bold)),
                Text('${'reports.count'.tr()}: ${sales['sales_count'] ?? 0}'),
                const SizedBox(height: 20),
                Text('reports.profit'.tr(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                _row('reports.sales'.tr(), FaidaBizTheme.money(sales['sales'])),
                _row('reports.purchases'.tr(), FaidaBizTheme.money(sales['purchases'])),
                _row('reports.expenses'.tr(), FaidaBizTheme.money(sales['expenses'])),
                _row('reports.profit_label'.tr(), FaidaBizTheme.money(sales['profit']), bold: true),
                const SizedBox(height: 20),
                Text('reports.top'.tr(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ...top.asMap().entries.map((e) {
                  final p = e.value as Map<String, dynamic>;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: FaidaBizTheme.green,
                      foregroundColor: Colors.white,
                      child: Text('${e.key + 1}'),
                    ),
                    title: Text(p['name']?.toString() ?? ''),
                    subtitle: Text('${p['quantity']}'),
                    trailing: Text(FaidaBizTheme.money(p['revenue'])),
                  );
                }),
              ],
            ),
    );
  }

  Widget _row(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
