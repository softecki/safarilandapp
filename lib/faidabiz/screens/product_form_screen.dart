import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wicom/faidabiz/faidabiz_api.dart';

const kProductUnits = ['pcs', 'kg', 'g', 'l', 'ml', 'box', 'packet', 'dozen', 'pair', 'sack', 'bottle'];

class FaidaBizProductFormScreen extends StatefulWidget {
  const FaidaBizProductFormScreen({super.key, this.product});
  final Map<String, dynamic>? product;

  @override
  State<FaidaBizProductFormScreen> createState() => _FaidaBizProductFormScreenState();
}

class _FaidaBizProductFormScreenState extends State<FaidaBizProductFormScreen> {
  late final name = TextEditingController(text: widget.product?['name']?.toString() ?? '');
  late String unit = (() {
    final u = widget.product?['unit']?.toString() ?? 'pcs';
    return kProductUnits.contains(u) ? u : 'pcs';
  })();
  late final stock = TextEditingController(text: '${widget.product?['stock_qty'] ?? 0}');
  late final buy = TextEditingController(text: '${widget.product?['buy_price'] ?? 0}');
  late final sell = TextEditingController(text: '${widget.product?['sell_price'] ?? 0}');
  late final note = TextEditingController();
  List history = [];
  bool loading = false;
  String? error;
  String? info;

  bool get isEdit => widget.product != null;

  @override
  void initState() {
    super.initState();
    if (isEdit) _loadHistory();
  }

  Future<void> _loadHistory() async {
    try {
      final res = await FaidaBizApi.get('/products/${widget.product!['id']}/price-history');
      final page = res['data'];
      if (page is Map) {
        history = (page['data'] as List?) ?? [];
      } else if (page is List) {
        history = page;
      }
    } catch (_) {}
    if (mounted) setState(() {});
  }

  Future<void> _save() async {
    if (name.text.trim().isEmpty) {
      setState(() => error = 'form.product'.tr());
      return;
    }
    setState(() {
      loading = true;
      error = null;
      info = null;
    });
    final payload = <String, dynamic>{
      'name': name.text.trim(),
      'unit': unit,
      'stock_qty': double.tryParse(stock.text) ?? 0,
      'buy_price': double.tryParse(buy.text) ?? 0,
      'sell_price': double.tryParse(sell.text) ?? 0,
    };
    if (isEdit && note.text.trim().isNotEmpty) {
      payload['price_note'] = note.text.trim();
    }
    try {
      if (isEdit) {
        final res = await FaidaBizApi.put('/products/${widget.product!['id']}', payload);
        if (res['prices_changed'] == true) {
          setState(() => info = 'form.price_updated'.tr());
          await _loadHistory();
        } else if (mounted) {
          Navigator.pop(context, true);
        }
      } else {
        await FaidaBizApi.post('/products', payload);
        if (mounted) Navigator.pop(context, true);
      }
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'form.edit_product'.tr() : 'home.add_product'.tr())),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(controller: name, decoration: InputDecoration(labelText: 'form.product'.tr())),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: unit,
            items: kProductUnits.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
            onChanged: (v) => setState(() => unit = v ?? 'pcs'),
            decoration: InputDecoration(labelText: 'form.unit'.tr()),
          ),
          const SizedBox(height: 12),
          TextField(controller: stock, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: InputDecoration(labelText: 'form.stock'.tr())),
          const SizedBox(height: 12),
          TextField(controller: buy, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: InputDecoration(labelText: 'form.buying'.tr())),
          const SizedBox(height: 12),
          TextField(controller: sell, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: InputDecoration(labelText: 'form.selling'.tr())),
          if (isEdit) ...[
            const SizedBox(height: 12),
            TextField(controller: note, decoration: InputDecoration(labelText: 'form.price_note'.tr())),
          ],
          if (info != null) ...[
            const SizedBox(height: 8),
            Text(info!, style: const TextStyle(color: Color(0xFF15803D))),
          ],
          if (error != null) ...[
            const SizedBox(height: 8),
            Text(error!, style: const TextStyle(color: Colors.red)),
          ],
          const SizedBox(height: 24),
          ElevatedButton(onPressed: loading ? null : _save, child: Text('form.save'.tr())),
          if (isEdit) ...[
            const SizedBox(height: 28),
            Text('form.price_history'.tr(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 4),
            Text('form.price_history_hint'.tr(), style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
            const SizedBox(height: 8),
            ...history.map((h) {
              final m = h as Map<String, dynamic>;
              final from = m['effective_from']?.toString() ?? '';
              final to = m['effective_to']?.toString();
              return Card(
                child: ListTile(
                  title: Text(
                    '${'form.buying'.tr()}: ${m['buy_price']} · ${'form.selling'.tr()}: ${m['sell_price']}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    to == null || to.isEmpty
                        ? '$from (${'form.current_price'.tr()})'
                        : '$from → $to\n${m['reason'] ?? ''} ${m['note'] ?? ''}',
                  ),
                  isThreeLine: to != null && to.isNotEmpty,
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}
