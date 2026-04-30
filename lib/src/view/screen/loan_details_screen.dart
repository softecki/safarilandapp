import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../services/api_service.dart';

class LoanDetailsScreen extends StatefulWidget {
  const LoanDetailsScreen({super.key});

  @override
  State<LoanDetailsScreen> createState() => _LoanDetailsScreenState();
}

class _LoanDetailsScreenState extends State<LoanDetailsScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _loanData;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadLoanDetails();
  }

  Future<void> _loadLoanDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await ApiService().getLoanDetails();
      
      if (response['status'] == 'success' && response['data'] != null) {
        setState(() {
          _loanData = response['data'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = response['message'] ?? 'Failed to load loan details';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  String _formatCurrency(dynamic value) {
    if (value == null) return '0.00';
    final numValue = double.tryParse(value.toString()) ?? 0;
    return NumberFormat('#,##0.00').format(numValue);
  }

  String _formatDate(String? date) {
    if (date == null || date.isEmpty) return 'N/A';
    try {
      final parsed = DateTime.parse(date);
      return DateFormat('dd MMM yyyy').format(parsed);
    } catch (e) {
      return date;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Loan Details'),
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadLoanDetails,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                      const SizedBox(height: 16),
                      Text(
                        _errorMessage,
                        style: TextStyle(color: Colors.grey[700]),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadLoanDetails,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _loanData == null
                  ? const Center(child: Text('No loan data available'))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Loan Summary Card
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.08),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Iconsax.card, color: Colors.blue),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Outstanding Balance',
                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'TZS ${_formatCurrency(_loanData!['remaining_balance'])}',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey[800],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Summary Section
                          const Text(
                            'Summary',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          _infoTile(
                            'Principal Amount',
                            'TZS ${_formatCurrency(_loanData!['principal_amount'])}',
                          ),
                          _infoTile(
                            'Total Expected Repayment',
                            'TZS ${_formatCurrency(_loanData!['total_expected_repayment'])}',
                          ),
                          _infoTile(
                            'Total Repaid',
                            'TZS ${_formatCurrency(_loanData!['total_repaid'])}',
                          ),
                          _infoTile(
                            'Remaining Balance',
                            'TZS ${_formatCurrency(_loanData!['remaining_balance'])}',
                          ),
                          _infoTile(
                            'Next Payment Date',
                            _formatDate(_loanData!['next_payment_date']?.toString()),
                          ),
                          _infoTile(
                            'Loan Status',
                            _loanData!['loan_status']?.toString().toUpperCase() ?? 'N/A',
                            statusColor: _getStatusColor(_loanData!['loan_status']?.toString()),
                          ),
                          const SizedBox(height: 24),
                          
                          // Repayment Schedule Section
                          const Text(
                            'Repayment Schedule',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          
                          if (_loanData!['repayment_schedule'] != null &&
                              (_loanData!['repayment_schedule'] as List).isNotEmpty)
                            ...(_loanData!['repayment_schedule'] as List).map((schedule) => _scheduleItem(schedule))
                          else
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.06),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Text(
                                'No repayment schedule available',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                        ],
                      ),
                    ),
    );
  }

  Widget _infoTile(String title, String value, {Color? statusColor}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(child: Text(title, style: TextStyle(color: Colors.grey[700]))),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: statusColor ?? Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _scheduleItem(Map<String, dynamic> schedule) {
    final status = schedule['status']?.toString().toLowerCase() ?? 'pending';
    final isPaid = status == 'paid' || (schedule['completed_derived'] ?? 0) == 1;
    final installmentNum = schedule['installment_number'] ?? schedule['installment'] ?? 0;
    final dueDate = _formatDate(schedule['due_date']?.toString() ?? schedule['duedate']?.toString());
    final total = _formatCurrency(schedule['total'] ?? schedule['total_amount_to_be_paid'] ?? 0);
    final paid = _formatCurrency(schedule['paid'] ?? schedule['paid_amount'] ?? 0);
    final remained = _formatCurrency(schedule['remained'] ?? schedule['remained_amount'] ?? (total - paid));

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isPaid ? Colors.green.withOpacity(0.3) : Colors.grey.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Installment #$installmentNum',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isPaid ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isPaid ? 'PAID' : 'PENDING',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isPaid ? Colors.green[700] : Colors.orange[700],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Due Date',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    dueDate,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Total Amount',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'TZS $total',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _scheduleDetailItem('Paid', 'TZS $paid', Colors.green),
              _scheduleDetailItem('Remaining', 'TZS $remained', Colors.orange),
            ],
          ),
        ],
      ),
    );
  }

  Widget _scheduleDetailItem(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: color[700],
          ),
        ),
      ],
    );
  }

  Color? _getStatusColor(String? status) {
    if (status == null) return null;
    final lowerStatus = status.toLowerCase();
    if (lowerStatus == 'active' || lowerStatus == 'disbursed') {
      return Colors.green[700];
    } else if (lowerStatus == 'pending') {
      return Colors.orange[700];
    } else if (lowerStatus == 'completed' || lowerStatus == 'paid') {
      return Colors.blue[700];
    }
    return null;
  }
}
