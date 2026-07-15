import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wicom/faidabiz/faidabiz_api.dart';
import 'package:wicom/faidabiz/faidabiz_theme.dart';
import 'package:wicom/faidabiz/screens/sale_form_screen.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_loader.dart';

class FaidaBizSalesScreen extends StatefulWidget {
  const FaidaBizSalesScreen({super.key});

  @override
  State<FaidaBizSalesScreen> createState() => _FaidaBizSalesScreenState();
}

class _FaidaBizSalesScreenState extends State<FaidaBizSalesScreen> {
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
      final res = await FaidaBizApi.get('/sales');
      final page = res['data'] as Map<String, dynamic>?;
      items = (page?['data'] as List?) ?? [];
    } catch (_) {}
    if (mounted) setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('nav.sales'.tr())),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => const FaidaBizSaleFormScreen()));
          _load();
        },
        icon: const Icon(Icons.add),
        label: Text('home.add_sale'.tr()),
      ),
      body: loading
          ? FaidaBizLoader.body()
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, i) {
                  final s = items[i] as Map<String, dynamic>;
                  final lineItems = (s['items'] as List?) ?? [];
                  final first = lineItems.isNotEmpty ? lineItems.first as Map<String, dynamic> : null;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(first?['product_name']?.toString() ?? 'Mauzo #${s['id']}'),
                    subtitle: Text(
                      '${first?['quantity'] ?? ''} ${first?['unit'] ?? first?['product']?['unit'] ?? ''}'
                      '${first?['unit_price'] != null ? ' · @ ${FaidaBizTheme.money(first!['unit_price'])}' : ''}'
                      ' · ${s['sold_at'] ?? ''}',
                    ),
                    trailing: Text(FaidaBizTheme.money(s['total']), style: const TextStyle(fontWeight: FontWeight.bold)),
                  );
                },
              ),
            ),
    );
  }
}
