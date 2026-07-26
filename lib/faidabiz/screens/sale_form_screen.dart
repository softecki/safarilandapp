import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wicom/faidabiz/faidabiz_api.dart';
import 'package:wicom/faidabiz/faidabiz_theme.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_chrome.dart';
import 'package:wicom/faidabiz/screens/product_form_screen.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_loader.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_neumorphic.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_select.dart';

class FaidaBizSaleFormScreen extends StatefulWidget {
  const FaidaBizSaleFormScreen({super.key});

  @override
  State<FaidaBizSaleFormScreen> createState() => _FaidaBizSaleFormScreenState();
}

class _FaidaBizSaleFormScreenState extends State<FaidaBizSaleFormScreen> {
  List products = [];
  int? productId;
  String? newProductName;
  String newProductUnit = 'pcs';
  final qty = TextEditingController(text: '1');
  final price = TextEditingController();
  bool loading = false;
  bool productsLoaded = false;
  String? error;

  bool get isCreatingNew => newProductName != null && newProductName!.trim().isNotEmpty;

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

    if (p['_create_new'] == true) {
      setState(() {
        newProductName = p['name']?.toString().trim();
        productId = null;
        newProductUnit = 'pcs';
        if (price.text.trim().isEmpty) price.text = '';
        error = null;
      });
      return;
    }

    setState(() {
      newProductName = null;
      productId = int.tryParse('${p['id']}');
      price.text = FaidaBizTheme.amountInput(p['sell_price']);
      error = null;
    });
  }

  Future<void> _pickUnit() async {
    final picked = await showFaidaBizOptionPicker<String>(
      context: context,
      title: 'form.select_unit'.tr(),
      selected: newProductUnit,
      options: [
        for (final u in kProductUnits) (value: u, label: 'units.$u'.tr(), subtitle: null),
      ],
    );
    if (picked != null) setState(() => newProductUnit = picked);
  }

  double get total {
    final q = double.tryParse(qty.text) ?? 0;
    final p = double.tryParse(price.text) ?? 0;
    return q * p;
  }

  String get _unit {
    if (isCreatingNew) return newProductUnit;
    return selected?['unit']?.toString() ?? 'pcs';
  }

  double get _stockQty => FaidaBizTheme.asDouble(selected?['stock_qty']);
  double get _sellQty => double.tryParse(qty.text.replaceAll(',', '')) ?? 0;
  double get _stockDeficit {
    if (isCreatingNew) return _sellQty; // new product starts at 0 stock
    return _sellQty > _stockQty ? (_sellQty - _stockQty) : 0;
  }

  Future<void> _save() async {
    if (!isCreatingNew && productId == null) {
      setState(() => error = 'form.select_product'.tr());
      return;
    }
    if (isCreatingNew && (newProductName == null || newProductName!.trim().isEmpty)) {
      setState(() => error = 'form.select_product'.tr());
      return;
    }

    final sellQty = double.tryParse(qty.text) ?? 0;
    final unitPrice = double.tryParse(price.text) ?? 0;
    if (sellQty <= 0) {
      setState(() => error = 'sales.qty_required'.tr());
      return;
    }
    if (unitPrice < 0) {
      setState(() => error = 'sales.price_required'.tr());
      return;
    }

    setState(() {
      loading = true;
      error = null;
    });

    try {
      int? saleProductId = productId;

      if (isCreatingNew) {
        // Block duplicate product names before create
        final check = await FaidaBizApi.get('/products/check-name', query: {
          'name': newProductName!.trim(),
        });
        if (check['exists'] == true) {
          setState(() {
            loading = false;
            error = 'form.product_duplicate'.tr();
          });
          return;
        }

        // Create product first: buy_price = sell_price for quick onboarding
        final created = await FaidaBizApi.post('/products', {
          'name': newProductName!.trim(),
          'unit': newProductUnit,
          'stock_qty': 0,
          'buy_price': unitPrice,
          'sell_price': unitPrice,
        });
        final data = created['data'];
        if (data is Map) {
          saleProductId = int.tryParse('${data['id']}');
        }
        if (saleProductId == null) {
          throw Exception('sales.create_product_failed'.tr());
        }
      }

      await FaidaBizApi.post('/sales', {
        'product_id': saleProductId,
        'quantity': sellQty,
        'unit_price': unitPrice,
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
      return FaidaBizNeuFormScaffold(
        appBar: faidaBizAppBar(title: 'home.add_sale'.tr()),
        body: FaidaBizLoader.body(),
      );
    }

    final unit = _unit;
    final valueLabel = isCreatingNew
        ? '${newProductName!} · ${'sales.new_product_badge'.tr()}'
        : (selected == null
            ? null
            : '${selected!['name']} · $unit · ${FaidaBizTheme.money(selected!['sell_price'])}');
    final deficit = _stockDeficit;

    return FaidaBizNeuFormScaffold(
      appBar: faidaBizAppBar(title: 'home.add_sale'.tr()),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FaidaBizSelectField(
            label: 'form.product'.tr(),
            hint: 'form.select_product'.tr(),
            valueLabel: valueLabel,
            leading: Icon(
              isCreatingNew ? Icons.add_box_outlined : Icons.inventory_2_outlined,
              color: FaidaBizTheme.green,
              size: 22,
            ),
            onTap: _pickProduct,
          ),
          if (isCreatingNew) ...[
            const SizedBox(height: 10),
            FaidaBizNeuHint(
              icon: Icons.info_outline,
              child: Text(
                'sales.create_inline_hint'.tr(),
                style: TextStyle(color: Colors.grey.shade800, fontSize: 13, height: 1.35),
              ),
            ),
            const SizedBox(height: 12),
            FaidaBizSelectField(
              label: 'form.unit'.tr(),
              hint: 'form.select_unit'.tr(),
              valueLabel: 'units.$newProductUnit'.tr(),
              leading: const Icon(Icons.straighten_rounded, color: FaidaBizTheme.green, size: 22),
              onTap: _pickUnit,
            ),
          ] else if (selected != null) ...[
            const SizedBox(height: 10),
            FaidaBizNeuHint(
              icon: Icons.inventory_2_outlined,
              child: Text(
                'sales.stock_now'.tr(args: ['${FaidaBizTheme.asDouble(selected!['stock_qty'])}', unit]),
                style: TextStyle(color: Colors.grey.shade800, fontSize: 13),
              ),
            ),
          ],
          const SizedBox(height: 14),
          FaidaBizNeuField(
            controller: qty,
            label: '${'form.qty'.tr()} ($unit)',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 14),
          FaidaBizNeuField(
            controller: price,
            label: 'form.price'.tr(),
            helperText: isCreatingNew ? 'sales.buy_equals_sell_hint'.tr() : null,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          Text(
            '${'form.total'.tr()}: ${FaidaBizTheme.money(total)}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          if (deficit > 0) ...[
            const SizedBox(height: 12),
            FaidaBizNeuHint(
              color: const Color(0xFF9A3412),
              icon: Icons.warning_amber_rounded,
              child: Text(
                'sales.stock_topup_hint'.tr(args: [
                  '${FaidaBizTheme.asDouble(isCreatingNew ? 0 : _stockQty)}',
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
