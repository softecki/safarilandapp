import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wicom/faidabiz/faidabiz_api.dart';
import 'package:wicom/faidabiz/faidabiz_offline.dart';
import 'package:wicom/faidabiz/faidabiz_shell.dart';
import 'package:wicom/faidabiz/faidabiz_theme.dart';
import 'package:wicom/faidabiz/screens/forgot_password_screen.dart';
import 'package:wicom/faidabiz/screens/otp_screen.dart';
import 'package:wicom/faidabiz/screens/register_screen.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_neumorphic.dart';
import 'package:wicom/faidabiz/widgets/landing_backdrop.dart';

class FaidaBizLoginScreen extends StatefulWidget {
  const FaidaBizLoginScreen({super.key});

  @override
  State<FaidaBizLoginScreen> createState() => _FaidaBizLoginScreenState();
}

class _FaidaBizLoginScreenState extends State<FaidaBizLoginScreen> with SingleTickerProviderStateMixin {
  final phone = TextEditingController();
  final password = TextEditingController();
  bool loading = false;
  String? error;
  late final AnimationController _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..forward();
  late final Animation<double> _fade = CurvedAnimation(parent: _anim, curve: Curves.easeOut);
  late final Animation<Offset> _slide = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
      .animate(CurvedAnimation(parent: _anim, curve: Curves.easeOutCubic));

  @override
  void initState() {
    super.initState();
    _prefillPhone();
  }

  Future<void> _prefillPhone() async {
    await FaidaBizOffline.load();
    final p = FaidaBizOffline.storedPhone;
    if (p != null && p.isNotEmpty && mounted) {
      phone.text = p;
    }
  }

  @override
  void dispose() {
    _anim.dispose();
    phone.dispose();
    password.dispose();
    super.dispose();
  }

  Future<void> _setLanguage(Locale next) async {
    await context.setLocale(next);
    if (mounted) setState(() {});
  }

  Future<void> _openForgotPassword() async {
    final updatedPhone = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (_) => FaidaBizForgotPasswordScreen(
          initialPhone: phone.text.trim(),
        ),
      ),
    );
    if (updatedPhone != null && updatedPhone.isNotEmpty && mounted) {
      phone.text = updatedPhone;
      password.clear();
    }
  }

  Future<void> _submit() async {
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final res = await FaidaBizApi.login(phone: phone.text.trim(), password: password.text);
      if (!mounted) return;
      if (res['requires_verification'] == true) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => FaidaBizOtpScreen(
              phone: res['phone']?.toString() ?? phone.text.trim(),
              password: password.text,
            ),
          ),
        );
        return;
      }
      await FaidaBizApi.applyLocaleFromUser(context);
      if (!mounted) return;
      if (res['offline'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('auth.offline_mode'.tr())),
        );
      }
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const FaidaBizShell()),
      );
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSw = context.locale.languageCode == 'sw';

    return Scaffold(
      body: Stack(
        children: [
          const FaidaBizLandingBackdrop(),
          SafeArea(
            child: FadeTransition(
              opacity: _fade,
              child: SlideTransition(
                position: _slide,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Material(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(24),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(24),
                          onTap: () => _setLanguage(isSw ? const Locale('en') : const Locale('sw')),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.language_rounded, color: Colors.white, size: 18),
                                const SizedBox(width: 6),
                                Text(
                                  isSw ? 'SW' : 'EN',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  isSw ? 'Kiswahili' : 'English',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Safari Land Tanzania',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -1,
                            height: 1.05,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'brand.tagline'.tr(),
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 16, height: 1.35),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'landing.subtitle'.tr(),
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 14),
                    ),
                    const SizedBox(height: 28),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const FaidaBizRegisterScreen()),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        foregroundColor: Colors.white,
                      ),
                      child: Text(
                        'landing.register_biz_cta'.tr(),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.5,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white,
                          decorationThickness: 2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    FaidaBizNeuScope(
                      child: NeuPanel(
                        padding: const EdgeInsets.all(22),
                        depth: 6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text('auth.login'.tr(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: FaidaBizTheme.black)),
                            const SizedBox(height: 18),
                            FaidaBizNeuField(
                              controller: phone,
                              label: 'auth.phone'.tr(),
                              keyboardType: TextInputType.phone,
                            ),
                            const SizedBox(height: 14),
                            FaidaBizNeuField(
                              controller: password,
                              label: 'auth.password'.tr(),
                              obscureText: true,
                            ),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: _openForgotPassword,
                                style: TextButton.styleFrom(
                                  foregroundColor: FaidaBizTheme.greenDark,
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                                  minimumSize: const Size(0, 36),
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  'auth.forgot_password'.tr(),
                                  style: const TextStyle(
                                    color: FaidaBizTheme.greenDark,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    decoration: TextDecoration.underline,
                                    decorationColor: FaidaBizTheme.greenDark,
                                  ),
                                ),
                              ),
                            ),
                            if (error != null) ...[
                              const SizedBox(height: 4),
                              Text(error!, style: const TextStyle(color: Colors.red)),
                            ],
                            const SizedBox(height: 12),
                            NeuPrimaryButton(
                              label: 'auth.login'.tr(),
                              loading: loading,
                              onPressed: loading ? null : _submit,
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => const FaidaBizRegisterScreen()),
                                );
                              },
                              child: Text('auth.no_account'.tr()),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
