import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wicom/faidabiz/faidabiz_api.dart';
import 'package:wicom/faidabiz/faidabiz_theme.dart';
import 'package:wicom/faidabiz/screens/otp_screen.dart';

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
    if (name.text.trim().isEmpty || phone.text.trim().isEmpty || password.text.isEmpty) {
      setState(() => error = 'auth.fill_all'.tr());
      return;
    }
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final res = await FaidaBizApi.register(
        name: name.text.trim(),
        phone: phone.text.trim(),
        password: password.text,
      );
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => FaidaBizOtpScreen(
            phone: res['phone']?.toString() ?? phone.text.trim(),
            debugCode: res['debug_code']?.toString(),
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
    return Scaffold(
      appBar: AppBar(title: Text('auth.register'.tr())),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'auth.register_subtitle'.tr(),
            style: TextStyle(color: Colors.grey.shade700),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: name,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(labelText: 'auth.name'.tr()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: phone,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(labelText: 'auth.phone'.tr(), hintText: '07XXXXXXXX'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: password,
            obscureText: true,
            decoration: InputDecoration(labelText: 'auth.password'.tr()),
          ),
          if (error != null) ...[
            const SizedBox(height: 12),
            Text(error!, style: const TextStyle(color: Colors.red)),
          ],
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: loading ? null : _submit,
            child: loading
                ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : Text('auth.send_otp'.tr()),
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
