import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wicom/core/app_color.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import '../../services/api_service.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({Key? key}) : super(key: key);

  @override
  _SupportScreenState createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  List<Map<String, dynamic>> _supportTickets = [];
  bool _isLoading = true;
  bool _showCreateForm = false;
  
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _queryController = TextEditingController();
  String _queryType = 'General_Inquiry'; // Use key, not translated value
  final List<String> _queryTypes = [
    'General_Inquiry',
    'Loan_Application',
    'Payment_Issue',
    'Technical_Problem',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    _loadSavedLanguage();
    _loadSupportTickets();
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

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _queryController.dispose();
    super.dispose();
  }

  Future<void> _loadSupportTickets() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final response = await ApiService().getSupportTickets();
      
      if (response['status'] == 'success') {
        setState(() {
          _supportTickets = List<Map<String, dynamic>>.from(response['data'] ?? []);
          _isLoading = false;
        });
      } else {
        throw Exception(response['message'] ?? 'Failed to load support tickets');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${'Error_loading_support_tickets'.tr()}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _submitQuery() async {
    if (_formKey.currentState!.validate()) {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(
          child: CircularProgressIndicator(color: AppColor.primaryColor),
        ),
      );

      try {
        final response = await ApiService().submitSupportQuery(
          name: _nameController.text,
          email: _emailController.text,
          queryType: _queryType,
          query: _queryController.text,
        );

        if (!mounted) return;
        Navigator.pop(context); // Close loading

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Query_Submitted'.tr()),
            content: Text(
              response['message'] ?? 'Thank_you_for_your_query_We_will_get_back_to_you_soon'.tr(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'.tr()),
              ),
            ],
          ),
        );

        // Clear form and refresh list
        _nameController.clear();
        _emailController.clear();
        _queryController.clear();
        setState(() {
          _queryType = 'General_Inquiry'; // Use key, not translated value
          _showCreateForm = false;
        });
        
        // Refresh the support tickets list
        _loadSupportTickets();
      } catch (e) {
        if (!mounted) return;
        Navigator.pop(context); // Close loading
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${'Failed_to_submit_query'.tr()}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Support_Queries'.tr()),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadSupportTickets,
          ),
        ],
      ),
      body: _showCreateForm ? _buildCreateForm() : _buildTicketsList(),
      floatingActionButton: _showCreateForm ? null : FloatingActionButton(
        onPressed: () {
          setState(() {
            _showCreateForm = true;
          });
        },
        backgroundColor: AppColor.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildTicketsList() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColor.primaryColor),
      );
    }

    if (_supportTickets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.support_agent,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No_Support_Tickets'.tr(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You_havent_submitted_any_support_queries_yet'.tr(),
              style: TextStyle(
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _showCreateForm = true;
                });
              },
              icon: const Icon(Icons.add),
              label: Text('Create_New_Query'.tr()),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadSupportTickets,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _supportTickets.length,
        itemBuilder: (context, index) {
          final ticket = _supportTickets[index];
          return _buildTicketCard(ticket);
        },
      ),
    );
  }

  Widget _buildTicketCard(Map<String, dynamic> ticket) {
    final status = ticket['status'] ?? 'pending';
    final statusColor = _getStatusColor(status);
    final statusText = _getStatusText(status);
    final createdAt = ticket['created_at'] ?? '';
    final formattedDate = _formatDate(createdAt);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: statusColor.withOpacity(0.3)),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  formattedDate,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              (ticket['query_type'] ?? 'General_Inquiry').toString().tr(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              ticket['query'] ?? '',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            if (ticket['response'] != null && ticket['response'].isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Response'.tr(),
                      style: TextStyle(
                        color: Colors.green[700],
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      ticket['response'],
                      style: TextStyle(
                        color: Colors.green[800],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCreateForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    setState(() {
                      _showCreateForm = false;
                    });
                  },
                ),
                Text(
                  'Create_New_Query'.tr(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Please_fill_out_the_form_below_and_our_team_will_get_back_to_you_as_soon_as_possible'.tr(),
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            
            // Query Type Dropdown
            DropdownButtonFormField<String>(
              value: _queryType,
              decoration: InputDecoration(
                labelText: 'Query_Type'.tr(),
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.category),
              ),
              items: _queryTypes.map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type.tr()),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _queryType = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            
            // Name Field
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Your_Name'.tr(),
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please_enter_your_name'.tr();
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Email Field
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email_Address'.tr(),
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please_enter_your_email'.tr();
                }
                if (!value.contains('@')) {
                  return 'Please_enter_a_valid_email'.tr();
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Query Field
            TextFormField(
              controller: _queryController,
              decoration: InputDecoration(
                labelText: 'Your_Query'.tr(),
                border: const OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 5,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please_enter_your_query'.tr();
                }
                if (value.length < 10) {
                  return 'Please_provide_more_details'.tr();
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            
            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _submitQuery,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Submit_Query'.tr(),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            
            // Contact Information
            const SizedBox(height: 32),
            Center(
              child: Text(
                'OR_CONTACT_US_DIRECTLY'.tr(),
                style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildContactOption(
              Icons.phone,
              'Call_Us'.tr(),
              '+255 677 222 460/+255 748 500 940',
              onTap: () async {
                final uri = Uri.parse('tel:+255677222460');
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri);
                } else {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Could not launch phone dialer')),
                  );
                }
              },
            ),
            _buildContactOption(
              Icons.email,
              'Email_Us'.tr(),
              'receiption@wicomfinance.co.tz',
              onTap: () async {
                final uri = Uri.parse('mailto:receiption@wicomfinance.co.tz?subject=Support Query');
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri);
                } else {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Could not launch email client')),
                  );
                }
              },
            ),
            _buildContactOption(
              Icons.location_on,
              'Visit_Us'.tr(),
              'Makumbusho, Dar es Salaam',
              onTap: () async {
                final uri = Uri.parse('https://maps.google.com/?q=Dar+es+Salaam');
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                } else {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Could not open maps')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildContactOption(IconData icon, String title, String subtitle, {VoidCallback? onTap}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColor.primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColor.primaryColor),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'in_progress':
        return Colors.blue;
      case 'resolved':
        return Colors.green;
      case 'closed':
        return Colors.grey;
      default:
        return Colors.orange;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending'.tr();
      case 'in_progress':
        return 'In_Progress'.tr();
      case 'resolved':
        return 'Resolved'.tr();
      case 'closed':
        return 'Closed'.tr();
      default:
        return 'Pending'.tr();
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final formatter = DateFormat('MMM dd, yyyy');
      return formatter.format(date);
    } catch (e) {
      return dateString;
    }
  }
}
