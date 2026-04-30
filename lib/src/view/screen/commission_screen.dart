import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wicom/core/app_color.dart';
import 'package:intl/intl.dart';
import '../../services/api_service.dart';

class CommissionScreen extends StatefulWidget {
  const CommissionScreen({Key? key}) : super(key: key);

  @override
  _CommissionScreenState createState() => _CommissionScreenState();
}

class _CommissionScreenState extends State<CommissionScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final DateFormat _dateFormat = DateFormat('MMM d, yyyy');
  final NumberFormat _currencyFormat = NumberFormat.currency(symbol: 'TZS ');
  
  List<Map<String, dynamic>> _allCommissions = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadSavedLanguage();
    _loadCommissions();
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

  Future<void> _loadCommissions() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await ApiService().getCommissions();
      final commissions = response['data']['commissions'] as List?;
      
      if (commissions != null) {
        setState(() {
          _allCommissions = commissions.map((c) => {
            'id': c['id']?.toString() ?? '',
            'clientName': c['client_name'] ?? 'Unknown',
            'loanAmount': double.tryParse(c['loan_amount']?.toString() ?? '0') ?? 0.0,
            'commissionAmount': double.tryParse(c['commission_amount']?.toString() ?? '0') ?? 0.0,
            'status': c['status'] ?? 'pending',
            'date': DateTime.tryParse(c['created_at'] ?? '') ?? DateTime.now(),
          }).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  double get _totalEarned {
    return _allCommissions
        .where((c) => c['status'] == 'paid')
        .map<double>((c) => (c['commissionAmount'] as num).toDouble())
        .fold(0, (sum, amount) => sum + amount);
  }

  double get _pendingCommissions {
    return _allCommissions
        .where((c) => c['status'] == 'pending')
        .map<double>((c) => (c['commissionAmount'] as num).toDouble())
        .fold(0, (sum, amount) => sum + amount);
  }

  List<Map<String, dynamic>> get _paidCommissions {
    return _allCommissions.where((c) => c['status'] == 'paid').toList();
  }

  List<Map<String, dynamic>> get _pendingCommissionList {
    return _allCommissions.where((c) => c['status'] == 'pending').toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My_Commissions'.tr()),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadCommissions,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Theme.of(context).primaryColor,
          tabs: [
            Tab(text: 'Summary'.tr()),
            Tab(text: 'Paid'.tr()),
            Tab(text: 'Pending'.tr()),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text('${'Error'.tr()}: $_errorMessage'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadCommissions,
                        child: Text('Retry'.tr()),
                      ),
                    ],
                  ),
                )
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildSummaryTab(),
                    _buildCommissionList(_paidCommissions, isPaid: true),
                    _buildCommissionList(_pendingCommissionList, isPaid: false),
                  ],
                ),
    );
  }

  Widget _buildSummaryTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSummaryCard(
            'Total_Earned'.tr(),
            _currencyFormat.format(_totalEarned),
            Icons.account_balance_wallet,
            AppColor.primaryColor,
          ),
          const SizedBox(height: 16),
          _buildSummaryCard(
            'Pending_Payout'.tr(),
            _currencyFormat.format(_pendingCommissions),
            Icons.pending_actions,
            Colors.orange,
          ),
          const SizedBox(height: 24),
          Text(
            'Recent_Transactions'.tr(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          ..._allCommissions
              .take(3)
              .map((commission) => _buildCommissionItem(commission))
              .toList(),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {
              _tabController.animateTo(1); // Switch to Paid tab
            },
            child: Text('VIEW_ALL_TRANSACTIONS'.tr()),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String amount, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              amount,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (title == 'Pending_Payout'.tr() && _pendingCommissions > 0) ...[
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Reach_our_branch_near_by'.tr()),
                      backgroundColor: Colors.orange,
                      duration: const Duration(seconds: 3),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryColor,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Request_Withdrawal'.tr()),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCommissionList(List<Map<String, dynamic>> commissions, {required bool isPaid}) {
    if (commissions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isPaid ? Icons.history : Icons.pending,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              isPaid 
                  ? 'No_paid_commissions_yet'.tr() 
                  : 'No_pending_commissions'.tr(),
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: commissions.length,
      itemBuilder: (context, index) {
        final commission = commissions[index];
        return _buildCommissionItem(commission);
      },
    );
  }

  Widget _buildCommissionItem(Map<String, dynamic> commission) {
    final bool isPaid = commission['status'] == 'paid';
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isPaid 
                ? Colors.green.withOpacity(0.1) 
                : Colors.orange.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isPaid ? Icons.check_circle : Icons.pending,
            color: isPaid ? Colors.green : Colors.orange,
          ),
        ),
        title: Text(
          commission['clientName'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${_dateFormat.format(commission['date'] as DateTime)} • ${commission['id']}',
          style: const TextStyle(fontSize: 12),
        ),
        trailing: SizedBox(
          width: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  _currencyFormat.format(commission['commissionAmount']),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isPaid 
                      ? Colors.green.withOpacity(0.1) 
                      : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isPaid ? 'Paid'.tr() : 'Pending'.tr(),
                  style: TextStyle(
                    color: isPaid ? Colors.green : Colors.orange,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          _showCommissionDetails(commission);
        },
      ),
    );
  }

  void _showCommissionDetails(Map<String, dynamic> commission) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  top: 16.0,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    Text(
                      'Commission_Details'.tr(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow('Commission_ID'.tr(), commission['id']),
                    _buildDetailRow('Client'.tr(), commission['clientName']),
                    _buildDetailRow('Loan_Amount'.tr(), 
                      _currencyFormat.format(commission['loanAmount'])),
                    _buildDetailRow('Commission_Rate'.tr(), '5%'),
                    _buildDetailRow('Commission_Amount'.tr(), 
                      _currencyFormat.format(commission['commissionAmount']),
                      isHighlighted: true,
                    ),
                    _buildDetailRow('Status'.tr(), 
                      commission['status'].toString().toUpperCase(),
                      status: commission['status'],
                    ),
                    _buildDetailRow('Date'.tr(), 
                      _dateFormat.format(commission['date'] as DateTime)),
                    const SizedBox(height: 24),
                    if (commission['status'] != 'paid')
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Reach our branch near by'),
                                backgroundColor: Colors.orange,
                                duration: Duration(seconds: 3),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text('Request_Payout'.tr()),
                        ),
                      ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value, 
      {bool isHighlighted = false, String? status}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          if (status != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: status == 'paid' 
                    ? Colors.green.withOpacity(0.1) 
                    : Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                status.toUpperCase(),
                style: TextStyle(
                  color: status == 'paid' ? Colors.green : Colors.orange,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ] else
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                color: isHighlighted ? AppColor.primaryColor : Colors.black,
              ),
            ),
        ],
      ),
    );
  }

  void _showWithdrawalDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Request_Withdrawal'.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Available_for_withdrawal'.tr()),
            const SizedBox(height: 8),
            Text(
              _currencyFormat.format(_pendingCommissions),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColor.primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            Text('Withdrawal_Method'.tr()),
            const SizedBox(height: 8),
            // TODO: Add withdrawal method selection
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              value: 'mobile_money',
              items: [
                DropdownMenuItem(
                  value: 'mobile_money',
                  child: Text('Mobile_Money'.tr()),
                ),
                DropdownMenuItem(
                  value: 'bank_transfer',
                  child: Text('Bank_Transfer'.tr()),
                ),
              ],
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            Text('Amount_to_Withdraw'.tr()),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: _pendingCommissions.toStringAsFixed(0),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixText: 'TZS ',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('CANCEL'.tr()),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              
              // Show loading
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => const Center(
                  child: CircularProgressIndicator(color: AppColor.primaryColor),
                ),
              );

              try {
                await ApiService().requestWithdrawal(
                  amount: _pendingCommissions,
                  method: 'mobile_money',
                );

                if (!mounted) return;
                Navigator.pop(context); // Close loading

                ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Withdrawal_request_submitted_successfully'.tr()),
                  backgroundColor: Colors.green,
                ),
                );
                
                // Reload commissions
                _loadCommissions();
              } catch (e) {
                if (!mounted) return;
                Navigator.pop(context); // Close loading
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${'Failed_to_submit_withdrawal'.tr()}: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primaryColor,
            ),
            child: Text('SUBMIT_REQUEST'.tr()),
          ),
        ],
      ),
    );
  }
}
