import 'dart:convert';
import 'package:http/http.dart' as http;

class OpsApi {
  OpsApi._();
  static const baseUrl = String.fromEnvironment('OPS_URL', defaultValue: 'https://pamojaadmin.softecki.com');
  static String? _live;

  static const _fallbacks = ['http://127.0.0.1:3001', 'http://10.0.2.2:3001', 'http://localhost:3001'];

  static List<String> get _origins {
    final list = <String>[baseUrl, ..._fallbacks];
    return [...{for (final origin in list) origin.replaceAll(RegExp(r'/$'), '')}];
  }

  static Map<String, String> _headers([String? token]) => {
        'Content-Type': 'application/json',
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      };

  static Future<String> _origin() async {
    if (_live != null) return _live!;
    Object? last;
    for (final origin in _origins) {
      try {
        final res = await http.get(Uri.parse('$origin/api/fan/catalog'), headers: _headers()).timeout(const Duration(seconds: 4));
        if (res.statusCode != 404 && res.statusCode < 500) {
          _live = origin;
          return origin;
        }
      } catch (e) {
        last = e;
      }
    }
    throw Exception(last ?? 'Pamoja OPS is unavailable.');
  }

  static Future<Uri> _u(String path) async => Uri.parse('${await _origin()}/api/fan/$path');

  static Future<Map<String, dynamic>> _parse(http.Response res) async {
    Map data = {};
    try {
      data = jsonDecode(res.body.isEmpty ? '{}' : res.body) as Map;
    } catch (_) {
      if (res.statusCode >= 400) throw Exception('Request failed (${res.statusCode})');
    }
    if (res.statusCode >= 400) {
      throw Exception(data['error'] ?? 'Request failed (${res.statusCode})');
    }
    return Map<String, dynamic>.from(data);
  }

  static Future<Map<String, dynamic>> register(Map<String, String> body) async {
    return _parse(await http.post(await _u('register'), headers: _headers(), body: jsonEncode(body)));
  }

  static Future<Map<String, dynamic>> login(String phone, String password) async {
    return _parse(await http.post(await _u('login'), headers: _headers(), body: jsonEncode({'phone': phone, 'password': password})));
  }

  static Future<Map<String, dynamic>> otp({String? phone, String? fanId, required String code, bool issueFanId = false}) async {
    return _parse(await http.post(await _u('otp'), headers: _headers(), body: jsonEncode({'phone': phone, 'fanId': fanId, 'code': code, if (issueFanId) 'issueFanId': '1'})));
  }

  static Future<Map<String, dynamic>> me(String token) async {
    return _parse(await http.get(await _u('me'), headers: _headers(token)));
  }

  static Future<Map<String, dynamic>> catalog([String? token]) async {
    return _parse(await http.get(await _u('catalog'), headers: _headers(token)));
  }

  static Future<Map<String, dynamic>> walletMove(String token, String type, int amount) async {
    return _parse(await http.post(await _u('wallet'), headers: _headers(token), body: jsonEncode({'type': type, 'amount': amount})));
  }

  static Future<Map<String, dynamic>> visaSubmit(String token, Map<String, String> body) async {
    return _parse(await http.post(await _u('visa'), headers: _headers(token), body: jsonEncode(body)));
  }

  static Future<Map<String, dynamic>> fanId(String token, [Map<String, String> body = const {}]) async {
    return _parse(await http.post(await _u('fan-id'), headers: _headers(token), body: jsonEncode(body)));
  }
}
