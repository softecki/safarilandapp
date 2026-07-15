import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wicom/faidabiz/faidabiz_api.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_loader.dart';

class FaidaBizExpenseFormScreen extends StatefulWidget {
  const FaidaBizExpenseFormScreen({super.key, this.expense});
  final Map<String, dynamic>? expense;

  @override
  State<FaidaBizExpenseFormScreen> createState() => _FaidaBizExpenseFormScreenState();
}

class _FaidaBizExpenseFormScreenState extends State<FaidaBizExpenseFormScreen> {
  late final title = TextEditingController(text: widget.expense?['title']?.toString() ?? '');
  late final amount = TextEditingController(text: widget.expense != null ? '${widget.expense!['amount'] ?? ''}' : '');
  late final category = TextEditingController(text: widget.expense?['category']?.toString() ?? '');
  late final notes = TextEditingController(text: widget.expense?['notes']?.toString() ?? '');
  late final reason = TextEditingController();
  bool loading = false;
  String? error;

  bool get isEdit => widget.expense != null;

  Future<void> _save() async {
    if (title.text.trim().isEmpty) {
      setState(() => error = 'form.expense_title'.tr());
      return;
    }
    if (isEdit && reason.text.trim().length < 3) {
      setState(() => error = 'form.edit_reason_required'.tr());
      return;
    }
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final payload = <String, dynamic>{
        'title': title.text.trim(),
        'amount': double.tryParse(amount.text.replaceAll(',', '')) ?? 0,
        'payment_method': 'cash',
        if (category.text.trim().isNotEmpty) 'category': category.text.trim(),
        if (notes.text.trim().isNotEmpty) 'notes': notes.text.trim(),
      };
      if (isEdit) {
        payload['edit_reason'] = reason.text.trim();
        await FaidaBizApi.put('/expenses/${widget.expense!['id']}', payload);
      } else {
        await FaidaBizApi.post('/expenses', payload);
      }
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  void dispose() {
    title.dispose();
    amount.dispose();
    category.dispose();
    notes.dispose();
    reason.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'expenses.edit'.tr() : 'home.add_expense'.tr()),
        backgroundColor: Colors.orange.shade800,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(controller: title, decoration: InputDecoration(labelText: 'form.expense_title'.tr())),
          const SizedBox(height: 12),
          TextField(
            controller: amount,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: 'form.amount'.tr()),
          ),
          const SizedBox(height: 12),
          TextField(controller: category, decoration: InputDecoration(labelText: 'expenses.category'.tr())),
          const SizedBox(height: 12),
          TextField(controller: notes, maxLines: 2, decoration: InputDecoration(labelText: 'expenses.notes'.tr())),
          if (isEdit) ...[
            const SizedBox(height: 16),
            Text('form.edit_reason'.tr(), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
            const SizedBox(height: 6),
            Text('form.edit_reason_hint'.tr(), style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
            const SizedBox(height: 8),
            TextField(
              controller: reason,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: 'form.edit_reason'.tr(),
                border: const OutlineInputBorder(),
              ),
            ),
          ],
          if (error != null) ...[
            const SizedBox(height: 12),
            Text(error!, style: const TextStyle(color: Colors.red)),
          ],
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange.shade800, foregroundColor: Colors.white),
            onPressed: loading ? null : _save,
            child: loading ? FaidaBizLoader.button() : Text('form.save'.tr()),
          ),
        ],
      ),
    );
  }
}
