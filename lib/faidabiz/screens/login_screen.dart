import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wicom/faidabiz/faidabiz_api.dart';
import 'package:wicom/faidabiz/faidabiz_shell.dart';
import 'package:wicom/faidabiz/faidabiz_theme.dart';
import 'package:wicom/faidabiz/screens/otp_screen.dart';
import 'package:wicom/faidabiz/screens/register_screen.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_loader.dart';
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
  void dispose() {
    _anim.dispose();
    phone.dispose();
    password.dispose();
    super.dispose();
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
            ),
          ),
        );
        return;
      }
      await FaidaBizApi.applyLocaleFromUser(context);
      if (!mounted) return;
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
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                  children: [
                    Text(
                      'FaidaBiz',
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
                      style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 16, height: 1.35),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'landing.subtitle'.tr(),
                      style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
                    ),
                    const SizedBox(height: 36),
                    Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 28, offset: const Offset(0, 14)),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text('auth.login'.tr(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: FaidaBizTheme.black)),
                          const SizedBox(height: 18),
                          TextField(
                            controller: phone,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(labelText: 'auth.phone'.tr()),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: password,
                            obscureText: true,
                            decoration: InputDecoration(labelText: 'auth.password'.tr()),
                          ),
                          if (error != null) ...[
                            const SizedBox(height: 12),
                            Text(error!, style: const TextStyle(color: Colors.red)),
                          ],
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: loading ? null : _submit,
                            child: loading
                                ? FaidaBizLoader.button()
                                : Text('auth.login'.tr()),
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
