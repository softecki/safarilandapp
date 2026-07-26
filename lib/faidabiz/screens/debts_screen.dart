import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wicom/faidabiz/faidabiz_api.dart';
import 'package:wicom/faidabiz/faidabiz_theme.dart';
import 'package:wicom/faidabiz/screens/debt_action_screens.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_chrome.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_delete_screen.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_loader.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_neumorphic.dart';

/// List of customer debts / loans with outstanding balances.
class FaidaBizDebtsScreen extends StatefulWidget {
  const FaidaBizDebtsScreen({super.key});

  @override
  State<FaidaBizDebtsScreen> createState() => _FaidaBizDebtsScreenState();
}

class _FaidaBizDebtsScreenState extends State<FaidaBizDebtsScreen> {
  List items = [];
  Map summary = {};
  bool loading = true;
  bool openOnly = true;
  String? error;

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
      final res = await FaidaBizApi.get('/debts', query: {'open': openOnly ? '1' : '0'});
      items = (res['data'] as List?) ?? [];
      summary = (res['summary'] as Map?) ?? {};
    } catch (e) {
      error = e.toString();
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> _openAdd() async {
    final ok = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const FaidaBizDebtFormScreen()),
    );
    if (ok == true) _load();
  }

  Future<void> _openDetail(Map m) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => FaidaBizDebtDetailScreen(debtId: int.parse('${m['id']}'))),
    );
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: faidaBizAppBar(
        title: 'debts.title'.tr(),
        backgroundColor: Colors.orange.shade800,
        actions: [
          IconButton(
            tooltip: openOnly ? 'debts.show_all'.tr() : 'debts.show_open'.tr(),
            onPressed: () {
              setState(() => openOnly = !openOnly);
              _load();
            },
            icon: Icon(openOnly ? Icons.filter_alt : Icons.filter_alt_off),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAdd,
        icon: const Icon(Icons.add),
        label: Text('debts.add'.tr()),
      ),
      body: loading
          ? FaidaBizLoader.body()
          : error != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(error!, textAlign: TextAlign.center),
                      TextButton(onPressed: _load, child: Text('common.retry'.tr())),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: FaidaBizTheme.green,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'debts.outstanding'.tr(),
                              style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 13),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              FaidaBizTheme.money(summary['outstanding'] ?? 0),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${summary['open_count'] ?? 0} ${'debts.open_count'.tr()}',
                              style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (items.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Center(child: Text('debts.empty'.tr(), textAlign: TextAlign.center)),
                        )
                      else
                        ...items.map((raw) {
                          final m = Map<String, dynamic>.from(raw as Map);
                          final balance = FaidaBizTheme.asDouble(m['balance']);
                          final paid = balance <= 0;
                          return Card(
                            margin: const EdgeInsets.only(bottom: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            child: ListTile(
                              onTap: () => _openDetail(m),
                              leading: CircleAvatar(
                                backgroundColor: paid
                                    ? FaidaBizTheme.green.withValues(alpha: 0.15)
                                    : Colors.orange.withValues(alpha: 0.15),
                                child: Icon(
                                  paid ? Icons.check_rounded : Icons.handshake_outlined,
                                  color: paid ? FaidaBizTheme.green : Colors.orange.shade800,
                                ),
                              ),
                              title: Text(m['name']?.toString() ?? '', style: const TextStyle(fontWeight: FontWeight.w700)),
                              subtitle: Text(
                                paid
                                    ? 'debts.cleared'.tr()
                                    : '${'debts.owed'.tr()}: ${FaidaBizTheme.money(m['owed'])} · ${'debts.paid'.tr()}: ${FaidaBizTheme.money(m['paid'])}',
                              ),
                              trailing: Text(
                                FaidaBizTheme.money(balance),
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: paid ? FaidaBizTheme.green : Colors.orange.shade900,
                                ),
                              ),
                            ),
                          );
                        }),
                    ],
                  ),
                ),
    );
  }
}

class FaidaBizDebtFormScreen extends StatefulWidget {
  const FaidaBizDebtFormScreen({super.key});

  @override
  State<FaidaBizDebtFormScreen> createState() => _FaidaBizDebtFormScreenState();
}

class _FaidaBizDebtFormScreenState extends State<FaidaBizDebtFormScreen> {
  final name = TextEditingController();
  final phone = TextEditingController();
  final amount = TextEditingController();
  final notes = TextEditingController();
  bool loading = false;
  String? error;

  @override
  void dispose() {
    name.dispose();
    phone.dispose();
    amount.dispose();
    notes.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (name.text.trim().isEmpty || (double.tryParse(amount.text) ?? 0) <= 0) {
      setState(() => error = 'debts.fill_required'.tr());
      return;
    }
    setState(() {
      loading = true;
      error = null;
    });
    try {
      await FaidaBizApi.post('/debts', {
        'name': name.text.trim(),
        'phone': phone.text.trim().isEmpty ? null : phone.text.trim(),
        'amount': double.tryParse(amount.text) ?? 0,
        'notes': notes.text.trim().isEmpty ? null : notes.text.trim(),
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
    return FaidaBizNeuFormScaffold(
      appBar: faidaBizAppBar(title: 'debts.add'.tr(), backgroundColor: Colors.orange.shade800),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FaidaBizNeuHint(
            icon: Icons.info_outline,
            child: Text('debts.add_hint'.tr(), style: TextStyle(color: Colors.grey.shade800, height: 1.4)),
          ),
          const SizedBox(height: 16),
          FaidaBizNeuField(
            controller: name,
            label: 'debts.customer_name'.tr(),
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 14),
          FaidaBizNeuField(
            controller: phone,
            label: 'debts.phone_optional'.tr(),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 14),
          FaidaBizNeuField(
            controller: amount,
            label: 'debts.loan_amount'.tr(),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 14),
          FaidaBizNeuField(
            controller: notes,
            label: 'debts.notes_optional'.tr(),
            hint: 'debts.notes_hint'.tr(),
            maxLines: 2,
          ),
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

class FaidaBizDebtDetailScreen extends StatefulWidget {
  const FaidaBizDebtDetailScreen({super.key, required this.debtId});
  final int debtId;

  @override
  State<FaidaBizDebtDetailScreen> createState() => _FaidaBizDebtDetailScreenState();
}

class _FaidaBizDebtDetailScreenState extends State<FaidaBizDebtDetailScreen> {
  Map<String, dynamic>? debt;
  List payments = [];
  bool loading = true;
  String? error;

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
      final res = await FaidaBizApi.get('/debts/${widget.debtId}');
      debt = Map<String, dynamic>.from(res['data'] as Map);
      payments = (res['payments'] as List?) ?? [];
    } catch (e) {
      error = e.toString();
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> _pay() async {
    final balance = FaidaBizTheme.asDouble(debt?['balance']);
    if (balance <= 0 || debt == null) return;
    final ok = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => FaidaBizDebtPayScreen(
          debtId: widget.debtId,
          balance: balance,
          name: debt!['name']?.toString() ?? '',
        ),
      ),
    );
    if (ok == true) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('debts.payment_saved'.tr())));
      }
      await _load();
    }
  }

  Future<void> _addMoreDebt() async {
    if (debt == null) return;
    final ok = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => FaidaBizDebtAddMoreScreen(
          debtId: widget.debtId,
          name: debt!['name']?.toString() ?? '',
        ),
      ),
    );
    if (ok == true) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('debts.more_saved'.tr())));
      }
      await _load();
    }
  }

  Future<void> _edit() async {
    if (debt == null) return;
    final ok = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => FaidaBizDebtEditScreen(debt: debt!)),
    );
    if (ok == true) await _load();
  }

  Future<void> _delete() async {
    if (debt == null) return;
    final ok = await confirmAndSoftDelete(
      context: context,
      title: 'delete.title_debt'.tr(),
      itemLabel: debt!['name']?.toString(),
      onConfirm: (reason, password) async {
        await FaidaBizApi.delete('/debts/${widget.debtId}', {
          'delete_reason': reason,
          'password': password,
        });
      },
    );
    if (ok && mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final balance = FaidaBizTheme.asDouble(debt?['balance']);
    final cleared = balance <= 0;

    return Scaffold(
      appBar: faidaBizAppBar(
        title: debt?['name']?.toString() ?? 'debts.title'.tr(),
        backgroundColor: Colors.orange.shade800,
      ),
      body: loading
          ? FaidaBizLoader.body()
          : error != null
              ? Center(child: Text(error!))
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: cleared ? FaidaBizTheme.green.withValues(alpha: 0.1) : Colors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: cleared ? FaidaBizTheme.green.withValues(alpha: 0.3) : Colors.orange.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(debt?['name']?.toString() ?? '', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                          if ((debt?['phone']?.toString() ?? '').isNotEmpty)
                            Text(debt!['phone'].toString(), style: TextStyle(color: Colors.grey.shade700)),
                          if ((debt?['notes']?.toString() ?? '').isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(debt!['notes'].toString()),
                          ],
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(child: _Stat('debts.owed'.tr(), FaidaBizTheme.money(debt?['owed']))),
                              Expanded(child: _Stat('debts.paid'.tr(), FaidaBizTheme.money(debt?['paid']))),
                              Expanded(
                                child: _Stat(
                                  'debts.remaining'.tr(),
                                  FaidaBizTheme.money(balance),
                                  bold: true,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        if (!cleared)
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _pay,
                              icon: const Icon(Icons.payments_outlined),
                              label: Text('debts.record_payment'.tr()),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange.shade800,
                                foregroundColor: Colors.white,
                                minimumSize: const Size.fromHeight(48),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              ),
                            ),
                          ),
                        if (!cleared) const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _addMoreDebt,
                            icon: const Icon(Icons.add_rounded),
                            label: Text('debts.add_more'.tr()),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.orange.shade900,
                              side: BorderSide(color: Colors.orange.shade300),
                              minimumSize: const Size.fromHeight(48),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    FaidaBizDetailActions(
                      onEdit: _edit,
                      onDelete: _delete,
                      accentColor: Colors.orange.shade800,
                    ),
                    const SizedBox(height: 24),
                    Text('debts.payment_history'.tr(), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                    const SizedBox(height: 8),
                    if (payments.isEmpty)
                      Text('debts.no_payments'.tr(), style: TextStyle(color: Colors.grey.shade600))
                    else
                      ...payments.map((raw) {
                        final p = Map<String, dynamic>.from(raw as Map);
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.check_circle_outline, color: FaidaBizTheme.green),
                          title: Text(FaidaBizTheme.money(p['amount']), style: const TextStyle(fontWeight: FontWeight.w700)),
                          subtitle: Text(p['paid_at']?.toString() ?? ''),
                        );
                      }),
                  ],
                ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat(this.label, this.value, {this.bold = false});
  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade700)),
        const SizedBox(height: 2),
        Text(value, style: TextStyle(fontWeight: bold ? FontWeight.w800 : FontWeight.w600, fontSize: 14)),
      ],
    );
  }
}
