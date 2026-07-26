import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wicom/faidabiz/faidabiz_api.dart';
import 'package:wicom/faidabiz/faidabiz_theme.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_chrome.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_neumorphic.dart';

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
  bool suggesting = false;
  String? error;
  List<Map<String, dynamic>> suggestions = const [];
  Timer? _debounce;
  bool _ignoreNextSuggest = false;

  bool get isEdit => widget.expense != null;

  @override
  void initState() {
    super.initState();
    if (!isEdit) {
      title.addListener(_onTitleChanged);
    }
  }

  void _onTitleChanged() {
    if (isEdit || _ignoreNextSuggest) return;
    _debounce?.cancel();
    final q = title.text.trim();
    if (q.length < 1) {
      if (suggestions.isNotEmpty) setState(() => suggestions = const []);
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 280), () => _loadSuggestions(q));
  }

  Future<void> _loadSuggestions(String q) async {
    if (!mounted || isEdit) return;
    setState(() => suggesting = true);
    try {
      final res = await FaidaBizApi.get('/expenses/suggest', query: {'q': q});
      final raw = (res['data'] as List?) ?? const [];
      if (!mounted || title.text.trim() != q) return;
      setState(() {
        suggestions = raw.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      });
    } catch (_) {
      if (mounted) setState(() => suggestions = const []);
    } finally {
      if (mounted) setState(() => suggesting = false);
    }
  }

  void _applySuggestion(Map<String, dynamic> s) {
    _ignoreNextSuggest = true;
    title.text = s['title']?.toString() ?? '';
    final cat = s['category']?.toString() ?? '';
    if (cat.isNotEmpty) category.text = cat;
    final amt = FaidaBizTheme.asDouble(s['amount']);
    if (amt > 0) amount.text = amt == amt.roundToDouble() ? amt.toStringAsFixed(0) : amt.toStringAsFixed(2);
    setState(() => suggestions = const []);
    Future<void>.delayed(const Duration(milliseconds: 350), () {
      _ignoreNextSuggest = false;
    });
  }

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
      suggestions = const [];
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
    _debounce?.cancel();
    if (!isEdit) title.removeListener(_onTitleChanged);
    title.dispose();
    amount.dispose();
    category.dispose();
    notes.dispose();
    reason.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FaidaBizNeuFormScaffold(
      appBar: faidaBizAppBar(
        title: isEdit ? 'expenses.edit'.tr() : 'home.add_expense'.tr(),
        backgroundColor: Colors.orange.shade800,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FaidaBizNeuField(
            controller: title,
            label: 'form.expense_title'.tr(),
            hint: isEdit ? null : 'expenses.title_hint'.tr(),
            textCapitalization: TextCapitalization.sentences,
            suffix: suggesting
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)),
                  )
                : null,
          ),
          if (!isEdit && suggestions.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'expenses.suggestions_hint'.tr(),
              style: TextStyle(fontSize: 12.5, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 8),
            ...suggestions.map((s) {
              final cat = (s['category']?.toString() ?? '').trim();
              final amt = FaidaBizTheme.asDouble(s['amount']);
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Material(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => _applySuggestion(s),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.orange.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.history_rounded, color: Colors.orange.shade800, size: 22),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  s['title']?.toString() ?? '',
                                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                                ),
                                if (cat.isNotEmpty || amt > 0)
                                  Text(
                                    [
                                      if (cat.isNotEmpty) cat,
                                      if (amt > 0) FaidaBizTheme.money(amt),
                                    ].join(' · '),
                                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                                  ),
                              ],
                            ),
                          ),
                          Icon(Icons.chevron_right_rounded, color: Colors.orange.shade700),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
          const SizedBox(height: 14),
          FaidaBizNeuField(
            controller: amount,
            label: 'form.amount'.tr(),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 14),
          FaidaBizNeuField(controller: category, label: 'expenses.category'.tr()),
          const SizedBox(height: 14),
          FaidaBizNeuField(controller: notes, label: 'expenses.notes'.tr(), maxLines: 2),
          if (isEdit) ...[
            const SizedBox(height: 14),
            FaidaBizNeuField(
              controller: reason,
              label: 'form.edit_reason'.tr(),
              helperText: 'form.edit_reason_hint'.tr(),
              maxLines: 2,
            ),
          ],
          if (error != null) ...[
            const SizedBox(height: 12),
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
