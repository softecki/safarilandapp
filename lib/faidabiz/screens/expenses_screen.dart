import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wicom/faidabiz/faidabiz_api.dart';
import 'package:wicom/faidabiz/faidabiz_theme.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_chrome.dart';
import 'package:wicom/faidabiz/screens/expense_detail_screen.dart';
import 'package:wicom/faidabiz/screens/expense_form_screen.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_loader.dart';

class FaidaBizExpensesScreen extends StatefulWidget {
  const FaidaBizExpensesScreen({super.key});

  @override
  State<FaidaBizExpensesScreen> createState() => _FaidaBizExpensesScreenState();
}

class _FaidaBizExpensesScreenState extends State<FaidaBizExpensesScreen> {
  List items = [];
  bool loading = true;

  double get _total {
    var sum = 0.0;
    for (final raw in items) {
      final e = raw as Map<String, dynamic>;
      sum += FaidaBizTheme.asDouble(e['amount']);
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
      final res = await FaidaBizApi.get('/expenses');
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

  Future<void> _openDetail(Map<String, dynamic> e) async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => FaidaBizExpenseDetailScreen(expenseId: (e['id'] as num).toInt())),
    );
    if (changed == true) _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4EF),
      appBar: faidaBizAppBar(
        title: 'nav.expenses'.tr(),
        backgroundColor: Colors.orange.shade800,
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.orange.shade800,
        onPressed: () async {
          final ok = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (_) => const FaidaBizExpenseFormScreen()),
          );
          if (ok == true) _load();
        },
        icon: const Icon(Icons.add),
        label: Text('home.add_expense'.tr()),
      ),
      body: loading
          ? FaidaBizLoader.body()
          : RefreshIndicator(
              color: Colors.orange.shade800,
              onRefresh: _load,
              child: items.isEmpty
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        const SizedBox(height: 100),
                        Icon(Icons.payments_outlined, size: 64, color: Colors.orange.shade200),
                        const SizedBox(height: 16),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Text(
                              'expenses.empty'.tr(),
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
                              final e = items[i] as Map<String, dynamic>;
                              final spent = e['spent_at']?.toString();
                              return _ExpenseCard(
                                title: e['title']?.toString() ?? '',
                                category: e['category']?.toString(),
                                dayLabel: _dayLabel(spent),
                                timeLabel: _timeLabel(spent),
                                amount: FaidaBizTheme.money(e['amount']),
                                onTap: () => _openDetail(e),
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
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.orange.shade700, Colors.deepOrange.shade800],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.shade300.withValues(alpha: 0.45),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'expenses.list_total'.tr(),
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
              'expenses.list_count'.tr(args: ['$count']),
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpenseCard extends StatelessWidget {
  const _ExpenseCard({
    required this.title,
    required this.category,
    required this.dayLabel,
    required this.timeLabel,
    required this.amount,
    required this.onTap,
  });

  final String title;
  final String? category;
  final String dayLabel;
  final String timeLabel;
  final String amount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cat = (category ?? '').trim();
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 0,
      shadowColor: Colors.black12,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.orange.shade50),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 3)),
            ],
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Container(
                  width: 5,
                  decoration: BoxDecoration(
                    color: Colors.orange.shade700,
                    borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
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
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.payments_rounded, color: Colors.orange.shade800, size: 22),
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
                                [
                                  if (cat.isNotEmpty) cat,
                                  dayLabel,
                                  if (timeLabel.isNotEmpty) timeLabel,
                                ].join(' · '),
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
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                                color: Colors.orange.shade900,
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
