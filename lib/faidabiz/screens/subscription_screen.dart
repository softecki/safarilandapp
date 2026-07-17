import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wicom/faidabiz/faidabiz_api.dart';
import 'package:wicom/faidabiz/faidabiz_theme.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_loader.dart';

class FaidaBizSubscriptionScreen extends StatefulWidget {
  const FaidaBizSubscriptionScreen({super.key});

  @override
  State<FaidaBizSubscriptionScreen> createState() => _FaidaBizSubscriptionScreenState();
}

class _FaidaBizSubscriptionScreenState extends State<FaidaBizSubscriptionScreen> {
  Map<String, dynamic>? payload;
  List<Map<String, dynamic>> transactions = const [];
  bool loading = true;
  bool paying = false;
  bool refreshingStatus = false;
  String? error;
  String? refreshMessage;
  String paymentMode = 'annual';
  String pushType = 'voda_push';
  late final TextEditingController phone;

  @override
  void initState() {
    super.initState();
    phone = TextEditingController(text: FaidaBizApi.user?['phone']?.toString() ?? '');
    _load();
  }

  @override
  void dispose() {
    phone.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final res = await FaidaBizApi.get('/subscription');
      final txRes = await FaidaBizApi.get('/subscription/transactions');
      final txRaw = (txRes['data'] as List?) ?? const [];
      if (!mounted) return;
      setState(() {
        payload = res;
        transactions = txRaw.map((e) => Map<String, dynamic>.from(e as Map)).toList();
        final defaultPhone = res['default_phone']?.toString().trim();
        if (defaultPhone != null && defaultPhone.isNotEmpty) phone.text = defaultPhone;
        final modes = (res['subscription']?['payment_modes'] as List?) ?? [];
        if (modes.isNotEmpty) {
          final current = res['subscription']?['payment_mode']?.toString();
          paymentMode = (current != null && modes.any((m) => m is Map && m['id'] == current))
              ? current
              : (modes.first['id']?.toString() ?? 'annual');
        }
      });
    } catch (e) {
      if (mounted) setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> _refreshPaymentStatus() async {
    setState(() {
      refreshingStatus = true;
      refreshMessage = null;
    });
    try {
      final res = await FaidaBizApi.post('/subscription/refresh-status', {});
      if (!mounted) return;
      setState(() {
        payload = {
          ...?payload,
          'subscription': Map<String, dynamic>.from(res['subscription'] as Map? ?? {}),
        };
        final txRaw = (res['transactions'] as List?) ?? const [];
        transactions = txRaw.map((e) => Map<String, dynamic>.from(e as Map)).toList();
        refreshMessage = res['message']?.toString();
      });
      await _load();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => refreshingStatus = false);
    }
  }

  Map<String, dynamic> get sub => payload?['subscription'] as Map<String, dynamic>? ?? {};
  List get networks => (payload?['networks'] as List?) ?? [];
  List get modes => (sub['payment_modes'] as List?) ?? [];

  double get selectedAmount {
    for (final m in modes) {
      if (m is Map && m['id']?.toString() == paymentMode) {
        return (m['amount'] as num?)?.toDouble() ?? 0;
      }
    }
    return 0;
  }

  Color get _statusColor => FaidaBizTheme.subscriptionStatusColor(sub['status']?.toString());

  Map<String, dynamic> get paymentReminder =>
      sub['payment_reminder'] is Map ? Map<String, dynamic>.from(sub['payment_reminder'] as Map) : const {};

  Future<void> _pay() async {
    if (phone.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('subscription.phone_required'.tr())),
      );
      return;
    }
    setState(() => paying = true);
    try {
      final res = await FaidaBizApi.post('/subscription/pay', {
        'payment_mode': paymentMode,
        'msisdn': phone.text.trim(),
        'push_type': pushType,
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: FaidaBizTheme.green,
          content: Text(res['message']?.toString() ?? 'subscription.payment_sent'.tr()),
        ),
      );
      _load();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => paying = false);
    }
  }

  Future<void> _requestExtension() async {
    try {
      final res = await FaidaBizApi.post('/subscription/extend-trial', {});
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res['message']?.toString() ?? 'OK')),
      );
      _load();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = sub['status']?.toString() ?? 'none';
    final label = sub['label']?.toString() ?? status;
    final daysLeft = sub['days_left'];
    final pendingExt = sub['pending_extension'] == true;
    final annual = sub['annual_amount'] ?? sub['settings']?['annual_amount'];

    return Scaffold(
      backgroundColor: const Color(0xFFF7FBF8),
      appBar: AppBar(
        title: Text('subscription.title'.tr()),
        actions: [
          TextButton.icon(
            onPressed: refreshingStatus || loading ? null : _refreshPaymentStatus,
            icon: refreshingStatus
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.refresh_rounded, size: 20),
            label: Text('subscription.refresh_status'.tr()),
            style: TextButton.styleFrom(foregroundColor: Colors.white),
          ),
        ],
      ),
      body: loading
          ? FaidaBizLoader.body()
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                    children: [
                      if (error != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(error!, style: const TextStyle(color: Colors.red)),
                        ),
                      if (paymentReminder['show'] == true) ...[
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF7ED),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFFDBA74)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.warning_amber_rounded, color: Color(0xFFC2410C)),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'subscription.reminder_title'.tr(),
                                      style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF9A3412)),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      paymentReminder['message']?.toString()
                                          ?? 'subscription.reminder_body'.tr(args: ['${paymentReminder['days_left'] ?? ''}']),
                                      style: TextStyle(color: Colors.grey.shade800, fontSize: 13, height: 1.35),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                      ],
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [_statusColor, _statusColor.withValues(alpha: 0.75)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: _statusColor.withValues(alpha: 0.25),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'subscription.status'.tr().toUpperCase(),
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(label, style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800)),
                            if (daysLeft != null) ...[
                              const SizedBox(height: 6),
                              Text(
                                'subscription.days_left'.tr(args: ['$daysLeft']),
                                style: TextStyle(color: Colors.white.withValues(alpha: 0.95), fontSize: 14),
                              ),
                            ],
                            if (sub['installments_paid'] != null && sub['installments_total'] != null) ...[
                              const SizedBox(height: 6),
                              Text(
                                'subscription.installments_paid'.tr(args: [
                                  '${sub['installments_paid']}',
                                  '${sub['installments_total']}',
                                ]),
                                style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 13),
                              ),
                            ],
                            if (annual != null) ...[
                              const SizedBox(height: 14),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${'subscription.annual_fee'.tr()}: ${FaidaBizTheme.money(annual)}',
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (status == 'trial' || status == 'expired') ...[
                        const SizedBox(height: 14),
                        OutlinedButton.icon(
                          onPressed: pendingExt ? null : _requestExtension,
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(46),
                            side: BorderSide(color: FaidaBizTheme.green.withValues(alpha: 0.5)),
                            foregroundColor: FaidaBizTheme.greenDark,
                          ),
                          icon: const Icon(Icons.more_time_rounded),
                          label: Text(pendingExt ? 'subscription.extension_pending'.tr() : 'subscription.request_extension'.tr()),
                        ),
                      ],
                      if (refreshMessage != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          refreshMessage!,
                          style: TextStyle(
                            color: refreshMessage!.toLowerCase().contains('active') ? FaidaBizTheme.greenDark : Colors.orange.shade800,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                      const SizedBox(height: 22),
                      Text('subscription.pay_title'.tr(), style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 4),
                      Text('subscription.pay_hint'.tr(), style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                      const SizedBox(height: 12),
                      ...modes.map((m) {
                        final id = m['id']?.toString() ?? '';
                        final amount = m['amount'];
                        final parts = m['parts'] ?? 1;
                        final selected = paymentMode == id;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Material(
                            color: selected ? const Color(0xFFECFDF3) : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () => setState(() => paymentMode = id),
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: selected ? FaidaBizTheme.green : Colors.grey.shade200,
                                    width: selected ? 1.6 : 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      selected ? Icons.radio_button_checked : Icons.radio_button_off,
                                      color: selected ? FaidaBizTheme.green : Colors.grey,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'subscription.mode_$id'.tr(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: selected ? FaidaBizTheme.greenDark : Colors.black87,
                                            ),
                                          ),
                                          Text(
                                            'subscription.mode_parts'.tr(args: ['$parts']),
                                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      FaidaBizTheme.money(amount),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 15,
                                        color: selected ? FaidaBizTheme.green : Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 8),
                      Text('subscription.phone'.tr(), style: const TextStyle(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: phone,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: '07XXXXXXXX',
                          prefixIcon: const Icon(Icons.phone_iphone_rounded, color: FaidaBizTheme.green),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text('subscription.network'.tr(), style: const TextStyle(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: networks.map((n) {
                          final pt = n['push_type']?.toString() ?? '';
                          final selected = pushType == pt;
                          final netId = n['id']?.toString() ?? pt;
                          return ChoiceChip(
                            selected: selected,
                            label: Text('subscription.net_$netId'.tr()),
                            selectedColor: FaidaBizTheme.green.withValues(alpha: 0.15),
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: selected ? FaidaBizTheme.greenDark : Colors.black87,
                            ),
                            side: BorderSide(color: selected ? FaidaBizTheme.green : Colors.grey.shade300),
                            onSelected: (_) => setState(() => pushType = pt),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 18),
                      Text('subscription.transactions_title'.tr(), style: const TextStyle(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 8),
                      if (transactions.isEmpty)
                        Text(
                          'subscription.transactions_empty'.tr(),
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                        )
                      else
                        ...transactions.take(10).map((tx) {
                          final status = tx['status']?.toString() ?? 'pending';
                          final amount = FaidaBizTheme.money(tx['amount']);
                          final ref = tx['deposit_request_id']?.toString() ?? tx['payment_request_id']?.toString() ?? '-';
                          final date = tx['paid_at']?.toString() ?? tx['created_at']?.toString() ?? '';
                          final color = switch (status) {
                            'success' => FaidaBizTheme.green,
                            'failed' => Colors.red.shade700,
                            'cancelled' => Colors.grey.shade700,
                            _ => Colors.orange.shade700,
                          };
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              dense: true,
                              title: Text('$amount • ${'subscription.mode_${tx['payment_mode'] ?? 'annual'}'.tr()}'),
                              subtitle: Text('$ref\n$date', style: const TextStyle(fontSize: 12)),
                              isThreeLine: true,
                              trailing: Text(
                                'subscription.tx_status_$status'.tr(),
                                style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 12),
                              ),
                            ),
                          );
                        }),
                    ],
                  ),
                ),
                SafeArea(
                  top: false,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 12,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('subscription.pay_amount'.tr(), style: TextStyle(color: Colors.grey.shade700)),
                            Text(
                              FaidaBizTheme.money(selectedAmount),
                              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: FaidaBizTheme.greenDark),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        FilledButton.icon(
                          onPressed: paying ? null : _pay,
                          style: FilledButton.styleFrom(
                            backgroundColor: FaidaBizTheme.green,
                            minimumSize: const Size.fromHeight(52),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          icon: paying
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                )
                              : const Icon(Icons.lock_outline_rounded),
                          label: Text(
                            paying ? 'subscription.sending'.tr() : 'subscription.pay_now'.tr(),
                            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
