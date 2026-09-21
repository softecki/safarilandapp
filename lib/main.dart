import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:ui' show PointerDeviceKind;
import 'package:wicom/core/font_loader.dart';
import 'package:wicom/safari/safari_api.dart';
import 'package:wicom/safari/safari_brand.dart';
import 'package:wicom/safari/safari_gate.dart';
import 'package:wicom/safari/safari_nav.dart';
import 'package:wicom/safari/safari_theme.dart';
import 'package:wicom/safari/safari_ui.dart';
import 'package:wicom/safari/screens/login_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await SafariApi.loadSession();

  SafariApi.onUnauthorized = () {
    final nav = navigatorKey.currentState;
    if (nav == null) return;
    nav.pushAndRemoveUntil(
      SafariNav.fade<void>(const SafariLoginScreen()),
      (_) => false,
    );
  };

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('sw')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'),
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
      title: SafariBrand.name,
      theme: SafariTheme.material(),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      home: const SafariSplashScreen(),
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: const MaterialScrollBehavior().copyWith(
            dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch},
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}

class SafariSplashScreen extends StatefulWidget {
  const SafariSplashScreen({super.key});

  @override
  State<SafariSplashScreen> createState() => _SafariSplashScreenState();
}

class _SafariSplashScreenState extends State<SafariSplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _boot());
  }

  Future<void> _boot() async {
    await SafariApi.loadSession();
    Widget next = const SafariLoginScreen();
    if (SafariApi.isLoggedIn) {
      try {
        final json = await SafariApi.get('/auth/me');
        SafariApi.driver = Map<String, dynamic>.from(SafariApi.data(json) as Map);
        next = SafariGate.home();
      } catch (_) {
        next = const SafariLoginScreen();
      }
    }
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    Navigator.pushReplacement(context, SafariNav.fade(next));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SafariTheme.darkEarth,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            SafariBrand.posterAsset,
            fit: BoxFit.cover,
            alignment: Alignment.center,
            errorBuilder: (_, __, ___) => const ColoredBox(color: SafariTheme.darkEarth),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  SafariTheme.darkEarth.withValues(alpha: 0.25),
                  SafariTheme.wine.withValues(alpha: 0.78),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(28, 28, 28, 40),
              child: Column(
                children: [
                  const SafariLogo(height: 72),
                  const SizedBox(height: 12),
                  const SafariTagline(light: true),
                  const Spacer(),
                  Text('Go beyond the safari', style: SafariTheme.display(color: Colors.white, size: 32)),
                  const SizedBox(height: 8),
                  const Text(
                    'Driver-guide partner platform',
                    style: TextStyle(color: SafariTheme.goldSoft, fontWeight: FontWeight.w600, letterSpacing: 0.6),
                  ),
                  const SizedBox(height: 28),
                  const CircularProgressIndicator(color: SafariTheme.gold),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
