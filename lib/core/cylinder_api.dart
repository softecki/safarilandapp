import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:wicom/core/whatslipa_config.dart';
import 'package:wicom/core/whatslipa_session.dart';

/// Cylinder QR tracking API — /api/v1/cylinders/*
class CylinderApi {
  static Future<Map<String, String>> _headers() async {
    final token = await WhatsLipaSession.token;
    final slug = await _tenantSlug();
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      if (slug.isNotEmpty) 'X-Tenant-Slug': slug,
    };
  }

  static Future<String> _tenantSlug() async {
    final stored = await WhatsLipaSession.tenantSlug;
    if (stored != null && stored.isNotEmpty) {
      return stored;
    }

    final prefix = await WhatsLipaSession.portalPrefix;
    if (prefix.isNotEmpty && prefix != 'afm' && prefix != 'sokofresh') {
      return prefix;
    }

    final portal = WhatsLipaConfig.portalWebUrl;
    final uri = Uri.tryParse(portal);
    if (uri == null) return '';
    final parts = uri.pathSegments.where((s) => s.isNotEmpty).toList();
    if (parts.isEmpty) return '';
    final reserved = {'api', 'afm', 'lotigas', 'mobile', 'login', 'admin'};
    if (reserved.contains(parts.first)) return '';
    return parts.first;
  }

  static Uri _uri(String path) {
    final base = WhatsLipaConfig.apiBaseUrl.replaceAll(RegExp(r'/+$'), '');
    return Uri.parse('$base/v1/cylinders$path');
  }

  static Future<Map<String, dynamic>> scanContext() async {
    final res =
        await http.get(_uri('/scan-context'), headers: await _headers());
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> scan({
    required String qrPayload,
    required String eventType,
    String? secondaryQrPayload,
    int? orderId,
    int? customerId,
    double? latitude,
    double? longitude,
    String? clientNonce,
  }) async {
    final res = await http.post(
      _uri('/scan'),
      headers: await _headers(),
      body: jsonEncode({
        'qr_payload': qrPayload,
        if (secondaryQrPayload != null && secondaryQrPayload.isNotEmpty)
          'secondary_qr_payload': secondaryQrPayload,
        'event_type': eventType,
        if (orderId != null) 'order_id': orderId,
        if (customerId != null) 'customer_id': customerId,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
        if (clientNonce != null) 'client_nonce': clientNonce,
      }),
    );
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> myStock() async {
    final res = await http.get(_uri('/my-stock'), headers: await _headers());
    return jsonDecode(res.body) as Map<String, dynamic>;
  }
}
