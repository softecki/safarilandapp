import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wicom/faidabiz/faidabiz_api.dart';
import 'package:wicom/faidabiz/faidabiz_theme.dart';
import 'package:wicom/faidabiz/screens/activity_screen.dart';
import 'package:wicom/faidabiz/screens/expense_form_screen.dart';
import 'package:wicom/faidabiz/screens/expenses_screen.dart';
import 'package:wicom/faidabiz/screens/product_form_screen.dart';
import 'package:wicom/faidabiz/screens/products_screen.dart';
import 'package:wicom/faidabiz/screens/purchase_form_screen.dart';
import 'package:wicom/faidabiz/screens/reports_screen.dart';
import 'package:wicom/faidabiz/screens/sale_form_screen.dart';
import 'package:wicom/faidabiz/screens/sales_screen.dart';
import 'package:wicom/faidabiz/screens/settings_screen.dart';
import 'package:wicom/faidabiz/widgets/count_up_money_card.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_loader.dart';

/// Home hub with summary cards + feature grid (no bottom navigation).
class FaidaBizHomeScreen extends StatefulWidget {
  const FaidaBizHomeScreen({super.key});

  @override
  State<FaidaBizHomeScreen> createState() => _FaidaBizHomeScreenState();
}

class _FaidaBizHomeScreenState extends State<FaidaBizHomeScreen> {
  Map<String, dynamic>? data;
  String? error;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final res = await FaidaBizApi.get('/home');
      setState(() => data = res);
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> _open(Widget page) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => page));
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final biz = FaidaBizApi.user?['business'] as Map<String, dynamic>?;
    final summary = data?['summary'] as Map<String, dynamic>? ?? {};
    final recent = (data?['recent'] as List?) ?? [];

    final features = [
      _Feature('nav.sales'.tr(), Icons.point_of_sale, FaidaBizTheme.green, () => _open(const FaidaBizSalesScreen())),
      _Feature('nav.expenses'.tr(), Icons.payments, Colors.orange.shade800, () => _open(const FaidaBizExpensesScreen())),
      _Feature('nav.products'.tr(), Icons.inventory_2, FaidaBizTheme.greenDark, () => _open(const FaidaBizProductsScreen())),
      _Feature('nav.reports'.tr(), Icons.bar_chart, FaidaBizTheme.black, () => _open(const FaidaBizReportsScreen())),
      _Feature('home.add_sale'.tr(), Icons.add_shopping_cart, FaidaBizTheme.green, () => _open(const FaidaBizSaleFormScreen())),
      _Feature('home.add_expense'.tr(), Icons.add_card, Colors.orange.shade800, () => _open(const FaidaBizExpenseFormScreen())),
      _Feature('home.add_purchase'.tr(), Icons.add_box, FaidaBizTheme.black, () => _open(const FaidaBizPurchaseFormScreen())),
      _Feature('home.add_product'.tr(), Icons.playlist_add, FaidaBizTheme.greenDark, () => _open(const FaidaBizProductFormScreen())),
      _Feature('settings.activity'.tr(), Icons.history, Colors.blueGrey, () => _open(const FaidaBizActivityScreen())),
      _Feature('nav.settings'.tr(), Icons.settings, Colors.grey.shade800, () => _open(const FaidaBizSettingsScreen())),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('FaidaBiz', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text(biz?['name']?.toString() ?? 'brand.tagline'.tr(), style: const TextStyle(fontSize: 12, color: Colors.white70)),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _load),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => _open(const FaidaBizSettingsScreen()),
          ),
        ],
      ),
      body: loading
          ? FaidaBizLoader.body()
          : error != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(padding: const EdgeInsets.all(16), child: Text(error!, textAlign: TextAlign.center)),
                      TextButton(onPressed: _load, child: Text('common.retry'.tr())),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Text('home.question'.tr(), style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text('home.today'.tr(), style: TextStyle(color: Colors.grey.shade700)),
                      const SizedBox(height: 14),
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 1.35,
                        children: [
                          CountUpMoneyCard(
                            label: 'home.sales'.tr(),
                            value: summary['sales'] ?? 0,
                            color: FaidaBizTheme.green,
                            icon: Icons.trending_up,
                          ),
                          CountUpMoneyCard(
                            label: 'home.expenses'.tr(),
                            value: summary['expenses'] ?? 0,
                            color: Colors.orange.shade800,
                            icon: Icons.payments_outlined,
                            delay: const Duration(milliseconds: 150),
                          ),
                          CountUpMoneyCard(
                            label: 'home.purchases'.tr(),
                            value: summary['purchases'] ?? 0,
                            color: FaidaBizTheme.black,
                            icon: Icons.shopping_bag_outlined,
                            delay: const Duration(milliseconds: 250),
                          ),
                          CountUpMoneyCard(
                            label: 'home.profit'.tr(),
                            value: summary['profit'] ?? 0,
                            color: FaidaBizTheme.greenDark,
                            icon: Icons.savings_outlined,
                            delay: const Duration(milliseconds: 350),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),
                      Text('home.features'.tr(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 10),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: features.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 1.25,
                        ),
                        itemBuilder: (_, i) => _FeatureTile(feature: features[i]),
                      ),
                      if (recent.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        Text('home.recent'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        ...recent.take(8).map((r) {
                          final m = r as Map<String, dynamic>;
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(m['title']?.toString() ?? ''),
                            subtitle: Text(m['occurred_at']?.toString() ?? ''),
                            trailing: m['amount'] != null
                                ? Text(FaidaBizTheme.money(m['amount']), style: const TextStyle(fontWeight: FontWeight.w600))
                                : null,
                          );
                        }),
                      ],
                    ],
                  ),
                ),
    );
  }
}

class _Feature {
  _Feature(this.label, this.icon, this.color, this.onTap);
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
}

class _FeatureTile extends StatefulWidget {
  const _FeatureTile({required this.feature});
  final _Feature feature;

  @override
  State<_FeatureTile> createState() => _FeatureTileState();
}

class _FeatureTileState extends State<_FeatureTile> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 450))..forward();
  late final Animation<double> _fade = CurvedAnimation(parent: _c, curve: Curves.easeOut);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final f = widget.feature;
    return FadeTransition(
      opacity: _fade,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: f.onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: f.color.withOpacity(0.18)),
              boxShadow: [
                BoxShadow(color: f.color.withOpacity(0.08), blurRadius: 14, offset: const Offset(0, 5)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: f.color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(f.icon, color: f.color),
                ),
                const SizedBox(height: 12),
                Text(
                  f.label.replaceFirst('+ ', ''),
                  style: TextStyle(fontWeight: FontWeight.w700, color: f.color, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
