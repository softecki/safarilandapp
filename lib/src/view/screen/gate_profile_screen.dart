import 'package:flutter/material.dart';
import 'package:wicom/core/app_mode_session.dart';
import 'package:wicom/core/gate_access_session.dart';
import 'package:wicom/src/view/screen/mode_selector_screen.dart';

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
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CircleAvatar(
                    radius: 36,
                    child: Text(
                      initials,
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
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
                  FilledButton.icon(
                    onPressed: _logout,
                    icon: const Icon(Icons.logout_rounded),
                    label: const Text('Log out'),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _detailCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: Icon(icon),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(value),
      ),
    );
  }
}
