import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wicom/core/whatslipa_api.dart';

class WhatsLipaDashboardTab extends StatefulWidget {
  const WhatsLipaDashboardTab({super.key});

  @override
  State<WhatsLipaDashboardTab> createState() => _WhatsLipaDashboardTabState();
}

class _WhatsLipaDashboardTabState extends State<WhatsLipaDashboardTab> {
  Map<String, dynamic>? _data;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await WhatsLipaApi.dashboard();
      setState(() => _data = Map<String, dynamic>.from(res['data'] as Map));
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  String _money(num? v) {
    final fmt = NumberFormat('#,###', 'en_US');
    return 'TZS ${fmt.format(v ?? 0)}';
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFF25D366)));
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton(onPressed: _load, child: const Text('Retry')),
          ],
        ),
      );
    }
    final d = _data!;
    return RefreshIndicator(
      onRefresh: _load,
      color: const Color(0xFF25D366),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Today', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _StatCard(label: 'Orders', value: '${d['today_orders'] ?? 0}')),
              const SizedBox(width: 10),
              Expanded(child: _StatCard(label: 'Revenue', value: _money(d['today_revenue'] as num?))),
            ],
          ),
          const SizedBox(height: 16),
          Text('This week', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _StatCard(label: 'Orders', value: '${d['week_orders'] ?? 0}')),
              const SizedBox(width: 10),
              Expanded(child: _StatCard(label: 'Revenue', value: _money(d['week_revenue'] as num?))),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _StatCard(label: 'Customers', value: '${d['total_customers'] ?? 0}')),
              const SizedBox(width: 10),
              Expanded(child: _StatCard(label: 'Pending delivery', value: '${d['pending_deliveries'] ?? 0}')),
            ],
          ),
          const SizedBox(height: 20),
          Text('Recent orders', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          ...((d['recent_orders'] as List<dynamic>? ?? []).map((raw) {
            final o = raw as Map<String, dynamic>;
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text('Order #${o['id']} · ${o['status']}'),
                subtitle: Text(o['customer_name']?.toString() ?? 'Customer'),
                trailing: Text(_money(o['total_amount'] as num?)),
              ),
            );
          })),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
            const SizedBox(height: 6),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
