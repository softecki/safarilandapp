import 'package:flutter/foundation.dart';
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
      } else {
        hints.addAll(candidates.where(_urlLooksLikeLotiGas));
      }
    } catch (_) {}

    _urlHints
        ..clear()
        ..addAll(hints.where((u) => u.trim().isNotEmpty));
    _applyLotiGasOverrides();
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

  static bool _urlLooksLikeLotiGas(String raw) {
    final portal = raw.toLowerCase().trim();
    if (portal.isEmpty) return false;
    if (portal.contains('lotigas') || portal.contains('loti-gas') || portal.contains('loti_gas')) {
      return true;
    }
    final uri = Uri.tryParse(portal.startsWith('http') ? portal : 'https://$portal');
    final host = uri?.host.toLowerCase() ?? '';
    final path = uri?.path.toLowerCase() ?? '';
    return host.contains('lotigas') || path.contains('lotigas');
  }

  static bool _detectLotiGas() {
    final urls = <String>{
      if (_portalHint != null) _portalHint!,
      WhatsLipaConfig.portalWebUrl,
      ..._urlHints,
    };

    if (kIsWeb) {
      urls.add(Uri.base.toString());
      urls.add('${Uri.base.scheme}://${Uri.base.host}');
    }

    for (final url in urls) {
      if (_urlLooksLikeLotiGas(url)) return true;
    }

    final slug = (_tenantSlugHint ?? '').toLowerCase();
    if (slug == 'lotigas') return true;

    final name = (_cached?['name'] ?? '').toString().toLowerCase().replaceAll(' ', '');
    if (name.contains('lotigas')) return true;

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
