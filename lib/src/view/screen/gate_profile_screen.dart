import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:wicom/core/app_color.dart';
import 'package:wicom/core/app_mode_session.dart';
import 'package:wicom/core/gate_access_session.dart';
import 'package:wicom/src/view/screen/mode_selector_screen.dart';
import 'package:wicom/src/view/widgets/neumorphic_widgets.dart';

class GateProfileScreen extends StatefulWidget {
  const GateProfileScreen({super.key});

  @override
  State<GateProfileScreen> createState() => _GateProfileScreenState();
}

class _GateProfileScreenState extends State<GateProfileScreen> {
  String? _tenantName;
  String? _tenantSlug;
  String? _gateName;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final tenantName = await GateAccessSession.tenantName;
    final tenantSlug = await GateAccessSession.tenantSlug;
    final gateName = await GateAccessSession.gateName;

    if (!mounted) return;
    setState(() {
      _tenantName = tenantName;
      _tenantSlug = tenantSlug;
      _gateName = gateName;
      _loading = false;
    });
  }

  Future<void> _logout() async {
    await GateAccessSession.clear();
    await AppModeSession.clear();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute<void>(builder: (_) => const ModeSelectorScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final initials = (_tenantName != null && _tenantName!.trim().isNotEmpty)
        ? _tenantName!.trim()[0].toUpperCase()
        : 'G';

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: NeuScreenCanvas(
        child: _loading
            ? const Center(child: CircularProgressIndicator(color: AppColor.primaryColor))
            : SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Neumorphic(
                          style: NeumorphicStyle(
                            depth: 6,
                            boxShape: const NeumorphicBoxShape.circle(),
                            color: AppColor.neumorphicSurface,
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            initials,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColor.primaryColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _detailCard(
                        icon: Icons.apartment_outlined,
                        label: 'Organization',
                        value: _tenantName?.isNotEmpty == true ? _tenantName! : 'Not available',
                      ),
                      const SizedBox(height: 12),
                      _detailCard(
                        icon: Icons.business_outlined,
                        label: 'Tenant slug',
                        value: _tenantSlug?.isNotEmpty == true ? _tenantSlug! : 'Not available',
                      ),
                      const SizedBox(height: 12),
                      _detailCard(
                        icon: Icons.security_outlined,
                        label: 'Gate',
                        value: _gateName?.isNotEmpty == true ? _gateName! : 'Not available',
                      ),
                      const Spacer(),
                      NeuDangerButton(
                        label: 'Log out',
                        icon: Icons.logout_rounded,
                        onPressed: _logout,
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _detailCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return NeuPanel(
      child: ListTile(
        leading: Icon(icon, color: AppColor.primaryColor),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(value),
      ),
    );
  }
}
