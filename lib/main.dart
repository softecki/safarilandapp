import 'dart:ui' show PointerDeviceKind;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wicom/core/font_loader.dart';
import 'package:wicom/core/whatslipa_config.dart';
import 'package:wicom/faidabiz/faidabiz_api.dart';
import 'package:wicom/faidabiz/faidabiz_shell.dart';
import 'package:wicom/faidabiz/faidabiz_theme.dart';
import 'package:wicom/faidabiz/screens/login_screen.dart';
import 'package:wicom/faidabiz/widgets/landing_backdrop.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await WhatsLipaConfig.loadSavedUrl();
  await FaidaBizApi.loadSession();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('sw')],
      path: 'assets/translations',
      fallbackLocale: const Locale('sw'),
      startLocale: const Locale('sw'),
      child: const MyApp(),
    ),
  );

  FontLoader.preloadFonts().catchError((_) {});
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'FaidaBiz',
      theme: FaidaBizTheme.material(),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: const MaterialScrollBehavior().copyWith(
            dragDevices: {
              PointerDeviceKind.mouse,
              PointerDeviceKind.touch,
            },
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1100))..forward();
  late final Animation<double> _fade = CurvedAnimation(parent: _c, curve: Curves.easeOut);
  late final Animation<double> _scale = Tween<double>(begin: 0.92, end: 1).animate(
    CurvedAnimation(parent: _c, curve: Curves.easeOutBack),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  Future<void> _bootstrap() async {
    try {
      await WhatsLipaConfig.loadSavedUrl();
      await FaidaBizApi.loadSession();
      await Future<void>.delayed(const Duration(milliseconds: 1400));
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => FaidaBizApi.isLoggedIn ? const FaidaBizShell() : const FaidaBizLoginScreen(),
          transitionsBuilder: (_, a, __, child) => FadeTransition(opacity: a, child: child),
          transitionDuration: const Duration(milliseconds: 450),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute<void>(builder: (_) => const FaidaBizLoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const FaidaBizLandingBackdrop(),
          FadeTransition(
            opacity: _fade,
            child: ScaleTransition(
              scale: _scale,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'FaidaBiz',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -1.2,
                            ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'brand.tagline'.tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white.withOpacity(0.88), fontSize: 16, height: 1.4),
                      ),
                      const SizedBox(height: 28),
                      const SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
