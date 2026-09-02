import 'package:flutter/material.dart';
import 'package:wicom/safari/safari_api.dart';
import 'package:wicom/safari/safari_nav.dart';
import 'package:wicom/safari/safari_theme.dart';
import 'package:wicom/safari/safari_ui.dart';
import 'package:wicom/safari/screens/register_screen.dart';
import 'package:wicom/safari/screens/reset_password_screen.dart';

class SafariOtpScreen extends StatefulWidget {
  const SafariOtpScreen({
    super.key,
    required this.phone,
    required this.purpose,
    this.email,
    this.debugCode,
    this.sentTo = const [],
    this.isDriver = false,
  });

  final String phone;
  final String purpose;
  final String? email;
  final String? debugCode;
  final List<String> sentTo;
  final bool isDriver;

  @override
  State<SafariOtpScreen> createState() => _SafariOtpScreenState();
}

class _SafariOtpScreenState extends State<SafariOtpScreen> {
  final code = TextEditingController();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.debugCode != null) code.text = widget.debugCode!;
  }

  @override
  void dispose() {
    code.dispose();
    super.dispose();
  }

  String get _hint {
    final parts = <String>[widget.phone];
    if (widget.email != null && widget.email!.isNotEmpty) parts.add(widget.email!);
    return 'We sent a one-time code to ${parts.join(' and ')}. Use it once to verify your account.';
  }

  Future<void> _verify() async {
    setState(() => loading = true);
    try {
      final json = await SafariApi.post('/auth/otp/verify', {
        'phone': widget.phone,
        'email': widget.email,
        'code': code.text.trim(),
        'purpose': widget.purpose,
        'is_driver': widget.isDriver,
      });
      final data = SafariApi.data(json) as Map<String, dynamic>;
      if (!mounted) return;
      if (widget.purpose == 'reset') {
        await SafariNav.replace(context, SafariResetPasswordScreen(resetToken: data['reset_token'].toString()));
        return;
      }
      await SafariNav.replace(
        context,
        SafariRegisterScreen(
          phone: widget.phone,
          email: widget.email,
          registrationToken: data['registration_token'].toString(),
          isDriver: widget.isDriver,
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
      appBar: AppBar(title: const Text('Enter code')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(_hint, style: const TextStyle(color: SafariTheme.muted)),
          const SizedBox(height: 20),
          TextField(
            controller: code,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 28, letterSpacing: 10, fontWeight: FontWeight.w800),
            decoration: const InputDecoration(labelText: 'OTP'),
          ),
          const SizedBox(height: 20),
          SafariLoadingButton(label: 'Verify', loading: loading, onPressed: _verify),
        ],
      ),
    );
  }
}
