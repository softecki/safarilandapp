import 'package:flutter/material.dart';
import 'package:wicom/core/app_color.dart';
import 'package:wicom/core/app_mode_session.dart';
import 'package:wicom/core/attendance_api.dart';
import 'package:wicom/core/attendance_session.dart';
import 'package:wicom/core/app_data.dart';
import 'package:wicom/src/view/screen/attendance_home_screen.dart';
import 'package:wicom/src/view/screen/gate_login_screen.dart';

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
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  Icon(Icons.fingerprint_rounded, size: 56, color: AppColor.primaryColor),
                  const SizedBox(height: 16),
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
                  const SizedBox(height: 8),
                  Text(
                    'API: ${AppData.url}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    controller: _phone,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Phone number',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _password,
                    obscureText: _obscure,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 16),
                    Text(_error!, style: const TextStyle(color: Colors.red)),
                  ],
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _loading ? null : _submit,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColor.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _loading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Text('Sign in'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: _loading ? null : _switchToGateAccess,
                    icon: const Icon(Icons.storefront_outlined),
                    label: const Text('Switch to Gate Access'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
