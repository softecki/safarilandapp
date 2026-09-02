import 'package:flutter/material.dart';
import 'package:wicom/safari/safari_api.dart';
import 'package:wicom/safari/safari_nav.dart';
import 'package:wicom/safari/safari_theme.dart';
import 'package:wicom/safari/safari_ui.dart';
import 'package:wicom/safari/screens/otp_screen.dart';

class SafariForgotPasswordScreen extends StatefulWidget {
  const SafariForgotPasswordScreen({super.key});

  @override
  State<SafariForgotPasswordScreen> createState() => _SafariForgotPasswordScreenState();
}

class _SafariForgotPasswordScreenState extends State<SafariForgotPasswordScreen> {
  final phone = TextEditingController();
  final email = TextEditingController();
  bool loading = false;

  @override
  void dispose() {
    phone.dispose();
    email.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    setState(() => loading = true);
    try {
      final json = await SafariApi.post('/auth/otp/request', {
        'phone': phone.text.trim(),
        'email': email.text.trim().isEmpty ? null : email.text.trim(),
        'purpose': 'reset',
      });
      final data = Map<String, dynamic>.from(SafariApi.data(json) as Map);
      if (!mounted) return;
      await SafariNav.push(
        context,
        SafariOtpScreen(
          phone: phone.text.trim(),
          email: email.text.trim().isEmpty ? data['email']?.toString() : email.text.trim(),
          purpose: 'reset',
          debugCode: data['debug_code']?.toString(),
          sentTo: (data['sent_to'] as List?)?.map((e) => e.toString()).toList() ?? const [],
        ),
      );
    } catch (e) {
      await safariError(context, e);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot password')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text('Enter the phone on your account. A one-time code is sent by SMS and to your email if we have it.', style: TextStyle(color: SafariTheme.muted)),
          const SizedBox(height: 20),
          TextField(controller: phone, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Mobile number')),
          const SizedBox(height: 12),
          TextField(controller: email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email (optional)')),
          const SizedBox(height: 20),
          SafariLoadingButton(label: 'Send code', loading: loading, onPressed: _send),
        ],
      ),
    );
  }
}
