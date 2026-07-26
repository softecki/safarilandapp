import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wicom/faidabiz/faidabiz_api.dart';
import 'package:wicom/faidabiz/faidabiz_theme.dart';
import 'package:wicom/faidabiz/screens/transaction_edit_screens.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_chrome.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_delete_screen.dart';

class FaidaBizPurchaseDetailScreen extends StatefulWidget {
  const FaidaBizPurchaseDetailScreen({super.key, required this.purchase});
  final Map<String, dynamic> purchase;

  @override
  State<FaidaBizPurchaseDetailScreen> createState() => _FaidaBizPurchaseDetailScreenState();
}

class _FaidaBizPurchaseDetailScreenState extends State<FaidaBizPurchaseDetailScreen> {
  late Map<String, dynamic> purchase = Map<String, dynamic>.from(widget.purchase);

  String _fmtDate(String? raw) {
    final dt = DateTime.tryParse(raw ?? '');
    if (dt == null) return raw ?? '—';
    return DateFormat('d MMM yyyy · HH:mm').format(dt);
  }

  String _itemsLabel() {
    final lines = (purchase['items'] as List?) ?? [];
    if (lines.isEmpty) return '#${purchase['id']}';
    return lines.map((e) => (e as Map)['product_name']?.toString() ?? '').where((s) => s.isNotEmpty).join(', ');
  }

  Future<void> _edit() async {
    final updated = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (_) => FaidaBizPurchaseEditScreen(purchase: purchase)),
    );
    if (updated != null && mounted) setState(() => purchase = updated);
  }

  Future<void> _delete() async {
    final id = purchase['id'];
    final ok = await confirmAndSoftDelete(
      context: context,
      title: 'delete.title_purchase'.tr(),
      itemLabel: FaidaBizTheme.money(purchase['total']),
      onConfirm: (reason, password) async {
        await FaidaBizApi.delete('/purchases/$id', {
          'delete_reason': reason,
          'password': password,
        });
      },
    );
    if (ok && mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final lineItems = (purchase['items'] as List?) ?? [];
    final usedSales = FaidaBizTheme.asDouble(purchase['used_sales_amount']);
    final supplier = (purchase['supplier']?.toString() ?? '').trim();
    final notes = (purchase['notes']?.toString() ?? '').trim();

    return Scaffold(
      backgroundColor: const Color(0xFFF3F7F4),
      appBar: faidaBizAppBar(title: 'purchases.detail'.tr()),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [FaidaBizTheme.green, FaidaBizTheme.greenDark],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('purchases.list_total'.tr(), style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 13)),
                const SizedBox(height: 6),
                Text(FaidaBizTheme.money(purchase['total']), style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                Text(_itemsLabel(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Text(_fmtDate(purchase['purchased_at']?.toString()), style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 13)),
                if (supplier.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(supplier, style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 13)),
                ],
                if (usedSales > 0) ...[
                  const SizedBox(height: 6),
                  Text('${'form.used_sales_amount'.tr()}: ${FaidaBizTheme.money(usedSales)}', style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 13)),
                ],
                if (notes.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(notes, style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 13)),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text('purchases.items'.tr(), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
          const SizedBox(height: 10),
          if (lineItems.isEmpty)
            Text('purchases.no_items'.tr(), style: TextStyle(color: Colors.grey.shade600))
          else
            ...lineItems.map((raw) {
              final it = Map<String, dynamic>.from(raw as Map);
              final unit = it['unit']?.toString() ?? it['product']?['unit']?.toString() ?? '';
              final sell = it['product'] is Map ? (it['product'] as Map)['sell_price'] : null;
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE8F5EC)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(it['product_name']?.toString() ?? '—', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${FaidaBizTheme.asDouble(it['quantity'])} $unit × ${FaidaBizTheme.money(it['unit_cost'] ?? it['unit_price'])}',
                            style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                          ),
                        ),
                        Text(
                          FaidaBizTheme.money(it['line_total'] ?? purchase['total']),
                          style: const TextStyle(fontWeight: FontWeight.w800, color: FaidaBizTheme.greenDark),
                        ),
                      ],
                    ),
                    if (sell != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        '${'form.selling'.tr()}: ${FaidaBizTheme.money(sell)}',
                        style: TextStyle(fontSize: 12.5, color: Colors.grey.shade600),
                      ),
                    ],
                  ],
                ),
              );
            }),
          const SizedBox(height: 24),
          FaidaBizDetailActions(onEdit: _edit, onDelete: _delete),
          const SizedBox(height: 8),
          Text('purchases.delete_hint'.tr(), style: TextStyle(fontSize: 12.5, color: Colors.grey.shade600, height: 1.35)),
        ],
      ),
    );
  }
}
