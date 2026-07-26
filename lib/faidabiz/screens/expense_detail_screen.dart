import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wicom/faidabiz/faidabiz_api.dart';
import 'package:wicom/faidabiz/faidabiz_theme.dart';
import 'package:wicom/faidabiz/screens/expense_form_screen.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_chrome.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_delete_dialog.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_loader.dart';

class FaidaBizExpenseDetailScreen extends StatefulWidget {
  const FaidaBizExpenseDetailScreen({super.key, required this.expenseId});
  final int expenseId;

  @override
  State<FaidaBizExpenseDetailScreen> createState() => _FaidaBizExpenseDetailScreenState();
}

class _FaidaBizExpenseDetailScreenState extends State<FaidaBizExpenseDetailScreen> {
  Map<String, dynamic>? expense;
  List history = [];
  bool loading = true;
  String? error;
  bool changed = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final res = await FaidaBizApi.get('/expenses/${widget.expenseId}');
      expense = Map<String, dynamic>.from(res['data'] as Map);
      history = (res['history'] as List?) ?? [];
    } catch (e) {
      error = e.toString();
    }
    if (mounted) setState(() => loading = false);
  }

  Future<void> _edit() async {
    if (expense == null) return;
    final ok = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => FaidaBizExpenseFormScreen(expense: expense)),
    );
    if (ok == true) {
      changed = true;
      await _load();
    }
  }

  Future<void> _delete() async {
    final ok = await confirmAndSoftDelete(
      context: context,
      title: 'delete.title_expense'.tr(),
      itemLabel: expense?['title']?.toString(),
      onConfirm: (reason, password) async {
        await FaidaBizApi.delete('/expenses/${widget.expenseId}', {
          'delete_reason': reason,
          'password': password,
        });
      },
    );
    if (ok && mounted) Navigator.pop(context, true);
  }

  String _fmtDate(String? raw) {
    final dt = DateTime.tryParse(raw ?? '');
    if (dt == null) return raw ?? '—';
    return DateFormat('d MMM yyyy · HH:mm').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) return;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F4EF),
        appBar: faidaBizAppBar(
          title: 'expenses.detail'.tr(),
          backgroundColor: Colors.orange.shade800,
          onBack: () => Navigator.pop(context, changed),
        ),
        body: loading
            ? FaidaBizLoader.body()
            : error != null
                ? Center(child: Padding(padding: const EdgeInsets.all(24), child: Text(error!, textAlign: TextAlign.center)))
                : RefreshIndicator(
                    onRefresh: _load,
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                      children: [
                        _InfoCard(expense: expense!, fmtDate: _fmtDate),
                        const SizedBox(height: 16),
                        FaidaBizDetailActions(
                          onEdit: _edit,
                          onDelete: _delete,
                          editLabel: 'expenses.edit'.tr(),
                          accentColor: Colors.orange.shade800,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'expenses.history'.tr(),
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'expenses.history_hint'.tr(),
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                        ),
                        const SizedBox(height: 10),
                        if (history.isEmpty)
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text('expenses.history_empty'.tr(), style: TextStyle(color: Colors.grey.shade600)),
                          )
                        else
                          ...history.map((raw) {
                            final h = Map<String, dynamic>.from(raw as Map);
                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: Colors.orange.shade50),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          h['title']?.toString() ?? '',
                                          style: const TextStyle(fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      Text(
                                        FaidaBizTheme.money(h['amount']),
                                        style: TextStyle(fontWeight: FontWeight.w800, color: Colors.orange.shade900),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '${'expenses.reason'.tr()}: ${h['reason'] ?? ''}',
                                    style: TextStyle(color: Colors.grey.shade800, fontSize: 13),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _fmtDate(h['created_at']?.toString()),
                                    style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                                  ),
                                ],
                              ),
                            );
                          }),
                      ],
                    ),
                  ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.expense, required this.fmtDate});
  final Map<String, dynamic> expense;
  final String Function(String?) fmtDate;

  @override
  Widget build(BuildContext context) {
    final cat = (expense['category']?.toString() ?? '').trim();
    final notes = (expense['notes']?.toString() ?? '').trim();
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.orange.shade700, Colors.deepOrange.shade800],
        ),
        boxShadow: [
          BoxShadow(color: Colors.orange.shade300.withValues(alpha: 0.4), blurRadius: 16, offset: const Offset(0, 6)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            expense['title']?.toString() ?? '',
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          Text(
            FaidaBizTheme.money(expense['amount']),
            style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 16),
          _row(Icons.calendar_today_outlined, fmtDate(expense['spent_at']?.toString())),
          if (cat.isNotEmpty) ...[
            const SizedBox(height: 8),
            _row(Icons.label_outline, cat),
          ],
          const SizedBox(height: 8),
          _row(Icons.payments_outlined, _paymentLabel(expense['payment_method']?.toString())),
          if (notes.isNotEmpty) ...[
            const SizedBox(height: 8),
            _row(Icons.notes_outlined, notes),
          ],
        ],
      ),
    );
  }

  Widget _row(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.white70),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 13))),
      ],
    );
  }

  String _paymentLabel(String? method) {
    final m = (method ?? 'cash').toLowerCase();
    final key = 'payment.$m';
    final translated = key.tr();
    return translated == key ? m : translated;
  }
}
