import 'package:flutter/material.dart';
import 'package:wicom/core/app_mode_session.dart';
import 'package:wicom/core/gate_access_api.dart';
import 'package:wicom/core/gate_access_session.dart';
import 'package:wicom/src/view/screen/attendance_login_screen.dart';
import 'package:wicom/src/view/screen/gate_home_screen.dart';

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
      appBar: AppBar(title: const Text('Softecki FaceAccess - Gate Login')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
                const Icon(
                  Icons.fingerprint_rounded,
                  size: 56,
                  color: Colors.blue,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Softecki FaceAccess',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Gate access sign in',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _gateCode,
                  decoration: const InputDecoration(
                    labelText: 'Gate code (8 digits)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _password,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Gate password',
                    border: OutlineInputBorder(),
                  ),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(_error!, style: const TextStyle(color: Colors.red)),
                ],
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: _loading ? null : _submit,
                  child: _loading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Login'),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: _loading ? null : _switchToEmployeeAccess,
                  icon: const Icon(Icons.person_outline),
                  label: const Text('Switch to Employee Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

