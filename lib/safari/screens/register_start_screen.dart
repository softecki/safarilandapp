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
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text('We will send a one-time code to your phone and email.', style: TextStyle(color: SafariTheme.muted)),
          const SizedBox(height: 20),
          TextField(controller: phone, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Mobile number', hintText: '07XXXXXXXX')),
          const SizedBox(height: 12),
          TextField(controller: email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email')),
          const SizedBox(height: 16),
          SafariCard(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: SwitchListTile(
              value: isDriver,
              onChanged: (v) => setState(() => isDriver = v),
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              title: const Text('I am a driver', style: TextStyle(fontWeight: FontWeight.w800)),
              subtitle: const Text('On = driver-guide. Off = guest.', style: TextStyle(color: SafariTheme.muted, fontSize: 12)),
            ),
          ),
          const SizedBox(height: 20),
          SafariLoadingButton(label: 'Send code', loading: loading, onPressed: _send),
        ],
      ),
    );
  }
}
