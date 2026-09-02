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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: SafariTheme.cream,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: const Color(0xFFE8DCCB)),
            ),
            child: Row(
              children: [
                _nav(0, Icons.home_rounded, 'Home'),
                _nav(1, Icons.groups_rounded, 'Trips'),
                _nav(2, Icons.qr_code_2_rounded, 'QR'),
                _nav(3, Icons.account_balance_wallet_rounded, 'Wallet'),
                _nav(4, Icons.person_rounded, 'Me'),
              ],
            ),
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
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: on ? SafariTheme.maroon : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: on ? Colors.white : SafariTheme.muted, size: 22),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: on ? Colors.white : SafariTheme.muted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
