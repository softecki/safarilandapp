import 'package:flutter/material.dart';
import 'package:wicom/core/app_mode_session.dart';
import 'package:wicom/core/gate_access_api.dart';
import 'package:wicom/core/gate_access_session.dart';
import 'package:wicom/src/view/screen/attendance_login_screen.dart';
import 'package:wicom/src/view/screen/gate_home_screen.dart';
import 'package:wicom/src/view/widgets/neumorphic_widgets.dart';
import 'package:wicom/src/view/widgets/softecki_brand_logo.dart';

class GateLoginScreen extends StatefulWidget {
  const GateLoginScreen({super.key});

  @override
  State<GateLoginScreen> createState() => _GateLoginScreenState();
}

class _GateLoginScreenState extends State<GateLoginScreen> {
  final _gateCode = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _gateCode.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await GateAccessApi.login(
        gateCode: _gateCode.text.trim(),
        password: _password.text,
      );
      final tenant = (result['tenant'] as Map<String, dynamic>? ?? {});
      final scanner = (result['scanner'] as Map<String, dynamic>? ?? {});
      final scannerToken = result['scanner_token']?.toString() ?? '';
      if (scannerToken.isEmpty) {
        throw Exception('Missing gate session token from server.');
      }
      await GateAccessSession.save(
        scannerToken: scannerToken,
        tenantSlug: tenant['slug']?.toString() ?? '',
        tenantName: tenant['name']?.toString() ?? 'Tenant',
        gateName: scanner['name']?.toString() ?? 'Gate',
      );

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute<void>(builder: (_) => const GateHomeScreen()),
      );
    } on GateAccessApiException catch (e) {
      setState(() => _error = e.message);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _switchToEmployeeAccess() async {
    await AppModeSession.setMode(AppMode.employee);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(builder: (_) => const AttendanceLoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Softecki FaceAccess — Gate')),
      body: NeuScreenCanvas(
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      NeuPanel(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: const Center(child: SofteckiBrandLogo(height: 40)),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Softecki FaceAccess',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Gate access sign in',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                      ),
                      const SizedBox(height: 22),
                      NeuTextField(
                        controller: _gateCode,
                        labelText: 'Gate code (8 digits)',
                        hintText: '12345678',
                        prefixIcon: Icons.pin_outlined,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      NeuTextField(
                        controller: _password,
                        labelText: 'Gate password',
                        hintText: '••••••••',
                        prefixIcon: Icons.lock_outline,
                        obscureText: true,
                      ),
                      if (_error != null) ...[
                        const SizedBox(height: 12),
                        NeuPanel(
                          padding: const EdgeInsets.all(12),
                          depth: 2,
                          child: Text(
                            _error!,
                            style: const TextStyle(color: Color(0xFFDC2626), fontSize: 14),
                          ),
                        ),
                      ],
                      const SizedBox(height: 22),
                      NeuPrimaryButton(
                        label: 'Login',
                        loading: _loading,
                        onPressed: _loading ? null : _submit,
                      ),
                      const SizedBox(height: 14),
                      NeuSecondaryButton(
                        label: 'Switch to Employee Login',
                        icon: Icons.person_outline,
                        onPressed: _loading ? null : _switchToEmployeeAccess,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
