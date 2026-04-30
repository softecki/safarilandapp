import 'package:shared_preferences/shared_preferences.dart';

class GateAccessSession {
  static const _kScannerToken = 'gate_scanner_token';
  static const _kTenantSlug = 'gate_tenant_slug';
  static const _kTenantName = 'gate_tenant_name';
  static const _kGateName = 'gate_name';

  static Future<void> save({
    required String scannerToken,
    required String tenantSlug,
    required String tenantName,
    required String gateName,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kScannerToken, scannerToken);
    await prefs.setString(_kTenantSlug, tenantSlug);
    await prefs.setString(_kTenantName, tenantName);
    await prefs.setString(_kGateName, gateName);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kScannerToken);
    await prefs.remove(_kTenantSlug);
    await prefs.remove(_kTenantName);
    await prefs.remove(_kGateName);
  }

  static Future<bool> get isLoggedIn async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_kScannerToken);
    final slug = prefs.getString(_kTenantSlug);
    return (token != null && token.isNotEmpty) && (slug != null && slug.isNotEmpty);
  }

  static Future<String?> get scannerToken async =>
      (await SharedPreferences.getInstance()).getString(_kScannerToken);

  static Future<String?> get tenantSlug async =>
      (await SharedPreferences.getInstance()).getString(_kTenantSlug);

  static Future<String?> get tenantName async =>
      (await SharedPreferences.getInstance()).getString(_kTenantName);

  static Future<String?> get gateName async =>
      (await SharedPreferences.getInstance()).getString(_kGateName);
}
