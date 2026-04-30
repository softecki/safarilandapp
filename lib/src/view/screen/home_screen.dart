import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import 'package:wicom/core/app_color.dart';
import 'package:wicom/src/view/screen/client_screen.dart';
import 'package:wicom/src/view/screen/dashboard_screen.dart';
import 'package:wicom/src/view/screen/login_screen.dart';
import 'package:wicom/src/view/screen/profile_screen.dart';
import 'package:wicom/src/view/screen/support_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static List<Widget> screens = [
    DashboardScreen(),
     ClientScreen(),
     SupportScreen(),
     ProfileScreen(),
  ];

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int newIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    // Set status bar color to green
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.green,
        statusBarIconBrightness: Brightness.light, // For dark icons on green background
      ),
    );
  }
  
  @override
  void dispose() {
    // Reset status bar to default when leaving this screen
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    super.dispose();
  }

  bool _isMobileSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth < 768; // Mobile breakpoint
  }

  Widget _getCurrentScreen() {
    try {
      if (newIndex >= 0 && newIndex < HomeScreen.screens.length) {
        return HomeScreen.screens[newIndex];
      } else {
        print('Invalid screen index: $newIndex, falling back to DashboardScreen');
        return DashboardScreen();
      }
    } catch (e) {
      print('Error getting screen: $e, falling back to DashboardScreen');
      return DashboardScreen();
    }
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = true;

    if (!isLoggedIn && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildBottomNavigationBar() {
    // Check if we should use mobile-friendly navigation
    final shouldUseMobileNav = kIsWeb ? _isMobileSize(context) : true;
    final screenWidth = MediaQuery.of(context).size.width;
    
    print('Screen width: $screenWidth, Using mobile nav: $shouldUseMobileNav'); // Debug log
    
    if (!shouldUseMobileNav) {
      return Container(
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
            print('StylishBottomBar tapped: $index'); // Debug log
            print('Previous index: $newIndex, New index: $index'); // More detailed debug
            
            // Add haptic feedback for better user experience
            HapticFeedback.lightImpact();
            
            if (mounted) {
              setState(() {
                newIndex = index;
              });
              print('State updated successfully to index: $newIndex');
            }
          },
          items: [
            BottomBarItem(
              backgroundColor: AppColor.primaryColor.withOpacity(0.2),
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home),
              title: const Text('Home'),
            ),
            BottomBarItem(
              backgroundColor: Colors.blue.withOpacity(0.2),
              icon: const Icon(Icons.people_outline),
              selectedIcon: const Icon(Icons.people),
              title: const Text('Clients'),
            ),
            BottomBarItem(
              backgroundColor: Colors.green.withOpacity(0.2),
              icon: const Icon(Icons.support_agent_outlined),
              selectedIcon: const Icon(Icons.support_agent),
              title: const Text('Support'),
            ),
            BottomBarItem(
              backgroundColor: Colors.purple.withOpacity(0.2),
              icon: const Icon(Icons.person_outline),
              selectedIcon: const Icon(Icons.person),
              title: const Text('Profile'),
            ),
          ],
          option: BubbleBarOptions(
            opacity: 0.15,
            inkColor: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(16),
            barStyle: BubbleBarStyle.horizontal,
          ),
        ),
      );
    } else {
      // Fallback to standard BottomNavigationBar for better mobile compatibility
      return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: newIndex,
        onTap: (index) {
          print('Standard BottomNavBar tapped: $index'); // Debug log
          print('Previous index: $newIndex, New index: $index'); // More detailed debug
          
          // Add haptic feedback for better user experience
          HapticFeedback.lightImpact();
          
          if (mounted) {
            setState(() {
              newIndex = index;
            });
            print('State updated successfully to index: $newIndex');
          }
        },
        selectedItemColor: AppColor.primaryColor,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'Clients',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.support_agent_outlined),
            activeIcon: Icon(Icons.support_agent),
            label: 'Support',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Since navigation is now handled in DashboardScreen, just return the dashboard
    // Add padding to avoid overlap with system status bar (time, battery, etc.)
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 5),
      child: const DashboardScreen(),
    );
  }
}
