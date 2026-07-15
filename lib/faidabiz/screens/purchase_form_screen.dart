import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wicom/faidabiz/faidabiz_api.dart';
import 'package:wicom/faidabiz/faidabiz_theme.dart';
import 'package:wicom/faidabiz/screens/product_form_screen.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_loader.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_select.dart';

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

  @override
  void dispose() {
    qty.dispose();
    cost.dispose();
    supplier.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final res = await FaidaBizApi.get('/products');
      products = (res['data'] as List?) ?? [];
      if (products.isNotEmpty && productId == null) {
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
      return products.cast<Map<String, dynamic>>().firstWhere(
            (e) => e['id'] == productId || '${e['id']}' == '$productId',
          );
    } catch (_) {
      return null;
    }
  }

  Future<void> _pickProduct() async {
    final p = await showFaidaBizProductPicker(
      context: context,
      products: products,
      selectedId: productId,
    );
    if (p == null) return;
    setState(() {
      productId = int.tryParse('${p['id']}');
      cost.text = '${p['buy_price'] ?? 0}';
    });
  }

  Future<void> _save() async {
    if (productId == null) {
      setState(() => error = 'form.select_product'.tr());
      return;
    }
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
      return Scaffold(appBar: AppBar(title: Text('home.add_purchase'.tr())), body: FaidaBizLoader.body());
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
    final valueLabel = selected == null
        ? null
        : '${selected!['name']} · $unit · ${FaidaBizTheme.money(selected!['buy_price'])}';

    return Scaffold(
      appBar: AppBar(title: Text('home.add_purchase'.tr())),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FaidaBizSelectField(
            label: 'form.product'.tr(),
            hint: 'form.select_product'.tr(),
            valueLabel: valueLabel,
            leading: const Icon(Icons.inventory_2_outlined, color: FaidaBizTheme.green, size: 22),
            onTap: _pickProduct,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: qty,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: '${'form.qty'.tr()} ($unit)'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: cost,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: 'form.buy_price'.tr()),
          ),
          const SizedBox(height: 12),
          TextField(controller: supplier, decoration: InputDecoration(labelText: 'form.supplier'.tr())),
          if (error != null) Text(error!, style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: loading ? null : _save,
            child: loading ? FaidaBizLoader.button() : Text('form.save'.tr()),
          ),
        ],
      ),
    );
  }
}
