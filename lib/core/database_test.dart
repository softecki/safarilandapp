import 'package:flutter/foundation.dart';
import '../src/data/database_helper.dart';
import '../src/data/drift_web_database_helper.dart';

/// Test class to verify database operations
class DatabaseTest {
  static Future<void> testDatabaseOperations() async {
    print('=== DATABASE TEST STARTED ===');
    print('Platform: ${kIsWeb ? 'Web' : 'Mobile'}');
    
    try {
      if (kIsWeb) {
        await _testDriftDatabase();
      } else {
        await _testSQLiteDatabase();
      }
      print('=== DATABASE TEST COMPLETED SUCCESSFULLY ===');
    } catch (e) {
      print('=== DATABASE TEST FAILED: $e ===');
    }
  }
  
  static Future<void> _testDriftDatabase() async {
    print('Testing Drift Web Database...');
    
    try {
      final driftHelper = DriftWebDatabaseHelper();
      
      // Test customer data
      final testCustomer = {
        'display_name': 'Test User',
        'external_id': '12345',
        'mobile_no': '1234567890',
      };
      
      print('Saving test customer to Drift...');
      await driftHelper.saveCustomer(testCustomer);
      print('Customer saved successfully to Drift');
      
      // Test getting customers
      final customers = await driftHelper.getAllCustomers();
      print('Retrieved ${customers.length} customers from Drift');
      
    } catch (e) {
      print('Drift database test failed: $e');
      rethrow;
    }
  }
  
  static Future<void> _testSQLiteDatabase() async {
    print('Testing SQLite Database...');
    
    try {
      // Test customer data
      final testCustomer = {
        'display_name': 'Test User',
        'external_id': '12345',
        'mobile_no': '1234567890',
      };
      
      print('Saving test customer to SQLite...');
      await DatabaseHelper.instance.insertCustomer(testCustomer);
      print('Customer saved successfully to SQLite');
      
      // Test getting customers
      final customers = await DatabaseHelper.instance.getCustomer();
      print('Retrieved ${customers.length} customers from SQLite');
      
    } catch (e) {
      print('SQLite database test failed: $e');
      rethrow;
    }
  }
}
