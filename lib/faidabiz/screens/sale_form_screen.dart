import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wicom/faidabiz/faidabiz_api.dart';
import 'package:wicom/faidabiz/screens/product_form_screen.dart';

class FaidaBizSaleFormScreen extends StatefulWidget {
  const FaidaBizSaleFormScreen({super.key});

  @override
  State<FaidaBizSaleFormScreen> createState() => _FaidaBizSaleFormScreenState();
}

class _FaidaBizSaleFormScreenState extends State<FaidaBizSaleFormScreen> {
  List products = [];
  int? productId;
  final qty = TextEditingController(text: '1');
  final price = TextEditingController();
  bool loading = false;
  bool productsLoaded = false;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final res = await FaidaBizApi.get('/products');
      products = (res['data'] as List?) ?? [];
      if (products.isNotEmpty) {
        final p = products.first as Map<String, dynamic>;
        productId = int.tryParse('${p['id']}');
        price.text = '${p['sell_price'] ?? 0}';
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

  void _onProductChanged(int? id) {
    productId = id;
    final p = selected;
    if (p != null) price.text = '${p['sell_price'] ?? 0}';
    setState(() {});
  }

  double get total {
    final q = double.tryParse(qty.text) ?? 0;
    final p = double.tryParse(price.text) ?? 0;
    return q * p;
  }

  Future<void> _save() async {
    if (productId == null) return;
    setState(() {
      loading = true;
      error = null;
    });
    try {
      await FaidaBizApi.post('/sales', {
        'product_id': productId,
        'quantity': double.tryParse(qty.text) ?? 1,
        'unit_price': double.tryParse(price.text) ?? 0,
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
      return Scaffold(appBar: AppBar(title: Text('home.add_sale'.tr())), body: const Center(child: CircularProgressIndicator()));
    }
    if (products.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('home.add_sale'.tr())),
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
                  _loadProducts();
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
      appBar: AppBar(title: Text('home.add_sale'.tr())),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<int>(
            value: productId,
            items: products.map((p) {
              final m = p as Map;
              final id = int.tryParse('${m['id']}');
              return DropdownMenuItem(
                value: id,
                child: Text('${m['name']} (${m['unit']})'),
              );
            }).toList(),
            onChanged: _onProductChanged,
            decoration: InputDecoration(labelText: 'form.product'.tr()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: qty,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: '${'form.qty'.tr()} ($unit)'),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: price,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: 'form.price'.tr()),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          Text('${'form.total'.tr()}: ${total.toStringAsFixed(0)} TZS',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          if (error != null) ...[
            const SizedBox(height: 8),
            Text(error!, style: const TextStyle(color: Colors.red)),
          ],
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: loading ? null : _save,
            child: Text('form.save'.tr()),
          ),
        ],
      ),
    );
  }
}
