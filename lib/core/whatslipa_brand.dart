import 'package:flutter/material.dart';
import 'package:wicom/core/whatslipa_session.dart';

/// Brand name and colors from portal login/config API.
class WhatsLipaBrand {
  static Map<String, dynamic>? _cached;

  static Future<void> loadFromSession() async {
    _cached = await WhatsLipaSession.brand;
  }

  static void apply(Map<String, dynamic>? brand) {
    _cached = brand;
  }

  static String get name => _cached?['name']?.toString() ?? 'WhatsLipa';

  static Color get primary {
    final hex = _cached?['primary_color']?.toString() ?? '#15803D';
    return _colorFromHex(hex);
  }

  static Color get secondary {
    final hex = _cached?['secondary_color']?.toString() ?? '#40916C';
    return _colorFromHex(hex);
  }

  static Color _colorFromHex(String hex) {
    var h = hex.replaceAll('#', '');
    if (h.length == 6) h = 'FF$h';
    final v = int.tryParse(h, radix: 16);
    if (v == null) return const Color(0xFF1B4332);
    return Color(v);
  }
}
