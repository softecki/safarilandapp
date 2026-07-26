import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wicom/faidabiz/faidabiz_api.dart';
import 'package:wicom/faidabiz/faidabiz_theme.dart';
import 'package:wicom/faidabiz/screens/transaction_edit_screens.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_chrome.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_delete_screen.dart';

class FaidaBizSaleDetailScreen extends StatefulWidget {
  const FaidaBizSaleDetailScreen({super.key, required this.sale});
  final Map<String, dynamic> sale;

  @override
  State<FaidaBizSaleDetailScreen> createState() => _FaidaBizSaleDetailScreenState();
}

class _FaidaBizSaleDetailScreenState extends State<FaidaBizSaleDetailScreen> {
  late Map<String, dynamic> sale = Map<String, dynamic>.from(widget.sale);

  String _fmtDate(String? raw) {
    final dt = DateTime.tryParse(raw ?? '');
    if (dt == null) return raw ?? '—';
    return DateFormat('d MMM yyyy · HH:mm').format(dt);
  }

  Future<void> _edit() async {
    final updated = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (_) => FaidaBizSaleEditScreen(sale: sale)),
    );
    if (updated != null && mounted) setState(() => sale = updated);
  }

  Future<void> _delete() async {
    final id = sale['id'];
    final ok = await confirmAndSoftDelete(
      context: context,
      title: 'delete.title_sale'.tr(),
      itemLabel: FaidaBizTheme.money(sale['total']),
      onConfirm: (reason, password) async {
        await FaidaBizApi.delete('/sales/$id', {
          'delete_reason': reason,
          'password': password,
        });
      },
    );
    if (ok && mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final lineItems = (sale['items'] as List?) ?? [];
    final notes = (sale['notes']?.toString() ?? '').trim();

    return Scaffold(
      backgroundColor: const Color(0xFFF3F7F4),
      appBar: faidaBizAppBar(title: 'sales.detail'.tr()),
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
                colors: [Color(0xFF166534), FaidaBizTheme.green, Color(0xFF0B1A12)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('sales.sale_total'.tr(), style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 13)),
                const SizedBox(height: 6),
                Text(FaidaBizTheme.money(sale['total']), style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800)),
                const SizedBox(height: 14),
                _row(Icons.calendar_today_outlined, _fmtDate(sale['sold_at']?.toString())),
                const SizedBox(height: 8),
                _row(Icons.payments_outlined, _paymentLabel(sale['payment_method']?.toString())),
                if (sale['profit'] != null) ...[
                  const SizedBox(height: 8),
                  _row(Icons.trending_up, '${'sales.profit'.tr()}: ${FaidaBizTheme.money(sale['profit'])}'),
                ],
                if (notes.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _row(Icons.notes_outlined, notes),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text('sales.items'.tr(), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
          const SizedBox(height: 10),
          if (lineItems.isEmpty)
            Text('sales.no_items'.tr(), style: TextStyle(color: Colors.grey.shade600))
          else
            ...lineItems.map((raw) {
              final it = Map<String, dynamic>.from(raw as Map);
              final unit = it['unit']?.toString() ?? it['product']?['unit']?.toString() ?? '';
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
                            '${FaidaBizTheme.asDouble(it['quantity'])} $unit × ${FaidaBizTheme.money(it['unit_price'])}',
                            style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                          ),
                        ),
                        Text(
                          FaidaBizTheme.money(it['line_total'] ?? sale['total']),
                          style: const TextStyle(fontWeight: FontWeight.w800, color: FaidaBizTheme.greenDark),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          const SizedBox(height: 24),
          FaidaBizDetailActions(onEdit: _edit, onDelete: _delete),
          const SizedBox(height: 8),
          Text('sales.delete_hint'.tr(), style: TextStyle(fontSize: 12.5, color: Colors.grey.shade600, height: 1.35)),
        ],
      ),
    );
  }

  Widget _row(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.white70),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 13))),
      ],
    );
  }

  String _paymentLabel(String? method) {
    final m = (method ?? 'cash').toLowerCase();
    final key = 'payment.$m';
    final translated = key.tr();
    return translated == key ? m : translated;
  }
}
