import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wicom/faidabiz/faidabiz_api.dart';
import 'package:wicom/faidabiz/faidabiz_theme.dart';
import 'package:wicom/faidabiz/screens/product_form_screen.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_loader.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_select.dart';

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

  @override
  void dispose() {
    qty.dispose();
    price.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    try {
      final res = await FaidaBizApi.get('/products');
      products = (res['data'] as List?) ?? [];
      if (products.isNotEmpty && productId == null) {
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
      price.text = '${p['sell_price'] ?? 0}';
    });
  }

  double get total {
    final q = double.tryParse(qty.text) ?? 0;
    final p = double.tryParse(price.text) ?? 0;
    return q * p;
  }

  double get _stockQty => FaidaBizTheme.asDouble(selected?['stock_qty']);
  double get _sellQty => double.tryParse(qty.text.replaceAll(',', '')) ?? 0;
  double get _stockDeficit => _sellQty > _stockQty ? (_sellQty - _stockQty) : 0;

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
      return Scaffold(appBar: AppBar(title: Text('home.add_sale'.tr())), body: FaidaBizLoader.body());
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
    final valueLabel = selected == null
        ? null
        : '${selected!['name']} · $unit · ${FaidaBizTheme.money(selected!['sell_price'])}';
    final deficit = _stockDeficit;

    return Scaffold(
      appBar: AppBar(
        title: Text('home.add_sale'.tr()),
        backgroundColor: FaidaBizTheme.green,
        foregroundColor: Colors.white,
      ),
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
          if (selected != null) ...[
            const SizedBox(height: 8),
            Text(
              'sales.stock_now'.tr(args: ['${FaidaBizTheme.asDouble(selected!['stock_qty'])}', unit]),
              style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
            ),
          ],
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
          Text(
            '${'form.total'.tr()}: ${FaidaBizTheme.money(total)}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          if (deficit > 0) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7ED),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFDBA74)),
              ),
              child: Text(
                'sales.stock_topup_hint'.tr(args: [
                  '${FaidaBizTheme.asDouble(_stockQty)}',
                  unit,
                  '${FaidaBizTheme.asDouble(_sellQty)}',
                  '${FaidaBizTheme.asDouble(deficit)}',
                ]),
                style: const TextStyle(fontSize: 13, height: 1.35, color: Color(0xFF9A3412)),
              ),
            ),
          ],
          if (error != null) ...[
            const SizedBox(height: 8),
            Text(error!, style: const TextStyle(color: Colors.red)),
          ],
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
