import 'dart:ui' show PointerDeviceKind;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:wicom/core/app_neumorphic.dart';
import 'package:wicom/core/font_loader.dart';
import 'package:wicom/core/whatslipa_brand.dart';
import 'package:wicom/core/whatslipa_config.dart';
import 'package:wicom/core/whatslipa_maps_init.dart';
import 'package:wicom/core/whatslipa_session.dart';
import 'package:wicom/whatslipa/navigation/whatslipa_route_observer.dart';
import 'package:wicom/whatslipa/screens/whatslipa_home_screen.dart';
import 'package:wicom/whatslipa/widgets/whatslipa_theme.dart';
import 'package:wicom/whatslipa/screens/whatslipa_login_screen.dart';
import 'package:wicom/whatslipa/widgets/whatslipa_branded_loader.dart';
import 'package:wicom/src/services/health_check_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await WhatsLipaConfig.loadSavedUrl();
  await WhatsLipaBrand.loadFromSession();
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

  _initializeInBackground();
}

void _initializeInBackground() async {
  try {
    FontLoader.preloadFonts().catchError((_) {});
    // WhatsLipa does not use the legacy health-check dialog; keep disabled unless explicitly enabled.
    if (await HealthCheckService.isEnabled()) {
      await HealthCheckService.initialize();
    }
  } catch (_) {}
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    HealthCheckService.setNavigatorKey(navigatorKey);

    return NeumorphicApp(
      navigatorKey: navigatorKey,
      navigatorObservers: [whatsLipaRouteObserver],
      title: WhatsLipaConfig.appName,
      themeMode: ThemeMode.light,
      theme: AppNeumorphic.lightTheme,
      darkTheme: AppNeumorphic.darkTheme,
      materialTheme: WhatsLipaTheme.materialTheme(),
      materialDarkTheme: WhatsLipaTheme.materialTheme(),
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

class _SplashScreenState extends State<SplashScreen> {
  String _status = 'Starting…';

  static const _statusLoading = 'Loading…';
  static const _statusConfig = 'Loading configuration…';
  static const _statusPortal = 'Restoring session…';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  Future<void> _bootstrap() async {
    if (!mounted) return;

    try {
      setState(() => _status = _statusLoading);
      await WhatsLipaConfig.loadSavedUrl();
      await WhatsLipaBrand.loadFromSession();
      if (mounted) setState(() {});

      final locked = await WhatsLipaConfig.isUserPortalLocked();
      if (!locked) {
        setState(() => _status = _statusConfig);
        await WhatsLipaConfig.fetchAppConfigFromConfigServer();
      } else {
        setState(() => _status = _statusPortal);
        await WhatsLipaConfig.fetchMapsKeyOnly();
      }

      await initWhatsLipaGoogleMaps();

      if (!mounted) return;

      final loggedIn = await WhatsLipaSession.isLoggedIn;
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute<void>(
          builder: (_) => loggedIn ? const WhatsLipaHomeScreen() : const WhatsLipaLoginScreen(),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute<void>(builder: (_) => const WhatsLipaLoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WhatsLipaBrandedLoaderScreen(
      message: _status,
      showBrandName: true,
    );
  }
}
