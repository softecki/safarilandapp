import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wicom/faidabiz/faidabiz_api.dart';
import 'package:wicom/faidabiz/screens/product_form_screen.dart';

class FaidaBizPurchaseFormScreen extends StatefulWidget {
  const FaidaBizPurchaseFormScreen({super.key});

  @override
  State<FaidaBizPurchaseFormScreen> createState() => _FaidaBizPurchaseFormScreenState();
}

class _FaidaBizPurchaseFormScreenState extends State<FaidaBizPurchaseFormScreen> {
  List products = [];
  int? productId;
  final qty = TextEditingController(text: '1');
  final cost = TextEditingController();
  final supplier = TextEditingController();
  bool loading = false;
  bool productsLoaded = false;
  String? error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final res = await FaidaBizApi.get('/products');
      products = (res['data'] as List?) ?? [];
      if (products.isNotEmpty) {
        final p = products.first as Map<String, dynamic>;
        productId = int.tryParse('${p['id']}');
        cost.text = '${p['buy_price'] ?? 0}';
      }
    } catch (_) {}
    if (mounted) setState(() => productsLoaded = true);
  }

  Map<String, dynamic>? get selected {
    if (productId == null) return null;
    try {
      return products.cast<Map<String, dynamic>>().firstWhere((e) => e['id'] == productId || '${e['id']}' == '$productId');
    } catch (_) {
      return null;
    }
  }

  Future<void> _save() async {
    if (productId == null) return;
    setState(() {
      loading = true;
      error = null;
    });
    try {
      await FaidaBizApi.post('/purchases', {
        'product_id': productId,
        'quantity': double.tryParse(qty.text) ?? 1,
        'unit_cost': double.tryParse(cost.text) ?? 0,
        'supplier': supplier.text.trim().isEmpty ? null : supplier.text.trim(),
        'payment_method': 'cash',
      });
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!productsLoaded) {
      return Scaffold(appBar: AppBar(title: Text('home.add_purchase'.tr())), body: const Center(child: CircularProgressIndicator()));
    }
    if (products.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('home.add_purchase'.tr())),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('form.no_products'.tr()),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  await Navigator.push(context, MaterialPageRoute(builder: (_) => const FaidaBizProductFormScreen()));
                  _load();
                },
                child: Text('home.add_product'.tr()),
              ),
            ],
          ),
        ),
      );
    }

    final unit = selected?['unit']?.toString() ?? 'pcs';

    return Scaffold(
      appBar: AppBar(title: Text('home.add_purchase'.tr())),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<int>(
            value: productId,
            items: products.map((p) {
              final m = p as Map;
              return DropdownMenuItem(
                value: int.tryParse('${m['id']}'),
                child: Text('${m['name']} (${m['unit']})'),
              );
            }).toList(),
            onChanged: (v) {
              productId = v;
              final p = selected;
              if (p != null) cost.text = '${p['buy_price'] ?? 0}';
              setState(() {});
            },
            decoration: InputDecoration(labelText: 'form.product'.tr()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: qty,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: '${'form.qty'.tr()} ($unit)'),
          ),
          const SizedBox(height: 12),
          TextField(controller: cost, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: InputDecoration(labelText: 'form.buy_price'.tr())),
          const SizedBox(height: 12),
          TextField(controller: supplier, decoration: InputDecoration(labelText: 'form.supplier'.tr())),
          if (error != null) Text(error!, style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 24),
          ElevatedButton(onPressed: loading ? null : _save, child: Text('form.save'.tr())),
        ],
      ),
    );
  }
}
