import 'package:shared_preferences/shared_preferences.dart';

/// Persists WhatsLipa bootstrap config (maps key, etc.).
/// Uses [SharedPreferences] so login works on web, Android, and iOS (sqflite is not available on web).
class WhatsLipaLocalDb {
  WhatsLipaLocalDb._();

  static const _keyGoogleMaps = 'whatslipa_maps_key';

  static Future<void> setGoogleMapsApiKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyGoogleMaps, key.trim());
  }

  static Future<String?> getGoogleMapsApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    final v = prefs.getString(_keyGoogleMaps);
    return (v == null || v.isEmpty) ? null : v;
  }
}
