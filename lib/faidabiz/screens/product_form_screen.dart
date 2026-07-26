import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wicom/faidabiz/faidabiz_api.dart';
import 'package:wicom/faidabiz/faidabiz_theme.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_chrome.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_delete_dialog.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_neumorphic.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_select.dart';

const kProductUnits = ['pcs', 'kg', 'g', 'l', 'ml', 'box', 'packet', 'dozen', 'pair', 'sack', 'bottle'];

class FaidaBizProductFormScreen extends StatefulWidget {
  const FaidaBizProductFormScreen({super.key, this.product});
  final Map<String, dynamic>? product;

  @override
  State<FaidaBizProductFormScreen> createState() => _FaidaBizProductFormScreenState();
}

class _FaidaBizProductFormScreenState extends State<FaidaBizProductFormScreen> {
  late final name = TextEditingController(text: widget.product?['name']?.toString() ?? '');
  late String unit = (() {
    final u = widget.product?['unit']?.toString() ?? 'pcs';
    return kProductUnits.contains(u) ? u : 'pcs';
  })();
  late final stock = TextEditingController(text: '${widget.product?['stock_qty'] ?? 0}');
  late final buy = TextEditingController(text: '${widget.product?['buy_price'] ?? 0}');
  late final sell = TextEditingController(text: '${widget.product?['sell_price'] ?? 0}');
  late final note = TextEditingController();
  List history = [];
  bool loading = false;
  bool checkingName = false;
  bool nameExists = false;
  Map<String, dynamic>? exactMatch;
  List<Map<String, dynamic>> similar = const [];
  String? error;
  String? info;
  Timer? _debounce;

  bool get isEdit => widget.product != null;

  @override
  void initState() {
    super.initState();
    name.addListener(_onNameChanged);
    if (isEdit) _loadHistory();
  }

  void _onNameChanged() {
    _debounce?.cancel();
    final q = name.text.trim();
    if (q.isEmpty) {
      if (nameExists || similar.isNotEmpty || exactMatch != null) {
        setState(() {
          nameExists = false;
          exactMatch = null;
          similar = const [];
          if (error == 'form.product_duplicate'.tr()) error = null;
        });
      }
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 300), () => _checkName(q));
  }

  Future<void> _checkName(String q) async {
    if (!mounted) return;
    setState(() => checkingName = true);
    try {
      final query = <String, String>{'name': q};
      if (isEdit) query['exclude_id'] = '${widget.product!['id']}';
      final res = await FaidaBizApi.get('/products/check-name', query: query);
      if (!mounted || name.text.trim() != q) return;
      final exists = res['exists'] == true;
      final exact = res['exact'] is Map ? Map<String, dynamic>.from(res['exact'] as Map) : null;
      final simRaw = (res['similar'] as List?) ?? const [];
      setState(() {
        nameExists = exists;
        exactMatch = exact;
        similar = simRaw.map((e) => Map<String, dynamic>.from(e as Map)).toList();
        if (exists) {
          error = 'form.product_duplicate'.tr();
        } else if (error == 'form.product_duplicate'.tr()) {
          error = null;
        }
      });
    } catch (_) {
      // Ignore network hiccups while typing; server still blocks on save.
    } finally {
      if (mounted) setState(() => checkingName = false);
    }
  }

  Future<void> _loadHistory() async {
    try {
      final res = await FaidaBizApi.get('/products/${widget.product!['id']}/price-history');
      final page = res['data'];
      if (page is Map) {
        history = (page['data'] as List?) ?? [];
      } else if (page is List) {
        history = page;
      }
    } catch (_) {}
    if (mounted) setState(() {});
  }

  Future<void> _save() async {
    if (name.text.trim().isEmpty) {
      setState(() => error = 'form.product'.tr());
      return;
    }
    if (nameExists) {
      setState(() => error = 'form.product_duplicate'.tr());
      return;
    }
    if (isEdit && note.text.trim().length < 3) {
      setState(() => error = 'form.edit_reason_required'.tr());
      return;
    }
    setState(() {
      loading = true;
      error = null;
      info = null;
    });
    final payload = <String, dynamic>{
      'name': name.text.trim(),
      'unit': unit,
      'stock_qty': double.tryParse(stock.text) ?? 0,
      'buy_price': double.tryParse(buy.text) ?? 0,
      'sell_price': double.tryParse(sell.text) ?? 0,
    };
    if (isEdit) {
      payload['edit_reason'] = note.text.trim();
      payload['price_note'] = note.text.trim();
    }
    try {
      // Final server-side check before save
      final check = await FaidaBizApi.get('/products/check-name', query: {
        'name': name.text.trim(),
        if (isEdit) 'exclude_id': '${widget.product!['id']}',
      });
      if (check['exists'] == true) {
        setState(() {
          nameExists = true;
          exactMatch = check['exact'] is Map ? Map<String, dynamic>.from(check['exact'] as Map) : null;
          error = 'form.product_duplicate'.tr();
          loading = false;
        });
        return;
      }

      if (isEdit) {
        final res = await FaidaBizApi.put('/products/${widget.product!['id']}', payload);
        if (res['prices_changed'] == true) {
          setState(() => info = 'form.price_updated'.tr());
          await _loadHistory();
        } else if (mounted) {
          Navigator.pop(context, true);
        }
      } else {
        await FaidaBizApi.post('/products', payload);
        if (mounted) Navigator.pop(context, true);
      }
    } catch (e) {
      final msg = e.toString();
      setState(() {
        error = msg.contains('tayari ipo') || msg.toLowerCase().contains('duplicate')
            ? 'form.product_duplicate'.tr()
            : msg;
        if (error == 'form.product_duplicate'.tr()) nameExists = true;
      });
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    name.removeListener(_onNameChanged);
    name.dispose();
    stock.dispose();
    buy.dispose();
    sell.dispose();
    note.dispose();
    super.dispose();
  }

  Future<void> _delete() async {
    if (!isEdit) return;
    final ok = await confirmAndSoftDelete(
      context: context,
      title: 'delete.title_product'.tr(),
      itemLabel: widget.product?['name']?.toString(),
      onConfirm: (reason, password) async {
        await FaidaBizApi.delete('/products/${widget.product!['id']}', {
          'delete_reason': reason,
          'password': password,
        });
      },
    );
    if (ok && mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return FaidaBizNeuFormScaffold(
      appBar: faidaBizAppBar(title: isEdit ? 'form.edit_product'.tr() : 'home.add_product'.tr()),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FaidaBizNeuField(
            controller: name,
            label: 'form.product'.tr(),
            hint: 'form.product_name_hint'.tr(),
            errorText: nameExists ? 'form.product_duplicate'.tr() : null,
            textCapitalization: TextCapitalization.words,
            suffix: checkingName
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)),
                  )
                : (nameExists
                    ? const Icon(Icons.error_outline, color: Colors.red)
                    : (name.text.trim().isNotEmpty
                        ? const Icon(Icons.check_circle_outline, color: FaidaBizTheme.green)
                        : null)),
          ),
          if (nameExists && exactMatch != null) ...[
            const SizedBox(height: 8),
            FaidaBizNeuHint(
              color: Colors.red.shade700,
              icon: Icons.error_outline,
              child: Text(
                'form.product_duplicate_detail'.tr(args: [
                  exactMatch!['name']?.toString() ?? '',
                  '${exactMatch!['unit'] ?? ''}',
                ]),
                style: TextStyle(color: Colors.red.shade800, height: 1.35, fontSize: 13),
              ),
            ),
          ],
          if (!nameExists && similar.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text('form.product_similar_hint'.tr(), style: TextStyle(fontSize: 12.5, color: Colors.grey.shade700)),
            const SizedBox(height: 6),
            ...similar.map((p) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    '• ${p['name']} (${p['unit']})',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade800),
                  ),
                )),
          ],
          const SizedBox(height: 14),
          FaidaBizSelectField(
            label: 'form.unit'.tr(),
            hint: 'form.select_unit'.tr(),
            valueLabel: 'units.$unit'.tr(),
            leading: const Icon(Icons.straighten_rounded, color: Color(0xFF15803D), size: 22),
            onTap: () async {
              final picked = await showFaidaBizOptionPicker<String>(
                context: context,
                title: 'form.select_unit'.tr(),
                selected: unit,
                options: [
                  for (final u in kProductUnits) (value: u, label: 'units.$u'.tr(), subtitle: null),
                ],
              );
              if (picked != null) setState(() => unit = picked);
            },
          ),
          const SizedBox(height: 14),
          FaidaBizNeuField(
            controller: stock,
            label: 'form.stock'.tr(),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 14),
          FaidaBizNeuField(
            controller: buy,
            label: 'form.buying'.tr(),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 14),
          FaidaBizNeuField(
            controller: sell,
            label: 'form.selling'.tr(),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          if (isEdit) ...[
            const SizedBox(height: 14),
            FaidaBizNeuField(
              controller: note,
              label: 'form.edit_reason'.tr(),
              helperText: 'form.edit_reason_hint'.tr(),
              maxLines: 2,
            ),
          ],
          if (info != null) ...[
            const SizedBox(height: 8),
            Text(info!, style: const TextStyle(color: Color(0xFF15803D))),
          ],
          if (error != null && !nameExists) ...[
            const SizedBox(height: 8),
            Text(error!, style: const TextStyle(color: Colors.red)),
          ],
          const SizedBox(height: 24),
          NeuPrimaryButton(
            label: 'form.save'.tr(),
            loading: loading,
            onPressed: (loading || nameExists) ? null : _save,
          ),
          if (isEdit) ...[
            const SizedBox(height: 12),
            FaidaBizDetailActions(onDelete: _delete),
            const SizedBox(height: 28),
            Text('form.price_history'.tr(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 4),
            Text('form.price_history_hint'.tr(), style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
            const SizedBox(height: 8),
            ...history.map((h) {
              final m = h as Map<String, dynamic>;
              final from = m['effective_from']?.toString() ?? '';
              final to = m['effective_to']?.toString();
              return Card(
                child: ListTile(
                  title: Text(
                    '${'form.buying'.tr()}: ${m['buy_price']} · ${'form.selling'.tr()}: ${m['sell_price']}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    to == null || to.isEmpty
                        ? '$from (${'form.current_price'.tr()})'
                        : '$from → $to\n${m['reason'] ?? ''} ${m['note'] ?? ''}',
                  ),
                  isThreeLine: to != null && to.isNotEmpty,
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}
