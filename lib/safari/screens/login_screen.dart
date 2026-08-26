import 'package:flutter/material.dart';
import 'package:wicom/safari/safari_api.dart';
import 'package:wicom/safari/safari_brand.dart';
import 'package:wicom/safari/safari_theme.dart';
import 'package:wicom/safari/safari_ui.dart';
import 'package:wicom/safari/screens/otp_screen.dart';
import 'package:wicom/safari/screens/settings_screen.dart';

class SafariLoginScreen extends StatefulWidget {
  const SafariLoginScreen({super.key});

  @override
  State<SafariLoginScreen> createState() => _SafariLoginScreenState();
}

class _SafariLoginScreenState extends State<SafariLoginScreen> {
  final phone = TextEditingController();
  bool loading = false;

  Future<void> _send() async {
    setState(() => loading = true);
    try {
      final json = await SafariApi.post('/auth/otp/request', {'phone': phone.text.trim(), 'purpose': 'login'});
      if (!mounted) return;
      Navigator.push(context, MaterialPageRoute(builder: (_) => SafariOtpScreen(phone: phone.text.trim(), purpose: 'login', debugCode: SafariApi.data(json)?['debug_code']?.toString())));
    } catch (e) {
      await safariError(context, e);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 24),
            const SafariHero(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(SafariBrand.name, style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
                SizedBox(height: 8),
                Text(SafariBrand.tagline),
              ]),
            ),
            const SizedBox(height: 24),
            TextField(controller: phone, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Mobile number', hintText: '07XXXXXXXX')),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: loading ? null : _send, child: Text(loading ? 'Sending…' : 'Send OTP')),
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SafariSettingsScreen())),
              child: const Text('API settings', style: TextStyle(color: SafariTheme.muted)),
            ),
          ],
        ),
      ),
    );
  }
}
