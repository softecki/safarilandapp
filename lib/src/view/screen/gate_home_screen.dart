import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:wicom/core/app_color.dart';
import 'package:wicom/core/gate_access_session.dart';
import 'package:wicom/src/view/screen/gate_profile_screen.dart';
import 'package:wicom/src/view/screen/gate_report_screen.dart';
import 'package:wicom/src/view/screen/gate_scan_screen.dart';
import 'package:wicom/src/view/widgets/neumorphic_widgets.dart';

class GateHomeScreen extends StatefulWidget {
  const GateHomeScreen({super.key});

  @override
  State<GateHomeScreen> createState() => _GateHomeScreenState();
}

class _GateHomeScreenState extends State<GateHomeScreen> {
  String tenant = '...';
  String gate = '...';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final tenantName = await GateAccessSession.tenantName;
    final gateName = await GateAccessSession.gateName;
    if (!mounted) return;
    setState(() {
      tenant = tenantName ?? 'Tenant';
      gate = gateName ?? 'Gate';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gate Access'),
        backgroundColor: AppColor.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          NeumorphicButton(
            onPressed: () {
              Navigator.push<void>(
                context,
                MaterialPageRoute<void>(builder: (_) => const GateProfileScreen()),
              );
            },
            style: NeumorphicStyle(
              depth: 2,
              color: AppColor.primaryColor,
              boxShape: const NeumorphicBoxShape.circle(),
            ),
            padding: const EdgeInsets.all(10),
            child: const Icon(Icons.person_outline, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: NeuScreenCanvas(
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Organization: $tenant',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text('Gate: $gate', style: const TextStyle(color: AppColor.textSecondary)),
                const SizedBox(height: 22),
                NeuPanel(
                  child: ListTile(
                    leading: Neumorphic(
                      style: NeumorphicStyle(
                        depth: 3,
                        boxShape: const NeumorphicBoxShape.circle(),
                        color: AppColor.neumorphicSurface,
                      ),
                      padding: const EdgeInsets.all(10),
                      child: const Icon(Icons.person_outline, color: AppColor.primaryColor),
                    ),
                    title: const Text('Profile', style: TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: const Text('View gate details and log out'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push<void>(
                        context,
                        MaterialPageRoute<void>(builder: (_) => const GateProfileScreen()),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                NeuPrimaryButton(
                  label: 'Scan Employee Card',
                  icon: Icons.qr_code_scanner,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(builder: (_) => const GateScanScreen()),
                    );
                  },
                ),
                const SizedBox(height: 12),
                NeuSecondaryButton(
                  label: 'Reports & PDF',
                  icon: Icons.receipt_long_outlined,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(builder: (_) => const GateReportScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
