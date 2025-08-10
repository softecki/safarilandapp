import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/app_color.dart';
import '../../data/database_helper.dart';
import 'login_screen.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<PaymentScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Map<String, dynamic>? firstStudent;
  Map<String, dynamic>? firstUser;
  Map<String, dynamic>? customer;
  String phonenumber = "";
  String nida = "";
  String account_number = "";
  String payment_type = "";
  String selected_bank = "";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchFirstStudent(); // Fetch student data on screen load
  }

  Future<void> _fetchFirstStudent() async {
    List<Map<String, dynamic>> students = await DatabaseHelper.instance.getStudents();
    List<Map<String, dynamic>> customerList = await DatabaseHelper.instance.getCustomer();
    List<Map<String, dynamic>> account = await DatabaseHelper.instance.getAccountSetup();
    final prefs = await SharedPreferences.getInstance();
    String? current_student = prefs.getString('code_number');

    if (students.isNotEmpty && current_student != null) {
      firstStudent = await DatabaseHelper.instance.getStudentById(int.parse(current_student));
    } else {
      firstUser = await DatabaseHelper.instance.getFirstUser();
    }
    if(customerList.isNotEmpty){
      customer = customerList[0];
      phonenumber = customer?["mobile_no"] ?? "";
    }
    if(account.isNotEmpty){
      account_number ='0';
    }

    setState(() {});
  }
  Future<void> _logout(BuildContext context) async {
    await DatabaseHelper.instance.logOutUser();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: const Text(
          "My Profile",
          style: TextStyle(color: Colors.blue, fontSize: 18),
        ),
      ),
      body: Column(
        children: [
          // Profile Header with depth
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(25)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[200],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.7),
                        offset: const Offset(-2, -2),
                        blurRadius: 4,
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        offset: const Offset(2, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[200],
                    child: Icon(Icons.person, size: 50, color: Colors.blue),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  phonenumber,
                  style: const TextStyle(color: Colors.blue, fontSize: 18),
                ),
              ],
            ),
          ),

          // Tab Bar with mild elevation
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              boxShadow: [
                BoxShadow(
                  color: Colors.white,
                  offset: const Offset(-1, -1),
                  blurRadius: 3,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: const Offset(2, 2),
                  blurRadius: 4,
                ),
              ],
            ),
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppColor.primaryColor,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(text: "ACCOUNT SETUP"),
                Tab(text: "SETTING"),
              ],
            ),
          ),

          // TabBarView
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(12),
                  child: _buildParentInfoUser(firstUser),
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.all(12),
                  child: _buildParentInfoCard(firstStudent),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildParentInfoCard(Map<String, dynamic>? student) {
    return _neumorphicContainer(
      children: [
        _infoTile(
          icon: Icons.language,
          title: 'Language',
          subtitle: 'English',
        ),
        _infoTile(
          icon: Icons.phone,
          title: 'Support Contact',
          subtitle: '+255678009293',
        ),
        const Divider(),
        const SizedBox(height: 10),
        ListTile(
          leading: Icon(Icons.logout, color: Colors.red[700]),
          title: const Text('Logout'),
          onTap: () => _logout(context),
        ),
      ],
    );
  }

  Widget _buildParentInfoUser(Map<String, dynamic>? user) {
    // Display all customer details if available
    if (customer == null) {
      return _neumorphicContainer(
        children: [
          _infoTile(
            icon: Icons.info,
            title: 'No customer data',
            subtitle: '',
          ),
        ],
      );
    }
    return _neumorphicContainer(
      children: [
        _infoTile(
          icon: Icons.perm_identity,
          title: 'ID',
          subtitle: customer!["id"].toString(),
        ),
        _infoTile(
          icon: Icons.person,
          title: 'Display Name',
          subtitle: customer!["display_name"]?.toString() ?? '',
        ),
        _infoTile(
          icon: Icons.badge,
          title: 'External ID',
          subtitle: customer!["external_id"]?.toString() ?? '',
        ),
        _infoTile(
          icon: Icons.account_balance,
          title: 'Account No',
          subtitle: customer!["account_no"]?.toString() ?? '',
        ),
        _infoTile(
          icon: Icons.phone,
          title: 'Mobile No',
          subtitle: customer!["mobile_no"]?.toString() ?? '',
        ),
        _infoTile(
          icon: Icons.lock,
          title: 'OTP',
          subtitle: customer!["otp"]?.toString() ?? '',
        ),
      ],
    );
  }


  // Widget _buildParentInfoCard(Map<String, dynamic>? student) {
  //   return Padding(
  //     padding: const EdgeInsets.all(16),
  //     child: Container(
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(15),
  //         boxShadow: [
  //           BoxShadow(
  //             color: Colors.black.withOpacity(0.1),
  //             blurRadius: 6,
  //             offset: Offset(0, 3),
  //           ),
  //         ],
  //       ),
  //       child: Column(
  //         children: [
  //           _infoTile(
  //             icon: Icons.language,
  //             title: 'Language',
  //             subtitle: 'English',
  //           ),
  //           _infoTile(
  //             icon: Icons.phone,
  //             title: 'Support Contact',
  //             subtitle: '+255678009293',
  //           ),
  //           Divider(),
  //           SizedBox(height: 10,),
  //           ListTile(
  //             leading: Icon(Icons.logout),
  //             title: Text('Logout'),
  //             onTap: () {
  //               _logout(context);
  //             },
  //           ),
  //
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildParentInfoUser(Map<String, dynamic>? user) {
  //   return Padding(
  //     padding: const EdgeInsets.all(16),
  //     child: Container(
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(15),
  //         boxShadow: [
  //           BoxShadow(
  //             color: Colors.black.withOpacity(0.1),
  //             blurRadius: 6,
  //             offset: Offset(0, 3),
  //           ),
  //         ],
  //       ),
  //       child: Column(
  //         children: [
  //           _infoTile(
  //             icon: Icons.comment_bank,
  //             title: "Mobile Money"?? 'Loading...',
  //             subtitle: 'Payment Type',
  //           ),
  //           Divider(),
  //           _infoTile(
  //             icon: Icons.receipt,
  //             title: 'M-PESA',
  //             subtitle: '',
  //           ),
  //           Divider(),
  //           _infoTile(
  //             icon: Icons.phone,
  //             title: account_number,
  //             subtitle: 'Phone Number',
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _neumorphicContainer({required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.white,
            offset: const Offset(-3, -3),
            blurRadius: 6,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            offset: const Offset(3, 3),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }


  // Widget _infoTile({required IconData icon, required String title, required String subtitle}) {
  //   return ListTile(
  //     leading: CircleAvatar(
  //       backgroundColor: Colors.grey[200],
  //       child: Icon(icon, size: 28, color: AppColor.primaryColor),
  //     ),
  //     title: Text(
  //       title,
  //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
  //     ),
  //     subtitle: Text(subtitle),
  //   );
  // }

  Widget _infoTile({required IconData icon, required String title, required String subtitle}) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey[300],
        child: Icon(icon, size: 28, color: AppColor.primaryColor),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(subtitle),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
