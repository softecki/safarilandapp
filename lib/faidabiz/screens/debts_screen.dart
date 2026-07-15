import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wicom/faidabiz/faidabiz_api.dart';
import 'package:wicom/faidabiz/faidabiz_theme.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_loader.dart';

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
      appBar: AppBar(
        title: Text('debts.title'.tr()),
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
    return Scaffold(
      appBar: AppBar(title: Text('debts.add'.tr())),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('debts.add_hint'.tr(), style: TextStyle(color: Colors.grey.shade700, height: 1.4)),
          const SizedBox(height: 16),
          TextField(
            controller: name,
            decoration: InputDecoration(labelText: 'debts.customer_name'.tr()),
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: phone,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(labelText: 'debts.phone_optional'.tr()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: amount,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: 'debts.loan_amount'.tr()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: notes,
            maxLines: 2,
            decoration: InputDecoration(labelText: 'debts.notes_optional'.tr(), hintText: 'debts.notes_hint'.tr()),
          ),
          if (error != null) ...[
            const SizedBox(height: 12),
            Text(error!, style: const TextStyle(color: Colors.red)),
          ],
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
    if (balance <= 0) return;

    final amountCtrl = TextEditingController(text: balance.toStringAsFixed(0));
    final notesCtrl = TextEditingController();

    final ok = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(4)),
                  ),
                ),
                const SizedBox(height: 16),
                Text('debts.record_payment'.tr(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text(
                  '${'debts.remaining'.tr()}: ${FaidaBizTheme.money(balance)}',
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: amountCtrl,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(labelText: 'debts.payment_amount'.tr()),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: notesCtrl,
                  decoration: InputDecoration(labelText: 'debts.notes_optional'.tr()),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: Text('debts.save_payment'.tr()),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (ok != true) return;
    final amount = double.tryParse(amountCtrl.text) ?? 0;
    if (amount <= 0) return;

    try {
      await FaidaBizApi.post('/debts/${widget.debtId}/pay', {
        'amount': amount,
        'notes': notesCtrl.text.trim().isEmpty ? null : notesCtrl.text.trim(),
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('debts.payment_saved'.tr())));
      }
      await _load();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final balance = FaidaBizTheme.asDouble(debt?['balance']);
    final cleared = balance <= 0;

    return Scaffold(
      appBar: AppBar(title: Text(debt?['name']?.toString() ?? 'debts.title'.tr())),
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
                    if (!cleared) ...[
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _pay,
                        icon: const Icon(Icons.payments_outlined),
                        label: Text('debts.record_payment'.tr()),
                      ),
                    ],
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
