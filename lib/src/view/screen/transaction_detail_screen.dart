import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/drift_database.dart';
import '../../data/database_helper.dart';

class TransactionDetailScreen extends StatefulWidget {
  final Map<String, dynamic> transaction;
  const TransactionDetailScreen({super.key, required this.transaction});

  @override
  State<TransactionDetailScreen> createState() => _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();
  String _userName = 'Customer';
  
  @override
  void initState() {
    super.initState();
    _loadUserName();
  }
  
  Future<void> _loadUserName() async {
    try {
      String? name;
      
      if (kIsWeb) {
        // Web platform - Use Drift database (customer table)
        try {
          final driftDb = AppDatabase();
          final customers = await driftDb.select(driftDb.customer).get();
          if (customers.isNotEmpty) {
            name = customers.first.displayName ?? 'Customer';
            print('Found name from Drift customer table: $name');
          } else {
            print('No customers found in Drift database');
          }
        } catch (e) {
          print('Error getting name from Drift customer table: $e');
        }
      } else {
        // Mobile platform - Use SQLite database (customer table)
        try {
          final customers = await DatabaseHelper.instance.getCustomer();
          if (customers.isNotEmpty && customers.first['display_name'] != null) {
            name = customers.first['display_name'].toString();
            print('Found name from SQLite customer table: $name');
          } else {
            print('No customers found in SQLite database');
          }
        } catch (e) {
          print('Error getting name from SQLite customer table: $e');
        }
      }
      
      // Fallback to SharedPreferences if database query failed
      if (name == null || name.isEmpty) {
        try {
          final prefs = await SharedPreferences.getInstance();
          name = prefs.getString('user_display_name');
          if (name != null && name.isNotEmpty) {
            print('Found name from SharedPreferences: $name');
          }
        } catch (e) {
          print('Error getting name from SharedPreferences: $e');
        }
      }
      
      if (mounted) {
        setState(() {
          _userName = name ?? 'Customer';
        });
        print('Final user name set to: $_userName');
      }
    } catch (e) {
      print('Error loading user name: $e');
      if (mounted) {
        setState(() {
          _userName = 'Customer';
        });
      }
    }
  }

  Future<void> _shareReceipt() async {
    try {
      final image = await _screenshotController.capture();
      if (image != null) {
        final tempDir = await getTemporaryDirectory();
        final file = await File('${tempDir.path}/receipt_${widget.transaction['reference']}.png').create();
        await file.writeAsBytes(image);
        await Share.shareXFiles([XFile(file.path)], text: 'Transaction Receipt - ${widget.transaction['reference']}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sharing receipt: $e')),
        );
      }
    }
  }

  Future<void> _downloadReceipt() async {
    try {
      final image = await _screenshotController.capture();
      if (image != null) {
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/receipt_${widget.transaction['reference']}.png');
        await file.writeAsBytes(image);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Receipt saved to: ${file.path}'),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error downloading receipt: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Extract essential details
    final amount = widget.transaction['amount']?.toString() ?? '0';
    final reference = widget.transaction['reference']?.toString() ?? 'N/A';
    final createdAt = widget.transaction['created_at']?.toString() ?? '';
    final phoneNumber = widget.transaction['msisdn']?.toString() ?? 'N/A';
    
    // Format amount with currency
    final amountValue = double.tryParse(amount) ?? 0;
    final formattedAmount = NumberFormat.currency(symbol: 'TZS ', decimalDigits: 0).format(amountValue);
    
    // Format date
    String formattedDate = 'N/A';
    if (createdAt.isNotEmpty) {
      try {
        final date = DateTime.parse(createdAt);
        formattedDate = DateFormat('dd MMM yyyy, HH:mm').format(date);
      } catch (e) {
        formattedDate = createdAt;
      }
    }

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Transaction Receipt'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareReceipt,
            tooltip: 'Share Receipt',
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _downloadReceipt,
            tooltip: 'Download Receipt',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Screenshot(
            controller: _screenshotController,
            child: Container(
              width: 300, // Narrow width like a paper receipt
              constraints: const BoxConstraints(maxWidth: 300),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Company Header
                  Text(
                    'SOFTECKI FACEACCESS',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Transaction Receipt',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                      letterSpacing: 0.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  // Dashed line
                  _buildDashedLine(),
                  
                  const SizedBox(height: 16),
                  
                  // Customer Name
                  Text(
                    _userName.toUpperCase(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      letterSpacing: 0.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Amount Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey[300]!, width: 1),
                        bottom: BorderSide(color: Colors.grey[300]!, width: 1),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'AMOUNT PAID',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          formattedAmount,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Transaction Details
                  _buildReceiptDetailRow('Description', 'Loan Repayment'),
                  const SizedBox(height: 12),
                  _buildReceiptDetailRow('Reference', reference),
                  const SizedBox(height: 12),
                  _buildReceiptDetailRow('Phone', phoneNumber),
                  const SizedBox(height: 12),
                  _buildReceiptDetailRow('Date', formattedDate),
                  
                  const SizedBox(height: 20),
                  
                  // Dashed line
                  _buildDashedLine(),
                  
                  const SizedBox(height: 16),
                  
                  // Footer
                  Text(
                    'Transaction ID: $reference',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[600],
                      letterSpacing: 0.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Thank you for your payment!',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[700],
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now()),
                    style: TextStyle(
                      fontSize: 9,
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildDashedLine() {
    return CustomPaint(
      painter: DashedLinePainter(),
      size: const Size(double.infinity, 1),
    );
  }
  
  Widget _buildReceiptDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 11,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

}

// Custom painter for dashed line
class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[400]!
      ..strokeWidth = 1.0;

    const dashWidth = 5.0;
    const dashSpace = 3.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
