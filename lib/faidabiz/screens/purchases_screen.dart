import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wicom/faidabiz/faidabiz_api.dart';
import 'package:wicom/faidabiz/faidabiz_theme.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_chrome.dart';
import 'package:wicom/faidabiz/screens/purchase_detail_screen.dart';
import 'package:wicom/faidabiz/screens/purchase_form_screen.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_loader.dart';

class FaidaBizPurchasesScreen extends StatefulWidget {
  const FaidaBizPurchasesScreen({super.key});

  @override
  State<FaidaBizPurchasesScreen> createState() => _FaidaBizPurchasesScreenState();
}

class _FaidaBizPurchasesScreenState extends State<FaidaBizPurchasesScreen> {
  List items = [];
  bool loading = true;

  double get _total {
    var sum = 0.0;
    for (final raw in items) {
      final p = raw as Map<String, dynamic>;
      sum += FaidaBizTheme.asDouble(p['total']);
    }
    return sum;
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => loading = true);
    try {
      final res = await FaidaBizApi.get('/purchases');
      final page = res['data'] as Map<String, dynamic>?;
      items = (page?['data'] as List?) ?? (res['data'] is List ? res['data'] as List : []);
    } catch (_) {}
    if (mounted) setState(() => loading = false);
  }

  String _dayLabel(String? raw) {
    if (raw == null || raw.isEmpty) return '—';
    final dt = DateTime.tryParse(raw);
    if (dt == null) return raw;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(dt.year, dt.month, dt.day);
    if (day == today) return 'home.filter_today'.tr();
    if (day == today.subtract(const Duration(days: 1))) return 'home.filter_yesterday'.tr();
    return DateFormat('d MMM yyyy').format(dt);
  }

  String _itemsLabel(Map<String, dynamic> purchase) {
    final lines = (purchase['items'] as List?) ?? [];
    if (lines.isEmpty) return '#${purchase['id']}';
    return lines.map((e) => (e as Map)['product_name']?.toString() ?? '').where((s) => s.isNotEmpty).join(', ');
  }

  Future<void> _openDetail(Map<String, dynamic> purchase) async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => FaidaBizPurchaseDetailScreen(purchase: purchase)),
    );
    if (changed == true) _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7F4),
      appBar: faidaBizAppBar(
        title: 'nav.purchases'.tr(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: FaidaBizTheme.green,
        foregroundColor: Colors.white,
        onPressed: () async {
          final ok = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (_) => const FaidaBizPurchaseFormScreen()),
          );
          if (ok == true || ok == null) _load();
        },
        icon: const Icon(Icons.add),
        label: Text('home.add_purchase'.tr()),
      ),
      body: loading
          ? FaidaBizLoader.body()
          : RefreshIndicator(
              color: FaidaBizTheme.green,
              onRefresh: _load,
              child: items.isEmpty
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        const SizedBox(height: 80),
                        Center(child: Text('purchases.empty'.tr(), style: TextStyle(color: Colors.grey.shade600))),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
                      itemCount: items.length + 1,
                      itemBuilder: (_, i) {
                        if (i == 0) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 14),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [FaidaBizTheme.green, FaidaBizTheme.greenDark]),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('purchases.list_total'.tr(), style: TextStyle(color: Colors.white.withValues(alpha: 0.9))),
                                const SizedBox(height: 4),
                                Text(FaidaBizTheme.money(_total), style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                                Text('purchases.list_count'.tr(args: ['${items.length}']), style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 13)),
                              ],
                            ),
                          );
                        }
                        final p = items[i - 1] as Map<String, dynamic>;
                        final usedSales = FaidaBizTheme.asDouble(p['used_sales_amount']);
                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          child: ListTile(
                            onTap: () => _openDetail(p),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            title: Text(_itemsLabel(p), maxLines: 2, overflow: TextOverflow.ellipsis),
                            subtitle: Text(
                              [
                                _dayLabel(p['purchased_at']?.toString()),
                                if ((p['supplier']?.toString() ?? '').isNotEmpty) p['supplier'].toString(),
                                if (usedSales > 0) '${'form.used_sales_amount'.tr()}: ${FaidaBizTheme.money(usedSales)}',
                              ].join(' · '),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  FaidaBizTheme.money(p['total']),
                                  style: const TextStyle(fontWeight: FontWeight.w800, color: FaidaBizTheme.greenDark),
                                ),
                                const SizedBox(width: 4),
                                Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
