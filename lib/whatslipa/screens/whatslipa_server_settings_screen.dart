import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:wicom/core/app_color.dart';
import 'package:wicom/core/whatslipa_brand.dart';
import 'package:wicom/core/whatslipa_config.dart';
import 'package:wicom/src/view/widgets/neumorphic_widgets.dart';

class WhatsLipaServerSettingsScreen extends StatefulWidget {
  const WhatsLipaServerSettingsScreen({super.key});

  @override
  State<WhatsLipaServerSettingsScreen> createState() => _WhatsLipaServerSettingsScreenState();
}

class _WhatsLipaServerSettingsScreenState extends State<WhatsLipaServerSettingsScreen> {
  final _ctrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _ctrl.text = WhatsLipaConfig.portalWebUrl;
  }

  Future<void> _save() async {
    await WhatsLipaConfig.lockPortalAfterLogin(_ctrl.text);
    await WhatsLipaBrand.syncFromPortal();
    if (!mounted) return;
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Server URL saved')),
    );
  }

  Future<void> _resetPortal() async {
    await WhatsLipaConfig.clearPortalLock();
    if (!mounted) return;
    setState(() => _ctrl.text = WhatsLipaConfig.defaultConfigServerUrl);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Portal reset — try sign in again')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.neumorphicBase,
      appBar: AppBar(
        backgroundColor: AppColor.neumorphicBase,
        elevation: 0,
        foregroundColor: AppColor.primaryColor,
        title: const Text('Portal server', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: NeuScreenCanvas(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Portal base address (set by your administrator). After save, only this portal is used for sign-in.',
                style: TextStyle(color: AppColor.textSecondary, fontSize: 14),
              ),
              const SizedBox(height: 16),
              NeuTextField(
                controller: _ctrl,
                labelText: 'Portal address',
                hintText: 'https://your-portal.example.com',
                prefixIcon: Icons.link_rounded,
              ),
              const SizedBox(height: 24),
              NeuPrimaryButton(label: 'Save', icon: Icons.save_rounded, onPressed: _save),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: _resetPortal,
                child: const Text('Reset portal (try all servers on login)'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
