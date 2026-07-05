import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:intl/intl.dart';
import 'package:wicom/core/app_color.dart';
import 'package:wicom/core/whatslipa_api.dart';
import 'package:wicom/core/whatslipa_brand.dart';
import 'package:wicom/core/whatslipa_config.dart';
import 'package:wicom/core/whatslipa_session.dart';
import 'package:wicom/whatslipa/screens/cylinder_scan_screen.dart';
import 'package:wicom/whatslipa/screens/inventory_scan_screen.dart';
import 'package:wicom/whatslipa/screens/whatslipa_campaign_screen.dart';
import 'package:wicom/whatslipa/screens/whatslipa_delivery_screen.dart';
import 'package:wicom/whatslipa/screens/whatslipa_login_screen.dart';
import 'package:wicom/whatslipa/screens/whatslipa_organization_picker_screen.dart';
import 'package:wicom/whatslipa/screens/whatslipa_orders_screen.dart';
import 'package:wicom/whatslipa/screens/whatslipa_products_screen.dart';
import 'package:wicom/whatslipa/screens/whatslipa_reports_screen.dart';
import 'package:wicom/whatslipa/screens/whatslipa_whatsapp_screen.dart';
import 'package:wicom/whatslipa/widgets/whatslipa_loading.dart';
import 'package:wicom/whatslipa/widgets/whatslipa_organization_switcher.dart';
import 'package:wicom/whatslipa/widgets/whatslipa_ui.dart';

class WhatsLipaHomeScreen extends StatefulWidget {
  const WhatsLipaHomeScreen({super.key});

  @override
  State<WhatsLipaHomeScreen> createState() => _WhatsLipaHomeScreenState();
}

class _WhatsLipaHomeScreenState extends State<WhatsLipaHomeScreen> {
  Map<String, dynamic>? _user;
  List<_MenuItem> _menuItems = [];
  bool _loading = true;
  List<Map<String, dynamic>> _organizations = [];
  String? _tenantSlug;
  String? _tenantName;
  bool _isPlatformAdmin = false;
  bool _canSwitchOrganization = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _load();
    });
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    await WhatsLipaConfig.ensurePortalLoaded();
    try {
      _user = await WhatsLipaSession.user;
      final brand = await WhatsLipaSession.brand;
      WhatsLipaBrand.apply(brand);

      List<Map<String, dynamic>> modules = await WhatsLipaSession.appModules;
      try {
        final me = await WhatsLipaApi.me();
        final data = me['data'];
        if (data is Map) {
          final payload = Map<String, dynamic>.from(data);
          await WhatsLipaSession.applyTenantPayload(payload);
          final fresh = data['app_modules'];
          if (fresh is List) {
            modules = fresh.map((e) => Map<String, dynamic>.from(e as Map)).toList();
            await WhatsLipaSession.updateAppModules(fresh);
          }
          final rawUser = data['user'];
          if (rawUser is Map) {
            _user = Map<String, dynamic>.from(rawUser);
          }
        }
      } catch (_) {}

      if (await WhatsLipaSession.requiresOrganizationChoice) {
        final orgs = await WhatsLipaSession.organizations;
        if (mounted && orgs.isNotEmpty) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute<void>(
              builder: (_) => WhatsLipaOrganizationPickerScreen(organizations: orgs),
            ),
          );
          return;
        }
      }

      _menuItems = _menuItemsFromModules(modules);
      _organizations = await WhatsLipaSession.organizations;
      _tenantSlug = await WhatsLipaSession.tenantSlug;
      _tenantName = await WhatsLipaSession.tenantName;
      _isPlatformAdmin = await WhatsLipaSession.isPlatformAdmin;
      _canSwitchOrganization = await WhatsLipaSession.canSwitchOrganization;
    } catch (_) {
      _user ??= await WhatsLipaSession.user;
      _menuItems = [];
      _organizations = await WhatsLipaSession.organizations;
      _tenantSlug = await WhatsLipaSession.tenantSlug;
      _isPlatformAdmin = await WhatsLipaSession.isPlatformAdmin;
      _canSwitchOrganization = await WhatsLipaSession.canSwitchOrganization;
    }
    if (mounted) setState(() => _loading = false);
  }

  List<_MenuItem> _menuItemsFromModules(List<Map<String, dynamic>> modules) {
    return modules.map((m) {
      final id = m['id']?.toString() ?? '';
      final title = m['title']?.toString() ?? id;
      final colorHex = m['color']?.toString() ?? '#1B4332';
      final color = _hexColor(colorHex);
      if (id == 'whatsapp') return _MenuItem.whatsapp();
      return _MenuItem(id: id, title: title, icon: _iconForModule(id), color: color);
    }).toList();
  }

  IconData _iconForModule(String id) => switch (id) {
        'orders' => Icons.shopping_bag_rounded,
        'delivery' => Icons.delivery_dining_rounded,
        'campaign' => Icons.campaign_rounded,
        'reports' => Icons.assessment_rounded,
        'products' => Icons.inventory_2_rounded,
        'cylinders' => Icons.qr_code_scanner_rounded,
        'inventory' => Icons.inventory_outlined,
        _ => Icons.apps_rounded,
      };

  Color _hexColor(String hex) {
    var h = hex.replaceAll('#', '');
    if (h.length == 6) h = 'FF$h';
    final v = int.tryParse(h, radix: 16);
    return v != null ? Color(v) : AppColor.primaryColor;
  }

  Future<void> _logout() async {
    WhatsLipaLoading.show(context, message: 'Signing out…');
    await WhatsLipaApi.logout();
    WhatsLipaLoading.hide();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute<void>(builder: (_) => const WhatsLipaLoginScreen()),
      (_) => false,
    );
  }

  void _open(_MenuItem item) {
    Widget? screen;
    switch (item.id) {
      case 'whatsapp':
        screen = const WhatsLipaWhatsappScreen();
        break;
      case 'orders':
        screen = const WhatsLipaOrdersScreen();
        break;
      case 'delivery':
        screen = const WhatsLipaDeliveryScreen();
        break;
      case 'campaign':
        screen = const WhatsLipaCampaignScreen();
        break;
      case 'reports':
        screen = const WhatsLipaReportsScreen();
        break;
      case 'products':
        screen = const WhatsLipaProductsScreen();
        break;
      case 'cylinders':
        screen = const CylinderScanScreen();
        break;
      case 'inventory':
        screen = const InventoryScanScreen();
        break;
    }
    if (screen == null) return;
    Navigator.push(context, MaterialPageRoute<void>(builder: (_) => screen!));
  }

  String get _todayLabel => DateFormat('EEEE, d MMMM').format(DateTime.now());

  String get _initials {
    final name = _user?['name']?.toString() ?? 'U';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }

  @override
  Widget build(BuildContext context) {
    final name = _user?['name']?.toString() ?? 'User';
    final role = _user?['roles']?.first?['slug']?.toString() ?? _user?['afm_role']?.toString() ?? '';
    final brandPrimary = WhatsLipaBrand.primary;

    return Scaffold(
      backgroundColor: AppColor.neumorphicBase,
      body: WhatsLipaScreenBackground(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            WhatsLipaGradientHeader(
              child: SafeArea(
                bottom: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            WhatsLipaBrand.name,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                        WhatsLipaHeaderIconButton(
                          icon: Icons.refresh_rounded,
                          onPressed: _loading ? null : _load,
                        ),
                        const SizedBox(width: 8),
                        WhatsLipaHeaderIconButton(
                          icon: Icons.logout_rounded,
                          onPressed: _logout,
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 58,
                          height: 58,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.2),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.35), width: 2),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            _initials,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Karibu,',
                                style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              if (role.isNotEmpty)
                                Container(
                                  margin: const EdgeInsets.only(top: 6),
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.16),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    role.toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Icon(Icons.calendar_today_rounded, size: 14, color: Colors.white.withValues(alpha: 0.85)),
                        const SizedBox(width: 6),
                        Text(
                          _todayLabel,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        if (!_canSwitchOrganization && _tenantName != null && _tenantName!.isNotEmpty) ...[
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              '• $_tenantName',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 12),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (_canSwitchOrganization && _organizations.isNotEmpty && !_loading)
              Transform.translate(
                offset: const Offset(0, -18),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: WhatsLipaOrganizationSwitcher(
                    organizations: _organizations,
                    currentSlug: _tenantSlug,
                    isPlatformAdmin: _isPlatformAdmin,
                    onSwitched: _load,
                  ),
                ),
              ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, _canSwitchOrganization && _organizations.isNotEmpty ? 0 : 8, 20, 4),
              child: Text(
                'Your workspace',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: brandPrimary,
                  letterSpacing: -0.2,
                ),
              ),
            ),
            Expanded(
              child: _loading
                  ? Center(child: CircularProgressIndicator(color: brandPrimary))
                  : RefreshIndicator(
                      color: brandPrimary,
                      onRefresh: _load,
                      child: _menuItems.isEmpty
                          ? ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: const [
                                WhatsLipaEmptyState(
                                  icon: Icons.apps_outage_rounded,
                                  title: 'No modules yet',
                                  message:
                                      'Ask your administrator to enable app features for your account, then pull to refresh.',
                                ),
                              ],
                            )
                          : GridView.builder(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 14,
                                crossAxisSpacing: 14,
                                childAspectRatio: 0.92,
                              ),
                              itemCount: _menuItems.length,
                              itemBuilder: (context, i) {
                                final item = _menuItems[i];
                                return WhatsLipaModuleTile(
                                  title: item.title,
                                  icon: item.icon,
                                  color: item.color,
                                  useWhatsAppBrand: item.useWhatsAppBrand,
                                  onTap: () => _open(item),
                                );
                              },
                            ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItem {
  const _MenuItem({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
  }) : useWhatsAppBrand = false;

  _MenuItem.whatsapp()
      : id = 'whatsapp',
        title = 'WhatsApp',
        icon = Icons.chat_rounded,
        color = const Color(0xFF25D366),
        useWhatsAppBrand = true;

  final String id;
  final String title;
  final IconData icon;
  final Color color;
  final bool useWhatsAppBrand;
}
