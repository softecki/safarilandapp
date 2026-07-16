import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wicom/faidabiz/faidabiz_api.dart';
import 'package:wicom/faidabiz/faidabiz_theme.dart';
import 'package:wicom/faidabiz/screens/activity_screen.dart';
import 'package:wicom/faidabiz/screens/login_screen.dart';
import 'package:wicom/faidabiz/screens/settings_add_business_screen.dart';
import 'package:wicom/faidabiz/screens/settings_add_staff_screen.dart';
import 'package:wicom/faidabiz/screens/settings_migrations_screen.dart';
import 'package:wicom/faidabiz/screens/support_chat_screen.dart';

class FaidaBizSettingsScreen extends StatefulWidget {
  const FaidaBizSettingsScreen({super.key});

  @override
  State<FaidaBizSettingsScreen> createState() => _FaidaBizSettingsScreenState();
}

class _FaidaBizSettingsScreenState extends State<FaidaBizSettingsScreen> {
  List<Map<String, dynamic>> _businesses = [];
  List<Map<String, dynamic>> _team = [];
  bool _loading = true;
  bool _switching = false;
  int _unreadChat = 0;
  String? _error;

  bool _checkOwner([Map<String, dynamic>? u]) {
    u ??= FaidaBizApi.user;
    if (u?['is_owner'] == true) return true;
    final biz = u?['business'] as Map<String, dynamic>?;
    if (biz?['is_owner'] == true || biz?['role'] == 'owner') return true;
    for (final b in _businesses) {
      if (b['role'] == 'owner' && b['is_active'] == true) return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final businesses = await FaidaBizApi.fetchMyBusinesses();
      List<Map<String, dynamic>> team = [];
      if (!mounted) return;
      setState(() => _businesses = businesses);
      if (_checkOwner()) {
        try {
          team = await FaidaBizApi.fetchTeam();
        } catch (_) {}
      }
      try {
        final home = await FaidaBizApi.get('/home');
        final n = home['unread_chat'];
        if (n is num) _unreadChat = n.toInt();
      } catch (_) {}
      if (!mounted) return;
      setState(() {
        _businesses = businesses;
        _team = team;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
        _businesses = _businessesFromUser();
      });
    }
  }

  List<Map<String, dynamic>> _businessesFromUser() {
    final raw = FaidaBizApi.user?['businesses'];
    if (raw is List) {
      return raw.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
    }
    final biz = FaidaBizApi.user?['business'];
    if (biz is Map) {
      return [Map<String, dynamic>.from(biz)];
    }
    return [];
  }

  Future<void> _setLanguage(Locale next) async {
    await context.setLocale(next);
    try {
      final res = await FaidaBizApi.put('/business', {'language': next.languageCode});
      final u = res['user'] as Map<String, dynamic>?;
      if (u != null && FaidaBizApi.token != null) {
        await FaidaBizApi.saveSession(FaidaBizApi.token!, u);
      }
    } catch (_) {}
  }

  Future<void> _switchBusiness(int id) async {
    if (_switching) return;
    setState(() => _switching = true);
    try {
      await FaidaBizApi.switchBusiness(id);
      await _load();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('settings.business_switched'.tr())));
      Navigator.pop(context, true);
    } on FaidaBizApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _switching = false);
    }
  }

  Future<void> _openAddBusiness() async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const FaidaBizAddBusinessScreen()),
    );
    if (changed == true) {
      await _load();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('settings.business_added'.tr())));
        Navigator.pop(context, true);
      }
    }
  }

  Future<void> _openAddStaff() async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const FaidaBizAddStaffScreen()),
    );
    if (changed == true) {
      await _load();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('settings.team_added'.tr())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final biz = FaidaBizApi.user?['business'] as Map<String, dynamic>?;
    final businesses = _businesses.isNotEmpty ? _businesses : _businessesFromUser();

    return Scaffold(
      appBar: AppBar(title: Text('nav.settings'.tr())),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: FaidaBizTheme.green))
          : RefreshIndicator(
              onRefresh: _load,
              color: FaidaBizTheme.green,
              child: ListView(
                children: [
                  ListTile(
                    title: Text(biz?['name']?.toString() ?? 'FaidaBiz'),
                    subtitle: Text('${biz?['business_type'] ?? ''} · ${FaidaBizApi.user?['phone'] ?? ''}'),
                    leading: const CircleAvatar(
                      backgroundColor: FaidaBizTheme.green,
                      child: Icon(Icons.store, color: Colors.white),
                    ),
                  ),
                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 13)),
                    ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                    child: Text('settings.my_businesses'.tr(), style: Theme.of(context).textTheme.titleSmall),
                  ),
                  if (businesses.isEmpty)
                    ListTile(title: Text('settings.no_businesses'.tr()))
                  else
                    ...businesses.map((b) {
                      final id = (b['id'] as num?)?.toInt() ?? 0;
                      final active = b['is_active'] == true;
                      final role = b['role']?.toString() ?? '';
                      return ListTile(
                        leading: Icon(active ? Icons.check_circle : Icons.store_outlined, color: active ? FaidaBizTheme.green : null),
                        title: Text(b['name']?.toString() ?? ''),
                        subtitle: Text(
                          [
                            if (b['business_type'] != null) b['business_type'].toString(),
                            if (role.isNotEmpty) role == 'owner' ? 'settings.role_owner'.tr() : 'settings.role_staff'.tr(),
                          ].join(' · '),
                        ),
                        trailing: active
                            ? Chip(
                                label: Text('settings.active'.tr()),
                                backgroundColor: FaidaBizTheme.green.withValues(alpha: 0.12),
                                labelStyle: const TextStyle(color: FaidaBizTheme.green, fontSize: 12),
                              )
                            : _switching
                                ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                                : TextButton(onPressed: () => _switchBusiness(id), child: Text('settings.switch'.tr())),
                        onTap: active || _switching ? null : () => _switchBusiness(id),
                      );
                    }),
                  if (_checkOwner())
                    ListTile(
                      leading: const Icon(Icons.add_business),
                      title: Text('settings.business_add'.tr()),
                      onTap: _openAddBusiness,
                    ),
                  const Divider(),
                  if (_checkOwner()) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                      child: Text('settings.team'.tr(), style: Theme.of(context).textTheme.titleSmall),
                    ),
                    if (_team.isEmpty)
                      ListTile(title: Text('settings.team_empty'.tr()))
                    else
                      ..._team.map((m) => ListTile(
                            leading: CircleAvatar(
                              backgroundColor: m['role'] == 'owner' ? FaidaBizTheme.green : Colors.blueGrey,
                              child: Icon(m['role'] == 'owner' ? Icons.star : Icons.person, color: Colors.white, size: 20),
                            ),
                            title: Text(m['name']?.toString() ?? ''),
                            subtitle: Text('${m['phone'] ?? ''} · ${m['role'] == 'owner' ? 'settings.role_owner'.tr() : 'settings.role_staff'.tr()}'),
                          )),
                    ListTile(
                      leading: const Icon(Icons.person_add),
                      title: Text('settings.team_add'.tr()),
                      subtitle: Text('settings.team_add_sub'.tr()),
                      onTap: _openAddStaff,
                    ),
                    const Divider(),
                  ],
                  ListTile(
                    leading: const Icon(Icons.storage),
                    title: Text('settings.migrations'.tr()),
                    subtitle: Text('settings.migrations_hint'.tr()),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const FaidaBizSettingsMigrationsScreen()),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.chat_bubble_outline, color: Color(0xFF128C7E)),
                    title: Text('nav.chat'.tr()),
                    subtitle: Text('chat.subtitle'.tr()),
                    trailing: _unreadChat > 0
                        ? CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.red,
                            child: Text('$_unreadChat', style: const TextStyle(color: Colors.white, fontSize: 11)),
                          )
                        : null,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const FaidaBizSupportChatScreen()),
                      );
                      _load();
                    },
                  ),
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
                      _setLanguage(next);
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
            ),
    );
  }
}
