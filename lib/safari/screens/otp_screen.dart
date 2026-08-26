import 'package:flutter/material.dart';
import 'package:wicom/safari/safari_api.dart';
import 'package:wicom/safari/safari_shell.dart';
import 'package:wicom/safari/safari_ui.dart';
import 'package:wicom/safari/screens/pending_screen.dart';
import 'package:wicom/safari/screens/register_screen.dart';

class SafariOtpScreen extends StatefulWidget {
  const SafariOtpScreen({super.key, required this.phone, required this.purpose, this.debugCode});
  final String phone;
  final String purpose;
  final String? debugCode;

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

  Future<void> _verify() async {
    setState(() => loading = true);
    try {
      final json = await SafariApi.post('/auth/otp/verify', {
        'phone': widget.phone,
        'code': code.text.trim(),
        'purpose': widget.purpose,
      });
      final data = SafariApi.data(json) as Map<String, dynamic>;
      if (!mounted) return;
      if (data['needs_registration'] == true) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SafariRegisterScreen(
          phone: widget.phone,
          registrationToken: data['registration_token'].toString(),
        )));
        return;
      }
      await SafariApi.saveAuth(data['token'].toString(), Map<String, dynamic>.from(data['driver'] as Map));
      if (!mounted) return;
      final status = (SafariApi.driver?['status'] ?? '').toString();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => status == 'ACTIVE' ? const SafariShell() : const SafariPendingScreen()),
        (_) => false,
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
          Text('We sent a code to ${widget.phone}'),
          const SizedBox(height: 16),
          TextField(controller: code, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'OTP')),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: loading ? null : _verify, child: Text(loading ? 'Checking…' : 'Verify')),
        ],
      ),
    );
  }
}
