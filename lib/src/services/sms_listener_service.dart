import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/app_data.dart';
import 'sms_processing_service.dart';
import 'sms_pending_service.dart';

/// Main SMS Listener Service
/// Handles permission requests and processes pending SMS
class SmsListenerService {
  static bool _isInitialized = false;
  static const String _smsListenerEnabledKey = 'sms_listener_enabled';
  static const MethodChannel _channel = MethodChannel('com.softecki.wicom/sms_receiver');
  
  // ========================================================================
  // HARDCODED DEFAULT: Change this value to set default enabled/disabled
  // Set to false to disable SMS listener by default
  // Set to true to enable SMS listener by default
  // ========================================================================
  static const bool _defaultEnabled = false;

  /// Initialize SMS listener service
  /// Requests permissions and sets up processing only if enabled
  static Future<bool> initialize() async {
    // Check if SMS listener is enabled
    if (!await isEnabled()) {
      print('SMS Listener is disabled - skipping initialization and stopping native service');
      // Stop the native service if it's running
      await _stopNativeService();
      return false;
    }

    if (_isInitialized) {
      return true;
    }

    try {
      // Request SMS permissions
      final hasPermission = await requestSmsPermissions();
      if (!hasPermission) {
        print('SMS permissions not granted');
        return false;
      }

      // Initialize WorkManager for background processing
      await SmsProcessingService.initialize();

      // Sync API URL to native service (ensures both use same endpoint)
      try {
        await _channel.invokeMethod('setApiBaseUrl', {'url': AppData.url});
        print('API URL synced to native service: ${AppData.url}');
      } catch (e) {
        print('Note: Could not sync API URL to native service: $e');
      }

      // Start the foreground service for background SMS processing
      // This ensures SMS are processed even when app is closed
      try {
        await _channel.invokeMethod('startSmsProcessingService');
        print('SMS Processing Service started for background processing');
      } catch (e) {
        print('Note: Could not start foreground service (may already be running): $e');
      }

      // Set up MethodChannel listener to receive notifications from native code
      // IMPORTANT: Set handler BEFORE processing pending SMS to avoid duplicate processing
      _channel.setMethodCallHandler(_handleMethodCall);
      
      // Process any pending SMS from native receiver (only on initialization)
      // Note: Subsequent processing will be triggered by method call handler
      await SmsPendingService.processPendingSms();

      _isInitialized = true;
      print('SMS Listener Service initialized successfully');
      return true;
    } catch (e) {
      print('Error initializing SMS Listener Service: $e');
      return false;
    }
  }

  /// Stop the native SMS processing service
  static Future<void> _stopNativeService() async {
    try {
      await _channel.invokeMethod('stopSmsProcessingService');
      print('Native SMS Processing Service stopped');
    } catch (e) {
      print('Note: Could not stop foreground service (may not be running): $e');
    }
  }

  /// Public method to stop native service if SMS is disabled
  /// Call this from main.dart to ensure service is stopped on app startup
  static Future<void> stopNativeServiceIfDisabled() async {
    if (!await isEnabled()) {
      await _stopNativeService();
    }
  }

  /// Check if SMS listener is enabled
  /// Returns the hardcoded/local app setting
  static Future<bool> isEnabled() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // If setting exists, use it; otherwise use default
      return prefs.getBool(_smsListenerEnabledKey) ?? _defaultEnabled;
    } catch (e) {
      print('Error checking SMS listener enabled status: $e');
      return _defaultEnabled;
    }
  }

  /// Enable SMS listener
  /// This will start the SMS listener if not already initialized
  static Future<bool> enable() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_smsListenerEnabledKey, true);
      
      // Initialize if not already done
      if (!_isInitialized) {
        return await initialize();
      }
      
      return true;
    } catch (e) {
      print('Error enabling SMS listener: $e');
      return false;
    }
  }

  /// Disable SMS listener
  /// This will stop processing new SMS but won't clear existing data
  static Future<bool> disable() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_smsListenerEnabledKey, false);
      _isInitialized = false;
      
      // Stop the native service
      await _stopNativeService();
      
      // Remove method call handler to prevent native callbacks
      _channel.setMethodCallHandler(null);
      
      print('SMS Listener disabled and native service stopped');
      return true;
    } catch (e) {
      print('Error disabling SMS listener: $e');
      return false;
    }
  }

  /// Set SMS listener enabled status
  static Future<bool> setEnabled(bool enabled) async {
    if (enabled) {
      return await enable();
    } else {
      return await disable();
    }
  }

  /// Request SMS reading permissions
  static Future<bool> requestSmsPermissions() async {
    try {
      // Check if permissions are already granted
      final receiveSmsStatus = await Permission.sms.status;
      final readSmsStatus = await Permission.sms.status;

      if (receiveSmsStatus.isGranted && readSmsStatus.isGranted) {
        return true;
      }

      // Request permissions
      final Map<Permission, PermissionStatus> statuses = await [
        Permission.sms,
      ].request();

      final smsPermission = statuses[Permission.sms];
      return smsPermission?.isGranted ?? false;
    } catch (e) {
      print('Error requesting SMS permissions: $e');
      return false;
    }
  }

  /// Check if SMS permissions are granted
  static Future<bool> hasSmsPermissions() async {
    try {
      final status = await Permission.sms.status;
      return status.isGranted;
    } catch (e) {
      return false;
    }
  }

  /// Check and process pending SMS
  /// Call this periodically or when app becomes active
  /// Only processes if SMS listener is enabled
  static Future<void> checkPendingSms() async {
    if (await isEnabled()) {
      await SmsPendingService.processPendingSms();
    }
  }

  // Track last method call to prevent duplicate processing
  static DateTime? _lastMethodCallTime;
  static String? _lastMethodCall;
  
  /// Handle method calls from native code (MainActivity)
  static Future<void> _handleMethodCall(MethodCall call) async {
    try {
      // First check if SMS listener is enabled - ignore all calls if disabled
      if (!await isEnabled()) {
        print('SmsListenerService: Received method call but SMS listener is disabled - ignoring');
        return;
      }
      
      // Prevent duplicate method calls within 1 second
      final now = DateTime.now();
      if (_lastMethodCallTime != null && 
          _lastMethodCall == call.method &&
          now.difference(_lastMethodCallTime!).inSeconds < 1) {
        print('SmsListenerService: Duplicate method call detected (${call.method}), ignoring');
        return;
      }
      
      _lastMethodCallTime = now;
      _lastMethodCall = call.method;
      
      print('SmsListenerService: Received method call: ${call.method}');
      print('SmsListenerService: Arguments: ${call.arguments}');
      
      if (call.method == 'onSmsReceived' || call.method == 'checkPendingSms') {
        // Native code notified us that SMS was received or app resumed
        // Note: We read pending count directly from SharedPreferences, not from arguments
        
        // Add a delay to ensure native commit() has completed
        await Future.delayed(const Duration(milliseconds: 500));
        
        // Process pending SMS immediately (with built-in duplicate prevention)
        print('SmsListenerService: Triggering pending SMS processing from native');
        await checkPendingSms();
      }
    } catch (e) {
      print('SmsListenerService: Error handling method call: $e');
    }
  }

  /// Manually process an SMS (for testing or manual entry)
  /// Only processes if SMS listener is enabled
  static Future<void> processSmsManually({
    required String sender,
    required String message,
    int? timestamp,
  }) async {
    if (await isEnabled()) {
      await SmsProcessingService.processSms(
        sender: sender,
        messageBody: message,
        timestamp: timestamp ?? DateTime.now().millisecondsSinceEpoch,
      );
    } else {
      print('SMS Listener is disabled - cannot process SMS manually');
    }
  }

  /// Open app settings to grant permissions
  static Future<void> openPermissionSettings() async {
    await openAppSettings();
  }
}
