import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/app_data.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // Use centralized URL from AppData
  String get baseUrl => AppData.url;

  // Get auth token from SharedPreferences
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Get user phone from SharedPreferences
  Future<String?> _getPhone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('code_number');
  }

  // Common headers
  Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ============= PROFILE APIs =============
  
  /// Get user profile
  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final phone = await _getPhone();
      final headers = await _getHeaders();
      
      final response = await http.post(
        Uri.parse('$baseUrl/profile'),
        headers: headers,
        body: jsonEncode({'phone': phone}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load profile: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching profile: $e');
    }
  }

  /// Update user profile
  Future<Map<String, dynamic>> updateUserProfile(Map<String, dynamic> data) async {
    try {
      final phone = await _getPhone();
      final headers = await _getHeaders();
      
      final response = await http.post(
        Uri.parse('$baseUrl/profile/update'),
        headers: headers,
        body: jsonEncode({...data, 'phone': phone}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to update profile: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating profile: $e');
    }
  }

  // ============= SUPPORT APIs =============
  
  /// Submit support query
  Future<Map<String, dynamic>> submitSupportQuery({
    required String name,
    required String email,
    required String queryType,
    required String query,
  }) async {
    try {
      final phone = await _getPhone();
      final headers = await _getHeaders();
      
      final response = await http.post(
        Uri.parse('$baseUrl/support/query'),
        headers: headers,
        body: jsonEncode({
          'name': name,
          'email': email,
          'query_type': queryType,
          'query': query,
          'phone': phone,
        }),
      );
      print(response.body);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to submit query: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error submitting query: $e');
    }
  }


  // ============= CLIENT APIs =============
  
  /// Register new client
  Future<Map<String, dynamic>> registerClient({
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    required String gender,
    required String dateOfBirth,
    required String idNumber,
    required String address,
    required String loanAmount,
    required String loanPurpose,
    String? idFrontImage,
    String? idBackImage,
    String? clientPhoto,
  }) async {
    try {
      final agentPhone = await _getPhone();
      final headers = await _getHeaders();
      
      final response = await http.post(
        Uri.parse('$baseUrl/client/register'),
        headers: headers,
        body: jsonEncode({
          'agent_phone': agentPhone,
          'first_name': firstName,
          'last_name': lastName,
          'phone': phone,
          'email': email,
          'gender': gender,
          'date_of_birth': dateOfBirth,
          'id_number': idNumber,
          'address': address,
          'loan_amount': loanAmount,
          'loan_purpose': loanPurpose,
          // 'id_front_image': idFrontImage,
          // 'id_back_image': idBackImage,
          // 'client_photo': clientPhoto,
        }),
      );
      print(response.body);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to register client: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error registering client: $e');
    }
  }

  /// Get client list
  Future<List<Map<String, dynamic>>> getClientList() async {
    try {
      final phone = await _getPhone();
      final headers = await _getHeaders();
      
      final response = await http.post(
        Uri.parse('$baseUrl/client/list'),
        headers: headers,
        body: jsonEncode({'agent_phone': phone}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['data'] ?? []);
      } else {
        throw Exception('Failed to load clients: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching clients: $e');
    }
  }

  // ============= COMMISSION APIs =============
  
  /// Get commissions
  Future<Map<String, dynamic>> getCommissions() async {
    try {
      final phone = await _getPhone();
      final headers = await _getHeaders();
      
      final response = await http.post(
        Uri.parse('$baseUrl/commission/list'),
        headers: headers,
        body: jsonEncode({'agent_phone': phone}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load commissions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching commissions: $e');
    }
  }

  /// Request commission withdrawal
  Future<Map<String, dynamic>> requestWithdrawal({
    required double amount,
    required String method,
    String? accountDetails,
  }) async {
    try {
      final phone = await _getPhone();
      final headers = await _getHeaders();
      
      final response = await http.post(
        Uri.parse('$baseUrl/commission/withdraw'),
        headers: headers,
        body: jsonEncode({
          'agent_phone': phone,
          'amount': amount,
          'method': method,
          'account_details': accountDetails,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to request withdrawal: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error requesting withdrawal: $e');
    }
  }

  // ============= TRANSACTION APIs =============
  
  /// Get transaction history
  Future<List<Map<String, dynamic>>> getTransactionHistory() async {
    try {
      final phone = await _getPhone();
      final headers = await _getHeaders();
      
      final response = await http.post(
        Uri.parse('$baseUrl/transactions'),
        headers: headers,
        body: jsonEncode({'phone': phone}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['data'] ?? []);
      } else {
        throw Exception('Failed to load transactions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching transactions: $e');
    }
  }

  // ============= DASHBOARD APIs =============
  
  /// Get dashboard data
  Future<Map<String, dynamic>> getDashboardData() async {
    try {
      final phone = await _getPhone();
      final headers = await _getHeaders();
      
      final response = await http.post(
        Uri.parse('$baseUrl/dashboard'),
        headers: headers,
        body: jsonEncode({'phone': phone}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load dashboard: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching dashboard: $e');
    }
  }

  // ============= LOAN APIs =============
  
  /// Get loan details
  Future<Map<String, dynamic>> getLoanDetails() async {
    try {
      final phone = await _getPhone();
      final headers = await _getHeaders();
      
      final response = await http.post(
        Uri.parse('$baseUrl/loan/details'),
        headers: headers,
        body: jsonEncode({'phone': phone}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load loan details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching loan details: $e');
    }
  }

  // ============= SUPPORT APIs =============
  
  /// Get user's support tickets
  Future<Map<String, dynamic>> getSupportTickets() async {
    try {
      final phone = await _getPhone();
      final headers = await _getHeaders();
      
      final response = await http.post(
        Uri.parse('$baseUrl/support/tickets'),
        headers: headers,
        body: jsonEncode({'phone': phone}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load support tickets: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching support tickets: $e');
    }
  }

}
