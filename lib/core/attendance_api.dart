import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'app_data.dart';

/// Workforce mobile API (Laravel `attendanceportal`).
class AttendanceApi {
  static Uri _uri(String path) {
    final base = AppData.url.replaceAll(RegExp(r'/+$'), '');
    final p = path.startsWith('/') ? path : '/$path';
    return Uri.parse('$base$p');
  }

  static Future<Map<String, dynamic>> login({
    required String phone,
    required String password,
  }) async {
    final res = await http.post(
      _uri('/v1/workforce/mobile/login'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'phone': phone,
        'password': password,
        'device_name': 'attendance-app',
      }),
    );
    final body = res.body.isEmpty
        ? <String, dynamic>{}
        : jsonDecode(res.body) as Map<String, dynamic>;
    if (res.statusCode == 200) {
      return body;
    }
    throw AttendanceApiException(
      res.statusCode,
      body['message']?.toString() ?? 'Login failed',
    );
  }

  static Future<Map<String, dynamic>> submitEmployeeGateScan({
    required String authToken,
    required String scannerToken,
    required String tenantSlug,
    required String localRef,
    required double lat,
    required double lng,
    required File selfieImage,
    String? deviceId,
    String scanType = 'check_in',
  }) async {
    AttendanceApiException? timeoutError;
    for (var attempt = 1; attempt <= 3; attempt++) {
      try {
        final req =
            http.MultipartRequest('POST', _uri('/v1/workforce/mobile/scan'));
        req.headers['Accept'] = 'application/json';
        req.headers['Authorization'] = 'Bearer $authToken';
        req.fields['tenant_slug'] = tenantSlug;
        req.fields['scanner_token'] = scannerToken;
        req.fields['local_ref'] = localRef;
        req.fields['lat'] = lat.toString();
        req.fields['lng'] = lng.toString();
        req.fields['scan_type'] = scanType;
        if (deviceId != null) {
          req.fields['device_id'] = deviceId;
        }
        req.files.add(
            await http.MultipartFile.fromPath('face_image', selfieImage.path));

        final streamed = await req.send().timeout(const Duration(seconds: 45));
        final res = await http.Response.fromStream(streamed);
        final body = res.body.isEmpty
            ? <String, dynamic>{}
            : jsonDecode(res.body) as Map<String, dynamic>;
        if (res.statusCode >= 200 && res.statusCode < 300) {
          return body;
        }
        throw AttendanceApiException(
          res.statusCode,
          body['message']?.toString() ?? 'Scan failed',
        );
      } on AttendanceApiException {
        rethrow;
      } on Exception {
        timeoutError =
            AttendanceApiException(408, 'Request timed out after 45 seconds');
        if (attempt >= 3) {
          break;
        }
      }
    }
    throw timeoutError ?? AttendanceApiException(500, 'Scan failed');
  }

  /// Parse gate QR payload from workforce scanner token screen.
  static GateQrPayload parseGateQrPayload(String raw) {
    final s = raw.trim();
    if (s.startsWith('{')) {
      try {
        final m = jsonDecode(s) as Map<String, dynamic>;
        final token = m['token']?.toString();
        final tenantSlug = m['tenant_slug']?.toString();
        if (token != null &&
            token.isNotEmpty &&
            tenantSlug != null &&
            tenantSlug.isNotEmpty) {
          return GateQrPayload(
            token: token,
            tenantSlug: tenantSlug,
            gateName: m['gate']?.toString(),
            gateLat: _toDouble(m['lat']),
            gateLng: _toDouble(m['lng']),
          );
        }
      } catch (_) {}
    }
    throw AttendanceApiException(422, 'Invalid gate QR payload');
  }

  static double? _toDouble(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString());
  }
}

class GateQrPayload {
  GateQrPayload({
    required this.token,
    required this.tenantSlug,
    this.gateName,
    this.gateLat,
    this.gateLng,
  });

  final String token;
  final String tenantSlug;
  final String? gateName;
  final double? gateLat;
  final double? gateLng;
}

class AttendanceApiException implements Exception {
  AttendanceApiException(this.statusCode, this.message);
  final int statusCode;
  final String message;

  @override
  String toString() => 'AttendanceApiException($statusCode): $message';
}
