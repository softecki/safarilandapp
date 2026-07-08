import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wicom/core/app_color.dart';
import 'package:wicom/core/whatslipa_api.dart';
import 'package:wicom/core/whatslipa_brand.dart';
import 'package:wicom/core/whatslipa_config.dart';
import 'package:wicom/core/whatslipa_maps_init.dart';
import 'package:wicom/core/whatslipa_session.dart';
import 'package:wicom/whatslipa/screens/whatslipa_home_screen.dart';
import 'package:wicom/whatslipa/screens/whatslipa_organization_picker_screen.dart';
import 'package:wicom/whatslipa/screens/whatslipa_server_settings_screen.dart';
import 'package:wicom/whatslipa/widgets/whatslipa_loading.dart';
import 'package:wicom/whatslipa/widgets/whatslipa_ui.dart';

class WhatsLipaLoginScreen extends StatefulWidget {
  const WhatsLipaLoginScreen({super.key});

  @override
  State<WhatsLipaLoginScreen> createState() => _WhatsLipaLoginScreenState();
}

class _WhatsLipaLoginScreenState extends State<WhatsLipaLoginScreen> {
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;
  bool _obscure = true;
  List<String> _loginEndpointUrls = [];
  String? _lastAttemptSummary;

  @override
  void initState() {
    super.initState();
    WhatsLipaBrand.loadFromSession().then((_) {
      if (mounted) setState(() {});
    });
    _refreshLoginUrls();
  }

  Future<void> _refreshLoginUrls() async {
    await WhatsLipaConfig.ensurePortalLoaded();
    await WhatsLipaBrand.syncFromPortal();
    final candidates = await WhatsLipaConfig.loginEndpointCandidates();
    if (!mounted) return;
    setState(() {
      _loginEndpointUrls = candidates
          .map((b) => '${WhatsLipaConfig.whatsliapaApiPrefixFor(b)}/login')
          .toList();
    });
  }

  Future<void> _login() async {
    final phone = _phoneCtrl.text.trim();
    final password = _passCtrl.text;

    if (phone.isEmpty) {
      _snack('Enter your phone number');
      return;
    }
    if (password.length < 6) {
      _snack('Password must be at least 6 characters');
      return;
    }

    setState(() => _loading = true);
    WhatsLipaLoading.show(context, message: 'Signing in…');

    try {
      final res = await WhatsLipaApi.login(
        phone: phone,
        password: password,
        onProgress: WhatsLipaLoading.update,
      );
      final rawData = res['data'];
      if (rawData is! Map) {
        throw WhatsLipaApiException(0, 'Invalid server response (missing data).');
      }
      final data = Map<String, dynamic>.from(rawData);
      final token = data['token']?.toString();
      if (token == null || token.isEmpty) {
        throw WhatsLipaApiException(0, 'Server did not return a login token.');
      }
      final rawUser = data['user'];
      if (rawUser is! Map) {
        throw WhatsLipaApiException(0, 'Invalid server response (missing user).');
      }

      final mapsKey = data['google_maps_api_key']?.toString();
      await WhatsLipaConfig.saveGoogleMapsApiKeyFromServer(mapsKey);
      final portalUrl = data['portal_base_url']?.toString() ?? WhatsLipaConfig.portalWebUrl;
      final brand = data['brand'] is Map ? Map<String, dynamic>.from(data['brand'] as Map) : null;

      final tenant = data['tenant'];
      String? tenantSlug;
      String? tenantName;
      int? tenantId;
      if (tenant is Map) {
        tenantSlug = tenant['slug']?.toString();
        tenantName = tenant['name']?.toString();
        final id = tenant['id'];
        tenantId = id is int ? id : int.tryParse(id?.toString() ?? '');
      }

      WhatsLipaBrand.apply(brand, portalUrl: portalUrl, tenantSlug: tenantSlug);

      final organizations = _asDynamicList(data['organizations']);
      final requiresOrgChoice = data['requires_organization_choice'] == true;

      await WhatsLipaSession.save(
        token: token,
        user: Map<String, dynamic>.from(rawUser),
        menu: _asDynamicList(data['menu']),
        appModules: _asDynamicList(data['app_modules']),
        brand: brand,
        whatsappLink: data['whatsapp_link']?.toString(),
        portalBaseUrl: portalUrl,
        portalPrefix: data['portal_prefix']?.toString(),
        googleMapsApiKey: mapsKey,
        tenantSlug: tenantSlug,
        tenantName: tenantName,
        tenantId: tenantId,
        organizations: organizations,
        requiresOrganizationChoice: requiresOrgChoice,
        isPlatformAdmin: data['is_platform_admin'] == true,
      );
      await initWhatsLipaGoogleMaps();
      if (!mounted) return;
      WhatsLipaLoading.hide();

      if (requiresOrgChoice && tenantSlug == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute<void>(
            builder: (_) => WhatsLipaOrganizationPickerScreen(
              organizations: organizations.map((e) => Map<String, dynamic>.from(e as Map)).toList(),
              token: token,
            ),
          ),
        );
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute<void>(builder: (_) => const WhatsLipaHomeScreen()),
      );
    } on WhatsLipaApiException catch (e) {
      WhatsLipaLoading.hide();
      if (kDebugMode) {
        debugPrint('WhatsLipa login API error (${e.statusCode}): ${e.message}${e.attemptsSummary}');
      }
      setState(() => _lastAttemptSummary = _formatAttempts(e.attempts));
      _showLoginFailure(e.message, e.attempts);
    } catch (e, st) {
      WhatsLipaLoading.hide();
      debugPrint('WhatsLipa login error: $e');
      debugPrint('$st');
      final attempts = WhatsLipaApi.lastLoginAttempts;
      setState(() => _lastAttemptSummary = _formatAttempts(attempts));
      _showLoginFailure(_connectionErrorMessage(e), attempts);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _formatAttempts(List<WhatsLipaLoginAttempt> attempts) {
    if (attempts.isEmpty) {
      return _loginEndpointUrls.isEmpty
          ? 'No login URL loaded'
          : _loginEndpointUrls.join('\n');
    }
    return attempts
        .map((a) {
          final err = a.error;
          if (err != null && err.isNotEmpty) {
            final code = a.statusCode != null ? 'HTTP ${a.statusCode}: ' : '';
            return '${a.loginUrl}\n  → $code$err';
          }
          return a.loginUrl;
        })
        .join('\n');
  }

  void _showLoginFailure(String message, List<WhatsLipaLoginAttempt> attempts) {
    if (kDebugMode) {
      debugPrint('WhatsLipa login attempts:\n${_formatAttempts(attempts)}');
    }
    _snack(message);
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign-in failed'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message, style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              const Text(
                'Check your phone number and password. If the problem continues, open Server settings and confirm the correct portal is selected.',
                style: TextStyle(fontSize: 13, color: AppColor.textSecondary),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.push(
                context,
                MaterialPageRoute<void>(builder: (_) => const WhatsLipaServerSettingsScreen()),
              ).then((_) => _refreshLoginUrls());
            },
            child: const Text('Server settings'),
          ),
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK')),
        ],
      ),
    );
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 5)),
    );
  }

  List<dynamic> _asDynamicList(dynamic value) {
    if (value is List) {
      return List<dynamic>.from(value);
    }
    return [];
  }

  String _connectionErrorMessage(Object e) {
    final text = e.toString().toLowerCase();
    if (text.contains('socketexception') ||
        text.contains('failed host lookup') ||
        text.contains('connection refused') ||
        text.contains('network is unreachable') ||
        text.contains('timed out')) {
      return 'Could not reach the server. Check internet or open Server settings.';
    }
    if (e is FormatException) {
      return 'Server returned an invalid response. Check the server URL in settings.';
    }
    if (e is TypeError) {
      return 'Unexpected server response after login. Tap Server below to verify URL.';
    }
    final detail = e.toString();
    if (detail.isNotEmpty && detail != 'Exception') {
      return 'Sign-in failed: $detail';
    }
    return 'Sign-in failed. Try again or open Server settings.';
  }

  @override
  Widget build(BuildContext context) {
    final isLotiGas = WhatsLipaBrand.isLotiGas;
    final onBrand = WhatsLipaBrand.onPrimary;

    return Scaffold(
      backgroundColor: isLotiGas ? WhatsLipaBrand.lotiGasYellow : null,
      body: isLotiGas
          ? SafeArea(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
                children: [
                  const SizedBox(height: 12),
                  Center(child: WhatsLipaBrandLogo(size: 150)),
                  const SizedBox(height: 20),
                  Text(
                    WhatsLipaBrand.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: onBrand,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    WhatsLipaConfig.tagline,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: onBrand.withValues(alpha: 0.75),
                      fontSize: 14,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildLoginCard(),
                  const SizedBox(height: 12),
                  _buildServerSettingsButton(),
                ],
              ),
            )
          : WhatsLipaScreenBackground(
              child: SafeArea(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
                  children: [
                    const SizedBox(height: 16),
                    Center(
                      child: WhatsLipaBrandLogo(
                        size: 96,
                        icon: Icons.chat_bubble_rounded,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      WhatsLipaConfig.appName,
                      textAlign: TextAlign.center,
                      style: WhatsLipaUi.headline,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      WhatsLipaConfig.tagline,
                      textAlign: TextAlign.center,
                      style: WhatsLipaUi.subtitle,
                    ),
                    const SizedBox(height: 36),
                    _buildLoginCard(),
                    const SizedBox(height: 12),
                    _buildServerSettingsButton(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildLoginCard() {
    return WhatsLipaGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Sign in', style: WhatsLipaUi.sectionTitle),
          const SizedBox(height: 6),
          Text('Use your staff phone number and password.', style: WhatsLipaUi.subtitle.copyWith(fontSize: 13)),
          const SizedBox(height: 22),
          WhatsLipaInputField(
            controller: _phoneCtrl,
            label: 'PHONE NUMBER',
            hint: '2557XXXXXXXX',
            prefixIcon: Icons.phone_android_rounded,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 18),
          WhatsLipaInputField(
            controller: _passCtrl,
            label: 'PASSWORD',
            obscureText: _obscure,
            prefixIcon: Icons.lock_outline_rounded,
            suffix: IconButton(
              icon: Icon(
                _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                color: WhatsLipaUi.primary,
              ),
              onPressed: () => setState(() => _obscure = !_obscure),
            ),
          ),
          const SizedBox(height: 28),
          WhatsLipaPrimaryButton(
            label: 'Sign in',
            icon: Icons.login_rounded,
            loading: _loading,
            onPressed: _loading ? null : _login,
          ),
        ],
      ),
    );
  }

  Widget _buildServerSettingsButton() {
    final labelColor = WhatsLipaBrand.isLotiGas
        ? WhatsLipaBrand.lotiGasBlack.withValues(alpha: 0.85)
        : WhatsLipaUi.primary.withValues(alpha: 0.8);
    return TextButton.icon(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute<void>(builder: (_) => const WhatsLipaServerSettingsScreen()),
      ).then((_) => _refreshLoginUrls()),
      icon: Icon(Icons.settings_outlined, color: labelColor),
      label: Text('Server settings', style: TextStyle(fontSize: 13, color: labelColor)),
    );
  }
}
