import 'package:flutter/material.dart';
import 'package:wicom/core/whatslipa_config.dart';
import 'package:wicom/core/whatslipa_session.dart';

/// Brand name and colors from portal login/config API, with Loti Gas overrides.
class WhatsLipaBrand {
  static Map<String, dynamic>? _cached;

  static const Color lotiGasYellow = Color(0xFFFFD700);
  static const Color lotiGasBlack = Color(0xFF000000);
  static const String lotiGasLogoAsset = 'assets/images/lotigas_logo.png';

  static String? _portalHint;
  static String? _tenantSlugHint;

  static Future<void> syncFromPortal() async {
    await WhatsLipaConfig.ensurePortalLoaded();
    _portalHint = WhatsLipaConfig.portalWebUrl;
    _applyLotiGasOverrides();
  }

  static Future<void> loadFromSession() async {
    await syncFromPortal();
    _cached = await WhatsLipaSession.brand;
    _tenantSlugHint = await WhatsLipaSession.tenantSlug;
    _applyLotiGasOverrides();
  }

  static void apply(
    Map<String, dynamic>? brand, {
    String? portalUrl,
    String? tenantSlug,
  }) {
    _cached = brand;
    if (portalUrl != null && portalUrl.isNotEmpty) _portalHint = portalUrl;
    if (tenantSlug != null && tenantSlug.isNotEmpty) _tenantSlugHint = tenantSlug;
    _applyLotiGasOverrides();
  }

  static void _applyLotiGasOverrides() {
    if (!isLotiGas) return;
    _cached = {
      ...Map<String, dynamic>.from(_cached ?? {}),
      'name': 'Loti Gas',
      'primary_color': '#FFD700',
      'secondary_color': '#000000',
    };
  }

  static bool get isLotiGas => _detectLotiGas();

  static bool _detectLotiGas() {
    final portal = (_portalHint ?? WhatsLipaConfig.portalWebUrl).toLowerCase().trim();
    if (portal.isEmpty) return false;

    final uri = Uri.tryParse(portal.startsWith('http') ? portal : 'https://$portal');
    final host = uri?.host.toLowerCase() ?? '';
    if (host.contains('lotigas') || portal.contains('lotigas')) {
      return true;
    }

    final slug = (_tenantSlugHint ?? '').toLowerCase();
    if (slug == 'lotigas') return true;

    final name = (_cached?['name'] ?? '').toString().toLowerCase();
    if (name.contains('loti gas') || name.contains('lotigas')) return true;

    return false;
  }

  static String get name {
    if (isLotiGas) return 'Loti Gas';
    return _cached?['name']?.toString() ?? 'WhatsLipa';
  }

  static String? get logoAsset => isLotiGas ? lotiGasLogoAsset : null;

  static Color get primary {
    if (isLotiGas) return lotiGasYellow;
    final hex = _cached?['primary_color']?.toString() ?? '#15803D';
    return _colorFromHex(hex);
  }

  static Color get secondary {
    if (isLotiGas) return lotiGasBlack;
    final hex = _cached?['secondary_color']?.toString() ?? '#40916C';
    return _colorFromHex(hex);
  }

  /// Text/icon color on primary brand surfaces.
  static Color get onPrimary => isLotiGas ? lotiGasBlack : Colors.white;

  static Color _colorFromHex(String hex) {
    var h = hex.replaceAll('#', '');
    if (h.length == 6) h = 'FF$h';
    final v = int.tryParse(h, radix: 16);
    if (v == null) return const Color(0xFF1B4332);
    return Color(v);
  }
}
