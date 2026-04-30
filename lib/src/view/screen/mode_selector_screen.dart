import 'package:flutter/material.dart';
import 'package:wicom/core/app_mode_session.dart';
import 'package:wicom/src/view/screen/attendance_login_screen.dart';
import 'package:wicom/src/view/screen/gate_login_screen.dart';

class ModeSelectorScreen extends StatelessWidget {
  const ModeSelectorScreen({super.key});

  Future<void> _openGate(BuildContext context) async {
    await AppModeSession.setMode(AppMode.gateAccess);
    if (!context.mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(builder: (_) => const GateLoginScreen()),
    );
  }

  Future<void> _openEmployee(BuildContext context) async {
    await AppModeSession.setMode(AppMode.employee);
    if (!context.mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(builder: (_) => const AttendanceLoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Mode')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Choose application mode',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () => _openGate(context),
                  icon: const Icon(Icons.storefront_outlined),
                  label: const Text('Gate Access'),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => _openEmployee(context),
                  icon: const Icon(Icons.person_outline),
                  label: const Text('Employee Mode'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
