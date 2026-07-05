import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:intl/intl.dart';
import 'package:wicom/core/app_color.dart';
import 'package:wicom/core/whatslipa_api.dart';
import 'package:wicom/whatslipa/widgets/whatslipa_theme.dart';
import 'package:wicom/whatslipa/screens/whatslipa_order_detail_screen.dart';
import 'package:wicom/src/view/widgets/neumorphic_widgets.dart';

class WhatsLipaOrdersScreen extends StatefulWidget {
  const WhatsLipaOrdersScreen({super.key});

  @override
  State<WhatsLipaOrdersScreen> createState() => _WhatsLipaOrdersScreenState();
}

class _WhatsLipaOrdersScreenState extends State<WhatsLipaOrdersScreen> {
  Map<String, dynamic>? _summary;
  List<dynamic> _orders = [];
  bool _loading = true;
  String? _filter;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      _summary = await WhatsLipaApi.ordersSummary();
      final res = await WhatsLipaApi.ordersList(status: _filter);
      _orders = List<dynamic>.from(res['data']['orders'] as List);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
    if (mounted) setState(() => _loading = false);
  }

  Color _statusColor(String status) {
    return switch (status) {
      'New' => const Color(0xFF2563EB),
      'Confirmed' => const Color(0xFF7C3AED),
      'Packed' || 'Packing' => const Color(0xFFD97706),
      'On delivery' => const Color(0xFF0D9488),
      'Delivered' => const Color(0xFF16A34A),
      'Cancelled' => const Color(0xFFDC2626),
      _ => Colors.grey,
    };
  }

  IconData _statusIcon(String status) {
    return switch (status) {
      'New' => Icons.fiber_new_rounded,
      'Confirmed' => Icons.check_circle_outline,
      'Packed' || 'Packing' => Icons.inventory_2_outlined,
      'On delivery' => Icons.local_shipping_outlined,
      'Delivered' => Icons.done_all,
      'Cancelled' => Icons.cancel_outlined,
      _ => Icons.help_outline,
    };
  }

  String _formatDate(String? iso) {
    if (iso == null || iso.isEmpty) return '';
    try {
      final dt = DateTime.parse(iso).toLocal();
      return DateFormat('dd MMM yyyy · HH:mm').format(dt);
    } catch (_) {
      return iso;
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = WhatsLipaTheme.primary;

    return Scaffold(
      backgroundColor: AppColor.neumorphicBase,
      appBar: WhatsLipaTheme.appBar(title: 'Orders'),
      body: NeuScreenCanvas(
        child: Column(
          children: [
            if (_summary != null)
              Padding(
                padding: const EdgeInsets.all(12),
                child: Neumorphic(
                  style: NeumorphicStyle(depth: 4, boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(14))),
                  padding: const EdgeInsets.all(14),
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    children: [
                      _chip('Total', _summary!['total']),
                      _chip('Today', _summary!['today']),
                      _chip('New', _summary!['new']),
                      _chip('Packed', _summary!['packed']),
                    ],
                  ),
                ),
              ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  FilterChip(
                    label: const Text('All'),
                    selected: _filter == null,
                    onSelected: (_) {
                      setState(() => _filter = null);
                      _load();
                    },
                  ),
                  ...['New', 'Confirmed', 'Packed', 'Delivered', 'Cancelled'].map(
                    (s) => Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: FilterChip(
                        label: Text(s),
                        selected: _filter == s,
                        onSelected: (_) {
                          setState(() => _filter = s);
                          _load();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _loading
                  ? Center(child: CircularProgressIndicator(color: primary))
                  : RefreshIndicator(
                      color: primary,
                      onRefresh: _load,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: _orders.length,
                        itemBuilder: (context, i) {
                          final o = _orders[i] as Map<String, dynamic>;
                          final status = o['status']?.toString() ?? '';
                          final phone = o['customer_phone']?.toString() ?? o['customer']?['phone']?.toString() ?? '—';
                          final sc = _statusColor(status);

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: NeumorphicButton(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (_) => WhatsLipaOrderDetailScreen(orderId: o['id'] as int),
                                ),
                              ).then((_) => _load()),
                              style: NeumorphicStyle(
                                depth: 5,
                                boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(14)),
                              ),
                              padding: const EdgeInsets.all(14),
                              child: Row(
                                children: [
                                  Neumorphic(
                                    style: NeumorphicStyle(
                                      depth: 3,
                                      boxShape: const NeumorphicBoxShape.circle(),
                                      color: sc.withValues(alpha: 0.15),
                                    ),
                                    padding: const EdgeInsets.all(10),
                                    child: Icon(_statusIcon(status), color: sc, size: 26),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          phone,
                                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Order #${o['id']} · $status',
                                          style: TextStyle(fontSize: 12, color: sc, fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          _formatDate(o['created_at']?.toString()),
                                          style: const TextStyle(fontSize: 11, color: AppColor.textSecondary),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '${o['total_amount']} TZS',
                                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(String label, dynamic value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: AppColor.textSecondary)),
        Text('$value', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ],
    );
  }
}
