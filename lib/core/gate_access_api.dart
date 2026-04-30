import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import 'app_data.dart';

class GateAccessApi {
  static Uri _uri(String path) {
    final base = AppData.url.replaceAll(RegExp(r'/+$'), '');
    final p = path.startsWith('/') ? path : '/$path';
    return Uri.parse('$base$p');
  }

  static Future<Map<String, dynamic>> login({
    required String gateCode,
    required String password,
  }) async {
    final res = await http.post(
      _uri('/v1/workforce/gate/login'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'gate_code': gateCode,
        'password': password,
      }),
    );
    final body = res.body.isEmpty ? <String, dynamic>{} : jsonDecode(res.body) as Map<String, dynamic>;
    if (res.statusCode == 200) return body;
    throw GateAccessApiException(res.statusCode, body['message']?.toString() ?? 'Gate login failed');
  }

  static Future<Map<String, dynamic>> pushBatch({
    required String scannerToken,
    required List<Map<String, dynamic>> records,
  }) async {
    late http.Response res;
    try {
      res = await http
          .post(
            _uri('/v1/workforce/gate/batch-scan'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $scannerToken',
            },
            body: jsonEncode({'records': records}),
          )
          .timeout(const Duration(seconds: 45));
    } on Exception {
      throw GateAccessApiException(408, 'Request timed out after 45 seconds');
    }
    final body = res.body.isEmpty ? <String, dynamic>{} : jsonDecode(res.body) as Map<String, dynamic>;
    if (res.statusCode >= 200 && res.statusCode < 300) return body;
    throw GateAccessApiException(res.statusCode, body['message']?.toString() ?? 'Batch sync failed');
  }

  static Future<Uint8List> downloadReportPdf({
    required String scannerToken,
    required String from,
    required String to,
  }) async {
    final res = await http.post(
      _uri('/v1/workforce/gate/report-pdf'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/pdf',
        'Authorization': 'Bearer $scannerToken',
      },
      body: jsonEncode({'from': from, 'to': to}),
    );
    if (res.statusCode >= 200 && res.statusCode < 300) return res.bodyBytes;
    String message = 'Failed to generate report PDF';
    try {
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      message = body['message']?.toString() ?? message;
    } catch (_) {}
    throw GateAccessApiException(res.statusCode, message);
  }
}

class GateAccessApiException implements Exception {
  GateAccessApiException(this.statusCode, this.message);
  final int statusCode;
  final String message;

  @override
  String toString() => 'GateAccessApiException($statusCode): $message';
}
