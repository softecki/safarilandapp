import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wicom/faidabiz/faidabiz_api.dart';
import 'package:wicom/faidabiz/faidabiz_theme.dart';
import 'package:wicom/faidabiz/screens/activity_screen.dart';
import 'package:wicom/faidabiz/screens/login_screen.dart';

class FaidaBizSettingsScreen extends StatelessWidget {
  const FaidaBizSettingsScreen({super.key});

  Future<void> _setLanguage(BuildContext context, Locale next) async {
    await context.setLocale(next);
    try {
      final res = await FaidaBizApi.put('/business', {'language': next.languageCode});
      final u = res['user'] as Map<String, dynamic>?;
      if (u != null && FaidaBizApi.token != null) {
        await FaidaBizApi.saveSession(FaidaBizApi.token!, u);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final biz = FaidaBizApi.user?['business'] as Map<String, dynamic>?;
    return Scaffold(
      appBar: AppBar(title: Text('nav.settings'.tr())),
      body: ListView(
        children: [
          ListTile(
            title: Text(biz?['name']?.toString() ?? 'FaidaBiz'),
            subtitle: Text('${biz?['business_type'] ?? ''} · ${FaidaBizApi.user?['phone'] ?? ''}'),
            leading: const CircleAvatar(backgroundColor: FaidaBizTheme.green, child: Icon(Icons.store, color: Colors.white)),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.history),
            title: Text('settings.activity'.tr()),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FaidaBizActivityScreen())),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text('settings.language'.tr()),
            subtitle: Text(context.locale.languageCode == 'sw' ? 'Kiswahili' : 'English'),
            onTap: () {
              final next = context.locale.languageCode == 'sw' ? const Locale('en') : const Locale('sw');
              _setLanguage(context, next);
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('FaidaBiz'),
            subtitle: Text('brand.tagline'.tr()),
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text('settings.logout'.tr(), style: const TextStyle(color: Colors.red)),
            onTap: () async {
              await FaidaBizApi.logout();
              if (!context.mounted) return;
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const FaidaBizLoginScreen()),
                (_) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
