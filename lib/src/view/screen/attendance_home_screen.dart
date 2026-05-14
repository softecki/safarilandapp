import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:wicom/core/app_color.dart';
import 'package:wicom/core/app_data.dart';
import 'package:wicom/core/attendance_session.dart';
import 'package:wicom/src/view/screen/attendance_profile_screen.dart';
import 'package:wicom/src/view/screen/scan_qr_screen.dart';
import 'package:wicom/src/view/widgets/neumorphic_widgets.dart';

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
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          NeumorphicButton(
            onPressed: () {
              Navigator.push<void>(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => const AttendanceProfileScreen(),
                ),
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
                Text(
                  'Hello, ${_user ?? '…'}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColor.textPrimary,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Organization: ${_tenant ?? '…'}',
                  style: const TextStyle(color: AppColor.textSecondary, fontSize: 15),
                ),
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
                    title: const Text(
                      'Profile',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: const Text('View your account details and log out'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push<void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) => const AttendanceProfileScreen(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                NeuPanel(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Record attendance',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Scan the gate QR code. The app sends your employee QR token + location to your server for attendance.',
                        style: TextStyle(color: AppColor.textSecondary, fontSize: 14),
                      ),
                      const SizedBox(height: 20),
                      NeuPrimaryButton(
                        label: 'Scan gate QR',
                        icon: Icons.qr_code_scanner_rounded,
                        onPressed: () {
                          Navigator.push<void>(
                            context,
                            MaterialPageRoute<void>(builder: (_) => const ScanQrScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
