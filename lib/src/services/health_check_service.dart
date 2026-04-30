import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:workmanager/workmanager.dart';
import '../../core/app_data.dart';
import 'sms_listener_service.dart';

/// Health Check Service
/// Monitors application health, internet connectivity, and SMS listener service
/// Sends periodic health checks to backend and listens for commands from backend
class HealthCheckService {
  static const String taskName = 'health_check_task';
  static const String _healthCheckEnabledKey = 'health_check_enabled';
  static const String _deviceIdKey = 'health_check_device_id';
  static Timer? _periodicTimer;
  static Timer? _commandPollingTimer;
  static bool _isRunning = false;
  static BuildContext? _context;
  static bool _showingDialog = false;
  static GlobalKey<NavigatorState>? _navigatorKey;
  static DateTime? _lastCommandCheck;

  /// Set navigator key for showing dialogs from background
  static void setNavigatorKey(GlobalKey<NavigatorState> navigatorKey) {
    _navigatorKey = navigatorKey;
  }

  /// Update context (call this when navigating to new screens)
  static void updateContext(BuildContext? context) {
    _context = context;
  }

  /// Initialize health check service
  /// Only runs if SMS listener is enabled
  static Future<bool> initialize({BuildContext? context}) async {
    _context = context;
    
    // Check if SMS listener is enabled
    if (!await SmsListenerService.isEnabled()) {
      print('Health Check: SMS listener is disabled - health check will not run');
      return false;
    }

    // Check if health check is enabled
    if (!await isEnabled()) {
      print('Health Check: Service is disabled');
      return false;
    }

    if (_isRunning) {
      print('Health Check: Service is already running');
      return true;
    }

    try {
      // Initialize WorkManager for background processing
      await Workmanager().initialize(
        healthCheckCallbackDispatcher,
        isInDebugMode: false,
      );

      // Register periodic task (every 3 seconds)
      await Workmanager().registerPeriodicTask(
        taskName,
        taskName,
        frequency: const Duration(seconds: 3),
        constraints: Constraints(
          networkType: NetworkType.connected,
        ),
      );

      // Also start foreground monitoring
      _startPeriodicCheck();
      
      // Start command polling (more frequent for instant execution)
      _startCommandPolling();

      _isRunning = true;
      print('Health Check Service initialized successfully');
      return true;
    } catch (e) {
      print('Error initializing Health Check Service: $e');
      return false;
    }
  }

  /// Start periodic health check (foreground)
  static void _startPeriodicCheck() {
    _periodicTimer?.cancel();
    _periodicTimer = Timer.periodic(const Duration(minutes: 5), (timer) async {
      if (await SmsListenerService.isEnabled() && await isEnabled()) {
        await performHealthCheck();
      } else {
        timer.cancel();
        _isRunning = false;
      }
    });
  }

  /// Start command polling (runs more frequently for instant command execution)
  static void _startCommandPolling() {
    _commandPollingTimer?.cancel();
    _commandPollingTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      if (await SmsListenerService.isEnabled() && await isEnabled()) {
        try {
          // Check basic connectivity first (quick check)
          final hasBasicConnectivity = await _checkInternetConnectivity();
          if (hasBasicConnectivity) {
            final deviceId = await _getDeviceId();
            // Try to check commands - if it fails, it's silently handled
            await _checkBackendCommands(deviceId, skipIfRecent: true);
          }
        } catch (e) {
          print('Error in command polling: $e');
        }
      } else {
        timer.cancel();
      }
    });
  }

  /// Stop health check service
  static Future<void> stop() async {
    _periodicTimer?.cancel();
    _periodicTimer = null;
    _commandPollingTimer?.cancel();
    _commandPollingTimer = null;
    _isRunning = false;
    
    try {
      await Workmanager().cancelByUniqueName(taskName);
      print('Health Check Service stopped');
    } catch (e) {
      print('Error stopping Health Check Service: $e');
    }
  }

  /// Check if health check is enabled
  static Future<bool> isEnabled() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_healthCheckEnabledKey) ?? true; // Default enabled
    } catch (e) {
      return true;
    }
  }

  /// Enable health check
  static Future<bool> enable() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_healthCheckEnabledKey, true);
      
      if (!_isRunning) {
        return await initialize(context: _context);
      }
      
      return true;
    } catch (e) {
      print('Error enabling health check: $e');
      return false;
    }
  }

  /// Disable health check
  static Future<bool> disable() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_healthCheckEnabledKey, false);
      await stop();
      return true;
    } catch (e) {
      print('Error disabling health check: $e');
      return false;
    }
  }

  /// Get or create device ID
  static Future<String> _getDeviceId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? deviceId = prefs.getString(_deviceIdKey);
      
      if (deviceId == null || deviceId.isEmpty) {
        // Generate unique device ID
        deviceId = 'DEV_${DateTime.now().millisecondsSinceEpoch}_${DateTime.now().hashCode}';
        await prefs.setString(_deviceIdKey, deviceId);
      }
      
      return deviceId;
    } catch (e) {
      return 'DEV_${DateTime.now().millisecondsSinceEpoch}';
    }
  }

  /// Manually check for commands (can be called immediately after sending a command from portal)
  static Future<void> checkCommandsNow() async {
    try {
      // Check basic connectivity first (quick check)
      final hasBasicConnectivity = await _checkInternetConnectivity();
      if (hasBasicConnectivity) {
        final deviceId = await _getDeviceId();
        // Try to check commands - if it fails, it's silently handled
        await _checkBackendCommands(deviceId, skipIfRecent: false);
      }
    } catch (e) {
      print('Error checking commands now: $e');
    }
  }

  /// Perform health check
  static Future<void> performHealthCheck() async {
    try {
      // Check basic connectivity (WiFi/mobile data) - just for reporting, not for blocking
      final connectivityResult = await Connectivity().checkConnectivity();
      final hasBasicConnectivity = connectivityResult != ConnectivityResult.none;
      
      // Check SMS listener service status
      final smsListenerRunning = await _checkSmsListenerStatus();
      
      // Get device ID
      final deviceId = await _getDeviceId();
      
      // Prepare health check data
      final healthData = {
        'device_id': deviceId,
        'timestamp': DateTime.now().toIso8601String(),
        'internet_available': hasBasicConnectivity,
        'sms_listener_running': smsListenerRunning,
        'sms_listener_enabled': await SmsListenerService.isEnabled(),
        'app_version': '1.1.0',
        'platform': 'android', // You can detect this dynamically
      };

      // Always try to send health check to backend
      // The dialog will only show if the actual request fails
      final healthCheckSent = await _sendHealthCheckToBackend(healthData);
      
      // If health check failed to send, show dialog
      if (!healthCheckSent) {
        _showInternetDialog();
      }

      // Check if SMS listener needs to be restarted
      if (smsListenerRunning == false && await SmsListenerService.isEnabled()) {
        print('Health Check: SMS listener not running, attempting to restart...');
        await SmsListenerService.initialize();
      }

      // Check for commands from backend (only if health check was successful)
      if (healthCheckSent) {
        await _checkBackendCommands(deviceId);
      }
    } catch (e) {
      print('Error performing health check: $e');
      // If there's an error, show dialog as it likely means no internet
      _showInternetDialog();
    }
  }

  /// Check basic internet connectivity (WiFi/mobile data only)
  /// This is a lightweight check that doesn't ping the backend
  static Future<bool> _checkInternetConnectivity() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      return connectivityResult != ConnectivityResult.none;
    } catch (e) {
      print('Error checking internet connectivity: $e');
      return false;
    }
  }

  /// Check SMS listener service status
  static Future<bool> _checkSmsListenerStatus() async {
    try {
      // Check if SMS listener is enabled
      if (!await SmsListenerService.isEnabled()) {
        return false;
      }

      // Try to check native service status
      // This is a simplified check - you may need to add native method channel
      // For now, we assume it's running if enabled
      return true;
    } catch (e) {
      print('Error checking SMS listener status: $e');
      return false;
    }
  }

  /// Send health check to backend
  /// Returns true if successful, false if failed (no internet or backend unreachable)
  static Future<bool> _sendHealthCheckToBackend(Map<String, dynamic> healthData) async {
    try {
      final response = await http.post(
        Uri.parse('${AppData.url}/health-check/report'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(healthData),
      ).timeout(const Duration(seconds: 30)); // Increased timeout to 30 seconds

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        
        // Check if backend sent any commands
        if (responseData['command'] != null) {
          final command = responseData['command'];
          // Ensure command is a Map before processing
          if (command is Map<String, dynamic>) {
            await _handleBackendCommand(command);
          } else {
            print('Health Check: Invalid command format in response: ${command.runtimeType}');
          }
        }
        
        return true; // Successfully sent
      } else {
        print('Health Check: Backend returned status code ${response.statusCode}');
        return false; // Failed to send
      }
    } catch (e) {
      print('Error sending health check to backend: $e');
      return false; // Failed to send (likely no internet or backend unreachable)
    }
  }

  /// Check for commands from backend
  static Future<void> _checkBackendCommands(String deviceId, {bool skipIfRecent = false}) async {
    try {
      // Skip if we checked recently (within last 2 seconds) to avoid too frequent requests
      if (skipIfRecent && _lastCommandCheck != null) {
        final timeSinceLastCheck = DateTime.now().difference(_lastCommandCheck!);
        if (timeSinceLastCheck.inSeconds < 2) {
          return;
        }
      }
      
      _lastCommandCheck = DateTime.now();
      
      final response = await http.post(
        Uri.parse('${AppData.url}/health-check/commands'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'device_id': deviceId,
        }),
      ).timeout(const Duration(seconds: 30)); // Increased timeout to 30 seconds

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        
        if (responseData['commands'] != null && responseData['commands'] is List) {
          final commands = responseData['commands'] as List;
          if (commands.isNotEmpty) {
            print('Health Check: Found ${commands.length} pending command(s)');
            for (var command in commands) {
              // Ensure command is a Map before processing
              if (command is Map<String, dynamic>) {
                await _handleBackendCommand(command);
              } else {
                print('Health Check: Invalid command format: $command');
              }
            }
          }
        }
      }
    } catch (e) {
      print('Error checking backend commands: $e');
    }
  }

  /// Handle command from backend
  static Future<void> _handleBackendCommand(dynamic command) async {
    try {
      // Ensure command is a Map
      if (command is! Map<String, dynamic>) {
        print('Health Check: Command is not a Map: ${command.runtimeType}');
        return;
      }
      
      final commandId = command['id'];
      final commandType = command['type'] as String?;
      final commandData = command['data'] is Map ? command['data'] as Map<String, dynamic>? : null;

      print('Health Check: Received command from backend - ID: $commandId, Type: $commandType');

      if (commandId == null) {
        print('Health Check: Command ID is missing, cannot process command');
        return;
      }

      bool commandExecuted = false;
      String? responseMessage;

      switch (commandType) {
        case 'restart_sms_listener':
          print('Health Check: Restarting SMS listener...');
          try {
            await SmsListenerService.disable();
            await Future.delayed(const Duration(seconds: 1));
            await SmsListenerService.enable();
            commandExecuted = true;
            responseMessage = 'SMS listener restarted successfully';
          } catch (e) {
            print('Health Check: Error restarting SMS listener: $e');
            responseMessage = 'Failed to restart SMS listener: $e';
          }
          break;

        case 'enable_health_check':
          print('Health Check: Enabling health check...');
          try {
            await enable();
            commandExecuted = true;
            responseMessage = 'Health check enabled successfully';
          } catch (e) {
            print('Health Check: Error enabling health check: $e');
            responseMessage = 'Failed to enable health check: $e';
          }
          break;

        case 'disable_health_check':
          print('Health Check: Disabling health check...');
          try {
            await disable();
            commandExecuted = true;
            responseMessage = 'Health check disabled successfully';
          } catch (e) {
            print('Health Check: Error disabling health check: $e');
            responseMessage = 'Failed to disable health check: $e';
          }
          break;

        case 'perform_health_check':
          print('Health Check: Performing health check...');
          try {
            await performHealthCheck();
            commandExecuted = true;
            responseMessage = 'Health check performed successfully';
          } catch (e) {
            print('Health Check: Error performing health check: $e');
            responseMessage = 'Failed to perform health check: $e';
          }
          break;

        default:
          print('Health Check: Unknown command type: $commandType');
          responseMessage = 'Unknown command type: $commandType';
      }

      // Send response back to backend
      if (commandExecuted) {
        await _sendCommandResponse(commandId, 'success', responseMessage ?? 'Command executed');
      } else {
        await _sendCommandResponse(commandId, 'failed', responseMessage ?? 'Command failed');
      }
    } catch (e) {
      print('Error handling backend command: $e');
      // Try to send error response if we have command ID
      try {
        if (command is Map<String, dynamic> && command['id'] != null) {
          await _sendCommandResponse(command['id'], 'failed', 'Error executing command: $e');
        }
      } catch (responseError) {
        print('Error sending error response: $responseError');
      }
    }
  }

  /// Send command response to backend
  static Future<void> _sendCommandResponse(dynamic commandId, String status, String message) async {
    if (commandId == null) {
      print('Health Check: Cannot send command response - command ID is null');
      return;
    }

    try {
      final deviceId = await _getDeviceId();
      
      // Convert command ID to int if it's a string
      int? cmdId;
      if (commandId is int) {
        cmdId = commandId;
      } else if (commandId is String) {
        cmdId = int.tryParse(commandId);
      } else {
        print('Health Check: Invalid command ID type: ${commandId.runtimeType}');
        return;
      }
      
      if (cmdId == null) {
        print('Health Check: Cannot parse command ID: $commandId');
        return;
      }
      
      print('Health Check: Sending command response - ID: $cmdId, Status: $status, Message: $message');
      
      final response = await http.post(
        Uri.parse('${AppData.url}/health-check/command-response'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'command_id': cmdId,
          'device_id': deviceId,
          'status': status,
          'message': message,
          'timestamp': DateTime.now().toIso8601String(),
        }),
      ).timeout(const Duration(seconds: 30)); // Increased timeout to 30 seconds
      
      if (response.statusCode == 200) {
        print('Health Check: Command response sent successfully');
      } else {
        print('Health Check: Failed to send command response - Status: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      print('Error sending command response: $e');
    }
  }

  /// Show internet connectivity dialog
  static void _showInternetDialog() {
    if (_showingDialog) {
      return; // Already showing
    }

    _showingDialog = true;

    // Try to get context from navigator key first (works from background)
    BuildContext? context = _navigatorKey?.currentContext;
    
    // Fallback to stored context
    if (context == null) {
      context = _context;
    }
    
    if (context == null) {
      print('Health Check: Cannot show dialog - no context available');
      _showingDialog = false;
      return;
    }

    // Use Future.microtask to ensure we're in the right frame
    Future.microtask(() {
      try {
        // Show dialog
        showDialog(
          context: context!,
          barrierDismissible: false,
          builder: (BuildContext dialogContext) {
            return WillPopScope(
              onWillPop: () async => false, // Prevent dismissing
              child: AlertDialog(
                title: const Text('No Internet Connection'),
                content: const Text(
                  'Please enable internet connection to continue using the app.\n\n'
                  'The app needs internet to:\n'
                  '- Process SMS payments\n'
                  '- Send health reports\n'
                  '- Receive commands from server',
                ),
                actions: [
                  TextButton(
                    onPressed: () async {
                      // Open settings to enable internet
                      _showingDialog = false;
                      Navigator.of(dialogContext).pop();
                      
                      // Try to open settings
                      try {
                        // Use url_launcher to open Android settings
                        final Uri settingsUri = Uri.parse('android.settings.WIRELESS_SETTINGS');
                        // Note: You'll need to import url_launcher package
                        // await launchUrl(settingsUri);
                        print('Health Check: Opening settings to enable internet');
                      } catch (e) {
                        print('Error opening settings: $e');
                      }
                    },
                    child: const Text('Open Settings'),
                  ),
                  TextButton(
                    onPressed: () {
                      _showingDialog = false;
                      Navigator.of(dialogContext).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          },
        ).then((_) {
          // Reset flag when dialog is closed
          Future.delayed(const Duration(seconds: 2), () {
            _showingDialog = false;
          });
        });
      } catch (e) {
        print('Error showing internet dialog: $e');
        _showingDialog = false;
      }
    });
  }

  /// Background callback dispatcher
  @pragma('vm:entry-point')
  static void _healthCheckCallbackDispatcher() {
    Workmanager().executeTask((task, inputData) async {
      try {
        if (await SmsListenerService.isEnabled() && await HealthCheckService.isEnabled()) {
          await HealthCheckService.performHealthCheck();
        }
        return Future.value(true);
      } catch (e) {
        print('Error in health check background task: $e');
        return Future.value(false);
      }
    });
  }
}

/// Top-level callback dispatcher for WorkManager
@pragma('vm:entry-point')
void healthCheckCallbackDispatcher() {
  HealthCheckService._healthCheckCallbackDispatcher();
}

