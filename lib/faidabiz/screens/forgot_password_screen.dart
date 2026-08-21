import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wicom/faidabiz/faidabiz_api.dart';
import 'package:wicom/faidabiz/faidabiz_offline.dart';
import 'package:wicom/faidabiz/faidabiz_theme.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_chrome.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_neumorphic.dart';

/// Forgot password: phone check → new password + confirm → update.
class FaidaBizForgotPasswordScreen extends StatefulWidget {
  const FaidaBizForgotPasswordScreen({super.key, this.initialPhone});

  final String? initialPhone;

  @override
  State<FaidaBizForgotPasswordScreen> createState() => _FaidaBizForgotPasswordScreenState();
}

class _FaidaBizForgotPasswordScreenState extends State<FaidaBizForgotPasswordScreen> {
  final phone = TextEditingController();
  final password = TextEditingController();
  final passwordConfirm = TextEditingController();

  /// 1 = enter phone, 2 = enter new password
  int step = 1;
  bool loading = false;
  String? error;
  String? verifiedPhone;

  @override
  void initState() {
    super.initState();
    final p = widget.initialPhone?.trim();
    if (p != null && p.isNotEmpty) {
      phone.text = p;
    }
  }

  @override
  void dispose() {
    phone.dispose();
    password.dispose();
    passwordConfirm.dispose();
    super.dispose();
  }

  Future<void> _checkPhone() async {
    final p = phone.text.trim();
    if (p.isEmpty) {
      setState(() => error = 'auth.forgot_phone_required'.tr());
      return;
    }
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final res = await FaidaBizApi.forgotPasswordCheck(phone: p);
      if (!mounted) return;
      setState(() {
        step = 2;
        verifiedPhone = res['phone']?.toString() ?? p;
        error = null;
      });
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> _resetPassword() async {
    final pass = password.text;
    final confirm = passwordConfirm.text;
    if (pass.isEmpty || confirm.isEmpty) {
      setState(() => error = 'auth.forgot_fill_passwords'.tr());
      return;
    }
    if (pass.length < 4) {
      setState(() => error = 'auth.forgot_password_min'.tr());
      return;
    }
    if (pass != confirm) {
      setState(() => error = 'auth.forgot_password_mismatch'.tr());
      return;
    }

    setState(() {
      loading = true;
      error = null;
    });
    try {
      final res = await FaidaBizApi.forgotPasswordReset(
        phone: verifiedPhone ?? phone.text.trim(),
        password: pass,
        passwordConfirmation: confirm,
      );
      if (!mounted) return;

      // Keep offline credentials in sync if this phone was stored.
      await FaidaBizOffline.load();
      if (FaidaBizOffline.storedPhone == (verifiedPhone ?? phone.text.trim()) ||
          FaidaBizOffline.storedPhone == phone.text.trim()) {
        await FaidaBizOffline.saveCredentials(
          phone: verifiedPhone ?? phone.text.trim(),
          password: pass,
        );
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res['message']?.toString() ?? 'auth.forgot_success'.tr())),
      );
      Navigator.of(context).pop(verifiedPhone ?? phone.text.trim());
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FaidaBizNeuFormScaffold(
      appBar: faidaBizAppBar(title: 'auth.forgot_title'.tr()),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            step == 1 ? 'auth.forgot_phone_hint'.tr() : 'auth.forgot_new_password_hint'.tr(),
            style: TextStyle(color: Colors.grey.shade700, height: 1.35),
          ),
          const SizedBox(height: 24),
          if (step == 1) ...[
            FaidaBizNeuField(
              controller: phone,
              label: 'auth.phone'.tr(),
              hint: 'auth.phone_hint'.tr(),
              keyboardType: TextInputType.phone,
            ),
          ] else ...[
            Text(
              verifiedPhone ?? phone.text.trim(),
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: FaidaBizTheme.greenDark,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            FaidaBizNeuField(
              controller: password,
              label: 'auth.forgot_new_password'.tr(),
              obscureText: true,
            ),
            const SizedBox(height: 14),
            FaidaBizNeuField(
              controller: passwordConfirm,
              label: 'auth.forgot_confirm_password'.tr(),
              obscureText: true,
            ),
            TextButton(
              onPressed: loading
                  ? null
                  : () => setState(() {
                        step = 1;
                        error = null;
                        password.clear();
                        passwordConfirm.clear();
                      }),
              child: Text('auth.forgot_change_phone'.tr()),
            ),
          ],
          if (error != null) ...[
            const SizedBox(height: 12),
            Text(error!, style: const TextStyle(color: Colors.red)),
          ],
          const SizedBox(height: 24),
          NeuPrimaryButton(
            label: step == 1 ? 'auth.forgot_continue'.tr() : 'auth.forgot_save'.tr(),
            loading: loading,
            onPressed: loading ? null : (step == 1 ? _checkPhone : _resetPassword),
          ),
        ],
      ),
    );
  }
}
