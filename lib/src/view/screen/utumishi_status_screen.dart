import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../core/app_color.dart';
import '../../../core/app_data.dart';
import '../../data/database_helper.dart';
import '../../data/drift_database.dart';

class UtumishiStatusScreen extends StatefulWidget {
  const UtumishiStatusScreen({Key? key}) : super(key: key);

  @override
  _UtumishiStatusScreenState createState() => _UtumishiStatusScreenState();
}

class _UtumishiStatusScreenState extends State<UtumishiStatusScreen> {
  List<Map<String, dynamic>> _loanStatuses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLoanStatuses();
  }

  Future<void> _loadLoanStatuses() async {
    try {
      print('Loading loan statuses');
      final isWeb = kIsWeb;
      
      if (isWeb) {
        // Load from Drift database for web
        final driftDb = AppDatabase();
        final statuses = await driftDb.select(driftDb.loanStatus).get();
        
        // Group by client name
        final Map<String, List<LoanStatusData>> groupedStatuses = {};
        for (var status in statuses) {
          final clientName = status.clientName ?? 'Unknown';
          if (!groupedStatuses.containsKey(clientName)) {
            groupedStatuses[clientName] = [];
          }
          groupedStatuses[clientName]!.add(status);
        }
        
        // Convert to list format
        _loanStatuses = groupedStatuses.entries.map((entry) {
          return {
            'client_name': entry.key,
            'statuses': entry.value.map((status) => {
              'id': status.id,
              'loan_id': status.loanId,
              'status': status.status,
              'description': status.description,
              'created_at': status.createdAt,
              'updated_at': status.updatedAt,
            }).toList(),
          };
        }).toList();
      } else {
        // Load from SQLite database for mobile
        final db = await DatabaseHelper.instance.database;
        final statuses = await db.rawQuery('SELECT * FROM loan_status ORDER BY client_name ASC, created_at DESC');
        
        // Group by client name
        final Map<String, List<Map<String, dynamic>>> groupedStatuses = {};
        for (var status in statuses) {
          final clientName = status['client_name'] ?? 'Unknown';
          if (!groupedStatuses.containsKey(clientName)) {
            groupedStatuses[clientName] = [];
          }
          groupedStatuses[clientName]!.add(status);
        }
        
        // Convert to list format
        _loanStatuses = groupedStatuses.entries.map((entry) {
          return {
            'client_name': entry.key,
            'statuses': entry.value,
          };
        }).toList();
      }
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading loan statuses: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Utumishi Status'),
        backgroundColor: AppColor.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _loanStatuses.isEmpty
              ? const Center(
                  child: Text(
                    'No loan statuses found',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _loanStatuses.length,
                  itemBuilder: (context, index) {
                    final clientData = _loanStatuses[index];
                    final clientName = clientData['client_name'];
                    final statuses = clientData['statuses'] as List;
                    
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(
                          clientName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text('${statuses.length} status record(s)'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ClientStatusDetailScreen(
                                clientName: clientName,
                                statuses: statuses,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}

class ClientStatusDetailScreen extends StatefulWidget {
  final String clientName;
  final List statuses;

  const ClientStatusDetailScreen({
    Key? key,
    required this.clientName,
    required this.statuses,
  }) : super(key: key);

  @override
  _ClientStatusDetailScreenState createState() => _ClientStatusDetailScreenState();
}

class _ClientStatusDetailScreenState extends State<ClientStatusDetailScreen> {
  final _notesController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _approveLoan(String loanId) async {
    if (_notesController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter verification notes'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('${AppData.url}/loans/$loanId/verification'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'verification_status': 'approved',
          'verification_notes': _notesController.text.trim(),
        }),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseData['message'] ?? 'Loan approved successfully'),
            backgroundColor: Colors.green,
          ),
        );
        await _updateLoanData(responseData);
        _notesController.clear();
      } else {
        final errorData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorData['message'] ?? 'Failed to approve loan'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error approving loan: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _disburseLoan(String loanId) async {
    if (_notesController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter disbursement notes'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('${AppData.url}/disbursement/$loanId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'disbursement_amount': 0, // This will be calculated on the backend
          'disbursement_date': DateTime.now().toIso8601String().split('T')[0],
          'disbursement_status': 'approved',
          'disbursement_notes': _notesController.text.trim(),
        }),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseData['message'] ?? 'Loan disbursed successfully'),
            backgroundColor: Colors.green,
          ),
        );
        _notesController.clear();
        
        // Update data after successful disbursement
        await _updateLoanData(responseData);
      } else {
        final errorData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorData['message'] ?? 'Failed to disburse loan'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error disbursing loan: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Update loan data in local database after successful disbursement
  Future<void> _updateLoanData(Map<String, dynamic> responseData) async {
    try {
      print('Updating loan data after disbursement...');
      
      // Check if response contains updated loan data
      if (responseData['data'] != null) {
        final data = responseData['data'];
        final isWeb = kIsWeb;
        
        if (isWeb) {
          // Update Drift database for web
          final driftDb = AppDatabase();
          
          // Update loan data if exists
          if (data['loan'] != null && data['loan'].isNotEmpty) {
            final loanData = data['loan'];
            
            // Delete existing loan and insert updated loan data
            await driftDb.delete(driftDb.loan).go();
            
            final loanRecord = LoanCompanion.insert(
              id: Value(loanData['id'] ?? 0),
              clientId: Value(loanData['client_id']?.toString() ?? ''),
              totalExpectedRepaymentDerived: Value(loanData['total_expected_repayment_derived']?.toString() ?? '0'),
              totalRepaymentDerived: Value(loanData['total_repayment_derived']?.toString() ?? '0'),
            );
            
            await driftDb.into(driftDb.loan).insert(loanRecord);
            print('Loan data updated in Drift database');
          }
          
          // Update loan status data if exists
          if (data['loan_status'] != null && data['loan_status'].isNotEmpty) {
            final loanStatusData = data['loan_status'] as List?;
            if (loanStatusData != null) {
              for (var loanStatus in loanStatusData) {
                await driftDb.into(driftDb.loanStatus).insert(
                  LoanStatusCompanion.insert(
                    id: Value(loanStatus['id'] ?? 0),
                    loanId: Value(loanStatus['loan_id']?.toString() ?? ''),
                    clientName: Value(loanStatus['client_name']?.toString() ?? ''),
                    status: Value(loanStatus['status']?.toString() ?? ''),
                    description: Value(loanStatus['description']?.toString() ?? ''),
                    createdAt: Value(loanStatus['created_at']?.toString() ?? ''),
                    updatedAt: Value(loanStatus['updated_at']?.toString() ?? ''),
                  ),
                );
              }
              print('Loan status data updated in Drift database');
            }
          }
          
          // Update transaction data if exists
          if (data['transaction'] != null && data['transaction'].isNotEmpty) {
            final transactionData = data['transaction'] as List?;
            if (transactionData != null && transactionData.isNotEmpty) {
              // Delete existing transactions
              await driftDb.delete(driftDb.transactions).go();
              
              // Insert updated transactions
              for (var transaction in transactionData) {
                final transactionRecord = TransactionsCompanion.insert(
                  id: Value(transaction['id'] ?? 0),
                  msisdn: Value(transaction['msisdn']?.toString() ?? ''),
                  amount: Value(double.tryParse(transaction['amount']?.toString() ?? '0') ?? 0.0),
                  reference: Value(transaction['reference']?.toString() ?? ''),
                  type: Value(transaction['type']?.toString() ?? ''),
                  status: Value(transaction['status']?.toString() ?? ''),
                  settlementStatus: Value(transaction['settlement_status']?.toString() ?? ''),
                  mechantId: Value(int.tryParse(transaction['mechant_id']?.toString() ?? '0') ?? 0),
                  charge: Value(transaction['charge']?.toString() ?? ''),
                  receivingAccountId: Value(transaction['receiving_account_id']?.toString() ?? ''),
                  totalAmount: Value(transaction['total_amount']?.toString() ?? ''),
                  settlementId: Value(transaction['settlement_id']?.toString() ?? ''),
                  settlementDate: Value(transaction['settlement_date']?.toString() ?? ''),
                  transactionId: Value(transaction['transaction_id']?.toString() ?? ''),
                  createdAt: Value(transaction['created_at']?.toString() ?? ''),
                  updatedAt: Value(transaction['updated_at']?.toString() ?? ''),
                );
                
                await driftDb.into(driftDb.transactions).insert(transactionRecord);
              }
              print('Transaction data updated in Drift database');
            }
          }
        } else {
          // Update SQLite database for mobile
          if (data['loan'] != null && data['loan'].isNotEmpty) {
            final loanData = data['loan'];
            final loan = {
              'id': loanData['id'],
              'client_id': loanData['client_id']?.toString() ?? '',
              'total_expected_repayment_derived': loanData['total_expected_repayment_derived']?.toString() ?? '0',
              'total_repayment_derived': loanData['total_repayment_derived']?.toString() ?? '0',
            };
            await DatabaseHelper.instance.insertLoan(loan);
            print('Loan data updated in SQLite database');
          }
          
          // Update loan status data if exists
          if (data['loan_status'] != null && data['loan_status'].isNotEmpty) {
            final loanStatusData = data['loan_status'] as List?;
            if (loanStatusData != null) {
              for (var loanStatus in loanStatusData) {
                await DatabaseHelper.instance.insertLoanStatus(loanStatus);
              }
              print('Loan status data updated in SQLite database');
            }
          }
          
          // Update transaction data if exists
          if (data['transaction'] != null && data['transaction'].isNotEmpty) {
            final transactionData = data['transaction'] as List?;
            if (transactionData != null) {
              for (var transaction in transactionData) {
                await DatabaseHelper.instance.insertTransaction(transaction);
              }
              print('Transaction data updated in SQLite database');
            }
          }
        }
        
        print('Loan data updated successfully');
        
        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Data updated successfully'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      print('Error updating loan data: $e');
      // Don't show error to user as the disbursement was successful
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.clientName),
        backgroundColor: AppColor.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Notes input section
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[50],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Action Notes',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    hintText: 'Enter notes for approval or disbursement...',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(12),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : () {
                          final loanId = widget.statuses.isNotEmpty 
                              ? widget.statuses.first['loan_id']?.toString() 
                              : null;
                          if (loanId != null) {
                            _approveLoan(loanId);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('No loan ID found'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.check_circle),
                        label: const Text('Approve'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : () {
                          final loanId = widget.statuses.isNotEmpty 
                              ? widget.statuses.first['loan_id']?.toString() 
                              : null;
                          if (loanId != null) {
                            _disburseLoan(loanId);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('No loan ID found'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.payment),
                        label: const Text('Disburse'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
                if (_isLoading) ...[
                  const SizedBox(height: 16),
                  const Center(
                    child: CircularProgressIndicator(
                      color: AppColor.primaryColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Status list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.statuses.length,
              itemBuilder: (context, index) {
                // Sort statuses by created_at in descending order
                final sortedStatuses = List.from(widget.statuses);
                sortedStatuses.sort((a, b) {
                  final dateA = DateTime.tryParse(a['created_at'] ?? '') ?? DateTime(1970);
                  final dateB = DateTime.tryParse(b['created_at'] ?? '') ?? DateTime(1970);
                  return dateB.compareTo(dateA); // Descending order
                });
                
                final status = sortedStatuses[index];
                final statusText = status['status'] ?? 'Unknown';
                final description = status['description'] ?? 'No description';
                final createdAt = status['created_at'] ?? '';
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(statusText),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                statusText.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              _formatDate(createdAt),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          description,
                          style: const TextStyle(fontSize: 14),
                        ),
                        if (status['loan_id'] != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Loan ID: ${status['loan_id']}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  String _formatDate(String dateString) {
    if (dateString.isEmpty) return '';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}
