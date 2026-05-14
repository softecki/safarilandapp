import 'package:flutter/material.dart';
import 'package:wicom/core/app_color.dart';
import 'package:wicom/core/app_mode_session.dart';
import 'package:wicom/src/view/screen/attendance_login_screen.dart';
import 'package:wicom/src/view/screen/gate_login_screen.dart';
import 'package:wicom/src/view/widgets/neumorphic_widgets.dart';
import 'package:wicom/src/view/widgets/softecki_brand_logo.dart';

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
      body: NeuScreenCanvas(
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    NeuPanel(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: const Center(child: SofteckiBrandLogo(height: 40)),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Choose application mode',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColor.textPrimary,
                          ),
                    ),
                    const SizedBox(height: 28),
                    NeuPrimaryButton(
                      label: 'Gate Access',
                      icon: Icons.storefront_outlined,
                      onPressed: () => _openGate(context),
                    ),
                    const SizedBox(height: 14),
                    NeuSecondaryButton(
                      label: 'Employee Mode',
                      icon: Icons.person_outline,
                      onPressed: () => _openEmployee(context),
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
