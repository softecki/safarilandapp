import 'package:flutter/material.dart';
import 'package:wicom/safari/safari_nav.dart';
import 'package:wicom/safari/safari_theme.dart';
import 'package:wicom/safari/safari_ui.dart';
import 'package:wicom/safari/screens/home_screen.dart';
import 'package:wicom/safari/screens/notifications_screen.dart';
import 'package:wicom/safari/screens/profile_screen.dart';
import 'package:wicom/safari/screens/qr_screen.dart';
import 'package:wicom/safari/screens/trips_screen.dart';
import 'package:wicom/safari/screens/wallet_screen.dart';

class SafariShell extends StatefulWidget {
  const SafariShell({super.key});

  @override
  State<SafariShell> createState() => _SafariShellState();
}

class _SafariShellState extends State<SafariShell> {
  int index = 0;
  int unread = 0;

  @override
  void initState() {
    super.initState();
    index = SafariTabs.index.value;
    SafariTabs.index.addListener(_onTab);
  }

  @override
  void dispose() {
    SafariTabs.index.removeListener(_onTab);
    super.dispose();
  }

  void _onTab() {
    if (!mounted) return;
    final next = SafariTabs.index.value;
    if (next != index) setState(() => index = next);
  }

  void _go(int i) {
    SafariTabs.go(i);
    setState(() => index = i);
  }

  static const _pages = [
    SafariHomeScreen(),
    SafariTripsScreen(),
    SafariQrScreen(),
    SafariWalletScreen(),
    SafariProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final qrOn = index == SafariTabs.qr;
    return Scaffold(
      body: Column(
        children: [
          SafariStickyHeader(
            unread: unread,
            onNotify: () => SafariNav.push(context, const SafariNotificationsScreen()),
          ),
          Expanded(child: IndexedStack(index: index, children: _pages)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'safari-qr-fab',
        onPressed: () => _go(SafariTabs.qr),
        backgroundColor: qrOn ? SafariTheme.gold : SafariTheme.maroon,
        foregroundColor: qrOn ? SafariTheme.maroonDark : Colors.white,
        child: const Icon(Icons.qr_code_2, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 10,
        shadowColor: SafariTheme.maroon.withValues(alpha: 0.16),
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        padding: EdgeInsets.zero,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              _navItem(SafariTabs.home, Icons.home_outlined, Icons.home_rounded, 'Home'),
              _navItem(SafariTabs.trips, Icons.groups_outlined, Icons.groups_rounded, 'Trips'),
              const SizedBox(width: 72),
              _navItem(SafariTabs.wallet, Icons.account_balance_wallet_outlined, Icons.account_balance_wallet_rounded, 'Wallet'),
              _navItem(SafariTabs.profile, Icons.person_outline, Icons.person_rounded, 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(int i, IconData icon, IconData active, String label) {
    final on = index == i;
    return Expanded(
      child: InkWell(
        onTap: () => _go(i),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(on ? active : icon, color: on ? SafariTheme.maroon : SafariTheme.muted),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: on ? SafariTheme.maroon : SafariTheme.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
