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

  static String get _base {
    final portal = WhatsLipaConfig.normalizePortalUrl(WhatsLipaConfig.portalWebUrl);
    return '$portal/api/faidabiz';
  }

  static Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString(_tokenKey);
    final raw = prefs.getString(_userKey);
    if (raw != null && raw.isNotEmpty) {
      user = jsonDecode(raw) as Map<String, dynamic>;
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

  /// Apply saved business language (default Swahili on app).
  static Future<void> applyLocaleFromUser(BuildContext context) async {
    final biz = user?['business'] as Map<String, dynamic>?;
    final code = (biz?['language'] ?? 'sw').toString();
    final locale = code == 'en' ? const Locale('en') : const Locale('sw');
    await context.setLocale(locale);
  }

  static bool get isLoggedIn => token != null && token!.isNotEmpty;

  static Map<String, String> get _headers => {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

  static Future<Map<String, dynamic>> _handle(http.Response res) async {
    Map<String, dynamic> body = {};
    try {
      body = jsonDecode(res.body) as Map<String, dynamic>;
    } catch (_) {
      body = {'success': false, 'message': res.body};
    }
    if (res.statusCode == 401) {
      await clearSession();
    }
    // 403 with requires_verification is expected — return body to caller
    if (res.statusCode == 403 && body['requires_verification'] == true) {
      return body;
    }
    if (res.statusCode >= 400) {
      throw FaidaBizApiException(
        body['message']?.toString() ?? 'Hitilafu (${res.statusCode})',
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
    try {
      await http
          .post(Uri.parse('$_base/logout'), headers: _headers)
          .timeout(const Duration(seconds: 15));
    } catch (_) {}
    await clearSession();
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

  static Future<Map<String, dynamic>> delete(String path) async {
    final res =
        await http.delete(Uri.parse('$_base$path'), headers: _headers).timeout(const Duration(seconds: 30));
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
