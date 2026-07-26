import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wicom/faidabiz/faidabiz_api.dart';
import 'package:wicom/faidabiz/faidabiz_theme.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_chrome.dart';
import 'package:wicom/faidabiz/screens/sale_detail_screen.dart';
import 'package:wicom/faidabiz/screens/sale_form_screen.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_loader.dart';

class FaidaBizSalesScreen extends StatefulWidget {
  const FaidaBizSalesScreen({super.key});

  @override
  State<FaidaBizSalesScreen> createState() => _FaidaBizSalesScreenState();
}

class _FaidaBizSalesScreenState extends State<FaidaBizSalesScreen> {
  List items = [];
  bool loading = true;

  double get _total {
    var sum = 0.0;
    for (final raw in items) {
      final s = raw as Map<String, dynamic>;
      sum += FaidaBizTheme.asDouble(s['total']);
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
      final res = await FaidaBizApi.get('/sales');
      final page = res['data'] as Map<String, dynamic>?;
      items = (page?['data'] as List?) ?? [];
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

  String _timeLabel(String? raw) {
    final dt = DateTime.tryParse(raw ?? '');
    if (dt == null) return '';
    return DateFormat('HH:mm').format(dt);
  }

  Future<void> _openDetail(Map<String, dynamic> sale) async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => FaidaBizSaleDetailScreen(sale: sale)),
    );
    if (changed == true) _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7F4),
      appBar: faidaBizAppBar(
        title: 'nav.sales'.tr(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: FaidaBizTheme.green,
        onPressed: () async {
          final ok = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (_) => const FaidaBizSaleFormScreen()),
          );
          if (ok == true) _load();
        },
        icon: const Icon(Icons.add),
        label: Text('home.add_sale'.tr()),
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
                        const SizedBox(height: 100),
                        Icon(Icons.point_of_sale_outlined, size: 64, color: Colors.green.shade200),
                        const SizedBox(height: 16),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Text(
                              'sales.empty'.tr(),
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
                            ),
                          ),
                        ),
                      ],
                    )
                  : CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        SliverToBoxAdapter(child: _HeroHeader(total: _total, count: items.length)),
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                          sliver: SliverList.separated(
                            itemCount: items.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 10),
                            itemBuilder: (_, i) {
                              final s = items[i] as Map<String, dynamic>;
                              final lineItems = (s['items'] as List?) ?? [];
                              final first = lineItems.isNotEmpty ? Map<String, dynamic>.from(lineItems.first as Map) : null;
                              final name = first?['product_name']?.toString() ?? 'sales.fallback_title'.tr(args: ['${s['id']}']);
                              final qty = first?['quantity'];
                              final unit = first?['unit']?.toString() ??
                                  first?['product']?['unit']?.toString() ??
                                  '';
                              final sold = s['sold_at']?.toString();
                              final extra = lineItems.length > 1 ? ' +${lineItems.length - 1}' : '';
                              return _SaleCard(
                                title: '$name$extra',
                                subtitle: [
                                  if (qty != null) '${FaidaBizTheme.asDouble(qty)} $unit'.trim(),
                                  if (first?['unit_price'] != null) '@ ${FaidaBizTheme.money(first!['unit_price'])}',
                                  _dayLabel(sold),
                                  if (_timeLabel(sold).isNotEmpty) _timeLabel(sold),
                                ].where((e) => e.toString().trim().isNotEmpty).join(' · '),
                                amount: FaidaBizTheme.money(s['total']),
                                onTap: () => _openDetail(s),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
            ),
    );
  }
}

class _HeroHeader extends StatelessWidget {
  const _HeroHeader({required this.total, required this.count});
  final double total;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF166534), FaidaBizTheme.green, Color(0xFF0B1A12)],
        ),
        boxShadow: [
          BoxShadow(
            color: FaidaBizTheme.green.withValues(alpha: 0.35),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'sales.list_total'.tr(),
            style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 13, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 6),
          Text(
            FaidaBizTheme.money(total),
            style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -0.5),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'sales.list_count'.tr(args: ['$count']),
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _SaleCard extends StatelessWidget {
  const _SaleCard({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String amount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE8F5EC)),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 3)),
            ],
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Container(
                  width: 5,
                  decoration: const BoxDecoration(
                    color: FaidaBizTheme.green,
                    borderRadius: BorderRadius.horizontal(left: Radius.circular(16)),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5EC),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.point_of_sale_rounded, color: FaidaBizTheme.green, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Color(0xFF1A1A1A)),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                subtitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              amount,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                                color: FaidaBizTheme.greenDark,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Icon(Icons.chevron_right_rounded, size: 18, color: Colors.grey.shade400),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
