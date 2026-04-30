import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/app_color.dart';
import '../../services/sms_database_service.dart';

class SmsLogScreen extends StatefulWidget {
  const SmsLogScreen({super.key});

  @override
  State<SmsLogScreen> createState() => _SmsLogScreenState();
}

class _SmsLogScreenState extends State<SmsLogScreen> {
  final SmsDatabaseService _dbService = SmsDatabaseService();
  static const MethodChannel _channel = MethodChannel('com.softecki.wicom/sms_receiver');
  List<dynamic> _smsList = []; // Can be ProcessedSm (web) or Map (mobile)
  List<Map<String, dynamic>> _pendingSmsList = []; // Pending SMS from SharedPreferences
  Map<String, int> _statistics = {};
  bool _isLoading = true;
  bool _isRefreshing = false;
  String _selectedTab = 'all'; // 'all', 'processed', 'pending'

  @override
  void initState() {
    super.initState();
    _loadAllSms();
  }

  Future<void> _loadAllSms() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await Future.wait([
        _loadSmsList(),
        _loadPendingSms(),
        _loadStatistics(),
      ]);
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading SMS logs: $e')),
        );
      }
    }
  }

  Future<void> _loadSmsList() async {
    try {
      final smsList = await _dbService.getLastProcessedSms(limit: 100);
      setState(() {
        _smsList = smsList;
      });
    } catch (e) {
      print('Error loading processed SMS: $e');
    }
  }

  Future<void> _loadPendingSms() async {
    try {
      List<Map<String, dynamic>> pendingList = [];
      
      // Try MethodChannel first to get SMS from native SharedPreferences
      try {
        final List<dynamic> result = await _channel.invokeMethod('getPendingSms');
        final List<String> smsList = result.cast<String>();
        
        for (final smsJsonStr in smsList) {
          try {
            final smsData = jsonDecode(smsJsonStr) as Map<String, dynamic>;
            pendingList.add({
              'sender': smsData['sender'] ?? 'Unknown',
              'message': smsData['message'] ?? '',
              'timestamp': smsData['timestamp'] ?? DateTime.now().millisecondsSinceEpoch,
              'status': 'PENDING',
              'source': 'SharedPreferences',
            });
          } catch (e) {
            print('Error parsing pending SMS: $e');
          }
        }
      } catch (e) {
        print('Error getting pending SMS from native: $e');
      }
      
      // Fallback: Try Flutter SharedPreferences
      if (pendingList.isEmpty) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.reload();
        
        const pendingSmsKey = 'pending_sms_list';
        final count = prefs.getInt('${pendingSmsKey}_count') ?? 0;
        
        for (int i = 0; i < count && i < 100; i++) {
          final smsJsonStr = prefs.getString('${pendingSmsKey}_$i');
          if (smsJsonStr != null && smsJsonStr.isNotEmpty) {
            try {
              final smsData = jsonDecode(smsJsonStr) as Map<String, dynamic>;
              pendingList.add({
                'sender': smsData['sender'] ?? 'Unknown',
                'message': smsData['message'] ?? '',
                'timestamp': smsData['timestamp'] ?? DateTime.now().millisecondsSinceEpoch,
                'status': 'PENDING',
                'source': 'SharedPreferences',
              });
            } catch (e) {
              print('Error parsing pending SMS from SharedPreferences: $e');
            }
          }
        }
      }
      
      // Sort by timestamp (newest first)
      pendingList.sort((a, b) {
        final aTime = a['timestamp'] as int;
        final bTime = b['timestamp'] as int;
        return bTime.compareTo(aTime);
      });
      
      setState(() {
        _pendingSmsList = pendingList;
      });
    } catch (e) {
      print('Error loading pending SMS: $e');
    }
  }

  Future<void> _loadStatistics() async {
    try {
      final stats = await _dbService.getStatistics();
      setState(() {
        _statistics = stats;
      });
    } catch (e) {
      print('Error loading statistics: $e');
    }
  }

  Future<void> _refresh() async {
    setState(() {
      _isRefreshing = true;
    });
    await _loadAllSms();
    setState(() {
      _isRefreshing = false;
    });
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'SUCCESS':
        return Colors.green;
      case 'FAILED':
        return Colors.red;
      case 'PENDING':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toUpperCase()) {
      case 'SUCCESS':
        return Icons.check_circle;
      case 'FAILED':
        return Icons.error;
      case 'PENDING':
        return Icons.pending;
      default:
        return Icons.help;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SMS Payment History'),
        backgroundColor: AppColor.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isRefreshing ? null : _refresh,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Tab Selector
                _buildTabSelector(),
                
                // Statistics Card
                if (_statistics.isNotEmpty) _buildStatisticsCard(),
                
                // SMS List
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _refresh,
                    child: _buildSmsList(),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildTabSelector() {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTabButton('all', 'All (${_smsList.length + _pendingSmsList.length})'),
          ),
          Expanded(
            child: _buildTabButton('processed', 'Processed (${_smsList.length})'),
          ),
          Expanded(
            child: _buildTabButton('pending', 'Pending (${_pendingSmsList.length})'),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String tab, String label) {
    final isSelected = _selectedTab == tab;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedTab = tab;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildSmsList() {
    List<dynamic> displayList = [];
    
    if (_selectedTab == 'all') {
      // Combine processed and pending, sort by timestamp
      displayList = [..._smsList, ..._pendingSmsList];
      displayList.sort((a, b) {
        final aTime = _getTimestamp(a);
        final bTime = _getTimestamp(b);
        return bTime.compareTo(aTime);
      });
    } else if (_selectedTab == 'processed') {
      displayList = _smsList;
    } else if (_selectedTab == 'pending') {
      displayList = _pendingSmsList;
    }
    
    if (displayList.isEmpty) {
      return _buildEmptyState();
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: displayList.length,
      itemBuilder: (context, index) {
        return _buildSmsItem(displayList[index]);
      },
    );
  }

  int _getTimestamp(dynamic sms) {
    final timestamp = _getField(sms, 'timestamp') ?? 
                     _getField(sms, 'smsTimestamp') ?? 
                     _getField(sms, 'processedAt');
    
    if (timestamp is int) {
      return timestamp;
    } else if (timestamp is DateTime) {
      return timestamp.millisecondsSinceEpoch;
    } else if (timestamp is String) {
      try {
        return DateTime.parse(timestamp).millisecondsSinceEpoch;
      } catch (e) {
        return 0;
      }
    }
    return 0;
  }

  Widget _buildStatisticsCard() {
    final totalProcessed = _statistics['total'] ?? 0;
    final totalPending = _pendingSmsList.length;
    final totalAll = totalProcessed + totalPending;
    
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Total', totalAll, Colors.blue),
          _buildStatItem('Success', _statistics['success'] ?? 0, Colors.green),
          _buildStatItem('Failed', _statistics['failed'] ?? 0, Colors.red),
          _buildStatItem('Pending', (_statistics['pending'] ?? 0) + totalPending, Colors.orange),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, int value, Color color) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    String message;
    String subtitle;
    
    if (_selectedTab == 'pending') {
      message = 'No pending SMS';
      subtitle = 'All SMS messages have been processed';
    } else if (_selectedTab == 'processed') {
      message = 'No processed SMS yet';
      subtitle = 'Processed SMS messages will appear here';
    } else {
      message = 'No SMS messages yet';
      subtitle = 'SMS messages will appear here once received';
    }
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.sms_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Helper method to get field value from either ProcessedSm or Map
  dynamic _getField(dynamic sms, String field) {
    if (sms is Map) {
      // Convert camelCase to snake_case for Map
      final mapKey = field == 'originalMessage' ? 'original_message' :
                     field == 'normalizedMessage' ? 'normalized_message' :
                     field == 'messageHash' ? 'message_hash' :
                     field == 'errorMessage' ? 'error_message' :
                     field == 'apiStatusCode' ? 'api_status_code' :
                     field == 'smsTimestamp' ? 'sms_timestamp' :
                     field == 'processedAt' ? 'processed_at' :
                     field.toLowerCase();
      return sms[mapKey];
    } else {
      // ProcessedSm object - use direct property access
      try {
        switch (field) {
          case 'status': return (sms as dynamic).status;
          case 'command': return (sms as dynamic).command;
          case 'amount': return (sms as dynamic).amount;
          case 'service': return (sms as dynamic).service;
          case 'phone': return (sms as dynamic).phone;
          case 'sender': return (sms as dynamic).sender;
          case 'originalMessage': return (sms as dynamic).originalMessage;
          case 'normalizedMessage': return (sms as dynamic).normalizedMessage;
          case 'errorMessage': return (sms as dynamic).errorMessage;
          case 'apiStatusCode': return (sms as dynamic).apiStatusCode;
          case 'processedAt': return (sms as dynamic).processedAt;
          case 'timestamp': return (sms as dynamic).smsTimestamp?.millisecondsSinceEpoch;
          default: return null;
        }
      } catch (e) {
        return null;
      }
    }
  }

  Widget _buildSmsItem(dynamic sms) {
    final status = _getField(sms, 'status')?.toString() ?? 'UNKNOWN';
    final statusColor = _getStatusColor(status);
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    
    // Extract fields
    final command = _getField(sms, 'command');
    final amount = _getField(sms, 'amount');
    final service = _getField(sms, 'service');
    final phone = _getField(sms, 'phone');
    final sender = _getField(sms, 'sender')?.toString() ?? 'Unknown';
    final originalMessage = _getField(sms, 'originalMessage')?.toString() ?? 
                           _getField(sms, 'message')?.toString() ?? '';
    final normalizedMessage = _getField(sms, 'normalizedMessage')?.toString();
    final errorMessage = _getField(sms, 'errorMessage')?.toString();
    final apiStatusCode = _getField(sms, 'apiStatusCode');
    final processedAt = _getField(sms, 'processedAt');
    final smsTimestamp = _getField(sms, 'smsTimestamp');
    final timestamp = _getField(sms, 'timestamp');
    final source = _getField(sms, 'source')?.toString();
    
    // Get display timestamp
    DateTime? displayTime;
    if (smsTimestamp != null) {
      displayTime = smsTimestamp is DateTime 
          ? smsTimestamp 
          : DateTime.parse(smsTimestamp.toString());
    } else if (timestamp != null) {
      displayTime = DateTime.fromMillisecondsSinceEpoch(timestamp as int);
    } else if (processedAt != null) {
      displayTime = processedAt is DateTime 
          ? processedAt 
          : DateTime.parse(processedAt.toString());
    }
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ExpansionTile(
        leading: Icon(
          _getStatusIcon(status),
          color: statusColor,
        ),
        title: Text(
          sender,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  'Status: $status',
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (source != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      source,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.blue[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            if (command != null && amount != null && phone != null)
              Text(
                service != null 
                  ? '$command $amount ($service) to $phone'
                  : '$command $amount to $phone',
                style: const TextStyle(fontSize: 12),
              )
            else if (originalMessage.isNotEmpty)
              Text(
                originalMessage.length > 50 
                  ? '${originalMessage.substring(0, 50)}...'
                  : originalMessage,
                style: const TextStyle(fontSize: 12),
              ),
            if (displayTime != null)
              Text(
                dateFormat.format(displayTime),
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                ),
              ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Original Message:', originalMessage),
                if (normalizedMessage != null)
                  _buildDetailRow('Normalized:', normalizedMessage),
                if (command != null)
                  _buildDetailRow('Command:', command.toString()),
                if (amount != null)
                  _buildDetailRow('Amount:', amount.toString()),
                if (service != null)
                  _buildDetailRow('Service:', service.toString()),
                if (phone != null)
                  _buildDetailRow('Phone:', phone.toString()),
                _buildDetailRow('Status:', status),
                if (apiStatusCode != null)
                  _buildDetailRow('API Status Code:', apiStatusCode.toString()),
                if (errorMessage != null)
                  _buildDetailRow(
                    'Error:',
                    errorMessage,
                    isError: true,
                  ),
                if (displayTime != null)
                  _buildDetailRow(
                    status == 'PENDING' ? 'Received At:' : 'SMS Received:',
                    dateFormat.format(displayTime),
                  ),
                if (processedAt != null && status != 'PENDING')
                  _buildDetailRow(
                    'Processed At:',
                    processedAt is DateTime 
                      ? dateFormat.format(processedAt)
                      : dateFormat.format(DateTime.parse(processedAt.toString())),
                  ),
                if (source != null)
                  _buildDetailRow('Source:', source),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isError = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: isError ? Colors.red : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _dbService.close();
    super.dispose();
  }
}

