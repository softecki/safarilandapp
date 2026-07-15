import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wicom/faidabiz/faidabiz_api.dart';
import 'package:wicom/faidabiz/faidabiz_theme.dart';
import 'package:wicom/faidabiz/screens/expense_form_screen.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_loader.dart';

class FaidaBizExpensesScreen extends StatefulWidget {
  const FaidaBizExpensesScreen({super.key});

  @override
  State<FaidaBizExpensesScreen> createState() => _FaidaBizExpensesScreenState();
}

class _FaidaBizExpensesScreenState extends State<FaidaBizExpensesScreen> {
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
      final res = await FaidaBizApi.get('/expenses');
      final page = res['data'] as Map<String, dynamic>?;
      items = (page?['data'] as List?) ?? [];
    } catch (_) {}
    if (mounted) setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('nav.expenses'.tr())),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => const FaidaBizExpenseFormScreen()));
          _load();
        },
        icon: const Icon(Icons.add),
        label: Text('home.add_expense'.tr()),
      ),
      body: loading
          ? FaidaBizLoader.body()
          : RefreshIndicator(
              onRefresh: _load,
              child: items.isEmpty
                  ? ListView(
                      children: [
                        const SizedBox(height: 80),
                        Icon(Icons.payments_outlined, size: 48, color: Colors.grey.shade400),
                        const SizedBox(height: 12),
                        Center(child: Text('expenses.empty'.tr(), style: TextStyle(color: Colors.grey.shade600))),
                      ],
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (_, i) {
                        final e = items[i] as Map<String, dynamic>;
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            backgroundColor: Colors.orange.shade50,
                            child: Icon(Icons.payments, color: Colors.orange.shade800, size: 20),
                          ),
                          title: Text(e['title']?.toString() ?? '', style: const TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: Text('${e['category'] ?? ''} · ${e['spent_at'] ?? ''}'),
                          trailing: Text(
                            FaidaBizTheme.money(e['amount']),
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange.shade900),
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
