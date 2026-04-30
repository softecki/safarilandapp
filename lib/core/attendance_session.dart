import 'package:shared_preferences/shared_preferences.dart';

/// Persisted workforce mobile session (Sanctum token + selected tenant).
class AttendanceSession {
  static const _kToken = 'attendance_sanctum_token';
  static const _kTenantSlug = 'attendance_tenant_slug';
  static const _kTenantName = 'attendance_tenant_name';
  static const _kUserName = 'attendance_user_name';

  static Future<void> save({
    required String token,
    required String tenantSlug,
    required String tenantName,
    required String userName,
  }) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_kToken, token);
    await p.setString(_kTenantSlug, tenantSlug);
    await p.setString(_kTenantName, tenantName);
    await p.setString(_kUserName, userName);
  }

  static Future<void> clear() async {
    final p = await SharedPreferences.getInstance();
    await p.remove(_kToken);
    await p.remove(_kTenantSlug);
    await p.remove(_kTenantName);
    await p.remove(_kUserName);
  }

  static Future<bool> get isLoggedIn async {
    final p = await SharedPreferences.getInstance();
    final t = p.getString(_kToken);
    return t != null && t.isNotEmpty;
  }

  static Future<String?> get token async =>
      (await SharedPreferences.getInstance()).getString(_kToken);

  static Future<String?> get tenantSlug async =>
      (await SharedPreferences.getInstance()).getString(_kTenantSlug);

  static Future<String?> get tenantName async =>
      (await SharedPreferences.getInstance()).getString(_kTenantName);

  static Future<String?> get userName async =>
      (await SharedPreferences.getInstance()).getString(_kUserName);

}
