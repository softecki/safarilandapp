import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'sms_processing_service.dart';

/// Service for managing pending SMS from SharedPreferences
/// SMS are stored by native receiver and processed by Flutter
class SmsPendingService {
  static const String prefsKey = 'sms_receiver_prefs';
  static const String pendingSmsKey = 'pending_sms_list';
  static const int maxPendingSms = 100;
  static const MethodChannel _channel = MethodChannel('com.softecki.wicom/sms_receiver');
  
  // Processing lock to prevent concurrent processing
  static bool _isProcessing = false;
  static DateTime? _lastProcessingTime;

  /// Get pending SMS from native SharedPreferences via MethodChannel
  static Future<List<String>> _getPendingSmsFromNative() async {
    try {
      print('SmsPendingService: Requesting pending SMS from native via MethodChannel');
      final List<dynamic> result = await _channel.invokeMethod('getPendingSms');
      final List<String> smsList = result.cast<String>();
      print('SmsPendingService: Received ${smsList.length} SMS from native');
      return smsList;
    } catch (e) {
      print('SmsPendingService: Error getting SMS from native: $e');
      return [];
    }
  }

  /// Check for pending SMS and process them
  /// Should be called on app startup, when app comes to foreground, and periodically
  static Future<void> processPendingSms() async {
    // Prevent concurrent processing
    if (_isProcessing) {
      print('SmsPendingService: Already processing pending SMS, skipping duplicate call');
      return;
    }
    
    // Prevent processing too frequently (minimum 2 seconds between calls)
    if (_lastProcessingTime != null) {
      final timeSinceLastProcessing = DateTime.now().difference(_lastProcessingTime!);
      if (timeSinceLastProcessing.inSeconds < 2) {
        print('SmsPendingService: Processing called too soon (${timeSinceLastProcessing.inSeconds}s ago), skipping');
        return;
      }
    }
    
    _isProcessing = true;
    _lastProcessingTime = DateTime.now();
    
    try {
      // Try MethodChannel first to get SMS from native SharedPreferences directly
      List<String> pendingSmsList = await _getPendingSmsFromNative();
      
      // Fallback: Try Flutter SharedPreferences if MethodChannel fails
      if (pendingSmsList.isEmpty) {
        print('SmsPendingService: MethodChannel returned empty, trying Flutter SharedPreferences');
        final prefs = await SharedPreferences.getInstance();
        await prefs.reload();
        
        final count = prefs.getInt('${pendingSmsKey}_count') ?? 0;
        print('SmsPendingService: Flutter SharedPreferences count: $count');
        
        if (count > 0) {
          for (int i = 0; i < count && i < maxPendingSms; i++) {
            final sms = prefs.getString('${pendingSmsKey}_$i');
            if (sms != null && sms.isNotEmpty) {
              pendingSmsList.add(sms);
            }
          }
        }
      }
      
      print('SmsPendingService: Total pending SMS found: ${pendingSmsList.length}');

      if (pendingSmsList.isEmpty) {
        print('SmsPendingService: No valid pending SMS found after loading');
        return;
      }

      print('SmsPendingService: Processing ${pendingSmsList.length} pending SMS messages');

      // Process each pending SMS
      for (final smsJsonStr in pendingSmsList) {
        try {
          final smsData = jsonDecode(smsJsonStr) as Map<String, dynamic>;
          final sender = smsData['sender'] as String? ?? '';
          final message = smsData['message'] as String? ?? '';
          final timestamp = smsData['timestamp'] as int? ?? 
              DateTime.now().millisecondsSinceEpoch;

          print('SmsPendingService: Processing SMS - sender: $sender, message: $message, timestamp: $timestamp');
          
          // Check if already processed using timestamp-based key (shared with native service)
          if (await _isSmsAlreadyProcessed(sender, message, timestamp)) {
            print('SmsPendingService: SMS already processed (duplicate), skipping: $sender at $timestamp');
            continue; // Skip this SMS
          }
          
          // Mark as processed BEFORE processing (prevents duplicate processing)
          await _markSmsAsProcessed(sender, message, timestamp);
          
          // Process the SMS
          await SmsProcessingService.processSms(
            sender: sender,
            messageBody: message,
            timestamp: timestamp,
          );
          
          print('SmsPendingService: Successfully processed SMS from $sender');
        } catch (e) {
          print('SmsPendingService: Error processing pending SMS: $e');
          print('SmsPendingService: Stack trace: ${StackTrace.current}');
        }
      }

      // Clear processed SMS from native SharedPreferences via MethodChannel
      try {
        await _channel.invokeMethod('clearPendingSms');
        print('Cleared ${pendingSmsList.length} processed SMS from pending list via native');
      } catch (e) {
        print('Error clearing pending SMS via MethodChannel: $e');
        // Fallback: Try Flutter SharedPreferences
        try {
          final prefs = await SharedPreferences.getInstance();
          final currentCount = prefs.getInt('${pendingSmsKey}_count') ?? 0;
          await prefs.remove('${pendingSmsKey}_count');
          for (int i = 0; i < currentCount; i++) {
            await prefs.remove('${pendingSmsKey}_$i');
          }
          print('Cleared pending SMS via Flutter SharedPreferences fallback');
        } catch (clearError) {
          print('Error clearing via Flutter SharedPreferences: $clearError');
        }
      }

    } catch (e) {
      print('Error processing pending SMS: $e');
    } finally {
      _isProcessing = false;
    }
  }

  /// Get count of pending SMS
  static Future<int> getPendingSmsCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt('${pendingSmsKey}_count') ?? 0;
    } catch (e) {
      return 0;
    }
  }

  /// Check if SMS was already processed using timestamp-based key
  /// Uses the same key format as native service: timestamp_sender_messageHash
  static Future<bool> _isSmsAlreadyProcessed(
    String sender,
    String message,
    int timestamp,
  ) async {
    try {
      // Try MethodChannel first (reads from native SharedPreferences)
      try {
        final processed = await _channel.invokeMethod('isSmsProcessed', {
          'sender': sender,
          'message': message,
          'timestamp': timestamp,
        });
        if (processed == true) {
          return true;
        }
      } catch (e) {
        print('SmsPendingService: Error checking via MethodChannel: $e');
      }
      
      // Fallback: Check Flutter SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final processedKeys = prefs.getString('processed_sms_timestamps') ?? '';
      
      // Create key in same format as native: timestamp_sender_hash
      final hashInput = '$sender|$message|$timestamp';
      final messageHash = hashInput.hashCode.toString();
      final smsKey = '${timestamp}_${sender}_${messageHash.substring(0, messageHash.length > 16 ? 16 : messageHash.length)}';
      
      return processedKeys.contains(smsKey);
    } catch (e) {
      print('SmsPendingService: Error checking if SMS processed: $e');
      return false; // On error, assume not processed
    }
  }

  /// Mark SMS as processed using timestamp-based key
  /// Uses MethodChannel to mark in native SharedPreferences (shared with native service)
  static Future<void> _markSmsAsProcessed(
    String sender,
    String message,
    int timestamp,
  ) async {
    try {
      // Try MethodChannel first (marks in native SharedPreferences)
      try {
        await _channel.invokeMethod('markSmsAsProcessed', {
          'sender': sender,
          'message': message,
          'timestamp': timestamp,
        });
        print('SmsPendingService: Marked SMS as processed via MethodChannel');
      } catch (e) {
        print('SmsPendingService: Error marking via MethodChannel: $e');
        // Fallback: Mark in Flutter SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        String processedKeys = prefs.getString('processed_sms_timestamps') ?? '';
        
        final hashInput = '$sender|$message|$timestamp';
        final messageHash = hashInput.hashCode.toString();
        final smsKey = '${timestamp}_${sender}_${messageHash.substring(0, messageHash.length > 16 ? 16 : messageHash.length)}';
        
        if (!processedKeys.contains(smsKey)) {
          processedKeys = processedKeys.isEmpty ? smsKey : '$processedKeys,$smsKey';
          
          // Limit to last 1000 keys
          final keys = processedKeys.split(',');
          if (keys.length > 1000) {
            processedKeys = keys.sublist(keys.length - 1000).join(',');
          }
          
          await prefs.setString('processed_sms_timestamps', processedKeys);
          print('SmsPendingService: Marked SMS as processed via Flutter SharedPreferences');
        }
      }
    } catch (e) {
      print('SmsPendingService: Error marking SMS as processed: $e');
    }
  }

  /// Clear all pending SMS
  static Future<void> clearPendingSms() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final count = prefs.getInt('${pendingSmsKey}_count') ?? 0;
      await prefs.remove('${pendingSmsKey}_count');
      for (int i = 0; i < count; i++) {
        await prefs.remove('${pendingSmsKey}_$i');
      }
    } catch (e) {
      print('Error clearing pending SMS: $e');
    }
  }
}

