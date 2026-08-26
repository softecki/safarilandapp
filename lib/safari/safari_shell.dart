import 'package:flutter/material.dart';
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.groups_outlined), label: 'Trips'),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code_2), label: 'QR'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_outlined), label: 'Wallet'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}
