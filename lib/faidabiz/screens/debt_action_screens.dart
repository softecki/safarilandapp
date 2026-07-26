import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wicom/faidabiz/faidabiz_api.dart';
import 'package:wicom/faidabiz/faidabiz_theme.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_chrome.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_neumorphic.dart';

class FaidaBizDebtPayScreen extends StatefulWidget {
  const FaidaBizDebtPayScreen({super.key, required this.debtId, required this.balance, required this.name});
  final int debtId;
  final double balance;
  final String name;

  @override
  State<FaidaBizDebtPayScreen> createState() => _FaidaBizDebtPayScreenState();
}

class _FaidaBizDebtPayScreenState extends State<FaidaBizDebtPayScreen> {
  late final amount = TextEditingController(text: widget.balance.toStringAsFixed(0));
  final notes = TextEditingController();
  bool loading = false;
  String? error;

  @override
  void dispose() {
    amount.dispose();
    notes.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final value = double.tryParse(amount.text) ?? 0;
    if (value <= 0) {
      setState(() => error = 'debts.amount_required'.tr());
      return;
    }
    setState(() {
      loading = true;
      error = null;
    });
    try {
      await FaidaBizApi.post('/debts/${widget.debtId}/pay', {
        'amount': value,
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
      appBar: faidaBizAppBar(title: 'debts.record_payment'.tr(), backgroundColor: Colors.orange.shade800),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(widget.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
          const SizedBox(height: 4),
          Text('${'debts.remaining'.tr()}: ${FaidaBizTheme.money(widget.balance)}', style: TextStyle(color: Colors.grey.shade700)),
          const SizedBox(height: 16),
          FaidaBizNeuField(
            controller: amount,
            label: 'debts.payment_amount'.tr(),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 14),
          FaidaBizNeuField(controller: notes, label: 'debts.notes_optional'.tr()),
          if (error != null) ...[
            const SizedBox(height: 12),
            Text(error!, style: const TextStyle(color: Colors.red)),
          ],
          const SizedBox(height: 24),
          NeuPrimaryButton(
            label: 'debts.save_payment'.tr(),
            loading: loading,
            onPressed: loading ? null : _save,
          ),
        ],
      ),
    );
  }
}

class FaidaBizDebtAddMoreScreen extends StatefulWidget {
  const FaidaBizDebtAddMoreScreen({super.key, required this.debtId, required this.name});
  final int debtId;
  final String name;

  @override
  State<FaidaBizDebtAddMoreScreen> createState() => _FaidaBizDebtAddMoreScreenState();
}

class _FaidaBizDebtAddMoreScreenState extends State<FaidaBizDebtAddMoreScreen> {
  final amount = TextEditingController();
  final notes = TextEditingController();
  bool loading = false;
  String? error;

  @override
  void dispose() {
    amount.dispose();
    notes.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final value = double.tryParse(amount.text) ?? 0;
    if (value <= 0) {
      setState(() => error = 'debts.amount_required'.tr());
      return;
    }
    setState(() {
      loading = true;
      error = null;
    });
    try {
      await FaidaBizApi.post('/debts/${widget.debtId}/add', {
        'amount': value,
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
      appBar: faidaBizAppBar(title: 'debts.add_more'.tr(), backgroundColor: Colors.orange.shade800),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FaidaBizNeuHint(
            icon: Icons.info_outline,
            child: Text('debts.add_more_hint'.tr(args: [widget.name]), style: TextStyle(color: Colors.grey.shade800, height: 1.35)),
          ),
          const SizedBox(height: 16),
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
          ),
          if (error != null) ...[
            const SizedBox(height: 12),
            Text(error!, style: const TextStyle(color: Colors.red)),
          ],
          const SizedBox(height: 24),
          NeuPrimaryButton(
            label: 'debts.save_more'.tr(),
            loading: loading,
            onPressed: loading ? null : _save,
          ),
        ],
      ),
    );
  }
}

class FaidaBizDebtEditScreen extends StatefulWidget {
  const FaidaBizDebtEditScreen({super.key, required this.debt});
  final Map<String, dynamic> debt;

  @override
  State<FaidaBizDebtEditScreen> createState() => _FaidaBizDebtEditScreenState();
}

class _FaidaBizDebtEditScreenState extends State<FaidaBizDebtEditScreen> {
  late final name = TextEditingController(text: widget.debt['name']?.toString() ?? '');
  late final phone = TextEditingController(text: widget.debt['phone']?.toString() ?? '');
  late final notes = TextEditingController(text: widget.debt['notes']?.toString() ?? '');
  final reason = TextEditingController();
  bool loading = false;
  String? error;

  @override
  void dispose() {
    name.dispose();
    phone.dispose();
    notes.dispose();
    reason.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (name.text.trim().isEmpty) {
      setState(() => error = 'debts.fill_required'.tr());
      return;
    }
    if (reason.text.trim().length < 3) {
      setState(() => error = 'form.edit_reason_required'.tr());
      return;
    }
    setState(() {
      loading = true;
      error = null;
    });
    try {
      await FaidaBizApi.put('/customers/${widget.debt['id']}', {
        'name': name.text.trim(),
        'phone': phone.text.trim().isEmpty ? null : phone.text.trim(),
        'notes': notes.text.trim().isEmpty ? null : notes.text.trim(),
        'edit_reason': reason.text.trim(),
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
      appBar: faidaBizAppBar(title: 'debts.edit'.tr(), backgroundColor: Colors.orange.shade800),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FaidaBizNeuField(controller: name, label: 'debts.customer_name'.tr()),
          const SizedBox(height: 14),
          FaidaBizNeuField(
            controller: phone,
            label: 'debts.phone_optional'.tr(),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 14),
          FaidaBizNeuField(controller: notes, label: 'debts.notes_optional'.tr(), maxLines: 2),
          const SizedBox(height: 14),
          FaidaBizNeuField(
            controller: reason,
            label: 'form.edit_reason'.tr(),
            helperText: 'form.edit_reason_hint'.tr(),
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
