import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SafariApi {
  static const _tokenKey = 'safari_token';
  static const _userKey = 'safari_driver';
  static const _urlKey = 'safari_api_base';
  static const defaultBase = 'https://safarilandguiderewardsystem.softecki.com/api/v1';
  static const _legacyBases = {
    'http://127.0.0.1/project/safarilandguiderewardsystem/public/api/v1',
    'http://localhost/project/safarilandguiderewardsystem/public/api/v1',
  };

  static String baseUrl = defaultBase;
  static String? token;
  static Map<String, dynamic>? driver;
  static void Function()? onUnauthorized;

  static bool get isLoggedIn => token != null && token!.isNotEmpty;

  static String normalizeBaseUrl(String url) {
    var u = url.trim();
    if (u.isEmpty) return defaultBase;
    u = u.replaceAll(RegExp(r'/+$'), '');
    if (!u.endsWith('/api/v1')) {
      u = '$u/api/v1';
    }
    return u;
  }

  static Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_urlKey);
    if (saved == null || saved.isEmpty || _legacyBases.contains(saved)) {
      baseUrl = defaultBase;
      await prefs.setString(_urlKey, defaultBase);
    } else {
      baseUrl = normalizeBaseUrl(saved);
    }
    token = prefs.getString(_tokenKey);
    final raw = prefs.getString(_userKey);
    if (raw != null) {
      try {
        driver = jsonDecode(raw) as Map<String, dynamic>;
      } catch (_) {}
    }
  }

  static Future<void> setBaseUrl(String url) async {
    baseUrl = normalizeBaseUrl(url);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_urlKey, baseUrl);
  }

  static Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    if (token == null) {
      await prefs.remove(_tokenKey);
      await prefs.remove(_userKey);
    } else {
      await prefs.setString(_tokenKey, token!);
      await prefs.setString(_userKey, jsonEncode(driver ?? {}));
    }
  }

  static Future<void> saveAuth(String t, Map<String, dynamic> d) async {
    token = t;
    driver = d;
    await _persist();
  }

  static Future<void> clear() async {
    token = null;
    driver = null;
    await _persist();
  }

  static Future<Map<String, dynamic>> request(
    String method,
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? fields,
    List<http.MultipartFile>? files,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    http.Response res;
    final headers = <String, String>{
      'Accept': 'application/json',
    };
    if (token != null) headers['Authorization'] = 'Bearer $token';

    if (files != null) {
      final req = http.MultipartRequest(method, uri);
      req.headers.addAll(headers);
      (fields ?? {}).forEach((k, v) => req.fields[k] = v);
      req.files.addAll(files);
      final streamed = await req.send().timeout(const Duration(seconds: 60));
      res = await http.Response.fromStream(streamed);
    } else {
      final encoded = body == null ? null : jsonEncode(body);
      if (encoded != null) headers['Content-Type'] = 'application/json';
      switch (method) {
        case 'GET':
          res = await http.get(uri, headers: headers).timeout(const Duration(seconds: 30));
          break;
        case 'POST':
          res = await http.post(uri, headers: headers, body: encoded).timeout(const Duration(seconds: 45));
          break;
        default:
          res = await http.put(uri, headers: headers, body: encoded).timeout(const Duration(seconds: 30));
      }
    }

    Map<String, dynamic> json;
    try {
      json = jsonDecode(res.body) as Map<String, dynamic>;
    } catch (_) {
      json = {'success': false, 'message': 'Unexpected server response (${res.statusCode})'};
    }

    if (res.statusCode == 401) {
      await clear();
      onUnauthorized?.call();
    }

    if (res.statusCode >= 400) {
      throw SafariApiException(json['message']?.toString() ?? 'Request failed', res.statusCode, json);
    }
    return json;
  }

  static Future<Map<String, dynamic>> get(String path) => request('GET', path);
  static Future<Map<String, dynamic>> post(String path, [Map<String, dynamic>? body]) =>
      request('POST', path, body: body);

  static dynamic data(Map<String, dynamic> json) => json['data'];
}

class SafariApiException implements Exception {
  SafariApiException(this.message, this.status, this.body);
  final String message;
  final int status;
  final Map<String, dynamic> body;
  @override
  String toString() => message;
}
