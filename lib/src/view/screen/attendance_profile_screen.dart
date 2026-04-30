import 'package:flutter/material.dart';
import 'package:wicom/core/app_color.dart';
import 'package:wicom/core/attendance_session.dart';
import 'package:wicom/src/view/screen/attendance_login_screen.dart';

class AttendanceProfileScreen extends StatefulWidget {
  const AttendanceProfileScreen({super.key});

  @override
  State<AttendanceProfileScreen> createState() => _AttendanceProfileScreenState();
}

class _AttendanceProfileScreenState extends State<AttendanceProfileScreen> {
  String? _userName;
  String? _tenantName;
  String? _tenantSlug;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = await AttendanceSession.userName;
    final tenant = await AttendanceSession.tenantName;
    final slug = await AttendanceSession.tenantSlug;
    if (!mounted) return;
    setState(() {
      _userName = user;
      _tenantName = tenant;
      _tenantSlug = slug;
      _loading = false;
    });
  }

  Future<void> _logout() async {
    await AttendanceSession.clear();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute<void>(builder: (_) => const AttendanceLoginScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final initials = (_userName != null && _userName!.trim().isNotEmpty)
        ? _userName!.trim()[0].toUpperCase()
        : 'U';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppColor.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColor.primaryColor))
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: AppColor.primaryColor.withOpacity(0.15),
                    child: Text(
                      initials,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColor.primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _detailCard(
                    icon: Icons.person_outline,
                    label: 'Name',
                    value: _userName?.isNotEmpty == true ? _userName! : 'Not available',
                  ),
                  const SizedBox(height: 12),
                  _detailCard(
                    icon: Icons.apartment_outlined,
                    label: 'Organization',
                    value: _tenantName?.isNotEmpty == true ? _tenantName! : 'Not available',
                  ),
                  const SizedBox(height: 12),
                  _detailCard(
                    icon: Icons.badge_outlined,
                    label: 'Tenant slug',
                    value: _tenantSlug?.isNotEmpty == true ? _tenantSlug! : 'Not available',
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColor.primaryColor),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(value),
      ),
    );
  }
}
