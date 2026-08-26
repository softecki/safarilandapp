import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:ui' show PointerDeviceKind;
import 'package:wicom/core/font_loader.dart';
import 'package:wicom/safari/safari_api.dart';
import 'package:wicom/safari/safari_brand.dart';
import 'package:wicom/safari/safari_shell.dart';
import 'package:wicom/safari/safari_theme.dart';
import 'package:wicom/safari/screens/login_screen.dart';
import 'package:wicom/safari/screens/pending_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await SafariApi.loadSession();

  SafariApi.onUnauthorized = () {
    final nav = navigatorKey.currentState;
    if (nav == null) return;
    nav.pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const SafariLoginScreen()),
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
        final status = SafariApi.driver?['status']?.toString();
        next = status == 'ACTIVE' ? const SafariShell() : const SafariPendingScreen();
      } catch (_) {
        next = const SafariLoginScreen();
      }
    }
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    Navigator.pushReplacement(context, PageRouteBuilder(
      pageBuilder: (_, __, ___) => next,
      transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SafariTheme.maroon,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            SafariBrand.posterAsset,
            fit: BoxFit.contain,
            alignment: Alignment.center,
            errorBuilder: (_, __, ___) => const ColoredBox(color: SafariTheme.maroon),
          ),
          const SafeArea(
            child: Column(
              children: [
                Spacer(),
                Padding(
                  padding: EdgeInsets.fromLTRB(32, 0, 32, 48),
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
