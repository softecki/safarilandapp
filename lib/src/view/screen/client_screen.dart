import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wicom/src/utils/navigation_helper.dart';
import 'package:wicom/src/view/screen/client_registration_screen.dart';
import 'package:wicom/src/view/screen/commission_screen.dart';
import 'package:wicom/src/view/screen/client_list_screen.dart';
import 'package:wicom/src/view/screen/utumishi_status_screen.dart';

class ClientScreen extends StatefulWidget {
  const ClientScreen({Key? key}) : super(key: key);

  @override
  _ClientScreenState createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
  bool _isStaff = false;

  @override
  void initState() {
    super.initState();
    _loadSavedLanguage();
    _checkStaffStatus();
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

  Future<void> _checkStaffStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isStaff = prefs.getBool('is_staff') ?? false;
    });
    print(_isStaff);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clients'.tr(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildFeatureCard(
              context,
              'Invite_A_Friend'.tr(),
              'Invite_a_friend_for_loan_application'.tr(),
              Icons.person_add,
              () {
                NavigationHelper.navigateTo(
                  context,
                  const ClientRegistrationScreen(),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildFeatureCard(
              context,
              'My_Referrals'.tr(),
              'View_clients_you_have_referred_and_your_commissions'.tr(),
              Icons.people,
              () {
                NavigationHelper.navigateTo(
                  context,
                  const CommissionScreen(),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildFeatureCard(
              context,
              'Client_List'.tr(),
              'View_all_your_registered_clients'.tr(),
              Icons.list_alt,
              () {
                NavigationHelper.navigateTo(
                  context,
                  const ClientListScreen(),
                );
              },
            ),
            if (_isStaff) ...[
              const SizedBox(height: 16),
              _buildFeatureCard(
                context,
                'Utumishi_Status'.tr(),
                'View_loan_statuses_and_client_information'.tr(),
                Icons.assignment_turned_in,
                () {
                  NavigationHelper.navigateTo(
                    context,
                    const UtumishiStatusScreen(),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    String title,
    String description,
    IconData icon, 
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).primaryColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
