import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wicom/faidabiz/faidabiz_api.dart';
import 'package:wicom/faidabiz/faidabiz_theme.dart';
import 'package:wicom/faidabiz/screens/activity_screen.dart';
import 'package:wicom/faidabiz/screens/debts_screen.dart';
import 'package:wicom/faidabiz/screens/expenses_screen.dart';
import 'package:wicom/faidabiz/screens/products_screen.dart';
import 'package:wicom/faidabiz/screens/purchases_screen.dart';
import 'package:wicom/faidabiz/screens/reports_screen.dart';
import 'package:wicom/faidabiz/screens/sales_screen.dart';
import 'package:wicom/faidabiz/screens/settings_screen.dart';
import 'package:wicom/faidabiz/screens/subscription_screen.dart';
import 'package:wicom/faidabiz/widgets/count_up_money_card.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_date_filter.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_loader.dart';

/// Home hub with summary cards + feature grid (no bottom navigation).
class FaidaBizHomeScreen extends StatefulWidget {
  const FaidaBizHomeScreen({super.key});

  @override
  State<FaidaBizHomeScreen> createState() => _FaidaBizHomeScreenState();
}

class _FaidaBizHomeScreenState extends State<FaidaBizHomeScreen> {
  Map<String, dynamic>? data;
  Map<String, dynamic>? subscription;
  String? error;
  bool loading = true;
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    final n = DateTime.now();
    selectedDate = DateTime(n.year, n.month, n.day);
    _load();
  }

  bool get _isToday {
    final n = DateTime.now();
    return selectedDate.year == n.year && selectedDate.month == n.month && selectedDate.day == n.day;
  }

  Future<void> _load() async {
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final home = await FaidaBizApi.get('/home', query: {'date': faidaBizDateQuery(selectedDate)});
      Map<String, dynamic> subRes = {};
      try {
        subRes = await FaidaBizApi.get('/subscription');
      } catch (_) {}
      setState(() {
        data = home;
        subscription = subRes['subscription'] as Map<String, dynamic>?;
      });
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

  void _onDateChanged(DateTime d) {
    setState(() => selectedDate = d);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final biz = FaidaBizApi.user?['business'] as Map<String, dynamic>?;
    final summary = data?['summary'] as Map<String, dynamic>? ?? {};
    final recent = (data?['recent'] as List?) ?? [];
    final question = 'home.question'.tr();

    final summaryLabel = _isToday
        ? 'home.today'.tr()
        : 'home.summary_for'.tr(args: [DateFormat('EEE, d MMM yyyy').format(selectedDate)]);

    final features = [
      _Feature('nav.sales'.tr(), Icons.point_of_sale, FaidaBizTheme.green, () => _open(const FaidaBizSalesScreen())),
      _Feature('nav.debts'.tr(), Icons.handshake_outlined, Colors.orange.shade800, () => _open(const FaidaBizDebtsScreen())),
      _Feature('nav.expenses'.tr(), Icons.payments, Colors.deepOrange.shade700, () => _open(const FaidaBizExpensesScreen())),
      _Feature('nav.products'.tr(), Icons.inventory_2, FaidaBizTheme.greenDark, () => _open(const FaidaBizProductsScreen())),
      _Feature('nav.purchases'.tr(), Icons.shopping_bag_outlined, FaidaBizTheme.black, () => _open(const FaidaBizPurchasesScreen())),
      _Feature('nav.reports'.tr(), Icons.bar_chart, FaidaBizTheme.black, () => _open(const FaidaBizReportsScreen())),
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
          if (subscription != null)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Center(
                child: InkWell(
                  onTap: () => _open(const FaidaBizSubscriptionScreen()),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white54),
                    ),
                    child: Text(
                      subscription!['label']?.toString() ?? 'subscription.status'.tr(),
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
            ),
          IconButton(icon: const Icon(Icons.refresh), onPressed: _load),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => _open(const FaidaBizSettingsScreen()),
          ),
        ],
      ),
      body: loading && data == null
          ? FaidaBizLoader.body()
          : error != null && data == null
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
                      Text(question, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      FaidaBizDateFilter(selected: selectedDate, onChanged: _onDateChanged),
                      const SizedBox(height: 10),
                      Text(summaryLabel, style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w600)),
                      if (loading) ...[
                        const SizedBox(height: 12),
                        const LinearProgressIndicator(
                          minHeight: 2,
                          color: FaidaBizTheme.green,
                          backgroundColor: Color(0xFFE8F5EC),
                        ),
                      ],
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
                            label: _isToday ? 'home.sales'.tr() : 'home.sales_day'.tr(),
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
                      if (FaidaBizTheme.asDouble(summary['debts_outstanding']) > 0) ...[
                        const SizedBox(height: 12),
                        Material(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(14),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: () => _open(const FaidaBizDebtsScreen()),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              child: Row(
                                children: [
                                  Icon(Icons.handshake_outlined, color: Colors.orange.shade900),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      '${'debts.outstanding'.tr()}: ${FaidaBizTheme.money(summary['debts_outstanding'])}',
                                      style: TextStyle(fontWeight: FontWeight.w700, color: Colors.orange.shade900),
                                    ),
                                  ),
                                  Icon(Icons.chevron_right, color: Colors.orange.shade900),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 12),
                      Material(
                        color: const Color(0xFFE8F5EC),
                        borderRadius: BorderRadius.circular(14),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: () => _open(FaidaBizActivityScreen(initialDate: selectedDate)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            child: Row(
                              children: [
                                const Icon(Icons.history_rounded, color: FaidaBizTheme.greenDark),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    recent.isEmpty
                                        ? 'home.recent'.tr()
                                        : '${'home.recent'.tr()}: ${recent.length}',
                                    style: const TextStyle(fontWeight: FontWeight.w700, color: FaidaBizTheme.greenDark),
                                  ),
                                ),
                                const Icon(Icons.chevron_right, color: FaidaBizTheme.greenDark),
                              ],
                            ),
                          ),
                        ),
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
                    ],
                  ),
                ),
    );
  }
}

class _Feature {
  _Feature(this.label, this.icon, this.color, this.onTap, {this.badge = 0});
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final int badge;
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
              border: Border.all(color: f.color.withValues(alpha: 0.18)),
              boxShadow: [
                BoxShadow(color: f.color.withValues(alpha: 0.08), blurRadius: 14, offset: const Offset(0, 5)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: f.color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(f.icon, color: f.color),
                    ),
                    if (f.badge > 0)
                      Positioned(
                        right: -6,
                        top: -6,
                        child: Container(
                          constraints: const BoxConstraints(minWidth: 20),
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE53935),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                          child: Text(
                            f.badge > 99 ? '99+' : '${f.badge}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                  ],
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
