import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Offline support for FaidaBiz (Android + Flutter web via SharedPreferences).
///
/// Rules:
/// - After a successful **online** login, the user may work offline for up to 24 hours.
/// - Past 24 hours without an online login → must authenticate online again.
/// - Login always tries the network first; on timeout/network error, falls back to offline
///   if credentials match and the 24h window is still open.
class FaidaBizOffline {
  FaidaBizOffline._();

  static const maxOffline = Duration(hours: 24);
  static const loginTimeout = Duration(seconds: 30);
  static const requestTimeout = Duration(seconds: 30);

  static const _credPhoneKey = 'faidabiz_cred_phone';
  static const _credPassKey = 'faidabiz_cred_password';
  static const _lastOnlineKey = 'faidabiz_last_online_login_ms';
  static const _offlineFlagKey = 'faidabiz_offline_mode';
  static const _sessionTokenKey = 'faidabiz_offline_session_token';
  static const _sessionUserKey = 'faidabiz_offline_session_user';
  static const _cachePrefix = 'faidabiz_cache_v1:';
  static const _outboxKey = 'faidabiz_outbox_v1';
  static const _localOverlayKey = 'faidabiz_local_overlay_v1';

  /// True when the app is serving/queueing without the network.
  static final ValueNotifier<bool> isOffline = ValueNotifier<bool>(false);

  /// Pending sync count for UI badges.
  static final ValueNotifier<int> pendingCount = ValueNotifier<int>(0);

  static bool _loaded = false;
  static String? _credPhone;
  static String? _credPassword;
  static int? _lastOnlineMs;
  static List<Map<String, dynamic>> _outbox = [];
  static Map<String, List<Map<String, dynamic>>> _overlays = {};

  static Future<void> load() async {
    if (_loaded) return;
    final prefs = await SharedPreferences.getInstance();
    _credPhone = prefs.getString(_credPhoneKey);
    final enc = prefs.getString(_credPassKey);
    _credPassword = enc == null ? null : _decodeSecret(enc);
    _lastOnlineMs = prefs.getInt(_lastOnlineKey);
    isOffline.value = prefs.getBool(_offlineFlagKey) ?? false;

    final rawOut = prefs.getString(_outboxKey);
    if (rawOut != null && rawOut.isNotEmpty) {
      try {
        final list = jsonDecode(rawOut) as List;
        _outbox = list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      } catch (_) {
        _outbox = [];
      }
    }

    final rawOv = prefs.getString(_localOverlayKey);
    if (rawOv != null && rawOv.isNotEmpty) {
      try {
        final map = jsonDecode(rawOv) as Map<String, dynamic>;
        _overlays = map.map(
          (k, v) => MapEntry(
            k,
            (v as List).map((e) => Map<String, dynamic>.from(e as Map)).toList(),
          ),
        );
      } catch (_) {
        _overlays = {};
      }
    }

    pendingCount.value = _outbox.length;
    _loaded = true;
  }

  static String _encodeSecret(String value) =>
      base64Encode(utf8.encode('fb1:$value'));

  static String _decodeSecret(String encoded) {
    try {
      final raw = utf8.decode(base64Decode(encoded));
      if (raw.startsWith('fb1:')) return raw.substring(4);
      return raw;
    } catch (_) {
      return encoded;
    }
  }

  static DateTime? get lastOnlineLoginAt =>
      _lastOnlineMs == null ? null : DateTime.fromMillisecondsSinceEpoch(_lastOnlineMs!);

  static Duration? get remainingOfflineWindow {
    final last = lastOnlineLoginAt;
    if (last == null) return null;
    final end = last.add(maxOffline);
    final left = end.difference(DateTime.now());
    return left.isNegative ? Duration.zero : left;
  }

  /// Whether offline use is still allowed (credentials + 24h window).
  static bool get isWithinOfflineWindow {
    final last = lastOnlineLoginAt;
    if (last == null) return false;
    return DateTime.now().difference(last) <= maxOffline;
  }

  static bool get hasStoredCredentials =>
      (_credPhone != null && _credPhone!.isNotEmpty) &&
      (_credPassword != null && _credPassword!.isNotEmpty);

  static String? get storedPhone => _credPhone;

  static Future<void> saveCredentials({
    required String phone,
    required String password,
  }) async {
    await load();
    _credPhone = phone.trim();
    _credPassword = password;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_credPhoneKey, _credPhone!);
    await prefs.setString(_credPassKey, _encodeSecret(_credPassword!));
  }

  /// Durable copy of token/user so offline login still works after a soft session clear.
  static Future<void> saveOfflineSession({
    required String token,
    required Map<String, dynamic> user,
  }) async {
    await load();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionTokenKey, token);
    await prefs.setString(_sessionUserKey, jsonEncode(user));
  }

  static Future<({String token, Map<String, dynamic> user})?> readOfflineSession() async {
    await load();
    final prefs = await SharedPreferences.getInstance();
    final t = prefs.getString(_sessionTokenKey);
    final raw = prefs.getString(_sessionUserKey);
    if (t == null || t.isEmpty || raw == null || raw.isEmpty) return null;
    try {
      final u = jsonDecode(raw);
      if (u is Map<String, dynamic>) return (token: t, user: u);
      if (u is Map) return (token: t, user: Map<String, dynamic>.from(u));
    } catch (_) {}
    return null;
  }

  static Future<void> markOnlineLoginNow() async {
    await load();
    _lastOnlineMs = DateTime.now().millisecondsSinceEpoch;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastOnlineKey, _lastOnlineMs!);
    await setOfflineMode(false);
  }

  static Future<void> setOfflineMode(bool value) async {
    await load();
    isOffline.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_offlineFlagKey, value);
  }

  /// Credentials match a previous online login and 24h window is open.
  static Future<bool> canLoginOffline({
    required String phone,
    required String password,
  }) async {
    await load();
    if (!isWithinOfflineWindow || !hasStoredCredentials) return false;
    final p = phone.trim();
    return p == _credPhone && password == _credPassword;
  }

  static Future<void> clearAll({bool keepCredentials = false}) async {
    await load();
    final prefs = await SharedPreferences.getInstance();
    isOffline.value = false;
    await prefs.remove(_offlineFlagKey);

    if (!keepCredentials) {
      _outbox = [];
      _overlays = {};
      pendingCount.value = 0;
      await prefs.remove(_outboxKey);
      await prefs.remove(_localOverlayKey);
      for (final k in prefs.getKeys().where((k) => k.startsWith(_cachePrefix))) {
        await prefs.remove(k);
      }
      _credPhone = null;
      _credPassword = null;
      _lastOnlineMs = null;
      await prefs.remove(_credPhoneKey);
      await prefs.remove(_credPassKey);
      await prefs.remove(_lastOnlineKey);
      await prefs.remove(_sessionTokenKey);
      await prefs.remove(_sessionUserKey);
    }
  }

  static String cacheKey(String path, Map<String, String>? query) {
    final q = query == null || query.isEmpty
        ? ''
        : (query.entries.toList()..sort((a, b) => a.key.compareTo(b.key)))
            .map((e) => '${e.key}=${e.value}')
            .join('&');
    return '$_cachePrefix$path?$q';
  }

  static Future<void> putCache(String path, Map<String, String>? query, Map<String, dynamic> body) async {
    await load();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(cacheKey(path, query), jsonEncode(body));
  }

  static Future<Map<String, dynamic>?> getCache(String path, Map<String, String>? query) async {
    await load();
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(cacheKey(path, query));
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return null;
      final body = Map<String, dynamic>.from(decoded);
      return _mergeOverlays(path, body);
    } catch (_) {
      return null;
    }
  }

  static Map<String, dynamic> _mergeOverlays(String path, Map<String, dynamic> body) {
    final listKey = _listKeyForPath(path);
    if (listKey == null) return body;
    final extras = _overlays[listKey];
    if (extras == null || extras.isEmpty) return body;

    dynamic data = body['data'];
    if (data is List) {
      final existing = data.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      final ids = existing.map((e) => e['id']).toSet();
      for (final row in extras.reversed) {
        if (!ids.contains(row['id'])) {
          existing.insert(0, Map<String, dynamic>.from(row));
        }
      }
      body = Map<String, dynamic>.from(body);
      body['data'] = existing;
    }
    return body;
  }

  static String? _listKeyForPath(String path) {
    if (path.startsWith('/sales')) return '/sales';
    if (path.startsWith('/purchases')) return '/purchases';
    if (path.startsWith('/expenses')) return '/expenses';
    if (path.startsWith('/products')) return '/products';
    if (path.startsWith('/debts') || path.startsWith('/customers')) return '/debts';
    if (path.startsWith('/activity')) return '/activity';
    if (path.startsWith('/home')) return '/home';
    if (path.startsWith('/team')) return '/team';
    if (path.startsWith('/my-businesses')) return '/my-businesses';
    return null;
  }

  static bool isOnlineOnlyPath(String path) {
    final p = path.toLowerCase();
    if (p.contains('/subscription/pay')) return true;
    if (p.contains('/subscription/withdraw')) return true;
    if (p.contains('/subscription/extend')) return true;
    if (p.contains('/support-chat') && p.contains('media')) return true;
    if (p == '/register' || p == '/verify-otp' || p == '/resend-otp') return true;
    if (p.contains('/forgot-password')) return true;
    return false;
  }

  static Future<Map<String, dynamic>> enqueueMutation({
    required String method,
    required String path,
    Map<String, dynamic>? body,
  }) async {
    await load();
    final localId = -DateTime.now().millisecondsSinceEpoch;
    final item = <String, dynamic>{
      'id': 'local_$localId',
      'method': method.toUpperCase(),
      'path': path,
      'body': body,
      'created_at': DateTime.now().toIso8601String(),
      'local_id': localId,
    };
    _outbox.add(item);
    await _persistOutbox();
    pendingCount.value = _outbox.length;

    final optimistic = _buildOptimisticData(method, path, body, localId);
    if (optimistic != null) {
      await _addOverlay(path, optimistic);
    }

    return {
      'success': true,
      'offline': true,
      'queued': true,
      'message': 'Saved offline — will sync when online.',
      'data': optimistic ?? {'id': localId, 'queued': true},
    };
  }

  static Map<String, dynamic>? _buildOptimisticData(
    String method,
    String path,
    Map<String, dynamic>? body,
    int localId,
  ) {
    if (method.toUpperCase() != 'POST' || body == null) {
      return body == null ? null : {...body, 'id': localId, '_offline': true};
    }

    if (path == '/sales') {
      final qty = _asDouble(body['quantity']) ?? 1;
      final price = _asDouble(body['unit_price']) ?? 0;
      return {
        'id': localId,
        'total': qty * price,
        'profit': 0,
        'sold_at': DateTime.now().toIso8601String(),
        'notes': body['notes'],
        'payment_method': body['payment_method'] ?? 'cash',
        '_offline': true,
        'items': [
          {
            'product_name': body['product_name'] ?? '…',
            'quantity': qty,
            'unit_price': price,
            'line_total': qty * price,
          }
        ],
      };
    }
    if (path == '/purchases') {
      final qty = _asDouble(body['quantity']) ?? 1;
      final cost = _asDouble(body['unit_cost']) ?? 0;
      return {
        'id': localId,
        'total': qty * cost,
        'supplier': body['supplier'],
        'purchased_at': DateTime.now().toIso8601String(),
        '_offline': true,
      };
    }
    if (path == '/expenses') {
      return {
        'id': localId,
        'title': body['title'],
        'category': body['category'],
        'amount': body['amount'],
        'spent_at': DateTime.now().toIso8601String(),
        '_offline': true,
      };
    }
    if (path == '/products') {
      return {
        'id': localId,
        'name': body['name'],
        'unit': body['unit'] ?? 'pcs',
        'stock_qty': body['stock_qty'] ?? 0,
        'buy_price': body['buy_price'] ?? 0,
        'sell_price': body['sell_price'] ?? 0,
        'is_active': true,
        'status': 'active',
        '_offline': true,
      };
    }
    if (path == '/debts') {
      final amount = _asDouble(body['amount']) ?? 0;
      return {
        'id': localId,
        'name': body['name'],
        'phone': body['phone'],
        'owed': amount,
        'paid': 0,
        'balance': amount,
        'notes': body['notes'],
        'status': 'active',
        '_offline': true,
      };
    }
    return {...body, 'id': localId, '_offline': true};
  }

  static double? _asDouble(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString());
  }

  static Future<void> _addOverlay(String path, Map<String, dynamic> row) async {
    final key = _listKeyForPath(path);
    if (key == null) return;
    final list = List<Map<String, dynamic>>.from(_overlays[key] ?? []);
    list.insert(0, row);
    _overlays[key] = list;
    await _persistOverlays();
  }

  static Future<void> _persistOutbox() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_outboxKey, jsonEncode(_outbox));
  }

  static Future<void> _persistOverlays() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localOverlayKey, jsonEncode(_overlays));
  }

  static List<Map<String, dynamic>> get outboxSnapshot =>
      List<Map<String, dynamic>>.from(_outbox);

  /// Replay queued mutations. [sender] performs the real HTTP call.
  static Future<SyncResult> flushOutbox(
    Future<Map<String, dynamic>> Function(String method, String path, Map<String, dynamic>? body) sender,
  ) async {
    await load();
    if (_outbox.isEmpty) {
      return const SyncResult(synced: 0, failed: 0);
    }

    var synced = 0;
    var failed = 0;
    final remaining = <Map<String, dynamic>>[];

    for (final item in List<Map<String, dynamic>>.from(_outbox)) {
      try {
        await sender(
          item['method']?.toString() ?? 'POST',
          item['path']?.toString() ?? '/',
          item['body'] is Map ? Map<String, dynamic>.from(item['body'] as Map) : null,
        );
        synced++;
      } catch (_) {
        failed++;
        remaining.add(item);
      }
    }

    _outbox = remaining;
    await _persistOutbox();
    pendingCount.value = _outbox.length;

    if (failed == 0) {
      _overlays = {};
      await _persistOverlays();
    }

    return SyncResult(synced: synced, failed: failed);
  }

  static bool isNetworkFailure(Object e) {
    final s = e.toString().toLowerCase();
    return e is TimeoutException ||
        s.contains('timeout') ||
        s.contains('socket') ||
        s.contains('failed host lookup') ||
        s.contains('network is unreachable') ||
        s.contains('connection refused') ||
        s.contains('connection reset') ||
        s.contains('clientexception') ||
        s.contains('xmlhttprequest');
  }
}

class SyncResult {
  const SyncResult({required this.synced, required this.failed});
  final int synced;
  final int failed;
}
