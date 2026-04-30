import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../core/app_data.dart';
import '../../../core/app_color.dart';
import 'home_screen.dart';
import '../../static.dart';

class ChangePinScreen extends StatefulWidget {
  final String phone;
  final String currentPin;

  const ChangePinScreen({
    Key? key,
    required this.phone,
    required this.currentPin,
  }) : super(key: key);

  @override
  State<ChangePinScreen> createState() => _ChangePinScreenState();
}

class _ChangePinScreenState extends State<ChangePinScreen> {
  final TextEditingController currentPinController = TextEditingController();
  final TextEditingController newPinController = TextEditingController();
  final TextEditingController confirmPinController = TextEditingController();
  
  bool _obscureCurrentPin = true;
  bool _obscureNewPin = true;
  bool _obscureConfirmPin = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill current PIN
    currentPinController.text = widget.currentPin;
  }

  @override
  void dispose() {
    currentPinController.dispose();
    newPinController.dispose();
    confirmPinController.dispose();
    super.dispose();
  }

  Future<void> changePin() async {
    // Validate inputs
    if (currentPinController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter your current PIN'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (newPinController.text.length != 6 || !RegExp(r'^\d{6}$').hasMatch(newPinController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('New PIN must be exactly 6 digits'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (newPinController.text != confirmPinController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('New PIN and confirm PIN do not match'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (newPinController.text == currentPinController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('New PIN must be different from current PIN'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Show loading dialog
    if (!context.mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(
          color: AppColor.primaryColor,
        ),
      ),
    );

    try {
      final url = Uri.parse('${AppData.url}/change-pin');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'phone': widget.phone,
          'current_pin': currentPinController.text,
          'new_pin': newPinController.text,
          'confirm_new_pin': confirmPinController.text,
        }),
      );

      if (!context.mounted) return;
      // Dismiss loading dialog
      if (Navigator.of(context, rootNavigator: true).canPop()) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // PIN changed successfully
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseBody['message'] ?? 'PIN changed successfully'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );

          // Navigate to home screen
          constant().isItLogged = true;
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false,
          );
        }
      } else {
        // Error occurred
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseBody['message'] ?? 'Failed to change PIN. Please try again.'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 5),
            ),
          );
        }
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (context.mounted) {
        // Dismiss loading dialog
        if (Navigator.of(context, rootNavigator: true).canPop()) {
          Navigator.of(context, rootNavigator: true).pop();
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: Text('Change PIN'),
        backgroundColor: AppColor.primaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            // Info message
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.orange.shade700),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'You are using a temporary PIN. Please create a new PIN for security.',
                      style: TextStyle(
                        color: Colors.orange.shade900,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Current PIN field
            Text(
              'Current PIN',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white,
                    offset: Offset(-3, -3),
                    blurRadius: 6,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: Offset(3, 3),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: TextField(
                controller: currentPinController,
                obscureText: _obscureCurrentPin,
                keyboardType: TextInputType.number,
                maxLength: 6,
                enabled: false, // Disabled since it's pre-filled
                decoration: InputDecoration(
                  hintText: 'Current PIN',
                  prefixIcon: Icon(Icons.lock),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  counterText: '',
                ),
              ),
            ),
            const SizedBox(height: 20),

            // New PIN field
            Text(
              'New PIN (6 digits)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white,
                    offset: Offset(-3, -3),
                    blurRadius: 6,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: Offset(3, 3),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: TextField(
                controller: newPinController,
                obscureText: _obscureNewPin,
                keyboardType: TextInputType.number,
                maxLength: 6,
                enabled: !_isLoading,
                decoration: InputDecoration(
                  hintText: 'Enter new PIN',
                  prefixIcon: Icon(Icons.lock_outline),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  counterText: '',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureNewPin ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureNewPin = !_obscureNewPin;
                      });
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Confirm PIN field
            Text(
              'Confirm New PIN',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white,
                    offset: Offset(-3, -3),
                    blurRadius: 6,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: Offset(3, 3),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: TextField(
                controller: confirmPinController,
                obscureText: _obscureConfirmPin,
                keyboardType: TextInputType.number,
                maxLength: 6,
                enabled: !_isLoading,
                decoration: InputDecoration(
                  hintText: 'Confirm new PIN',
                  prefixIcon: Icon(Icons.lock_outline),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  counterText: '',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPin ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPin = !_obscureConfirmPin;
                      });
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Change PIN button
            GestureDetector(
              onTap: _isLoading ? null : changePin,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 16),
                decoration: BoxDecoration(
                  color: _isLoading ? Colors.grey : Colors.green.shade600,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: _isLoading ? Colors.grey.shade700 : Colors.green.shade700,
                      offset: Offset(4, 4),
                      blurRadius: 6,
                    ),
                    BoxShadow(
                      color: _isLoading ? Colors.grey.shade400 : Colors.green.shade400,
                      offset: Offset(-2, -2),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Center(
                  child: _isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          'CHANGE PIN',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

