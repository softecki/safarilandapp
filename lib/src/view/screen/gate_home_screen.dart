import 'package:flutter/material.dart';
import 'package:wicom/core/app_color.dart';
import 'package:wicom/core/gate_access_session.dart';
import 'package:wicom/src/view/screen/gate_profile_screen.dart';
import 'package:wicom/src/view/screen/gate_report_screen.dart';
import 'package:wicom/src/view/screen/gate_scan_screen.dart';

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
        actions: [
          IconButton(
            tooltip: 'Profile',
            onPressed: () {
              Navigator.push<void>(
                context,
                MaterialPageRoute<void>(builder: (_) => const GateProfileScreen()),
              );
            },
            icon: const Icon(Icons.person_outline, color: Colors.white),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Organization: $tenant', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text('Gate: $gate', style: const TextStyle(color: Colors.black54)),
            const SizedBox(height: 24),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0x1A4CAF50),
                  child: Icon(Icons.person_outline),
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
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const GateScanScreen()));
              },
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('Scan Employee Card'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const GateReportScreen()));
              },
              icon: const Icon(Icons.receipt_long_outlined),
              label: const Text('Reports & PDF'),
            ),
          ],
        ),
      ),
    );
  }
}
