import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wicom/core/whatslipa_config.dart';
import 'package:wicom/faidabiz/faidabiz_offline.dart';

/// FaidaBiz API client (`/api/faidabiz`) with offline cache + outbox (web + Android).
class FaidaBizApi {
  FaidaBizApi._();

  static const _tokenKey = 'faidabiz_token';
  static const _userKey = 'faidabiz_user';

  static String? token;
  static Map<String, dynamic>? user;

  /// Set from [main] to send the user to login when the Sanctum token is dead.
  static VoidCallback? onUnauthorized;

  static bool _unauthorizedHandling = false;
  static bool _flushing = false;

  static String get _base {
    final portal = WhatsLipaConfig.normalizePortalUrl(WhatsLipaConfig.portalWebUrl);
    return '$portal/api/faidabiz';
  }

  static Future<void> loadSession() async {
    await FaidaBizOffline.load();
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString(_tokenKey);
    final raw = prefs.getString(_userKey);
    if (raw != null && raw.isNotEmpty) {
      try {
        user = jsonDecode(raw) as Map<String, dynamic>;
      } catch (_) {
        user = null;
      }
    }
  }

  static Future<void> saveSession(String t, Map<String, dynamic> u) async {
    token = t;
    user = u;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, t);
    await prefs.setString(_userKey, jsonEncode(u));
    await FaidaBizOffline.saveOfflineSession(token: t, user: u);
  }

  static Future<void> clearSession({bool keepOfflineCredentials = false}) async {
    token = null;
    user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
    await FaidaBizOffline.clearAll(keepCredentials: keepOfflineCredentials);
  }

  /// Confirm stored token still works. Uses offline within 24h if network fails.
  static Future<bool> validateSession() async {
    if (!isLoggedIn) return false;
    await FaidaBizOffline.load();

    try {
      final res = await http
          .get(Uri.parse('$_base/me'), headers: _headers)
          .timeout(FaidaBizOffline.loginTimeout);

      if (res.statusCode == 401) {
        await clearSession(keepOfflineCredentials: true);
        return false;
      }

      if (res.statusCode >= 400) {
        return await _allowOfflineResume();
      }

      Map<String, dynamic> body = {};
      try {
        final decoded = jsonDecode(res.body);
        if (decoded is Map<String, dynamic>) {
          body = decoded;
        } else if (decoded is Map) {
          body = Map<String, dynamic>.from(decoded);
        }
      } catch (_) {}

      final u = body['user'];
      if (u is Map<String, dynamic>) {
        user = u;
      } else if (u is Map) {
        user = Map<String, dynamic>.from(u);
      }
      if (user != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_userKey, jsonEncode(user));
      }
      await FaidaBizOffline.markOnlineLoginNow();
      // After online session confirm (incl. post-24h login path), sync queued data.
      await flushPendingSync();
      return true;
    } catch (_) {
      return await _allowOfflineResume();
    }
  }

  static Future<bool> _allowOfflineResume() async {
    if (!isLoggedIn) return false;
    // First-time installs may have a session but no timestamp yet — seed window once.
    if (FaidaBizOffline.lastOnlineLoginAt == null) {
      await FaidaBizOffline.markOnlineLoginNow();
      await FaidaBizOffline.setOfflineMode(true);
      return true;
    }
    if (!FaidaBizOffline.isWithinOfflineWindow) {
      await clearSession(keepOfflineCredentials: true);
      return false;
    }
    await FaidaBizOffline.setOfflineMode(true);
    return true;
  }

  /// Apply saved business language (default Swahili on app).
  static Future<void> applyLocaleFromUser(BuildContext context) async {
    final biz = user?['business'] as Map<String, dynamic>?;
    final code = (biz?['language'] ?? 'sw').toString();
    final locale = code == 'en' ? const Locale('en') : const Locale('sw');
    await context.setLocale(locale);
  }

  static Future<List<Map<String, dynamic>>> fetchMyBusinesses() async {
    final res = await get('/my-businesses');
    final raw = res['data'];
    if (raw is! List) return [];
    return raw.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  static Future<void> switchBusiness(int businessId) async {
    final res = await post('/switch-business', {'business_id': businessId});
    final u = res['user'];
    if (u is Map<String, dynamic> && token != null) {
      await saveSession(token!, u);
    } else if (u is Map && token != null) {
      await saveSession(token!, Map<String, dynamic>.from(u));
    }
  }

  static Future<Map<String, dynamic>> setBusinessName(String name) async {
    final res = await post('/set-business-name', {'business_name': name});
    final u = res['user'] as Map<String, dynamic>?;
    if (u != null && token != null) await saveSession(token!, u);
    return res;
  }

  static Future<void> createBusiness({
    required String name,
    String? businessType,
    String? phone,
    String? language,
  }) async {
    final res = await post('/businesses', {
      'name': name,
      if (businessType != null) 'business_type': businessType,
      if (phone != null) 'phone': phone,
      if (language != null) 'language': language,
    });
    final u = res['user'];
    if (u is Map<String, dynamic> && token != null) {
      await saveSession(token!, u);
    } else if (u is Map && token != null) {
      await saveSession(token!, Map<String, dynamic>.from(u));
    }
  }

  static Future<List<Map<String, dynamic>>> fetchTeam() async {
    final res = await get('/team');
    final raw = res['data'];
    if (raw is! List) return [];
    return raw.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  static Future<void> addStaff({
    required String name,
    required String phone,
    required String password,
  }) async {
    await post('/team', {
      'name': name,
      'phone': phone,
      'password': password,
    });
  }

  static bool get isLoggedIn => token != null && token!.isNotEmpty;

  static Map<String, String> get _headers => {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        if (token != null && token!.isNotEmpty) 'Authorization': 'Bearer $token',
      };

  static Future<void> _handleUnauthorized() async {
    await clearSession(keepOfflineCredentials: true);
    if (_unauthorizedHandling) return;
    _unauthorizedHandling = true;
    try {
      onUnauthorized?.call();
    } finally {
      Future<void>.delayed(const Duration(milliseconds: 800), () {
        _unauthorizedHandling = false;
      });
    }
  }

  static Future<Map<String, dynamic>> _handle(http.Response res) async {
    Map<String, dynamic> body = {};
    try {
      final decoded = jsonDecode(res.body);
      if (decoded is Map<String, dynamic>) {
        body = decoded;
      } else if (decoded is Map) {
        body = Map<String, dynamic>.from(decoded);
      } else {
        body = {'success': false, 'message': res.body};
      }
    } catch (_) {
      body = {'success': false, 'message': res.body};
    }

    if (res.statusCode == 401) {
      await _handleUnauthorized();
      throw FaidaBizApiException(
        body['message']?.toString() ?? 'auth.session_expired'.tr(),
        statusCode: 401,
        body: body,
      );
    }

    if (res.statusCode == 403 && body['requires_verification'] == true) {
      return body;
    }
    if (res.statusCode >= 400) {
      throw FaidaBizApiException(
        body['message']?.toString() ?? 'common.http_error'.tr(args: ['${res.statusCode}']),
        statusCode: res.statusCode,
        body: body,
      );
    }
    return body;
  }

  static Future<void> _ensureOfflineWindowOrThrow() async {
    await FaidaBizOffline.load();
    if (FaidaBizOffline.lastOnlineLoginAt == null) {
      await FaidaBizOffline.markOnlineLoginNow();
      return;
    }
    if (!FaidaBizOffline.isWithinOfflineWindow) {
      await clearSession(keepOfflineCredentials: true);
      onUnauthorized?.call();
      throw FaidaBizApiException('auth.offline_expired'.tr());
    }
  }

  /// Sajili: simu + nenosiri → SMS OTP. Jina ni la hiari.
  static Future<Map<String, dynamic>> register({
    String? name,
    required String phone,
    required String password,
  }) async {
    final res = await http
        .post(
          Uri.parse('$_base/register'),
          headers: _headers,
          body: jsonEncode({
            if (name != null && name.isNotEmpty) 'name': name,
            'phone': phone,
            'password': password,
            'source': 'app',
            'account_type': 'business',
          }),
        )
        .timeout(const Duration(seconds: 30));
    return _handle(res);
  }

  static Future<Map<String, dynamic>> verifyOtp({
    required String phone,
    required String code,
  }) async {
    final res = await http
        .post(
          Uri.parse('$_base/verify-otp'),
          headers: _headers,
          body: jsonEncode({'phone': phone, 'code': code}),
        )
        .timeout(const Duration(seconds: 30));
    final body = await _handle(res);
    final t = body['token']?.toString();
    final u = body['user'] as Map<String, dynamic>?;
    if (t != null && u != null) {
      await saveSession(t, u);
      await FaidaBizOffline.markOnlineLoginNow();
      await flushPendingSync();
    }
    return body;
  }

  static Future<Map<String, dynamic>> resendOtp({required String phone}) async {
    final res = await http
        .post(
          Uri.parse('$_base/resend-otp'),
          headers: _headers,
          body: jsonEncode({'phone': phone}),
        )
        .timeout(const Duration(seconds: 30));
    return _handle(res);
  }

  /// Step 1: verify phone exists for password reset.
  static Future<Map<String, dynamic>> forgotPasswordCheck({required String phone}) async {
    final res = await http
        .post(
          Uri.parse('$_base/forgot-password/check'),
          headers: _headers,
          body: jsonEncode({'phone': phone}),
        )
        .timeout(FaidaBizOffline.loginTimeout);
    return _handle(res);
  }

  /// Step 2: set a new password for that phone.
  static Future<Map<String, dynamic>> forgotPasswordReset({
    required String phone,
    required String password,
    required String passwordConfirmation,
  }) async {
    final res = await http
        .post(
          Uri.parse('$_base/forgot-password/reset'),
          headers: _headers,
          body: jsonEncode({
            'phone': phone,
            'password': password,
            'password_confirmation': passwordConfirmation,
          }),
        )
        .timeout(FaidaBizOffline.loginTimeout);
    return _handle(res);
  }

  /// Online-first login. On timeout/network error → offline if within 24h + matching credentials.
  static Future<Map<String, dynamic>> login({
    required String phone,
    required String password,
  }) async {
    await FaidaBizOffline.load();
    try {
      final res = await http
          .post(
            Uri.parse('$_base/login'),
            headers: _headers,
            body: jsonEncode({'phone': phone, 'password': password}),
          )
          .timeout(FaidaBizOffline.loginTimeout);
      final body = await _handle(res);
      if (body['requires_verification'] == true) {
        return body;
      }
      final t = body['token']?.toString();
      final u = body['user'] as Map<String, dynamic>?;
      if (t != null && u != null) {
        await saveSession(t, u);
        await FaidaBizOffline.saveCredentials(phone: phone, password: password);
        await FaidaBizOffline.markOnlineLoginNow();
        // Online login (including after 24h forced online) always synchronizes queued offline data.
        await flushPendingSync();
      }
      return body;
    } catch (e) {
      if (e is FaidaBizApiException) rethrow;
      if (!FaidaBizOffline.isNetworkFailure(e)) rethrow;

      final ok = await FaidaBizOffline.canLoginOffline(phone: phone, password: password);
      if (!ok) {
        if (FaidaBizOffline.hasStoredCredentials &&
            phone.trim() == FaidaBizOffline.storedPhone &&
            !FaidaBizOffline.isWithinOfflineWindow) {
          throw FaidaBizApiException('auth.offline_expired'.tr());
        }
        throw FaidaBizApiException('auth.offline_unavailable'.tr());
      }

      // Restore last saved session for offline use.
      final offlineSession = await FaidaBizOffline.readOfflineSession();
      if (offlineSession == null) {
        throw FaidaBizApiException('auth.offline_unavailable'.tr());
      }
      await saveSession(offlineSession.token, offlineSession.user);
      await FaidaBizOffline.setOfflineMode(true);
      return {
        'success': true,
        'offline': true,
        'token': token,
        'user': user,
        'message': 'auth.offline_mode'.tr(),
      };
    }
  }

  static Future<void> logout() async {
    final previous = token;
    await clearSession(keepOfflineCredentials: false);
    if (previous == null || previous.isEmpty) return;
    try {
      await http
          .post(
            Uri.parse('$_base/logout'),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $previous',
            },
          )
          .timeout(const Duration(seconds: 15));
    } catch (_) {
      // Local session already cleared — ignore server failures / 401
    }
  }

  static Future<Map<String, dynamic>> get(String path, {Map<String, String>? query}) async {
    await FaidaBizOffline.load();
    try {
      var uri = Uri.parse('$_base$path');
      if (query != null && query.isNotEmpty) {
        uri = uri.replace(queryParameters: query);
      }
      final res = await http.get(uri, headers: _headers).timeout(FaidaBizOffline.requestTimeout);
      final body = await _handle(res);
      await FaidaBizOffline.putCache(path, query, body);
      if (FaidaBizOffline.isOffline.value) {
        await FaidaBizOffline.setOfflineMode(false);
        unawaited(flushPendingSync());
      }
      return body;
    } catch (e) {
      if (e is FaidaBizApiException && e.statusCode == 401) rethrow;
      if (!FaidaBizOffline.isNetworkFailure(e) && e is! TimeoutException) {
        // Non-network API errors should surface
        if (e is FaidaBizApiException) rethrow;
      }
      await _ensureOfflineWindowOrThrow();
      final cached = await FaidaBizOffline.getCache(path, query);
      if (cached != null) {
        await FaidaBizOffline.setOfflineMode(true);
        return {...cached, 'offline': true};
      }
      if (e is FaidaBizApiException) rethrow;
      throw FaidaBizApiException('auth.offline_no_cache'.tr());
    }
  }

  static Future<Map<String, dynamic>> post(String path, Map<String, dynamic> data) async {
    return _mutate('POST', path, data);
  }

  static Future<Map<String, dynamic>> put(String path, Map<String, dynamic> data) async {
    return _mutate('PUT', path, data);
  }

  static Future<Map<String, dynamic>> delete(String path, [Map<String, dynamic>? data]) async {
    return _mutate('DELETE', path, data);
  }

  static Future<Map<String, dynamic>> _mutate(
    String method,
    String path,
    Map<String, dynamic>? data,
  ) async {
    await FaidaBizOffline.load();

    if (FaidaBizOffline.isOnlineOnlyPath(path)) {
      // Payments / OTP / media require live network.
      return _mutateOnline(method, path, data);
    }

    try {
      final body = await _mutateOnline(method, path, data);
      if (FaidaBizOffline.isOffline.value) {
        await FaidaBizOffline.setOfflineMode(false);
        unawaited(flushPendingSync());
      }
      return body;
    } catch (e) {
      if (e is FaidaBizApiException && (e.statusCode ?? 0) >= 400 && e.statusCode != null) {
        // Real API validation errors — do not queue.
        if (!FaidaBizOffline.isNetworkFailure(e)) rethrow;
      }
      if (!FaidaBizOffline.isNetworkFailure(e) && e is! TimeoutException && e is! FaidaBizApiException) {
        rethrow;
      }
      if (e is FaidaBizApiException && e.statusCode != null && e.statusCode! < 500) {
        rethrow;
      }
      await _ensureOfflineWindowOrThrow();
      await FaidaBizOffline.setOfflineMode(true);
      return FaidaBizOffline.enqueueMutation(method: method, path: path, body: data).then((r) {
        return {
          ...r,
          'message': 'auth.offline_saved'.tr(),
        };
      });
    }
  }

  static Future<Map<String, dynamic>> _mutateOnline(
    String method,
    String path,
    Map<String, dynamic>? data,
  ) async {
    final uri = Uri.parse('$_base$path');
    late http.Response res;
    switch (method.toUpperCase()) {
      case 'POST':
        res = await http
            .post(uri, headers: _headers, body: jsonEncode(data ?? {}))
            .timeout(FaidaBizOffline.requestTimeout);
        break;
      case 'PUT':
        res = await http
            .put(uri, headers: _headers, body: jsonEncode(data ?? {}))
            .timeout(FaidaBizOffline.requestTimeout);
        break;
      case 'DELETE':
        final req = http.Request('DELETE', uri);
        req.headers.addAll(_headers);
        if (data != null) req.body = jsonEncode(data);
        final streamed = await req.send().timeout(FaidaBizOffline.requestTimeout);
        res = await http.Response.fromStream(streamed);
        break;
      default:
        throw FaidaBizApiException('Unsupported method $method');
    }
    return _handle(res);
  }

  /// Push queued offline writes to the server.
  static Future<SyncResult> flushPendingSync() async {
    if (_flushing || !isLoggedIn) return const SyncResult(synced: 0, failed: 0);
    _flushing = true;
    try {
      return await FaidaBizOffline.flushOutbox((method, path, body) async {
        return _mutateOnline(method, path, body);
      });
    } finally {
      _flushing = false;
    }
  }

  static Future<Map<String, dynamic>> postMultipart(
    String path, {
    required String fileField,
    String? filePath,
    List<int>? fileBytes,
    String? filename,
    Map<String, String> fields = const {},
  }) async {
    // Media uploads require network (no offline queue of binaries).
    final req = http.MultipartRequest('POST', Uri.parse('$_base$path'));
    req.headers['Accept'] = 'application/json';
    if (token != null && token!.isNotEmpty) {
      req.headers['Authorization'] = 'Bearer $token';
    }
    fields.forEach((k, v) => req.fields[k] = v);
    if (fileBytes != null) {
      req.files.add(http.MultipartFile.fromBytes(
        fileField,
        fileBytes,
        filename: filename ?? 'upload.bin',
      ));
    } else if (filePath != null && filePath.isNotEmpty) {
      req.files.add(await http.MultipartFile.fromPath(
        fileField,
        filePath,
        filename: filename,
      ));
    } else {
      throw FaidaBizApiException('common.no_file_upload'.tr());
    }
    final streamed = await req.send().timeout(const Duration(seconds: 90));
    final res = await http.Response.fromStream(streamed);
    return _handle(res);
  }
}

class FaidaBizApiException implements Exception {
  FaidaBizApiException(this.message, {this.statusCode, this.body});
  final String message;
  final int? statusCode;
  final Map<String, dynamic>? body;

  @override
  String toString() => message;
}
