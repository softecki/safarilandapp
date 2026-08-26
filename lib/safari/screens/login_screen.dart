import 'package:flutter/material.dart';
import 'package:wicom/safari/safari_api.dart';
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          children: [
            const SizedBox(height: 36),
            const Center(child: SafariLogo(height: 88)),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                'TANZANIA',
                textAlign: TextAlign.center,
                style: TextStyle(letterSpacing: 6, fontSize: 11, fontWeight: FontWeight.w600, color: SafariTheme.black),
              ),
            ),
            const SizedBox(height: 48),
            TextField(
              controller: phone,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Mobile number', hintText: '07XXXXXXXX'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: loading ? null : _send, child: Text(loading ? 'Sending…' : 'Send OTP')),
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SafariSettingsScreen())),
              child: const Text('API settings', style: TextStyle(color: SafariTheme.muted, letterSpacing: 0.6)),
            ),
          ],
        ),
      ),
    );
  }
}
