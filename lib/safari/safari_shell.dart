import 'package:flutter/material.dart';
import 'package:wicom/safari/safari_theme.dart';
import 'package:wicom/safari/screens/home_screen.dart';
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

  static const _pages = [
    SafariHomeScreen(),
    SafariTripsScreen(),
    SafariQrScreen(),
    SafariWalletScreen(),
    SafariProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final inset = MediaQuery.paddingOf(context).bottom;
    final qrSelected = index == 2;
    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: index, children: _pages),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        heroTag: 'safari-qr-fab',
        onPressed: () => setState(() => index = 2),
        backgroundColor: qrSelected ? SafariTheme.maroon : SafariTheme.maroonDark,
        foregroundColor: Colors.white,
        elevation: 8,
        highlightElevation: 12,
        shape: const CircleBorder(
          side: BorderSide(color: SafariTheme.gold, width: 3),
        ),
        child: const Icon(Icons.qr_code_2_rounded, size: 30),
      ),
      bottomNavigationBar: BottomAppBar(
        color: SafariTheme.cream,
        surfaceTintColor: Colors.transparent,
        elevation: 10,
        shadowColor: Colors.black26,
        padding: EdgeInsets.zero,
        height: 56 + inset,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Padding(
          padding: EdgeInsets.only(bottom: inset),
          child: Row(
            children: [
              _nav(0, Icons.home_rounded, 'Home'),
              _nav(1, Icons.groups_rounded, 'Trips'),
              const SizedBox(width: 72),
              _nav(3, Icons.account_balance_wallet_rounded, 'Wallet'),
              _nav(4, Icons.person_rounded, 'Me'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _nav(int i, IconData icon, String label) {
    final on = index == i;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => index = i),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: on ? SafariTheme.maroon : SafariTheme.muted, size: 22),
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
