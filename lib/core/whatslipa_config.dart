import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wicom/core/whatslipa_brand.dart';
import 'package:wicom/core/whatslipa_local_db.dart';
import 'package:wicom/core/whatslipa_maps_init.dart';

/// Session key written on login (portal from successful auth).
const _kSessionPortalBase = 'whatslipa_portal_base';

/// WhatsLipa — universal client; portal list comes from server `.env`.
class WhatsLipaConfig {
  const WhatsLipaConfig._();

  static const _prefKeyUserPortal = 'whatslipa_portal_web_url';
  static const _prefKeyUserPortalLocked = 'whatslipa_user_portal_locked';
  static const _prefKeyDiscoveredUrls = 'whatslipa_discovered_portal_urls';

  /// Default host for GET /api/whatslipa/config when the user has no saved portal yet.
  static const String defaultConfigServerUrl = 'https://freshmarket.softecki.com';

  /// Active portal for API calls (set after login or from settings).
  static String portalWebUrl = defaultConfigServerUrl;

  /// Maps key only (when user portal is already locked).
  static Future<void> fetchMapsKeyOnly() async {
    await fetchAppConfigFromConfigServer(mapsKeyOnly: true);
  }

  /// Hosts that do not work on a physical phone (use saved production URL instead).
  static bool isUnreachableOnDevice(String url) {
    final host = Uri.tryParse(normalizePortalUrl(url))?.host.toLowerCase() ?? '';
    return host == 'localhost' || host == '127.0.0.1' || host == '0.0.0.0';
  }

  /// Loads the locked portal URL used for every API call (WhatsApp, orders, etc.).
  static Future<void> ensurePortalLoaded() async {
    final prefs = await SharedPreferences.getInstance();
    final locked = prefs.getBool(_prefKeyUserPortalLocked) == true;

    final saved = prefs.getString(_prefKeyUserPortal);
    if (saved != null && saved.isNotEmpty && !isUnreachableOnDevice(saved)) {
      portalWebUrl = normalizePortalUrl(saved);
      return;
    }

    final sessionPortal = prefs.getString(_kSessionPortalBase);
    if (sessionPortal != null &&
        sessionPortal.isNotEmpty &&
        !isUnreachableOnDevice(sessionPortal)) {
      portalWebUrl = normalizePortalUrl(sessionPortal);
      await prefs.setString(_prefKeyUserPortal, portalWebUrl);
      if (locked) {
        await prefs.setBool(_prefKeyUserPortalLocked, true);
      }
      return;
    }

    if (locked) {
      // Locked but missing URL — keep last in-memory value if valid
      if (!isUnreachableOnDevice(portalWebUrl)) {
        return;
      }
    }

    portalWebUrl = defaultConfigServerUrl;
    if (saved != null && saved.isNotEmpty && isUnreachableOnDevice(saved)) {
      await prefs.setString(_prefKeyUserPortal, portalWebUrl);
    }
  }

  /// Call after a successful login on [baseUrl] — that host is used for all requests until next login.
  static Future<String> lockPortalAfterLogin(String baseUrl) async {
    final normalized = normalizePortalUrl(baseUrl);
    portalWebUrl = normalized;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKeyUserPortal, normalized);
    await prefs.setBool(_prefKeyUserPortalLocked, true);
    await prefs.setString(_kSessionPortalBase, normalized);
    return normalized;
  }

  static Future<void> loadSavedUrl() async => ensurePortalLoaded();

  /// Save portal URL. Set [lockUserPortal] true after login or manual server settings.
  static Future<void> savePortalWebUrl(String url, {bool lockUserPortal = false}) async {
    portalWebUrl = normalizePortalUrl(url);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKeyUserPortal, portalWebUrl);
    if (lockUserPortal) {
      await prefs.setBool(_prefKeyUserPortalLocked, true);
    }
  }

  static Future<bool> isUserPortalLocked() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_prefKeyUserPortalLocked) != true) {
      return false;
    }
    final url = prefs.getString(_prefKeyUserPortal);
    return url != null && url.isNotEmpty;
  }

  /// Persists [google_maps_api_key] from server .env into local SQLite.
  static Future<void> saveGoogleMapsApiKeyFromServer(String? key) async {
    if (key == null || key.trim().isEmpty) return;
    await WhatsLipaLocalDb.setGoogleMapsApiKey(key);
    await initWhatsLipaGoogleMaps();
  }

  /// Fetches WHATSLIPA_PORTAL_URLS + GOOGLE_MAPS_API_KEY from config server.
  /// When [mapsKeyOnly] is true, portal list is not updated (saved portal already set).
  static Future<void> fetchAppConfigFromConfigServer({
    String? configServerUrl,
    bool mapsKeyOnly = false,
  }) async {
    final server = normalizePortalUrl(configServerUrl ?? defaultConfigServerUrl);
    try {
      final res = await http
          .get(
            Uri.parse('$server/api/whatslipa/config'),
            headers: {'Accept': 'application/json'},
          )
          .timeout(const Duration(seconds: 20));

      if (res.statusCode < 200 || res.statusCode >= 300) {
        return;
      }

      final body = jsonDecode(res.body) as Map<String, dynamic>;
      if (body['success'] != true) {
        return;
      }

      final data = body['data'] as Map<String, dynamic>? ?? {};

      await saveGoogleMapsApiKeyFromServer(data['google_maps_api_key'] as String?);

      if (mapsKeyOnly || await isUserPortalLocked()) {
        return;
      }

      final urls = (data['portal_urls'] as List<dynamic>? ?? [])
          .map((e) => normalizePortalUrl(e.toString()))
          .where((u) => u.isNotEmpty)
          .toList();

      if (urls.isEmpty) {
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefKeyDiscoveredUrls, urls.join(','));
      final configHost = normalizePortalUrl(
        (data['config_server_url'] as String?) ?? server,
      );
      portalWebUrl = urls.contains(configHost) ? configHost : urls.first;
    } catch (_) {}
  }

  static Future<List<String>> getDiscoveredPortalUrls() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefKeyDiscoveredUrls);
    if (raw == null || raw.isEmpty) {
      return [defaultConfigServerUrl];
    }
    final seen = <String>{};
    final out = <String>[];
    for (final part in raw.split(',')) {
      final n = normalizePortalUrl(part);
      if (n.isNotEmpty && seen.add(n)) {
        out.add(n);
      }
    }
    return out.isEmpty ? [defaultConfigServerUrl] : out;
  }

  /// Clears locked portal (use when login fails against wrong host).
  static Future<void> clearPortalLock() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefKeyUserPortalLocked);
    await prefs.remove(_prefKeyUserPortal);
    await prefs.remove(_kSessionPortalBase);
    portalWebUrl = defaultConfigServerUrl;
  }

  /// Clears cached portal/session configuration so next login starts fresh.
  static Future<void> clearCachedState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefKeyUserPortalLocked);
    await prefs.remove(_prefKeyUserPortal);
    await prefs.remove(_prefKeyDiscoveredUrls);
    await prefs.remove(_kSessionPortalBase);
    portalWebUrl = defaultConfigServerUrl;
  }

  /// Login targets: only saved portal if locked; otherwise env list from config server.
  static Future<List<String>> loginEndpointCandidates() async {
    await loadSavedUrl();
    if (await isUserPortalLocked()) {
      return [portalWebUrl];
    }
    var discovered = await getDiscoveredPortalUrls();
    if (discovered.isEmpty) {
      await fetchAppConfigFromConfigServer();
      discovered = await getDiscoveredPortalUrls();
    }
    final preferred = normalizePortalUrl(portalWebUrl);
    final out = <String>[];
    if (preferred.isNotEmpty) {
      out.add(preferred);
    }
    for (final u in discovered) {
      if (u.isNotEmpty && u != preferred && !out.contains(u)) {
        out.add(u);
      }
    }
    return out.isEmpty ? [defaultConfigServerUrl] : out;
  }

  static String normalizePortalUrl(String url) {
    var normalized = url.trim();
    while (normalized.endsWith('/')) {
      normalized = normalized.substring(0, normalized.length - 1);
    }
    if (normalized.endsWith('/api')) {
      normalized = normalized.substring(0, normalized.length - 4);
    }
    return normalized;
  }

  static String apiBaseUrlFor(String portalWebUrl) => '${normalizePortalUrl(portalWebUrl)}/api';

  static String whatsliapaApiPrefixFor(String portalWebUrl) =>
      '${apiBaseUrlFor(portalWebUrl)}/whatslipa';

  static String get apiBaseUrl => apiBaseUrlFor(portalWebUrl);

  static String get whatsliapaApiPrefix => whatsliapaApiPrefixFor(portalWebUrl);

  static String get appName => WhatsLipaBrand.name;

  static String get tagline => WhatsLipaBrand.isLotiGas
      ? 'Cylinder tracking · Inventory · Delivery'
      : 'WhatsApp Commerce · Payments · Delivery';

  static const String developedBy = 'Softecki Group Company Limited';
}
