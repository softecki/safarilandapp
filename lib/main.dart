import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:wicom/src/view/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'dart:ui' show PointerDeviceKind;
import 'package:wicom/core/app_theme.dart';
import 'package:wicom/src/view/screen/home_screen.dart';
import 'package:wicom/src/data/database_helper.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'core/app_color.dart';
import 'core/app_data.dart';
import 'generated/assets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('sw')],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
        },
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      theme: AppTheme.lightAppTheme,
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      splash(context);
    });
  }

  Future<void> splash(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: AppColor.primaryColor),
      ),
    );

    try {
      final url = Uri.parse('${AppData.url}/splash');
      final info = await PackageInfo.fromPlatform();
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'version_name': info.version,
          'version_code': info.buildNumber,
        }),
      );
        print(response);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];

        await _storeDataLocally(data);

        Navigator.of(context).pop(); // Close loading
        final firstUser = await DatabaseHelper.instance.getFirstUser();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>  LoginScreen(),
          ),
        );
      } else {
        final errorMsg = jsonDecode(response.body)['message'] ?? 'Splash failed';
        _showError(errorMsg);
      }
    } catch (e) {
      _showError(e.toString());
    }
  }

  Future<void> _storeDataLocally(Map<String, dynamic> data) async {
    final db = DatabaseHelper.instance;

  }

  void _showError(String message) {
    Navigator.of(context).pop(); // Close loading
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFffffff),
      body: Center(
        child: Image.asset(
          Assets.imagesWicom,
          fit: BoxFit.cover,
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}
