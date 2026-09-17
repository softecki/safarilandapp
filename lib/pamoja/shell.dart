import 'package:flutter/material.dart';
import 'package:wicom/pamoja/brand.dart';
import 'package:wicom/pamoja/community_screen.dart';
import 'package:wicom/pamoja/explore_screen.dart';
import 'package:wicom/pamoja/home_screen.dart';
import 'package:wicom/pamoja/identity_screens.dart';
import 'package:wicom/pamoja/live_screen.dart';
import 'package:wicom/pamoja/session.dart';

class PamojaShell extends StatefulWidget {
  const PamojaShell({super.key});

  @override
  State<PamojaShell> createState() => _PamojaShellState();
}

class _PamojaShellState extends State<PamojaShell> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const PamojaHomeScreen(),
      const PamojaLiveScreen(),
      const PamojaExploreScreen(),
      const PamojaCommunityScreen(),
      const PamojaMeScreen(),
    ];
    return ListenableBuilder(
      listenable: PamojaSession.instance,
      builder: (context, _) {
        return Scaffold(
          body: IndexedStack(index: index, children: pages),
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: PamojaBrand.border)),
            ),
            child: BottomNavigationBar(
              currentIndex: index,
              onTap: (i) => setState(() => index = i),
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home_rounded), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.play_circle_outline), activeIcon: Icon(Icons.play_circle_fill), label: 'Live'),
                BottomNavigationBarItem(icon: Icon(Icons.grid_view_outlined), activeIcon: Icon(Icons.grid_view_rounded), label: 'Explore'),
                BottomNavigationBarItem(icon: Icon(Icons.groups_outlined), activeIcon: Icon(Icons.groups_rounded), label: 'Community'),
                BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Me'),
              ],
            ),
          ),
        );
      },
    );
  }
}
