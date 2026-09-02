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
  bool loading = false;

  @override
  void dispose() {
    phone.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    setState(() => loading = true);
    try {
      final json = await SafariApi.post('/auth/otp/request', {
        'phone': phone.text.trim(),
        'purpose': 'reset',
      });
      final data = Map<String, dynamic>.from(SafariApi.data(json) as Map);
      if (!mounted) return;
      await SafariNav.push(
        context,
        SafariOtpScreen(
          phone: phone.text.trim(),
          email: data['email']?.toString(),
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
          const Text('Enter the mobile number on your account. We will send a one-time code.', style: TextStyle(color: SafariTheme.muted)),
          const SizedBox(height: 20),
          TextField(controller: phone, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Mobile number', hintText: '07XXXXXXXX')),
          const SizedBox(height: 20),
          SafariLoadingButton(label: 'Send code', loading: loading, onPressed: _send),
        ],
      ),
    );
  }
}
