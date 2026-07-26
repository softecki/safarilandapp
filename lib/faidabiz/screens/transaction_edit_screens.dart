import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wicom/faidabiz/faidabiz_api.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_chrome.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_neumorphic.dart';

class FaidaBizSaleEditScreen extends StatefulWidget {
  const FaidaBizSaleEditScreen({super.key, required this.sale});
  final Map<String, dynamic> sale;

  @override
  State<FaidaBizSaleEditScreen> createState() => _FaidaBizSaleEditScreenState();
}

class _FaidaBizSaleEditScreenState extends State<FaidaBizSaleEditScreen> {
  late final Map<String, dynamic> item = (() {
    final items = (widget.sale['items'] as List?) ?? [];
    if (items.isEmpty) return <String, dynamic>{};
    return Map<String, dynamic>.from(items.first as Map);
  })();

  late final qty = TextEditingController(text: '${item['quantity'] ?? 1}');
  late final price = TextEditingController(text: '${item['unit_price'] ?? 0}');
  late final notes = TextEditingController(text: widget.sale['notes']?.toString() ?? '');
  final reason = TextEditingController();
  bool loading = false;
  String? error;

  @override
  void dispose() {
    qty.dispose();
    price.dispose();
    notes.dispose();
    reason.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final q = double.tryParse(qty.text) ?? 0;
    final p = double.tryParse(price.text) ?? -1;
    if (q <= 0) {
      setState(() => error = 'sales.qty_required'.tr());
      return;
    }
    if (p < 0) {
      setState(() => error = 'sales.price_required'.tr());
      return;
    }
    if (reason.text.trim().length < 3) {
      setState(() => error = 'form.edit_reason_required'.tr());
      return;
    }
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final res = await FaidaBizApi.put('/sales/${widget.sale['id']}', {
        'quantity': q,
        'unit_price': p,
        'notes': notes.text.trim().isEmpty ? null : notes.text.trim(),
        'edit_reason': reason.text.trim(),
      });
      if (mounted) Navigator.pop(context, Map<String, dynamic>.from(res['data'] as Map));
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = item['product_name']?.toString() ?? 'sales.detail'.tr();
    return FaidaBizNeuFormScaffold(
      appBar: faidaBizAppBar(title: 'sales.edit'.tr()),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
          const SizedBox(height: 4),
          FaidaBizNeuHint(
            icon: Icons.info_outline,
            child: Text('sales.edit_hint'.tr(), style: TextStyle(color: Colors.grey.shade800, height: 1.35)),
          ),
          const SizedBox(height: 16),
          FaidaBizNeuField(
            controller: qty,
            label: 'form.qty'.tr(),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 14),
          FaidaBizNeuField(
            controller: price,
            label: 'form.selling'.tr(),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 14),
          FaidaBizNeuField(controller: notes, label: 'expenses.notes'.tr(), maxLines: 2),
          const SizedBox(height: 14),
          FaidaBizNeuField(
            controller: reason,
            label: 'form.edit_reason'.tr(),
            helperText: 'form.edit_reason_hint'.tr(),
            maxLines: 2,
          ),
          if (error != null) ...[
            const SizedBox(height: 12),
            Text(error!, style: const TextStyle(color: Colors.red)),
          ],
          const SizedBox(height: 24),
          NeuPrimaryButton(
            label: 'form.save'.tr(),
            loading: loading,
            onPressed: loading ? null : _save,
          ),
        ],
      ),
    );
  }
}

class FaidaBizPurchaseEditScreen extends StatefulWidget {
  const FaidaBizPurchaseEditScreen({super.key, required this.purchase});
  final Map<String, dynamic> purchase;

  @override
  State<FaidaBizPurchaseEditScreen> createState() => _FaidaBizPurchaseEditScreenState();
}

class _FaidaBizPurchaseEditScreenState extends State<FaidaBizPurchaseEditScreen> {
  late final Map<String, dynamic> item = (() {
    final items = (widget.purchase['items'] as List?) ?? [];
    if (items.isEmpty) return <String, dynamic>{};
    return Map<String, dynamic>.from(items.first as Map);
  })();

  late final qty = TextEditingController(text: '${item['quantity'] ?? 1}');
  late final buy = TextEditingController(text: '${item['unit_cost'] ?? item['unit_price'] ?? 0}');
  late final sell = TextEditingController(text: '${_initialSellPrice()}');
  late final supplier = TextEditingController(text: widget.purchase['supplier']?.toString() ?? '');
  late final notes = TextEditingController(text: widget.purchase['notes']?.toString() ?? '');
  final reason = TextEditingController();
  bool loading = false;
  String? error;

  dynamic _initialSellPrice() {
    final prod = item['product'];
    if (prod is Map && prod['sell_price'] != null) return prod['sell_price'];
    return widget.purchase['sell_price'] ?? 0;
  }

  @override
  void dispose() {
    qty.dispose();
    buy.dispose();
    sell.dispose();
    supplier.dispose();
    notes.dispose();
    reason.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final q = double.tryParse(qty.text) ?? 0;
    final b = double.tryParse(buy.text) ?? -1;
    final s = double.tryParse(sell.text) ?? -1;
    if (q <= 0) {
      setState(() => error = 'sales.qty_required'.tr());
      return;
    }
    if (b < 0 || s < 0) {
      setState(() => error = 'sales.price_required'.tr());
      return;
    }
    if (reason.text.trim().length < 3) {
      setState(() => error = 'form.edit_reason_required'.tr());
      return;
    }
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final res = await FaidaBizApi.put('/purchases/${widget.purchase['id']}', {
        'quantity': q,
        'unit_cost': b,
        'sell_price': s,
        'supplier': supplier.text.trim().isEmpty ? null : supplier.text.trim(),
        'notes': notes.text.trim().isEmpty ? null : notes.text.trim(),
        'edit_reason': reason.text.trim(),
      });
      if (mounted) Navigator.pop(context, Map<String, dynamic>.from(res['data'] as Map));
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = item['product_name']?.toString() ?? 'purchases.detail'.tr();
    return FaidaBizNeuFormScaffold(
      appBar: faidaBizAppBar(title: 'purchases.edit'.tr()),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
          const SizedBox(height: 4),
          FaidaBizNeuHint(
            icon: Icons.info_outline,
            child: Text('purchases.edit_hint'.tr(), style: TextStyle(color: Colors.grey.shade800, height: 1.35)),
          ),
          const SizedBox(height: 16),
          FaidaBizNeuField(
            controller: qty,
            label: 'form.qty'.tr(),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 14),
          FaidaBizNeuField(
            controller: buy,
            label: 'form.buying'.tr(),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 14),
          FaidaBizNeuField(
            controller: sell,
            label: 'form.selling'.tr(),
            helperText: 'purchases.sell_price_hint'.tr(),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 14),
          FaidaBizNeuField(controller: supplier, label: 'form.supplier'.tr()),
          const SizedBox(height: 14),
          FaidaBizNeuField(controller: notes, label: 'expenses.notes'.tr(), maxLines: 2),
          const SizedBox(height: 14),
          FaidaBizNeuField(
            controller: reason,
            label: 'form.edit_reason'.tr(),
            helperText: 'form.edit_reason_hint'.tr(),
            maxLines: 2,
          ),
          if (error != null) ...[
            const SizedBox(height: 12),
            Text(error!, style: const TextStyle(color: Colors.red)),
          ],
          const SizedBox(height: 24),
          NeuPrimaryButton(
            label: 'form.save'.tr(),
            loading: loading,
            onPressed: loading ? null : _save,
          ),
        ],
      ),
    );
  }
}
