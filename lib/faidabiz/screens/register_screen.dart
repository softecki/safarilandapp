import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wicom/faidabiz/faidabiz_api.dart';
import 'package:wicom/faidabiz/faidabiz_theme.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_chrome.dart';
import 'package:wicom/faidabiz/screens/otp_screen.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_neumorphic.dart';

class FaidaBizRegisterScreen extends StatefulWidget {
  const FaidaBizRegisterScreen({super.key});

  @override
  State<FaidaBizRegisterScreen> createState() => _FaidaBizRegisterScreenState();
}

class _FaidaBizRegisterScreenState extends State<FaidaBizRegisterScreen> {
  final name = TextEditingController();
  final phone = TextEditingController();
  final password = TextEditingController();
  bool loading = false;
  String? error;

  Future<void> _submit() async {
    if (phone.text.trim().isEmpty || password.text.isEmpty) {
      setState(() => error = 'auth.fill_required'.tr());
      return;
    }
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final res = await FaidaBizApi.register(
        name: name.text.trim().isEmpty ? null : name.text.trim(),
        phone: phone.text.trim(),
        password: password.text,
      );
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => FaidaBizOtpScreen(
            phone: res['phone']?.toString() ?? phone.text.trim(),
          ),
        ),
      );
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FaidaBizNeuFormScaffold(
      appBar: faidaBizAppBar(title: 'auth.register_biz'.tr()),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'auth.register_subtitle'.tr(),
            style: TextStyle(color: Colors.grey.shade700),
          ),
          const SizedBox(height: 24),
          FaidaBizNeuField(
            controller: name,
            label: 'auth.name'.tr(),
            hint: 'auth.name_optional_hint'.tr(),
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 14),
          FaidaBizNeuField(
            controller: phone,
            label: 'auth.phone'.tr(),
            hint: 'auth.phone_hint'.tr(),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 14),
          FaidaBizNeuField(
            controller: password,
            label: 'auth.password'.tr(),
            obscureText: true,
          ),
          if (error != null) ...[
            const SizedBox(height: 12),
            Text(error!, style: const TextStyle(color: Colors.red)),
          ],
          const SizedBox(height: 24),
          NeuPrimaryButton(
            label: 'auth.send_otp'.tr(),
            loading: loading,
            onPressed: loading ? null : _submit,
          ),
          const SizedBox(height: 12),
          Text(
            'brand.tagline'.tr(),
            textAlign: TextAlign.center,
            style: const TextStyle(color: FaidaBizTheme.greenDark),
          ),
        ],
      ),
    );
  }
}
