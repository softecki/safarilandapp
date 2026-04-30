import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:wicom/core/app_mode_session.dart';
import 'package:wicom/src/view/screen/attendance_login_screen.dart';
import 'package:wicom/src/view/screen/attendance_home_screen.dart';
import 'package:wicom/core/attendance_session.dart';
import 'package:wicom/core/gate_access_session.dart';
import 'package:flutter/material.dart';
import 'dart:ui' show PointerDeviceKind;
import 'package:wicom/core/app_theme.dart';
import 'package:wicom/core/font_loader.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'core/app_color.dart';
import 'core/app_data.dart';
import 'generated/assets.dart';
import 'src/services/sms_listener_service.dart';
import 'src/services/health_check_service.dart';
import 'src/view/screen/gate_home_screen.dart';
import 'src/view/screen/gate_login_screen.dart';
import 'src/view/screen/mode_selector_screen.dart';

// Global navigator key for showing dialogs from background services
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize EasyLocalization BEFORE runApp()
  await EasyLocalization.ensureInitialized();
  
  // Start the app
  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('sw')],
      path: 'assets/translations',
      fallbackLocale: Locale('sw'),
      startLocale: Locale('sw'),
      child: MyApp(),
    ),
  );
  
  // Initialize heavy operations in background (non-blocking)
  _initializeInBackground();
}

// Initialize heavy operations without blocking the UI
void _initializeInBackground() async {
  try {
    // Preload fonts in background (non-blocking)
    FontLoader.preloadFonts().catchError((e) {
      print('Font preloading failed: $e');
    });
    
    // Initialize SMS Listener Service (only if enabled)
    try {
      // Check if enabled before initializing
      if (await SmsListenerService.isEnabled()) {
        await SmsListenerService.initialize();
        
        // Initialize Health Check Service (only if SMS listener is enabled)
        try {
          await HealthCheckService.initialize();
          print('Health Check Service initialized');
        } catch (e) {
          print('Health Check Service initialization failed: $e');
        }
      } else {
        print('SMS Listener is disabled - skipping initialization and stopping native service');
        // Explicitly stop the native service if it was started by MainActivity
        await SmsListenerService.stopNativeServiceIfDisabled();
      }
    } catch (e) {
      print('SMS Listener initialization failed: $e');
    }
  } catch (e) {
    print('Background initialization failed: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Set navigator key for health check service
    HealthCheckService.setNavigatorKey(navigatorKey);
    
    return MaterialApp(
      navigatorKey: navigatorKey, // Add navigator key
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
    // Show loading dialog with timeout
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: AppColor.primaryColor),
      ),
    );

    try {
      // Add timeout to prevent long waits
      final url = Uri.parse('${AppData.url}/splash');
      final info = await PackageInfo.fromPlatform();
      
      // Set a timeout for the HTTP request
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'version_name': info.version,
          'version_code': info.buildNumber,
        }),
      ).timeout(
        const Duration(seconds: 10), // 10 second timeout
        onTimeout: () {
          throw Exception('Request timeout - proceeding without splash check');
        },
      );
      
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final data = responseData['data'];
        
        Navigator.of(context).pop(); // Close loading dialog
        
        // Check if force update is required
        if (data['force_update'] == true) {
          _showUpdateDialog(context, data['update_url']);
        } else {
          // Check if app is in maintenance mode
          if (data['maintenance_mode'] == true) {
            _showMaintenanceDialog(context);
          } else {
            // Proceed to Attendance App sign-in
            Navigator.pushReplacement(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const _AttendanceEntryScreen(),
              ),
            );
          }
        }
      } else {
        // If API fails, proceed to login anyway
        Navigator.of(context).pop();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute<void>(
            builder: (_) => const _AttendanceEntryScreen(),
          ),
        );
      }
    } catch (e) {
      // If splash check fails, proceed to login anyway
      Navigator.of(context).pop();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute<void>(
          builder: (_) => const _AttendanceEntryScreen(),
        ),
      );
    }
  }


  void _showError(String message) {
    Navigator.of(context).pop(); // Close loading
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showUpdateDialog(BuildContext context, String? updateUrl) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Update Required',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColor.primaryColor,
            ),
          ),
          content: const Text(
            'A new version of the app is available. Please update to continue using the app.',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Close app if user refuses to update
                Navigator.of(context).pop();
                // You can also use SystemNavigator.pop() to close the app
              },
              child: const Text(
                'Later',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                // Open app store or download link
                await _openUpdateLink(updateUrl);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Update Now',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showMaintenanceDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Under Maintenance',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          content: const Text(
            'The app is currently under maintenance. Please try again later.',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Retry splash check
                splash(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Retry',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _openUpdateLink(String? updateUrl) async {
    // Use the URL from API response, fallback to default
    final String urlToOpen = updateUrl ?? 'https://play.google.com/store/apps/details?id=com.wicom.malipomtandao';
    
    try {
      final Uri url = Uri.parse(urlToOpen);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        // Fallback: show error message
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not open update link'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      // Handle error
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error opening update link: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFffffff),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.verified_user_rounded,
              size: 88,
              color: AppColor.primaryColor,
            ),
            const SizedBox(height: 14),
            Text(
              AppData.appDisplayName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// After splash: resume session or show phone login.
class _AttendanceEntryScreen extends StatefulWidget {
  const _AttendanceEntryScreen();

  @override
  State<_AttendanceEntryScreen> createState() => _AttendanceEntryScreenState();
}

class _AttendanceEntryScreenState extends State<_AttendanceEntryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _go());
  }

  Future<void> _go() async {
    final mode = await AppModeSession.getMode();
    if (mode == AppMode.gateAccess) {
      final loggedIn = await GateAccessSession.isLoggedIn;
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute<void>(builder: (_) => loggedIn ? const GateHomeScreen() : const GateLoginScreen()),
      );
      return;
    }

    if (mode == AppMode.employee) {
      final loggedIn = await AttendanceSession.isLoggedIn;
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute<void>(builder: (_) => loggedIn ? const AttendanceHomeScreen() : const AttendanceLoginScreen()),
      );
      return;
    }

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(builder: (_) => const ModeSelectorScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator(color: AppColor.primaryColor)),
    );
  }
}
