import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wicom/faidabiz/faidabiz_api.dart';
import 'package:wicom/faidabiz/faidabiz_theme.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_chrome.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_neumorphic.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_loader.dart';

class FaidaBizReferralsScreen extends StatefulWidget {
  const FaidaBizReferralsScreen({super.key});

  @override
  State<FaidaBizReferralsScreen> createState() => _FaidaBizReferralsScreenState();
}

class _FaidaBizReferralsScreenState extends State<FaidaBizReferralsScreen> {
  Map<String, dynamic>? referral;
  bool loading = true;
  final name = TextEditingController();
  final phone = TextEditingController();
  final withdrawPhone = TextEditingController();
  final withdrawName = TextEditingController();
  final withdrawAmount = TextEditingController();

  @override
  void initState() {
    super.initState();
    withdrawPhone.text = FaidaBizApi.user?['phone']?.toString() ?? '';
    withdrawName.text = FaidaBizApi.user?['name']?.toString() ?? '';
    _load();
  }

  @override
  void dispose() {
    name.dispose();
    phone.dispose();
    withdrawPhone.dispose();
    withdrawName.dispose();
    withdrawAmount.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => loading = true);
    try {
      final res = await FaidaBizApi.get('/subscription/referrals');
      if (!mounted) return;
      setState(() => referral = res['referral'] as Map<String, dynamic>?);
    } catch (_) {
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> _invite() async {
    try {
      final res = await FaidaBizApi.post('/subscription/invite', {
        'name': name.text.trim(),
        'phone': phone.text.trim(),
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['message']?.toString() ?? 'OK')));
      name.clear();
      phone.clear();
      _load();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> _withdraw() async {
    try {
      final res = await FaidaBizApi.post('/subscription/withdraw', {
        'amount': double.tryParse(withdrawAmount.text.trim()) ?? 0,
        'msisdn': withdrawPhone.text.trim(),
        'name': withdrawName.text.trim(),
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['message']?.toString() ?? 'OK')));
      _load();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final active = (referral?['active_balance'] as num?)?.toDouble() ?? 0;
    final inactive = (referral?['inactive_total'] as num?)?.toDouble() ?? 0;
    final earned = (referral?['earned_total'] as num?)?.toDouble() ?? 0;
    final items = (referral?['items'] as List?) ?? [];

    return Scaffold(
      appBar: faidaBizAppBar(title: 'subscription.invite_friends'.tr()),
      body: loading
          ? FaidaBizLoader.body()
          : FaidaBizNeuScope(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('subscription.earned'.tr(args: [FaidaBizTheme.money(earned)]),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 6),
                        Text('${'subscription.active_balance'.tr()}: ${FaidaBizTheme.money(active)}'),
                        Text('${'subscription.inactive_balance'.tr()}: ${FaidaBizTheme.money(inactive)}'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text('subscription.invite_title'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                FaidaBizNeuField(
                  controller: name,
                  label: 'auth.their_name'.tr(),
                ),
                const SizedBox(height: 14),
                FaidaBizNeuField(
                  controller: phone,
                  label: 'auth.phone'.tr(),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: _invite,
                  style: FilledButton.styleFrom(backgroundColor: FaidaBizTheme.green),
                  child: Text('subscription.send_invite'.tr()),
                ),
                if (active > 0) ...[
                  const SizedBox(height: 24),
                  Text('subscription.withdraw'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  FaidaBizNeuField(
                    controller: withdrawName,
                    label: 'auth.name'.tr(),
                  ),
                  const SizedBox(height: 14),
                  FaidaBizNeuField(
                    controller: withdrawPhone,
                    label: 'subscription.phone'.tr(),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 14),
                  FaidaBizNeuField(
                    controller: withdrawAmount,
                    label: 'subscription.withdraw_amount'.tr(),
                    hint: FaidaBizTheme.money(active),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: _withdraw,
                    style: FilledButton.styleFrom(backgroundColor: FaidaBizTheme.green),
                    child: Text('subscription.withdraw_btn'.tr()),
                  ),
                ],
                const SizedBox(height: 24),
                Text('subscription.invite_list'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...items.map((raw) {
                  final r = Map<String, dynamic>.from(raw as Map);
                  final earning = r['earning_status']?.toString() ?? 'inactive';
                  return Card(
                    child: ListTile(
                      title: Text(r['invitee_name']?.toString() ?? ''),
                      subtitle: Text('${r['invitee_phone']} · ${r['status']}'),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(FaidaBizTheme.money(r['bonus_amount']), style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                            earning == 'active' ? 'subscription.earning_active'.tr() : 'subscription.earning_inactive'.tr(),
                            style: TextStyle(
                              fontSize: 11,
                              color: earning == 'active' ? FaidaBizTheme.green : Colors.orange,
                            ),
                          ),
                        ],
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
