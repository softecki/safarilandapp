import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wicom/faidabiz/faidabiz_api.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_loader.dart';

class FaidaBizExpenseFormScreen extends StatefulWidget {
  const FaidaBizExpenseFormScreen({super.key});

  @override
  State<FaidaBizExpenseFormScreen> createState() => _FaidaBizExpenseFormScreenState();
}

class _FaidaBizExpenseFormScreenState extends State<FaidaBizExpenseFormScreen> {
  final title = TextEditingController();
  final amount = TextEditingController();
  bool loading = false;
  String? error;

  Future<void> _save() async {
    setState(() {
      loading = true;
      error = null;
    });
    try {
      await FaidaBizApi.post('/expenses', {
        'title': title.text.trim(),
        'amount': double.tryParse(amount.text) ?? 0,
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
    return Scaffold(
      appBar: AppBar(title: Text('home.add_expense'.tr())),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(controller: title, decoration: InputDecoration(labelText: 'form.expense_title'.tr())),
          const SizedBox(height: 12),
          TextField(controller: amount, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: InputDecoration(labelText: 'form.amount'.tr())),
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
