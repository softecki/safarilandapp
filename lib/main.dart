import 'package:flutter/material.dart';
import 'package:wicom/pamoja/app_nav.dart';
import 'package:wicom/pamoja/auth_screens.dart';
import 'package:wicom/pamoja/brand.dart';
import 'package:wicom/pamoja/session.dart';
import 'package:wicom/pamoja/theme.dart';
import 'package:wicom/pamoja/shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PamojaSession.instance.load();
  pamojaOnLogout = () {
    pamojaNavigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const PamojaLoginScreen()),
      (_) => false,
    );
  };
  runApp(const PamojaApp());
}

class PamojaApp extends StatelessWidget {
  const PamojaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: pamojaNavigatorKey,
      title: 'PAMOJA',
      theme: PamojaTheme.material(),
      debugShowCheckedModeBanner: false,
      home: const PamojaSplashScreen(),
    );
  }
}

class PamojaSplashScreen extends StatefulWidget {
  const PamojaSplashScreen({super.key});

  @override
  State<PamojaSplashScreen> createState() => _PamojaSplashScreenState();
}

class _PamojaSplashScreenState extends State<PamojaSplashScreen> {
  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 1200), _go);
  }

  void _go() {
    if (!mounted) return;
    final next = PamojaSession.instance.loggedIn ? const PamojaShell() : const PamojaLoginScreen();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => next));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [PamojaBrand.lake, PamojaBrand.indigo, PamojaBrand.night],
          ),
        ),
        child: const SafeArea(
          child: Column(
            children: [
              Spacer(),
              Text('PAMOJA', style: TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.w800, letterSpacing: 4)),
              SizedBox(height: 8),
              Text('DIGITAL PLATFORM ECOSYSTEM', style: TextStyle(color: Colors.white70, letterSpacing: 2.4, fontSize: 11, fontWeight: FontWeight.w600)),
              SizedBox(height: 16),
              Text('One region. One fan experience.', style: TextStyle(color: Colors.white, fontSize: 16)),
              Spacer(),
              Padding(
                padding: EdgeInsets.only(bottom: 48),
                child: CircularProgressIndicator(color: Colors.white),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 24),
                child: Text('AFCON 2027  ·  Tanzania · Kenya · Uganda', style: TextStyle(color: Colors.white70, fontSize: 12)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
