import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class WhatsLipaSession {
  static const _kToken = 'whatslipa_token';
  static const _kUser = 'whatslipa_user';
  static const _kMenu = 'whatslipa_menu';
  static const _kModules = 'whatslipa_app_modules';
  static const _kBrand = 'whatslipa_brand';
  static const _kWaLink = 'whatslipa_whatsapp_link';
  static const _kPortal = 'whatslipa_portal_base';
  static const _kPrefix = 'whatslipa_portal_prefix';
  static const _kMapsKey = 'whatslipa_maps_key';
  static const _kTenantSlug = 'whatslipa_tenant_slug';
  static const _kTenantName = 'whatslipa_tenant_name';
  static const _kTenantId = 'whatslipa_tenant_id';
  static const _kOrganizations = 'whatslipa_organizations';
  static const _kRequiresOrgChoice = 'whatslipa_requires_org_choice';
  static const _kIsPlatformAdmin = 'whatslipa_is_platform_admin';

  static Future<void> save({
    required String token,
    required Map<String, dynamic> user,
    required List<dynamic> menu,
    String? portalBaseUrl,
    String? portalPrefix,
    String? googleMapsApiKey,
    List<dynamic>? appModules,
    Map<String, dynamic>? brand,
    String? whatsappLink,
    String? tenantSlug,
    String? tenantName,
    int? tenantId,
    List<dynamic>? organizations,
    bool? requiresOrganizationChoice,
    bool? isPlatformAdmin,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kToken, token);
    await prefs.setString(_kUser, jsonEncode(user));
    await prefs.setString(_kMenu, jsonEncode(menu));
    if (appModules != null) {
      await prefs.setString(_kModules, jsonEncode(appModules));
    }
    if (brand != null) {
      await prefs.setString(_kBrand, jsonEncode(brand));
    }
    if (whatsappLink != null && whatsappLink.isNotEmpty) {
      await prefs.setString(_kWaLink, whatsappLink);
    }
    if (portalBaseUrl != null) {
      await prefs.setString(_kPortal, portalBaseUrl);
    }
    if (portalPrefix != null && portalPrefix.isNotEmpty) {
      await prefs.setString(_kPrefix, portalPrefix);
    }
    if (googleMapsApiKey != null && googleMapsApiKey.isNotEmpty) {
      await prefs.setString(_kMapsKey, googleMapsApiKey);
    }
    if (tenantSlug != null && tenantSlug.isNotEmpty) {
      await prefs.setString(_kTenantSlug, tenantSlug);
    }
    if (tenantName != null && tenantName.isNotEmpty) {
      await prefs.setString(_kTenantName, tenantName);
    }
    if (tenantId != null) {
      await prefs.setInt(_kTenantId, tenantId);
    }
    if (organizations != null) {
      await prefs.setString(_kOrganizations, jsonEncode(organizations));
    }
    if (requiresOrganizationChoice != null) {
      await prefs.setBool(_kRequiresOrgChoice, requiresOrganizationChoice);
    }
    if (isPlatformAdmin != null) {
      await prefs.setBool(_kIsPlatformAdmin, isPlatformAdmin);
    }
  }

  static Future<void> applyTenantPayload(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final tenant = data['tenant'];
    if (tenant is Map) {
      final slug = tenant['slug']?.toString();
      final name = tenant['name']?.toString();
      final id = tenant['id'];
      if (slug != null && slug.isNotEmpty) {
        await prefs.setString(_kTenantSlug, slug);
      }
      if (name != null && name.isNotEmpty) {
        await prefs.setString(_kTenantName, name);
      }
      if (id is int) {
        await prefs.setInt(_kTenantId, id);
      } else if (id != null) {
        final parsed = int.tryParse(id.toString());
        if (parsed != null) {
          await prefs.setInt(_kTenantId, parsed);
        }
      }
      await prefs.setBool(_kRequiresOrgChoice, false);
    } else {
      await prefs.setBool(
        _kRequiresOrgChoice,
        data['requires_organization_choice'] == true,
      );
    }

    final prefix = data['portal_prefix']?.toString();
    if (prefix != null && prefix.isNotEmpty) {
      await prefs.setString(_kPrefix, prefix);
    }
    final base = data['portal_base_url']?.toString();
    if (base != null && base.isNotEmpty) {
      await prefs.setString(_kPortal, base);
    }
    if (data['is_platform_admin'] != null) {
      await prefs.setBool(_kIsPlatformAdmin, data['is_platform_admin'] == true);
    }
    final orgs = data['organizations'];
    if (orgs is List) {
      await prefs.setString(_kOrganizations, jsonEncode(orgs));
    }
  }

  /// Persists full auth payload after login or organization switch.
  static Future<void> saveFromAuthPayload(
    Map<String, dynamic> payload, {
    String? token,
  }) async {
    await applyTenantPayload(payload);

    final tenant = payload['tenant'];
    String? tenantSlug;
    String? tenantName;
    int? tenantId;
    if (tenant is Map) {
      tenantSlug = tenant['slug']?.toString();
      tenantName = tenant['name']?.toString();
      final id = tenant['id'];
      tenantId = id is int ? id : int.tryParse(id?.toString() ?? '');
    }

    final sessionToken = token ?? await WhatsLipaSession.token;
    if (sessionToken == null || sessionToken.isEmpty) {
      throw StateError('Session expired. Please sign in again.');
    }

    await save(
      token: sessionToken,
      user: Map<String, dynamic>.from((payload['user'] as Map?) ?? {}),
      menu: (payload['menu'] as List?) ?? [],
      appModules: payload['app_modules'] as List?,
      brand: payload['brand'] is Map ? Map<String, dynamic>.from(payload['brand'] as Map) : null,
      whatsappLink: payload['whatsapp_link']?.toString(),
      portalBaseUrl: payload['portal_base_url']?.toString(),
      portalPrefix: payload['portal_prefix']?.toString(),
      googleMapsApiKey: payload['google_maps_api_key']?.toString(),
      tenantSlug: tenantSlug,
      tenantName: tenantName,
      tenantId: tenantId,
      organizations: payload['organizations'] as List?,
      requiresOrganizationChoice: false,
      isPlatformAdmin: payload['is_platform_admin'] == true,
    );
  }

  static Future<bool> get canSwitchOrganization async {
    if (await isPlatformAdmin) {
      return true;
    }
    final orgs = await organizations;
    return orgs.length > 1;
  }

  static Future<String?> get googleMapsApiKey async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kMapsKey);
  }

  static Future<String?> get token async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kToken);
  }

  static Future<bool> get isLoggedIn async {
    final t = await token;
    return t != null && t.isNotEmpty;
  }

  static Future<bool> get requiresOrganizationChoice async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kRequiresOrgChoice) == true;
  }

  static Future<bool> get isPlatformAdmin async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kIsPlatformAdmin) == true;
  }

  static Future<String?> get tenantSlug async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kTenantSlug);
  }

  static Future<String?> get tenantName async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kTenantName);
  }

  static Future<List<Map<String, dynamic>>> get organizations async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kOrganizations);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  static Future<Map<String, dynamic>?> get user async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kUser);
    if (raw == null) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  static Future<List<Map<String, dynamic>>> get menu async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kMenu);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  static Future<List<Map<String, dynamic>>> get appModules async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kModules);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  static Future<void> updateAppModules(List<dynamic> appModules) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kModules, jsonEncode(appModules));
  }

  static Future<Map<String, dynamic>?> get brand async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kBrand);
    if (raw == null) return null;
    return Map<String, dynamic>.from(jsonDecode(raw) as Map);
  }

  static Future<String?> get whatsappLink async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kWaLink);
  }

  static Future<String> get portalBaseUrl async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kPortal) ?? '';
  }

  static Future<String> get portalPrefix async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kPrefix) ?? 'sokofresh';
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kToken);
    await prefs.remove(_kUser);
    await prefs.remove(_kMenu);
    await prefs.remove(_kModules);
    await prefs.remove(_kBrand);
    await prefs.remove(_kWaLink);
    await prefs.remove(_kPortal);
    await prefs.remove(_kPrefix);
    await prefs.remove(_kMapsKey);
    await prefs.remove(_kTenantSlug);
    await prefs.remove(_kTenantName);
    await prefs.remove(_kTenantId);
    await prefs.remove(_kOrganizations);
    await prefs.remove(_kRequiresOrgChoice);
    await prefs.remove(_kIsPlatformAdmin);
  }
}
