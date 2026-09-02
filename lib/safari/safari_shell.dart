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

  @override
  Widget build(BuildContext context) {
    final pages = const [
      SafariHomeScreen(),
      SafariTripsScreen(),
      SafariQrScreen(),
      SafariWalletScreen(),
      SafariProfileScreen(),
    ];
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: SafeArea(
        top: false,
        child: SizedBox(
          height: 92,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              Positioned(
                left: 16,
                right: 16,
                bottom: 10,
                child: Container(
                  height: 58,
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    color: SafariTheme.cream,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: const Color(0xFFE8DCCB)),
                  ),
                  child: Row(
                    children: [
                      _nav(0, Icons.home_rounded, 'Home'),
                      _nav(1, Icons.groups_rounded, 'Trips'),
                      const SizedBox(width: 68),
                      _nav(3, Icons.account_balance_wallet_rounded, 'Wallet'),
                      _nav(4, Icons.person_rounded, 'Me'),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 28,
                child: GestureDetector(
                  onTap: () => setState(() => index = 2),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    height: 68,
                    width: 68,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index == 2 ? SafariTheme.maroon : SafariTheme.maroonDark,
                      border: Border.all(color: SafariTheme.gold, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: SafariTheme.maroon.withValues(alpha: 0.28),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.qr_code_2_rounded, color: Colors.white, size: 28),
                        Text(
                          'QR',
                          style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 0.6),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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
        borderRadius: BorderRadius.circular(20),
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
