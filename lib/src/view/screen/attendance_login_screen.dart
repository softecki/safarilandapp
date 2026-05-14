import 'package:flutter/material.dart';
import 'package:wicom/core/app_color.dart';
import 'package:wicom/core/app_data.dart';
import 'package:wicom/core/app_mode_session.dart';
import 'package:wicom/core/attendance_api.dart';
import 'package:wicom/core/attendance_session.dart';
import 'package:wicom/src/view/screen/attendance_home_screen.dart';
import 'package:wicom/src/view/screen/gate_login_screen.dart';
import 'package:wicom/src/view/widgets/neumorphic_widgets.dart';
import 'package:wicom/src/view/widgets/softecki_brand_logo.dart';

/// Phone + password against Laravel `/api/v1/workforce/mobile/login`.
class AttendanceLoginScreen extends StatefulWidget {
  const AttendanceLoginScreen({super.key});

  @override
  State<AttendanceLoginScreen> createState() => _AttendanceLoginScreenState();
}

class _AttendanceLoginScreenState extends State<AttendanceLoginScreen> {
  final _phone = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _phone.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _error = null;
      _loading = true;
    });
    try {
      final data = await AttendanceApi.login(
        phone: _phone.text.trim(),
        password: _password.text,
      );
      final token = data['token']?.toString();
      final tenants = data['tenants'] as List<dynamic>?;
      if (token == null || token.isEmpty || tenants == null || tenants.isEmpty) {
        throw AttendanceApiException(500, 'Unexpected server response');
      }
      final selected = _selectTenantWithEmployeeToken(tenants);
      final first = selected;
      final slug = first['slug']?.toString() ?? '';
      final name = first['name']?.toString() ?? slug;
      final user = data['user'] as Map<String, dynamic>?;
      final userName = user?['name']?.toString() ?? 'User';

      await AttendanceSession.save(
        token: token,
        tenantSlug: slug,
        tenantName: name,
        userName: userName,
      );

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute<void>(builder: (_) => const AttendanceHomeScreen()),
      );
    } on AttendanceApiException catch (e) {
      setState(() => _error = e.message);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Map<String, dynamic> _selectTenantWithEmployeeToken(List<dynamic> tenants) {
    for (final item in tenants) {
      final tenant = item as Map<String, dynamic>;
      final employee = tenant['employee'] as Map<String, dynamic>?;
      final id = employee?['id'];
      if (id != null) {
        return tenant;
      }
    }
    return tenants.first as Map<String, dynamic>;
  }

  Future<void> _switchToGateAccess() async {
    await AppModeSession.setMode(AppMode.gateAccess);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(builder: (_) => const GateLoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NeuScreenCanvas(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),
                    NeuPanel(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      child: const Center(child: SofteckiBrandLogo(height: 40)),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      AppData.appDisplayName,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColor.textPrimary,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sign in with the phone number and password from your portal account.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColor.textSecondary, fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    NeuPanel(
                      padding: const EdgeInsets.all(12),
                      depth: 2,
                      child: Text(
                        'API: ${AppData.url}',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                      ),
                    ),
                    const SizedBox(height: 28),
                    NeuTextField(
                      controller: _phone,
                      labelText: 'Phone number',
                      hintText: '07…',
                      prefixIcon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 18),
                    NeuTextField(
                      controller: _password,
                      labelText: 'Password',
                      hintText: '••••••••',
                      prefixIcon: Icons.lock_outline,
                      obscureText: _obscure,
                      suffix: IconButton(
                        icon: Icon(
                          _obscure ? Icons.visibility_off : Icons.visibility,
                          color: AppColor.primaryColor,
                        ),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                      keyboardType: TextInputType.visiblePassword,
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 16),
                      NeuPanel(
                        padding: const EdgeInsets.all(12),
                        depth: 2,
                        child: Text(
                          _error!,
                          style: const TextStyle(color: Color(0xFFDC2626), fontSize: 14),
                        ),
                      ),
                    ],
                    const SizedBox(height: 28),
                    NeuPrimaryButton(
                      label: 'Sign in',
                      loading: _loading,
                      onPressed: _loading ? null : _submit,
                    ),
                    const SizedBox(height: 14),
                    NeuSecondaryButton(
                      label: 'Switch to Gate Access',
                      icon: Icons.storefront_outlined,
                      onPressed: _loading ? null : _switchToGateAccess,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
