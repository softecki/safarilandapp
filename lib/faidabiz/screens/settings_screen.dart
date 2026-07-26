import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wicom/faidabiz/faidabiz_api.dart';
import 'package:wicom/faidabiz/faidabiz_theme.dart';
import 'package:wicom/faidabiz/screens/activity_screen.dart';
import 'package:wicom/faidabiz/screens/login_screen.dart';
import 'package:wicom/faidabiz/screens/referrals_screen.dart';
import 'package:wicom/faidabiz/screens/settings_add_business_screen.dart';
import 'package:wicom/faidabiz/screens/settings_add_staff_screen.dart';
import 'package:wicom/faidabiz/screens/subscription_screen.dart';
import 'package:wicom/faidabiz/screens/support_chat_screen.dart';
import 'package:wicom/faidabiz/screens/user_manual_screen.dart';

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
    if (mounted) setState(() {});
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
    final user = FaidaBizApi.user;
    final businesses = _businesses.isNotEmpty ? _businesses : _businessesFromUser();
    final isSw = context.locale.languageCode == 'sw';

    return Scaffold(
      backgroundColor: const Color(0xFFF3F7F4),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: FaidaBizTheme.green))
          : RefreshIndicator(
              onRefresh: _load,
              color: FaidaBizTheme.green,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(child: _HeroHeader(biz: biz, user: user)),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        if (_error != null) ...[
                          const SizedBox(height: 12),
                          _ErrorBanner(message: _error!),
                        ],
                        const SizedBox(height: 16),
                        _SectionCard(
                          title: 'settings.my_businesses'.tr(),
                          icon: Icons.storefront_rounded,
                          child: Column(
                            children: [
                              if (businesses.isEmpty)
                                _EmptyHint(text: 'settings.no_businesses'.tr())
                              else
                                ...businesses.map((b) {
                                  final id = (b['id'] as num?)?.toInt() ?? 0;
                                  final active = b['is_active'] == true;
                                  final role = b['role']?.toString() ?? '';
                                  return _BusinessRow(
                                    name: b['name']?.toString() ?? '',
                                    subtitle: [
                                      if (b['business_type'] != null) b['business_type'].toString(),
                                      if (role.isNotEmpty)
                                        role == 'owner' ? 'settings.role_owner'.tr() : 'settings.role_staff'.tr(),
                                    ].join(' · '),
                                    active: active,
                                    switching: _switching,
                                    onSwitch: () => _switchBusiness(id),
                                  );
                                }),
                              if (_checkOwner()) ...[
                                const SizedBox(height: 8),
                                _ActionTile(
                                  icon: Icons.add_business_rounded,
                                  color: FaidaBizTheme.green,
                                  title: 'settings.business_add'.tr(),
                                  onTap: _openAddBusiness,
                                ),
                              ],
                            ],
                          ),
                        ),
                        if (_checkOwner()) ...[
                          const SizedBox(height: 14),
                          _SectionCard(
                            title: 'settings.team'.tr(),
                            icon: Icons.groups_rounded,
                            child: Column(
                              children: [
                                if (_team.isEmpty)
                                  _EmptyHint(text: 'settings.team_empty'.tr())
                                else
                                  ..._team.map((m) => _TeamRow(
                                        name: m['name']?.toString() ?? '',
                                        phone: m['phone']?.toString() ?? '',
                                        isOwner: m['role'] == 'owner',
                                      )),
                                const SizedBox(height: 8),
                                _ActionTile(
                                  icon: Icons.person_add_alt_1_rounded,
                                  color: Colors.blueGrey,
                                  title: 'settings.team_add'.tr(),
                                  subtitle: 'settings.team_add_sub'.tr(),
                                  onTap: _openAddStaff,
                                ),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: 14),
                        _SectionCard(
                          title: 'subscription.section'.tr(),
                          icon: Icons.workspace_premium_rounded,
                          child: Column(
                            children: [
                              _NavTile(
                                icon: Icons.payments_outlined,
                                iconColor: FaidaBizTheme.green,
                                title: 'subscription.title'.tr(),
                                subtitle: 'subscription.section_hint'.tr(),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const FaidaBizSubscriptionScreen()),
                                ),
                              ),
                              _NavTile(
                                icon: Icons.person_add_alt_1_rounded,
                                iconColor: Colors.teal,
                                title: 'subscription.invite_friends'.tr(),
                                subtitle: 'subscription.invite_hint'.tr(),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const FaidaBizReferralsScreen()),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        _SectionCard(
                          title: 'settings.preferences'.tr(),
                          icon: Icons.tune_rounded,
                          child: Column(
                            children: [
                              _NavTile(
                                icon: Icons.chat_bubble_outline_rounded,
                                iconColor: const Color(0xFF128C7E),
                                title: 'nav.chat'.tr(),
                                subtitle: 'chat.subtitle'.tr(),
                                badge: _unreadChat,
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const FaidaBizSupportChatScreen()),
                                  );
                                  _load();
                                },
                              ),
                              _NavTile(
                                icon: Icons.menu_book_rounded,
                                iconColor: Colors.teal.shade700,
                                title: 'manual.title'.tr(),
                                subtitle: 'manual.settings_tile_hint'.tr(),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const FaidaBizUserManualScreen()),
                                ),
                              ),
                              _NavTile(
                                icon: Icons.history_rounded,
                                iconColor: FaidaBizTheme.greenDark,
                                title: 'settings.activity'.tr(),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const FaidaBizActivityScreen()),
                                ),
                              ),
                              _NavTile(
                                icon: Icons.language_rounded,
                                iconColor: Colors.indigo,
                                title: 'settings.language'.tr(),
                                subtitle: isSw ? 'Kiswahili' : 'English',
                                trailing: _LangToggle(
                                  isSw: isSw,
                                  onChanged: (sw) => _setLanguage(sw ? const Locale('sw') : const Locale('en')),
                                ),
                                onTap: () => _setLanguage(isSw ? const Locale('en') : const Locale('sw')),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        _SectionCard(
                          title: 'settings.about'.tr(),
                          icon: Icons.info_outline_rounded,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Brand header
                              Row(
                                children: [
                                  Container(
                                    width: 52,
                                    height: 52,
                                    decoration: BoxDecoration(
                                      color: FaidaBizTheme.green,
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: const Icon(Icons.storefront_rounded, color: Colors.white, size: 28),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('FaidaBiz', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: FaidaBizTheme.greenDark)),
                                      Text('about.version'.tr(), style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'about.description'.tr(),
                                style: TextStyle(color: Colors.grey.shade800, height: 1.5, fontSize: 13.5),
                              ),
                              const SizedBox(height: 16),
                              Text('about.features_title'.tr(), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: FaidaBizTheme.greenDark)),
                              const SizedBox(height: 10),
                              ...[
                                ('about.feat_sales_icon', 'about.feat_sales_title', 'about.feat_sales_body', Icons.point_of_sale_rounded, FaidaBizTheme.green),
                                ('about.feat_expenses_icon', 'about.feat_expenses_title', 'about.feat_expenses_body', Icons.payments_rounded, Colors.orange.shade700),
                                ('about.feat_purchases_icon', 'about.feat_purchases_title', 'about.feat_purchases_body', Icons.shopping_bag_rounded, Colors.brown.shade600),
                                ('about.feat_products_icon', 'about.feat_products_title', 'about.feat_products_body', Icons.inventory_2_rounded, FaidaBizTheme.greenDark),
                                ('about.feat_debts_icon', 'about.feat_debts_title', 'about.feat_debts_body', Icons.handshake_rounded, Colors.deepOrange.shade600),
                                ('about.feat_reports_icon', 'about.feat_reports_title', 'about.feat_reports_body', Icons.bar_chart_rounded, Colors.indigo),
                                ('about.feat_team_icon', 'about.feat_team_title', 'about.feat_team_body', Icons.groups_rounded, Colors.blueGrey),
                                ('about.feat_multi_icon', 'about.feat_multi_title', 'about.feat_multi_body', Icons.store_mall_directory_rounded, Colors.teal),
                                ('about.feat_referral_icon', 'about.feat_referral_title', 'about.feat_referral_body', Icons.person_add_rounded, Colors.purple.shade600),
                                ('about.feat_subscription_icon', 'about.feat_subscription_title', 'about.feat_subscription_body', Icons.workspace_premium_rounded, Colors.amber.shade800),
                                ('about.feat_chat_icon', 'about.feat_chat_title', 'about.feat_chat_body', Icons.chat_rounded, const Color(0xFF128C7E)),
                              ].map((f) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: f.$5.withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(f.$4, color: f.$5, size: 20),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(f.$2.tr(), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
                                          const SizedBox(height: 2),
                                          Text(f.$3.tr(), style: TextStyle(fontSize: 12.5, color: Colors.grey.shade700, height: 1.4)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                              const Divider(height: 24),
                              Text('about.contact'.tr(), style: TextStyle(fontSize: 12.5, color: Colors.grey.shade600, height: 1.4)),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  onPressed: () async {
                                    await FaidaBizApi.logout();
                                    if (!context.mounted) return;
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(builder: (_) => const FaidaBizLoginScreen()),
                                      (_) => false,
                                    );
                                  },
                                  icon: const Icon(Icons.logout_rounded, color: Colors.red),
                                  label: Text('settings.logout'.tr(), style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w700)),
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: Colors.red.shade200),
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _HeroHeader extends StatelessWidget {
  const _HeroHeader({required this.biz, required this.user});

  final Map<String, dynamic>? biz;
  final Map<String, dynamic>? user;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16, MediaQuery.of(context).padding.top + 12, 16, 28),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [FaidaBizTheme.green, FaidaBizTheme.greenDark],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              ),
              Expanded(
                child: Text(
                  'nav.settings'.tr(),
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
                ),
                child: const Icon(Icons.store_rounded, color: Colors.white, size: 32),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      biz?['name']?.toString() ?? 'FaidaBiz',
                      style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      [
                        if ((biz?['business_type']?.toString() ?? '').isNotEmpty) biz!['business_type'].toString(),
                        if ((user?['phone']?.toString() ?? '').isNotEmpty) user!['phone'].toString(),
                      ].join(' · '),
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 13),
                    ),
                    if ((user?['name']?.toString() ?? '').isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        user!['name'].toString(),
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.icon, required this.child});

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 16, offset: const Offset(0, 6)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: FaidaBizTheme.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: FaidaBizTheme.green, size: 20),
              ),
              const SizedBox(width: 10),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _BusinessRow extends StatelessWidget {
  const _BusinessRow({
    required this.name,
    required this.subtitle,
    required this.active,
    required this.switching,
    required this.onSwitch,
  });

  final String name;
  final String subtitle;
  final bool active;
  final bool switching;
  final VoidCallback onSwitch;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: active ? FaidaBizTheme.green.withValues(alpha: 0.08) : const Color(0xFFF7FAF8),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: active ? FaidaBizTheme.green.withValues(alpha: 0.35) : Colors.grey.shade200),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        leading: Icon(active ? Icons.check_circle_rounded : Icons.store_outlined, color: active ? FaidaBizTheme.green : Colors.grey),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: subtitle.isEmpty ? null : Text(subtitle),
        trailing: active
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: FaidaBizTheme.green,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('settings.active'.tr(), style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
              )
            : switching
                ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2))
                : TextButton(onPressed: onSwitch, child: Text('settings.switch'.tr())),
        onTap: active || switching ? null : onSwitch,
      ),
    );
  }
}

class _TeamRow extends StatelessWidget {
  const _TeamRow({required this.name, required this.phone, required this.isOwner});

  final String name;
  final String phone;
  final bool isOwner;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAF8),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: isOwner ? FaidaBizTheme.green : Colors.blueGrey,
            child: Icon(isOwner ? Icons.star_rounded : Icons.person_rounded, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w700)),
                Text(
                  '$phone · ${isOwner ? 'settings.role_owner'.tr() : 'settings.role_staff'.tr()}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.color,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(fontWeight: FontWeight.w700, color: color)),
                    if (subtitle != null)
                      Text(subtitle!, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: color),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  const _NavTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    this.badge = 0,
    this.trailing,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final int badge;
  final Widget? trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: subtitle == null ? null : Text(subtitle!),
      trailing: trailing ??
          (badge > 0
              ? CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.red,
                  child: Text('$badge', style: const TextStyle(color: Colors.white, fontSize: 11)),
                )
              : const Icon(Icons.chevron_right_rounded, color: Colors.grey)),
      onTap: onTap,
    );
  }
}

class _LangToggle extends StatelessWidget {
  const _LangToggle({required this.isSw, required this.onChanged});

  final bool isSw;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _LangChip(label: 'EN', selected: !isSw, onTap: () => onChanged(false)),
        const SizedBox(width: 6),
        _LangChip(label: 'SW', selected: isSw, onTap: () => onChanged(true)),
      ],
    );
  }
}

class _LangChip extends StatelessWidget {
  const _LangChip({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? FaidaBizTheme.green : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: selected ? Colors.white : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }
}

class _EmptyHint extends StatelessWidget {
  const _EmptyHint({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(text, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade100),
      ),
      child: Text(message, style: TextStyle(color: Colors.red.shade800, fontSize: 13)),
    );
  }
}
