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
  bool isDriver = false;
  bool loading = false;

  @override
  void dispose() {
    phone.dispose();
    email.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (email.text.trim().isEmpty) {
      await safariError(context, 'Email is required');
      return;
    }
    setState(() => loading = true);
    try {
      final json = await SafariApi.post('/auth/otp/request', {
        'phone': phone.text.trim(),
        'email': email.text.trim(),
        'purpose': 'register',
        'is_driver': isDriver,
      });
      final data = Map<String, dynamic>.from(SafariApi.data(json) as Map);
      if (!mounted) return;
      await SafariNav.push(
        context,
        SafariOtpScreen(
          phone: phone.text.trim(),
          email: email.text.trim(),
          purpose: 'register',
          isDriver: isDriver,
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
      body: SafariPageBody(
        padding: const EdgeInsets.fromLTRB(22, 8, 22, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Join Safari Land', style: SafariTheme.display(size: 28)),
            const SizedBox(height: 8),
            const Text('We will send a one-time code to your phone and email.', style: TextStyle(color: SafariTheme.muted, fontSize: 14)),
            const SizedBox(height: 22),
            TextField(controller: phone, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Mobile number', hintText: '07XXXXXXXX')),
            const SizedBox(height: 14),
            TextField(controller: email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 16),
            SafariCard(
              child: Row(
                children: [
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(isDriver ? 'Driver-guide' : 'Guide partner', style: const TextStyle(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      const Text('Choose the role that matches how you work.', style: TextStyle(color: SafariTheme.muted, fontSize: 12)),
                    ]),
                  ),
                  Switch(value: isDriver, onChanged: (v) => setState(() => isDriver = v)),
                ],
              ),
            ),
            const SizedBox(height: 22),
            SafariLoadingButton(label: 'Send code', loading: loading, onPressed: _send),
          ],
        ),
      ),
    );
  }
}
