import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iconsax/iconsax.dart';
import 'package:wicom/core/app_color.dart';
import '../../data/database_helper.dart';
import '../../data/drift_database.dart';
import '../../data/drift_web_database_helper.dart';
import '../../services/api_service.dart';
import '../../utils/navigation_helper.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool hasUsers = false;
  bool isLoading = true;
  Map<String, dynamic>? userData;
  String userName = 'User';
  String userEmail = '';
  String userPhone = '';

  @override
  void initState() {
    super.initState();
    _loadSavedLanguage();
    _loadUserData();
  }

  Future<void> _loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguageCode = prefs.getString('selected_language_code');
      
      if (savedLanguageCode != null && mounted) {
        context.setLocale(Locale(savedLanguageCode));
      }
    } catch (e) {
      print('Error loading saved language: $e');
    }
  }

  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final phone = prefs.getString('code_number');
      
      if (phone != null && phone.isNotEmpty) {
        // First check SharedPreferences (fastest, works on both platforms)
        String? savedName = prefs.getString('display_name');
        String? savedEmail = prefs.getString('email');
        
        String name = '';
        String email = '';
        
        // If not in SharedPreferences, try to get from database
        if (savedName == null || savedName.isEmpty) {
          final isWeb = kIsWeb;
          
          if (isWeb) {
            // Web platform - Use Drift database
            try {
              final driftDb = AppDatabase();
              final customers = await driftDb.select(driftDb.customer).get();
              if (customers.isNotEmpty) {
                final customer = customers.first;
                name = customer.displayName ?? '';
                // Note: Customer table doesn't have email field, email comes from SharedPreferences or API
              }
            } catch (e) {
              print('Error getting name from Drift: $e');
            }
          } else {
            // Mobile platform - Use SQLite database
            try {
              name = await DatabaseHelper.instance.getName(phone);
            } catch (e) {
              print('Error getting name from SQLite: $e');
            }
          }
        } else {
          name = savedName;
        }
        
        // If still no name, try API as last resort
        if (name.isEmpty) {
          try {
            final profile = await ApiService().getUserProfile();
            final data = profile['data'];
            name = data['display_name'] ?? data['name'] ?? 'User'.tr();
            email = data['email'] ?? savedEmail ?? '';
            userData = data;
          } catch (e) {
            print('Error getting profile from API: $e');
          }
        }
        
        setState(() {
          hasUsers = true;
          userName = name.isNotEmpty ? name : 'User'.tr();
          userEmail = email.isNotEmpty ? email : (savedEmail ?? '');
          userPhone = phone;
          isLoading = false;
        });
        
        print('Profile loaded:');
        print('userName: $userName');
        print('userEmail: $userEmail');
        print('userPhone: $userPhone');
      } else {
        setState(() {
          hasUsers = false;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        hasUsers = false;
        isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await DatabaseHelper.instance.logOutUser();
    if (!mounted) return;
    NavigationHelper.navigateAndRemoveUntil(
      context,
      LoginScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: isLoading 
        ? const Center(child: CircularProgressIndicator())
        : hasUsers ? _buildProfileView() : _buildLoginPrompt(),
    );
  }

  Widget _buildProfileView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 40),
          // Profile Header
          CircleAvatar(
            radius: 50,
            backgroundColor: AppColor.primaryColor.withOpacity(0.1),
            child: Text(
              userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: AppColor.primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            userName,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          if (userEmail.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(userEmail, style: TextStyle(color: Colors.grey[600])),
          ],
          if (userPhone.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(userPhone, style: TextStyle(color: Colors.grey[600])),
          ],
          const SizedBox(height: 32),
          
          // Profile Options
          _buildOptionCard(
            icon: Iconsax.user_edit,
            title: 'Edit_Profile'.tr(),
            subtitle: 'Update_your_personal_information'.tr(),
            onTap: () {
              // TODO: Navigate to edit profile
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Edit_profile_coming_soon'.tr())),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildOptionCard(
            icon: Iconsax.lock,
            title: 'Change_Password'.tr(),
            subtitle: 'Update_your_account_password'.tr(),
            onTap: () {
              // TODO: Navigate to change password
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Change_password_coming_soon'.tr())),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildOptionCard(
            icon: Iconsax.notification,
            title: 'Notifications'.tr(),
            subtitle: 'Manage_notification_preferences'.tr(),
            onTap: () {
              // TODO: Navigate to notifications settings
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Notifications_settings_coming_soon'.tr())),
              );
            },
          ),
          // const SizedBox(height: 12),
          // _buildOptionCard(
          //   icon: Iconsax.security,
          //   title: 'Security',
          //   subtitle: 'Privacy and security settings',
          //   onTap: () {
          //     // TODO: Navigate to security settings
          //     ScaffoldMessenger.of(context).showSnackBar(
          //       const SnackBar(content: Text('Security settings coming soon')),
          //     );
          //   },
          // ),
          const SizedBox(height: 12),
          _buildOptionCard(
            icon: Iconsax.info_circle,
            title: 'About'.tr(),
            subtitle: 'App_version_and_information'.tr(),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Malipo Mtandao',
                applicationVersion: '1.0.0',
                applicationIcon: const Icon(Icons.payment, size: 48),
              );
            },
          ),
          const SizedBox(height: 32),
          
          // Logout Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: _logout,
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Iconsax.logout),
              label: Text('Logout'.tr(), style: const TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(height: 20),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildOptionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColor.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColor.primaryColor),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      ),
    );
  }

  Widget _buildLoginPrompt() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.user, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 24),
            Text(
              'Welcome'.tr(),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Please_login_or_register_to_continue'.tr(),
              style: TextStyle(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
              onPressed: () {
                  NavigationHelper.navigateTo(
                  context,
                    LoginScreen(),
                );
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Login'.tr(), style: const TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
              onPressed: () {
                  NavigationHelper.navigateTo(
                  context,
                    RegisterScreen(),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColor.primaryColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Register'.tr(),
                  style: const TextStyle(fontSize: 16, color: AppColor.primaryColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
