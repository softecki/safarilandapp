import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wicom/core/whatslipa_config.dart';

/// FaidaBiz API client (`/api/faidabiz`).
class FaidaBizApi {
  FaidaBizApi._();

  static const _tokenKey = 'faidabiz_token';
  static const _userKey = 'faidabiz_user';

  static String? token;
  static Map<String, dynamic>? user;

  /// Set from [main] to send the user to login when the Sanctum token is dead.
  static VoidCallback? onUnauthorized;

  static bool _unauthorizedHandling = false;

  static String get _base {
    final portal = WhatsLipaConfig.normalizePortalUrl(WhatsLipaConfig.portalWebUrl);
    return '$portal/api/faidabiz';
  }

  static Future<void> loadSession() async {
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
  }

  static Future<void> clearSession() async {
    token = null;
    user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }

  /// Confirm stored token still works. Clears session on 401 (no navigation).
  static Future<bool> validateSession() async {
    if (!isLoggedIn) return false;
    try {
      final res = await http
          .get(Uri.parse('$_base/me'), headers: _headers)
          .timeout(const Duration(seconds: 20));

      if (res.statusCode == 401) {
        await clearSession();
        return false;
      }

      if (res.statusCode >= 400) {
        // Keep local session on soft failures (5xx / temporary)
        return isLoggedIn;
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
      return true;
    } catch (_) {
      return isLoggedIn;
    }
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
    await clearSession();
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

    // 403 with requires_verification is expected — return body to caller
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

  /// Sajili: jina + simu + nenosiri → SMS OTP (hakuna token bado).
  static Future<Map<String, dynamic>> register({
    required String name,
    required String phone,
    required String password,
  }) async {
    final res = await http
        .post(
          Uri.parse('$_base/register'),
          headers: _headers,
          body: jsonEncode({
            'name': name,
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
    if (t != null && u != null) await saveSession(t, u);
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

  static Future<Map<String, dynamic>> login({
    required String phone,
    required String password,
  }) async {
    final res = await http
        .post(
          Uri.parse('$_base/login'),
          headers: _headers,
          body: jsonEncode({'phone': phone, 'password': password}),
        )
        .timeout(const Duration(seconds: 30));
    final body = await _handle(res);
    if (body['requires_verification'] == true) {
      return body;
    }
    final t = body['token']?.toString();
    final u = body['user'] as Map<String, dynamic>?;
    if (t != null && u != null) await saveSession(t, u);
    return body;
  }

  static Future<void> logout() async {
    final previous = token;
    await clearSession();
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
    var uri = Uri.parse('$_base$path');
    if (query != null && query.isNotEmpty) {
      uri = uri.replace(queryParameters: query);
    }
    final res = await http.get(uri, headers: _headers).timeout(const Duration(seconds: 30));
    return _handle(res);
  }

  static Future<Map<String, dynamic>> post(String path, Map<String, dynamic> data) async {
    final res = await http
        .post(Uri.parse('$_base$path'), headers: _headers, body: jsonEncode(data))
        .timeout(const Duration(seconds: 30));
    return _handle(res);
  }

  static Future<Map<String, dynamic>> put(String path, Map<String, dynamic> data) async {
    final res = await http
        .put(Uri.parse('$_base$path'), headers: _headers, body: jsonEncode(data))
        .timeout(const Duration(seconds: 30));
    return _handle(res);
  }

  static Future<Map<String, dynamic>> delete(String path, [Map<String, dynamic>? data]) async {
    final req = http.Request('DELETE', Uri.parse('$_base$path'));
    req.headers.addAll(_headers);
    if (data != null) {
      req.body = jsonEncode(data);
    }
    final streamed = await req.send().timeout(const Duration(seconds: 30));
    final res = await http.Response.fromStream(streamed);
    return _handle(res);
  }

  static Future<Map<String, dynamic>> postMultipart(
    String path, {
    required String fileField,
    String? filePath,
    List<int>? fileBytes,
    String? filename,
    Map<String, String> fields = const {},
  }) async {
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
