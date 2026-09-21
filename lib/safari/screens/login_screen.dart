import 'package:flutter/material.dart';
import 'package:wicom/safari/safari_api.dart';
import 'package:wicom/safari/safari_brand.dart';
import 'package:wicom/safari/safari_gate.dart';
import 'package:wicom/safari/safari_google_auth.dart';
import 'package:wicom/safari/safari_nav.dart';
import 'package:wicom/safari/safari_theme.dart';
import 'package:wicom/safari/safari_ui.dart';
import 'package:wicom/safari/screens/forgot_password_screen.dart';
import 'package:wicom/safari/screens/register_screen.dart';
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

  Future<void> _google() async {
    setState(() => loading = true);
    try {
      final data = await SafariGoogleAuth.authenticate(isDriver: true);
      if (data == null) return;
      if (!mounted) return;
      if (data['needs_registration'] == true) {
        await SafariNav.push(
          context,
          SafariRegisterScreen(
            googleRegistrationToken: data['google_registration_token']?.toString(),
            email: data['email']?.toString(),
            googleName: data['name']?.toString(),
            isDriver: true,
          ),
        );
        return;
      }
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
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          SafariPhotoBanner(
            height: 220,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SafariWordmark(),
                const Spacer(),
                Text('Karibu', style: SafariTheme.display(color: Colors.white, size: 34)),
                const SizedBox(height: 4),
                const Text(
                  SafariBrand.tagline,
                  style: TextStyle(color: SafariTheme.goldSoft, fontWeight: FontWeight.w600, letterSpacing: 1.4, fontSize: 11),
                ),
              ],
            ),
          ),
          SafariPageBody(
            padding: const EdgeInsets.fromLTRB(22, 24, 22, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Sign in', style: SafariTheme.display(size: 28)),
                const SizedBox(height: 6),
                const Text('Use your mobile number and password.', style: TextStyle(color: SafariTheme.muted, fontSize: 14)),
                const SizedBox(height: 22),
                TextField(
                  controller: phone,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Mobile number', hintText: '07XXXXXXXX'),
                ),
                const SizedBox(height: 14),
                SafariPasswordField(controller: password),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => SafariNav.push(context, const SafariForgotPasswordScreen()),
                    child: const Text('Forgot password'),
                  ),
                ),
                SafariLoadingButton(label: 'Sign in', loading: loading, onPressed: _login),
                const SizedBox(height: 16),
                const Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('or', style: TextStyle(color: SafariTheme.muted))),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 16),
                SafariGoogleButton(loading: loading, onPressed: _google, label: 'Sign in with Google'),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => SafariNav.push(context, const SafariRegisterStartScreen()),
                  child: const Text('Create account'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
