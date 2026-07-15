import 'package:flutter/material.dart';
import 'package:wicom/faidabiz/screens/home_screen.dart';

/// Entry shell — home feature grid only (no bottom navigation).
class FaidaBizShell extends StatelessWidget {
  const FaidaBizShell({super.key});

  @override
  Widget build(BuildContext context) {
    return const FaidaBizHomeScreen();
  }
}
