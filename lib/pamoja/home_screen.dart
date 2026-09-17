import 'package:flutter/material.dart';
import 'package:wicom/pamoja/brand.dart';
import 'package:wicom/pamoja/catalog.dart';
import 'package:wicom/pamoja/identity_screens.dart';
import 'package:wicom/pamoja/live_screen.dart';
import 'package:wicom/pamoja/mini_programs.dart';
import 'package:wicom/pamoja/session.dart';
import 'package:wicom/pamoja/widgets.dart';

class PamojaHomeScreen extends StatelessWidget {
  const PamojaHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = PamojaSession.instance;
    return ListView(
      padding: const EdgeInsets.only(bottom: 28),
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [PamojaBrand.lake, PamojaBrand.indigo]),
          ),
          child: SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('PAMOJA', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, letterSpacing: 1.4)),
                    const Spacer(),
                    Text('${s.lang} · SW', style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w600, fontSize: 12)),
                    const SizedBox(width: 10),
                    const Icon(Icons.notifications_none, color: Colors.white),
                  ],
                ),
                const SizedBox(height: 6),
                Text('${s.city} · ${s.country}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 16),
                Text('${s.greeting}, ${s.firstName}', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800)),
                const Text('Your match day plan is 4 of 6 complete', style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
        ),
        const PamojaSearch(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: PamojaCard(
            color: PamojaBrand.indigo,
            onTap: () => pushPamoja(context, const PamojaMatchCentreScreen()),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('NEXT MATCH', style: TextStyle(color: PamojaBrand.gold, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1)),
                SizedBox(height: 6),
                Text('Tanzania vs Kenya', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
                Text('Sat · 20:00 EAT · National Stadium', style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.55,
            children: [
              _Quick(icon: Icons.badge_outlined, color: PamojaBrand.lake, title: 'Fan ID', subtitle: 'Verified credential', onTap: () => pushPamoja(context, const PamojaFanIdScreen())),
              _Quick(icon: Icons.account_balance_wallet_outlined, color: PamojaBrand.indigo, title: 'Wallet', subtitle: 'TZS ${s.wallet}', onTap: () => pushPamoja(context, const PamojaWalletScreen())),
              _Quick(icon: Icons.flight_land, color: PamojaBrand.green, title: 'Travel', subtitle: 'My Arrival', onTap: () => pushPamoja(context, const PamojaArrivalScreen())),
              _Quick(icon: Icons.health_and_safety_outlined, color: PamojaBrand.danger, title: 'Safety', subtitle: 'SOS and help', onTap: () => pushPamoja(context, const PamojaSafetyScreen())),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 18, 20, 8),
          child: Text('Mini programs', style: TextStyle(fontWeight: FontWeight.w800, color: PamojaBrand.indigo)),
        ),
        ...() {
          final s = PamojaSession.instance;
          final groups = s.catalog.isNotEmpty
              ? s.catalog
              : [
                  CatalogGroup(
                    name: 'Featured',
                    apps: pamojaPrograms.take(8).map((p) => CatalogApp(slug: p.id, name: p.title, partner: p.partner, group: 'Lifestyle', status: 'Live')).toList(),
                  ),
                ];
          return groups.take(3).expand((group) {
            return [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 6),
                child: Text(group.name, style: const TextStyle(fontWeight: FontWeight.w700, color: PamojaBrand.muted, fontSize: 12)),
              ),
              SizedBox(
                height: 78,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: group.apps.map((app) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ActionChip(
                        label: Text(app.name),
                        onPressed: () => openCatalogApp(context, app),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ];
          }).toList();
        }(),
        Padding(
          padding: const EdgeInsets.all(16),
          child: PamojaCard(
            onTap: () => pushPamoja(context, const PamojaVisaScreen()),
            child: const Row(
              children: [
                Expanded(child: Text('eVisa decision expected today', style: TextStyle(fontWeight: FontWeight.w700))),
                PamojaPill('Pending', tone: 'warn'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Quick extends StatelessWidget {
  const _Quick({required this.icon, required this.color, required this.title, required this.subtitle, required this.onTap});
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PamojaCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const Spacer(),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w800, color: PamojaBrand.indigo)),
          Text(subtitle, style: const TextStyle(fontSize: 11, color: PamojaBrand.muted)),
        ],
      ),
    );
  }
}
