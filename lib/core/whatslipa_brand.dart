import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wicom/core/whatslipa_config.dart';
import 'package:wicom/core/whatslipa_session.dart';

/// FaidaBiz brand name and colors (green / white / black).
class WhatsLipaBrand {
  static Map<String, dynamic>? _cached;

  static const Color faidaGreen = Color(0xFF15803D);
  static const Color faidaGreenDark = Color(0xFF166534);
  static const Color faidaBlack = Color(0xFF111111);
  static const Color faidaWhite = Color(0xFFFFFFFF);

  static String? _portalHint;
  static String? _tenantSlugHint;
  static final List<String> _urlHints = [];

  static Future<void> refreshDetectionHints() async {
    await WhatsLipaConfig.ensurePortalLoaded();
    _portalHint ??= WhatsLipaConfig.portalWebUrl;

    final hints = <String>{
      WhatsLipaConfig.portalWebUrl,
      if (_portalHint != null && _portalHint!.isNotEmpty) _portalHint!,
    };

    if (kIsWeb) {
      hints.add(Uri.base.toString());
      hints.add('${Uri.base.scheme}://${Uri.base.host}');
      if (Uri.base.path.isNotEmpty) {
        hints.add('${Uri.base.scheme}://${Uri.base.host}${Uri.base.path}');
      }
    }

    try {
      final locked = await WhatsLipaConfig.isUserPortalLocked();
      final candidates = await WhatsLipaConfig.loginEndpointCandidates();
      if (locked) {
        if (candidates.isNotEmpty) hints.add(candidates.first);
      } else if (candidates.length == 1) {
        hints.add(candidates.first);
      }
    } catch (_) {}

    _urlHints
      ..clear()
      ..addAll(hints.where((u) => u.trim().isNotEmpty));
  }

  static Future<void> syncFromPortal() async {
    await WhatsLipaConfig.ensurePortalLoaded();
    _portalHint = WhatsLipaConfig.portalWebUrl;
    await refreshDetectionHints();
  }

  static Future<void> loadFromSession() async {
    await WhatsLipaConfig.ensurePortalLoaded();
    _portalHint = WhatsLipaConfig.portalWebUrl;
    _cached = await WhatsLipaSession.brand;
    _tenantSlugHint = await WhatsLipaSession.tenantSlug;
    await refreshDetectionHints();
  }

  static void apply(
    Map<String, dynamic>? brand, {
    String? portalUrl,
    String? tenantSlug,
  }) {
    _cached = brand;
    if (portalUrl != null && portalUrl.isNotEmpty) _portalHint = portalUrl;
    if (tenantSlug != null && tenantSlug.isNotEmpty) _tenantSlugHint = tenantSlug;
  }

  /// Kept for API compatibility; Loti Gas yellow override removed.
  static bool get isLotiGas => false;

  static String get name {
    return _cached?['name']?.toString() ?? 'FaidaBiz';
  }

  static String? get logoAsset => null;

  static Color get primary {
    final hex = _cached?['primary_color']?.toString() ?? '#15803D';
    return _colorFromHex(hex);
  }

  static Color get secondary {
    final hex = _cached?['secondary_color']?.toString() ?? '#166534';
    return _colorFromHex(hex);
  }

  static Color get onPrimary => Colors.white;

  static Color _colorFromHex(String hex) {
    var h = hex.replaceAll('#', '');
    if (h.length == 6) h = 'FF$h';
    final v = int.tryParse(h, radix: 16);
    if (v == null) return faidaGreen;
    return Color(v);
  }
}
