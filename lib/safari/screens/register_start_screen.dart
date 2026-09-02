import 'package:flutter/material.dart';
import 'package:wicom/safari/safari_api.dart';
import 'package:wicom/safari/safari_nav.dart';
import 'package:wicom/safari/safari_theme.dart';
import 'package:wicom/safari/safari_ui.dart';
import 'package:wicom/safari/screens/otp_screen.dart';

class SafariRegisterStartScreen extends StatefulWidget {
  const SafariRegisterStartScreen({super.key});

  @override
  State<SafariRegisterStartScreen> createState() => _SafariRegisterStartScreenState();
}

class _SafariRegisterStartScreenState extends State<SafariRegisterStartScreen> {
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
        'purpose': 'register',
      });
      final data = Map<String, dynamic>.from(SafariApi.data(json) as Map);
      if (!mounted) return;
      await SafariNav.push(
        context,
        SafariOtpScreen(
          phone: phone.text.trim(),
          email: email.text.trim().isEmpty ? null : email.text.trim(),
          purpose: 'register',
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
      appBar: AppBar(title: const Text('Create account')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text('We will send a one-time code to your phone. If you add an email, the same code is also sent there.', style: TextStyle(color: SafariTheme.muted)),
          const SizedBox(height: 20),
          TextField(controller: phone, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Mobile number', hintText: '07XXXXXXXX')),
          const SizedBox(height: 12),
          TextField(controller: email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email (optional)')),
          const SizedBox(height: 20),
          SafariLoadingButton(label: 'Send code', loading: loading, onPressed: _send),
        ],
      ),
    );
  }
}
