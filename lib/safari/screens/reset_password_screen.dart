import 'package:flutter/material.dart';
import 'package:wicom/safari/safari_api.dart';
import 'package:wicom/safari/safari_nav.dart';
import 'package:wicom/safari/safari_theme.dart';
import 'package:wicom/safari/safari_ui.dart';
import 'package:wicom/safari/screens/login_screen.dart';

class SafariResetPasswordScreen extends StatefulWidget {
  const SafariResetPasswordScreen({super.key, required this.resetToken});
  final String resetToken;

  @override
  State<SafariResetPasswordScreen> createState() => _SafariResetPasswordScreenState();
}

class _SafariResetPasswordScreenState extends State<SafariResetPasswordScreen> {
  final password = TextEditingController();
  final confirm = TextEditingController();
  bool loading = false;

  @override
  void dispose() {
    password.dispose();
    confirm.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => loading = true);
    try {
      await SafariApi.post('/auth/password/reset', {
        'reset_token': widget.resetToken,
        'password': password.text,
        'password_confirmation': confirm.text,
      });
      if (!mounted) return;
      SafariNav.reset(context, const SafariLoginScreen());
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password saved. Sign in with phone and password.')));
    } catch (e) {
      await safariError(context, e);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New password')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text('Choose a password. After this, always sign in with your phone number and password.', style: TextStyle(color: SafariTheme.muted)),
          const SizedBox(height: 20),
          SafariPasswordField(controller: password, label: 'New password'),
          const SizedBox(height: 12),
          SafariPasswordField(controller: confirm, label: 'Confirm password'),
          const SizedBox(height: 20),
          SafariLoadingButton(label: 'Save password', loading: loading, onPressed: _save),
        ],
      ),
    );
  }
}
