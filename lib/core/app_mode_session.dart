import 'package:shared_preferences/shared_preferences.dart';

enum AppMode { gateAccess, employee }

class AppModeSession {
  static const _kMode = 'attendance_app_mode';

  static Future<void> setMode(AppMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kMode, mode.name);
  }

  static Future<AppMode?> getMode() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kMode);
    if (raw == AppMode.gateAccess.name) return AppMode.gateAccess;
    if (raw == AppMode.employee.name) return AppMode.employee;
    return null;
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kMode);
  }
}
