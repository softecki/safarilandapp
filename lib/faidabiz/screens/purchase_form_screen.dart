import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wicom/faidabiz/faidabiz_api.dart';
import 'package:wicom/faidabiz/faidabiz_theme.dart';
import 'package:wicom/faidabiz/screens/product_form_screen.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_chrome.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_loader.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_neumorphic.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_select.dart';

class FaidaBizPurchaseFormScreen extends StatefulWidget {
  const FaidaBizPurchaseFormScreen({super.key});

  @override
  State<FaidaBizPurchaseFormScreen> createState() => _FaidaBizPurchaseFormScreenState();
}

class _FaidaBizPurchaseFormScreenState extends State<FaidaBizPurchaseFormScreen> {
  List products = [];
  int? productId;
  String? newProductName;
  String newProductUnit = 'pcs';
  final qty = TextEditingController(text: '1');
  final cost = TextEditingController();
  final sell = TextEditingController();
  final supplier = TextEditingController();
  final usedSalesAmount = TextEditingController();
  bool usedSalesForPurchase = false;
  bool loading = false;
  bool productsLoaded = false;
  String? error;

  bool get isCreatingNew => newProductName != null && newProductName!.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    qty.dispose();
    cost.dispose();
    sell.dispose();
    supplier.dispose();
    usedSalesAmount.dispose();
    super.dispose();
  }

  Future<void> _load() async {
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
        cost.text = '';
        sell.text = '';
        error = null;
      });
      return;
    }

    setState(() {
      newProductName = null;
      productId = int.tryParse('${p['id']}');
      cost.text = '${p['buy_price'] ?? 0}';
      sell.text = '${p['sell_price'] ?? 0}';
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

  String get _unit => isCreatingNew ? newProductUnit : (selected?['unit']?.toString() ?? 'pcs');

  double get total {
    final q = double.tryParse(qty.text) ?? 0;
    final c = double.tryParse(cost.text) ?? 0;
    return q * c;
  }

  Future<void> _save() async {
    if (!isCreatingNew && productId == null) {
      setState(() => error = 'form.select_product'.tr());
      return;
    }
    final buyPrice = double.tryParse(cost.text) ?? 0;
    final sellPrice = double.tryParse(sell.text) ?? buyPrice;
    final quantity = double.tryParse(qty.text) ?? 0;
    if (quantity <= 0) {
      setState(() => error = 'sales.qty_required'.tr());
      return;
    }
    if (usedSalesForPurchase && (double.tryParse(usedSalesAmount.text) ?? 0) <= 0) {
      setState(() => error = 'form.used_sales_amount'.tr());
      return;
    }

    setState(() {
      loading = true;
      error = null;
    });

    try {
      int? purchaseProductId = productId;

      if (isCreatingNew) {
        final check = await FaidaBizApi.get('/products/check-name', query: {'name': newProductName!.trim()});
        if (check['exists'] == true) {
          setState(() {
            loading = false;
            error = 'form.product_duplicate'.tr();
          });
          return;
        }
        final created = await FaidaBizApi.post('/products', {
          'name': newProductName!.trim(),
          'unit': newProductUnit,
          'stock_qty': 0,
          'buy_price': buyPrice,
          'sell_price': sellPrice,
        });
        final data = created['data'];
        if (data is Map) purchaseProductId = int.tryParse('${data['id']}');
        if (purchaseProductId == null) throw Exception('sales.create_product_failed'.tr());
      }

      await FaidaBizApi.post('/purchases', {
        'product_id': purchaseProductId,
        'quantity': quantity,
        'unit_cost': buyPrice,
        'sell_price': sellPrice,
        'supplier': supplier.text.trim().isEmpty ? null : supplier.text.trim(),
        'payment_method': 'cash',
        'used_sales_for_purchase': usedSalesForPurchase,
        'used_sales_amount': usedSalesForPurchase ? (double.tryParse(usedSalesAmount.text) ?? 0) : 0,
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
        appBar: faidaBizAppBar(title: 'home.add_purchase'.tr()),
        body: FaidaBizLoader.body(),
      );
    }

    final unit = _unit;
    final valueLabel = isCreatingNew
        ? '${newProductName!} · ${'sales.new_product_badge'.tr()}'
        : (selected == null
            ? null
            : '${selected!['name']} · $unit · ${FaidaBizTheme.money(selected!['buy_price'])}');

    return FaidaBizNeuFormScaffold(
      appBar: faidaBizAppBar(title: 'home.add_purchase'.tr()),
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
                'purchases.create_inline_hint'.tr(),
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
                '${'form.selling'.tr()}: ${FaidaBizTheme.money(selected!['sell_price'])} · ${'form.stock'.tr()}: ${selected!['stock_qty']} $unit',
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
            controller: cost,
            label: 'form.buying'.tr(),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (_) => setState(() {}),
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
          const SizedBox(height: 8),
          NeuPanel(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: SwitchListTile(
              value: usedSalesForPurchase,
              onChanged: (v) => setState(() => usedSalesForPurchase = v),
              title: Text('form.used_sales_for_purchase'.tr()),
              subtitle: Text('form.used_sales_for_purchase_hint'.tr()),
              activeColor: FaidaBizTheme.green,
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            ),
          ),
          if (usedSalesForPurchase) ...[
            const SizedBox(height: 14),
            FaidaBizNeuField(
              controller: usedSalesAmount,
              label: 'form.used_sales_amount'.tr(),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
          ],
          const SizedBox(height: 16),
          Text('${'form.total'.tr()}: ${FaidaBizTheme.money(total)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
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
