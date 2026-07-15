import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wicom/faidabiz/faidabiz_api.dart';
import 'package:wicom/faidabiz/faidabiz_theme.dart';
import 'package:wicom/faidabiz/screens/product_form_screen.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_delete_dialog.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_loader.dart';

class FaidaBizProductsScreen extends StatefulWidget {
  const FaidaBizProductsScreen({super.key});

  @override
  State<FaidaBizProductsScreen> createState() => _FaidaBizProductsScreenState();
}

class _FaidaBizProductsScreenState extends State<FaidaBizProductsScreen> {
  List items = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => loading = true);
    try {
      final res = await FaidaBizApi.get('/products');
      items = (res['data'] as List?) ?? [];
    } catch (_) {}
    if (mounted) setState(() => loading = false);
  }

  Future<void> _delete(Map<String, dynamic> p) async {
    final ok = await confirmAndSoftDelete(
      context: context,
      title: 'delete.title_product'.tr(),
      itemLabel: p['name']?.toString(),
      onConfirm: (reason, password) async {
        await FaidaBizApi.delete('/products/${p['id']}', {
          'delete_reason': reason,
          'password': password,
        });
      },
    );
    if (ok) _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('nav.products'.tr())),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => const FaidaBizProductFormScreen()));
          _load();
        },
        child: const Icon(Icons.add),
      ),
      body: loading
          ? FaidaBizLoader.body()
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                itemBuilder: (_, i) {
                  final p = items[i] as Map<String, dynamic>;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      title: Text(p['name']?.toString() ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(
                        '${'form.stock'.tr()}: ${p['stock_qty']} ${p['unit']}\n'
                        '${'form.buying'.tr()}: ${FaidaBizTheme.money(p['buy_price'])} · '
                        '${'form.selling'.tr()}: ${FaidaBizTheme.money(p['sell_price'])}',
                      ),
                      isThreeLine: true,
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => FaidaBizProductFormScreen(product: p)),
                        );
                        _load();
                      },
                      trailing: IconButton(
                        icon: Icon(Icons.delete_outline, color: faidaBizDeleteColor),
                        onPressed: () => _delete(p),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
