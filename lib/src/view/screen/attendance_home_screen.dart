import 'package:flutter/material.dart';
import 'package:wicom/core/app_color.dart';
import 'package:wicom/core/attendance_session.dart';
import 'package:wicom/core/app_data.dart';
import 'package:wicom/src/view/screen/attendance_profile_screen.dart';
import 'package:wicom/src/view/screen/scan_qr_screen.dart';

class AttendanceHomeScreen extends StatefulWidget {
  const AttendanceHomeScreen({super.key});

  @override
  State<AttendanceHomeScreen> createState() => _AttendanceHomeScreenState();
}

class _AttendanceHomeScreenState extends State<AttendanceHomeScreen> {
  String? _user;
  String? _tenant;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final u = await AttendanceSession.userName;
    final t = await AttendanceSession.tenantName;
    if (!mounted) return;
    setState(() {
      _user = u;
      _tenant = t;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppData.appDisplayName),
        backgroundColor: AppColor.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'Profile',
            onPressed: () {
              Navigator.push<void>(
                context,
                MaterialPageRoute<void>(builder: (_) => const AttendanceProfileScreen()),
              );
            },
            icon: const Icon(Icons.person_outline),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Hello, ${_user ?? '…'}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'Organization: ${_tenant ?? '…'}',
              style: TextStyle(color: AppColor.textSecondary, fontSize: 15),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0x1A4CAF50),
                  child: Icon(Icons.person_outline, color: AppColor.primaryColor),
                ),
                title: const Text(
                  'Profile',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: const Text('View your account details and log out'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push<void>(
                    context,
                    MaterialPageRoute<void>(builder: (_) => const AttendanceProfileScreen()),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Record attendance', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),
                    Text(
                      'Scan the gate QR code. The app sends your employee QR token + location to your server for attendance.',
                      style: TextStyle(color: AppColor.textSecondary, fontSize: 14),
                    ),
                    const SizedBox(height: 20),
                    FilledButton.icon(
                      onPressed: () {
                        Navigator.push<void>(
                          context,
                          MaterialPageRoute<void>(builder: (_) => const ScanQrScreen()),
                        );
                      },
                      icon: const Icon(Icons.qr_code_scanner_rounded),
                      label: const Text('Scan gate QR'),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColor.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
