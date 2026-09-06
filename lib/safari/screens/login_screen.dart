import 'package:flutter/material.dart';
import 'package:wicom/safari/safari_api.dart';
import 'package:wicom/safari/safari_gate.dart';
import 'package:wicom/safari/safari_nav.dart';
import 'package:wicom/safari/safari_theme.dart';
import 'package:wicom/safari/safari_ui.dart';
import 'package:wicom/safari/screens/forgot_password_screen.dart';
import 'package:wicom/safari/screens/otp_screen.dart';
import 'package:wicom/safari/screens/register_start_screen.dart';

class SafariLoginScreen extends StatefulWidget {
  const SafariLoginScreen({super.key});

  @override
  State<SafariLoginScreen> createState() => _SafariLoginScreenState();
}

class _SafariLoginScreenState extends State<SafariLoginScreen> {
  final phone = TextEditingController();
  final password = TextEditingController();
  bool loading = false;

  @override
  void dispose() {
    phone.dispose();
    password.dispose();
    super.dispose();
  }

  Future<void> _otp() async {
    if (phone.text.trim().isEmpty) {
      await safariError(context, 'Enter your mobile number first');
      return;
    }
    setState(() => loading = true);
    try {
      final json = await SafariApi.post('/auth/otp/request', {
        'phone': phone.text.trim(),
        'purpose': 'login',
      });
      final data = Map<String, dynamic>.from(SafariApi.data(json) as Map);
      if (!mounted) return;
      await SafariNav.push(
        context,
        SafariOtpScreen(
          phone: phone.text.trim(),
          purpose: 'login',
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

  Future<void> _login() async {
    setState(() => loading = true);
    try {
      final json = await SafariApi.post('/auth/login', {
        'phone': phone.text.trim(),
        'password': password.text,
      });
      final data = SafariApi.data(json) as Map<String, dynamic>;
      await SafariApi.saveAuth(data['token'].toString(), Map<String, dynamic>.from(data['driver'] as Map));
      if (!mounted) return;
      SafariNav.reset(context, SafariGate.home());
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
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          children: [
            const SizedBox(height: 36),
            const Center(child: SafariLogo(height: 92)),
            const SizedBox(height: 14),
            const SafariTagline(),
            const SizedBox(height: 36),
            Text('Sign in', style: Theme.of(context).textTheme.displaySmall),
            const SizedBox(height: 8),
            const Text('Sign in with your phone and password, or request a one-time code.', style: TextStyle(color: SafariTheme.muted)),
            const SizedBox(height: 24),
            TextField(
              controller: phone,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Mobile number', hintText: '07XXXXXXXX'),
            ),
            const SizedBox(height: 12),
            SafariPasswordField(controller: password),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => SafariNav.push(context, const SafariForgotPasswordScreen()),
                style: TextButton.styleFrom(visualDensity: VisualDensity.compact, padding: const EdgeInsets.symmetric(horizontal: 4)),
                child: const Text('Forgot Password', style: TextStyle(fontSize: 12, color: SafariTheme.muted)),
              ),
            ),
            SafariLoadingButton(label: 'Sign in', loading: loading, onPressed: _login),
            const SizedBox(height: 8),
            OutlinedButton(onPressed: loading ? null : _otp, child: const Text('Sign in with OTP')),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => SafariNav.push(context, const SafariRegisterStartScreen()),
              child: const Text('Create account'),
            ),
          ],
        ),
      ),
    );
  }
}
