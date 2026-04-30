import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/app_data.dart';
import 'sms_parser_service.dart';

/// API Service for sending parsed SMS data to backend
class SmsApiService {
  // API endpoint - can be configured
  static String get apiEndpoint => '${AppData.url}/sms-payment/trigger';
  
  // API key header name - configure as needed
  static const String apiKeyHeader = 'X-API-Key';
  
  // API key value - should be stored securely (SharedPreferences or secure storage)
  // For now, this should be set from the app configuration
  static String? _apiKey;

  /// Set API key for authentication
  static void setApiKey(String? key) {
    _apiKey = key;
  }

  /// Send parsed SMS data to backend API
  /// Returns ApiResponse with success status and response data
  static Future<ApiResponse> sendPaymentTrigger(ParsedSmsResult parsedSms) async {
    try {
      final uri = Uri.parse(apiEndpoint);
      
      // Prepare headers
      final headers = <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      // Add API key if available
      if (_apiKey != null && _apiKey!.isNotEmpty) {
        headers[apiKeyHeader] = _apiKey!;
      }

      // Prepare payload
      final payload = parsedSms.toJson();

      // Make POST request
      final response = await http
          .post(
            uri,
            headers: headers,
            body: jsonEncode(payload),
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              throw Exception('Request timeout');
            },
          );

      // Parse response
      final responseBody = response.body.isNotEmpty
          ? jsonDecode(response.body)
          : <String, dynamic>{};

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiResponse(
          success: true,
          statusCode: response.statusCode,
          data: responseBody,
          message: 'Payment trigger sent successfully',
        );
      } else {
        return ApiResponse(
          success: false,
          statusCode: response.statusCode,
          data: responseBody,
          message: responseBody['message'] ?? 'Failed to send payment trigger',
        );
      }
    } catch (e) {
      return ApiResponse(
        success: false,
        statusCode: 0,
        error: e.toString(),
        message: 'Error sending payment trigger: $e',
      );
    }
  }

  /// Check if network is available (basic check)
  static Future<bool> isNetworkAvailable() async {
    try {
      final response = await http
          .get(Uri.parse('https://www.google.com'))
          .timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}

/// API Response model
class ApiResponse {
  final bool success;
  final int statusCode;
  final Map<String, dynamic>? data;
  final String? error;
  final String message;

  ApiResponse({
    required this.success,
    required this.statusCode,
    this.data,
    this.error,
    required this.message,
  });

  @override
  String toString() {
    return 'ApiResponse(success: $success, statusCode: $statusCode, message: $message)';
  }
}

