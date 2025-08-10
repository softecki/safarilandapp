import 'package:wicom/src/view/screen/paymentProfile.dart';
import 'package:wicom/src/view/screen/register_product.dart';
import 'package:wicom/src/view/screen/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:wicom/core/app_data.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import 'package:wicom/src/view/animation/page_transition_switcher_wrapper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static List<Widget> screens = [
    DashboardScreen(),
     TransactionListScreen(),
     PaymentScreen(),
  ];

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int newIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Scaffold(
          backgroundColor: Colors.grey[200],
          bottomNavigationBar: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.9),
                  offset: const Offset(-4, -4),
                  blurRadius: 6,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(4, 4),
                  blurRadius: 6,
                ),
              ],
            ),
            child: StylishBottomBar(
              backgroundColor: Colors.grey[200],
              elevation: 0,
              currentIndex: newIndex,
              onTap: (index) {
                setState(() {
                  newIndex = index;
                });
              },
              items: AppData.bottomNavBarItems.map(
                    (item) {
                  return BottomBarItem(
                    backgroundColor: item.activeColor.withOpacity(0.2),
                    icon: item.icon,
                    title: Text(
                      item.title,
                      style: TextStyle(
                        color: item.activeColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                },
              ).toList(),
              option: BubbleBarOptions(
                opacity: 0.15,
                inkColor: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(16),
                barStyle: BubbleBarStyle.horizontal,
                // iconStyle: IconStyle(
                //   size: 24, // ✅ Correct usage here
                //   selectedColor: Colors.black,
                //   color: Colors.grey,
                // ),
              ),
            ),
          ),
          body: PageTransitionSwitcherWrapper(
            child: HomeScreen.screens[newIndex],
          ),
        ),
      ),
    );
  }
}
