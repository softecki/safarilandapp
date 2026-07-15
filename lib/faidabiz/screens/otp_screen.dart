import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wicom/faidabiz/faidabiz_api.dart';
import 'package:wicom/faidabiz/faidabiz_shell.dart';
import 'package:wicom/faidabiz/faidabiz_theme.dart';

class FaidaBizOtpScreen extends StatefulWidget {
  const FaidaBizOtpScreen({
    super.key,
    required this.phone,
    this.debugCode,
  });

  final String phone;
  final String? debugCode;

  @override
  State<FaidaBizOtpScreen> createState() => _FaidaBizOtpScreenState();
}

class _FaidaBizOtpScreenState extends State<FaidaBizOtpScreen> {
  final controllers = List.generate(6, (_) => TextEditingController());
  final focuses = List.generate(6, (_) => FocusNode());
  bool loading = false;
  String? error;
  String? hint;

  @override
  void initState() {
    super.initState();
    if (widget.debugCode != null && widget.debugCode!.length == 6) {
      hint = 'Debug: ${widget.debugCode}';
    }
  }

  @override
  void dispose() {
    for (final c in controllers) {
      c.dispose();
    }
    for (final f in focuses) {
      f.dispose();
    }
    super.dispose();
  }

  String get code => controllers.map((c) => c.text).join();

  Future<void> _verify() async {
    if (code.length != 6) {
      setState(() => error = 'auth.otp_incomplete'.tr());
      return;
    }
    setState(() {
      loading = true;
      error = null;
    });
    try {
      await FaidaBizApi.verifyOtp(phone: widget.phone, code: code);
      if (!mounted) return;
      await FaidaBizApi.applyLocaleFromUser(context);
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const FaidaBizShell()),
        (_) => false,
      );
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> _resend() async {
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final res = await FaidaBizApi.resendOtp(phone: widget.phone);
      final debug = res['debug_code']?.toString();
      setState(() {
        hint = debug != null ? 'Debug: $debug' : 'auth.otp_resent'.tr();
      });
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('auth.verify_title'.tr())),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'auth.verify_hint'.tr(),
            style: TextStyle(color: Colors.grey.shade700, height: 1.4),
          ),
          const SizedBox(height: 8),
          Text(
            widget.phone,
            style: const TextStyle(fontWeight: FontWeight.bold, color: FaidaBizTheme.green),
          ),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(6, (i) {
              return SizedBox(
                width: 46,
                child: TextField(
                  controller: controllers[i],
                  focusNode: focuses[i],
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  maxLength: 1,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    counterText: '',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: FaidaBizTheme.green, width: 2),
                    ),
                  ),
                  onChanged: (v) {
                    if (v.isNotEmpty && i < 5) {
                      focuses[i + 1].requestFocus();
                    }
                    if (v.isEmpty && i > 0) {
                      focuses[i - 1].requestFocus();
                    }
                    if (code.length == 6) _verify();
                  },
                ),
              );
            }),
          ),
          if (hint != null) ...[
            const SizedBox(height: 12),
            Text(hint!, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
          ],
          if (error != null) ...[
            const SizedBox(height: 12),
            Text(error!, style: const TextStyle(color: Colors.red)),
          ],
          const SizedBox(height: 28),
          ElevatedButton(
            onPressed: loading ? null : _verify,
            child: loading
                ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : Text('auth.verify'.tr()),
          ),
          TextButton(
            onPressed: loading ? null : _resend,
            child: Text('auth.resend_otp'.tr()),
          ),
        ],
      ),
    );
  }
}
