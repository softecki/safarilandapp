import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:drift/drift.dart';
import '../data/drift_database.dart';
import '../data/sqlite_database.dart';

/// Database service for managing processed SMS records
/// 
/// Platform-aware implementation:
/// - Web: Uses Drift with WebDatabase (IndexedDB)
/// - Mobile: Uses SQLite directly (sqflite) - NOT Drift
class SmsDatabaseService {
  // Web implementation uses Drift
  AppDatabase? _driftDatabase;
  
  // Mobile implementation uses SQLite
  SQLiteDatabase? _sqliteDatabase;

  SmsDatabaseService() {
    if (kIsWeb) {
      // Web: Use Drift
      _driftDatabase = AppDatabase();
    } else {
      // Mobile: Use SQLite directly
      _sqliteDatabase = SQLiteDatabase();
    }
  }

  /// Initialize database (for SQLite)
  Future<void> _ensureInitialized() async {
    if (!kIsWeb && _sqliteDatabase != null) {
      await _sqliteDatabase!.initialize();
    }
  }

  /// Save processed SMS record to database
  Future<int> saveProcessedSms({
    required String sender,
    required String originalMessage,
    String? normalizedMessage,
    required String messageHash,
    String? command,
    int? amount,
    String? service,
    String? phone,
    required String status,
    String? errorMessage,
    int? apiStatusCode,
    required DateTime smsTimestamp,
  }) async {
    try {
      if (kIsWeb) {
        // Web: Use Drift
        // Note: After running build_runner, uncomment the service field
        final companion = ProcessedSmsCompanion(
          sender: Value(sender),
          originalMessage: Value(originalMessage),
          normalizedMessage: Value(normalizedMessage),
          messageHash: Value(messageHash),
          command: Value(command),
          amount: Value(amount),
          // service: Value(service), // TODO: Uncomment after running: flutter pub run build_runner build
          phone: Value(phone),
          status: Value(status),
          errorMessage: Value(errorMessage),
          apiStatusCode: Value(apiStatusCode),
          smsTimestamp: Value(smsTimestamp),
        );
        return await _driftDatabase!.into(_driftDatabase!.processedSms).insert(companion);
      } else {
        // Mobile: Use SQLite directly
        await _ensureInitialized();
        final now = DateTime.now().toIso8601String();
        final data = {
          'sender': sender,
          'original_message': originalMessage,
          'normalized_message': normalizedMessage,
          'message_hash': messageHash,
          'command': command,
          'amount': amount,
          'phone': phone,
          'status': status,
          'error_message': errorMessage,
          'api_status_code': apiStatusCode,
          'sms_timestamp': smsTimestamp.toIso8601String(),
          'processed_at': now,
        };
        
        // Add service if provided
        if (service != null && service.isNotEmpty) {
          data['service'] = service;
        }
        
        return await _sqliteDatabase!.insert('processed_sms', data);
      }
    } catch (e) {
      throw Exception('Error saving processed SMS: $e');
    }
  }

  /// Check if SMS hash already exists (duplicate detection)
  Future<bool> isDuplicateHash(String messageHash) async {
    try {
      if (kIsWeb) {
        // Web: Use Drift
        final query = _driftDatabase!.select(_driftDatabase!.processedSms)
          ..where((sms) => sms.messageHash.equals(messageHash));
        final existing = await query.getSingleOrNull();
        return existing != null;
      } else {
        // Mobile: Use SQLite directly
        await _ensureInitialized();
        final results = await _sqliteDatabase!.query(
          'processed_sms',
          where: 'message_hash = ?',
          whereArgs: [messageHash],
        );
        return results.isNotEmpty;
      }
    } catch (e) {
      // On error, assume not duplicate to avoid blocking processing
      return false;
    }
  }

  /// Get last N processed SMS records
  /// Note: After running build_runner, this will properly return ProcessedSm with service field
  Future<List<dynamic>> getLastProcessedSms({int limit = 50}) async {
    try {
      if (kIsWeb) {
        // Web: Use Drift
        final query = _driftDatabase!.select(_driftDatabase!.processedSms)
          ..orderBy([(sms) => OrderingTerm.desc(sms.processedAt)])
          ..limit(limit);
        return await query.get();
      } else {
        // Mobile: Use SQLite directly - return Map structure
        await _ensureInitialized();
        final results = await _sqliteDatabase!.rawQuery(
          'SELECT * FROM processed_sms ORDER BY processed_at DESC LIMIT ?',
          [limit],
        );
        // Return Map structure for mobile (will be converted to ProcessedSm-like in UI)
        return results.map((row) => _mapToProcessedSm(row)).toList();
      }
    } catch (e) {
      throw Exception('Error fetching processed SMS: $e');
    }
  }

  /// Convert SQLite row to ProcessedSm (for mobile)
  /// Note: This returns a Map for mobile since ProcessedSm is a Drift-generated class
  /// For mobile, we'll return a Map that matches the structure
  Map<String, dynamic> _mapToProcessedSm(Map<String, dynamic> row) {
    // Parse dates - handle both string and DateTime formats
    DateTime parseDate(dynamic value) {
      if (value == null) return DateTime.now();
      if (value is DateTime) return value;
      if (value is String) {
        try {
          return DateTime.parse(value);
        } catch (e) {
          return DateTime.now();
        }
      }
      return DateTime.now();
    }

    return {
      'id': row['id'] as int,
      'sender': row['sender'] as String,
      'originalMessage': row['original_message'] as String,
      'normalizedMessage': row['normalized_message'] as String?,
      'messageHash': row['message_hash'] as String,
      'command': row['command'] as String?,
      'amount': row['amount'] as int?,
      'service': row['service'] as String?,
      'phone': row['phone'] as String?,
      'status': row['status'] as String,
      'errorMessage': row['error_message'] as String?,
      'apiStatusCode': row['api_status_code'] as int?,
      'smsTimestamp': parseDate(row['sms_timestamp']),
      'processedAt': parseDate(row['processed_at']),
    };
  }

  /// Get processed SMS by ID
  Future<dynamic> getProcessedSmsById(int id) async {
    try {
      if (kIsWeb) {
        // Web: Use Drift
        final query = _driftDatabase!.select(_driftDatabase!.processedSms)
          ..where((sms) => sms.id.equals(id));
        return await query.getSingleOrNull();
      } else {
        // Mobile: Use SQLite directly
        await _ensureInitialized();
        final results = await _sqliteDatabase!.query(
          'processed_sms',
          where: 'id = ?',
          whereArgs: [id],
        );
        if (results.isEmpty) return null;
        return _mapToProcessedSm(results.first);
      }
    } catch (e) {
      throw Exception('Error fetching SMS by ID: $e');
    }
  }

  /// Update SMS record status
  Future<bool> updateSmsStatus({
    required int id,
    required String status,
    String? errorMessage,
    int? apiStatusCode,
  }) async {
    try {
      if (kIsWeb) {
        // Web: Use Drift
        final updated = await (_driftDatabase!.update(_driftDatabase!.processedSms)
          ..where((sms) => sms.id.equals(id)))
            .write(ProcessedSmsCompanion(
          status: Value(status),
          errorMessage: Value(errorMessage),
          apiStatusCode: Value(apiStatusCode),
        ));
        return updated > 0;
      } else {
        // Mobile: Use SQLite directly
        await _ensureInitialized();
        final updated = await _sqliteDatabase!.update(
          'processed_sms',
          {
            'status': status,
            'error_message': errorMessage,
            'api_status_code': apiStatusCode,
            'updated_at': DateTime.now().toIso8601String(),
          },
          where: 'id = ?',
          whereArgs: [id],
        );
        return updated > 0;
      }
    } catch (e) {
      throw Exception('Error updating SMS status: $e');
    }
  }

  /// Get statistics
  Future<Map<String, int>> getStatistics() async {
    try {
      if (kIsWeb) {
        // Web: Use Drift
        final allSms = await _driftDatabase!.select(_driftDatabase!.processedSms).get();
        
        int success = 0;
        int failed = 0;
        int pending = 0;
        
        for (var sms in allSms) {
          switch (sms.status.toUpperCase()) {
            case 'SUCCESS':
              success++;
              break;
            case 'FAILED':
              failed++;
              break;
            case 'PENDING':
              pending++;
              break;
          }
        }

        return {
          'total': allSms.length,
          'success': success,
          'failed': failed,
          'pending': pending,
        };
      } else {
        // Mobile: Use SQLite directly
        await _ensureInitialized();
        final allSms = await _sqliteDatabase!.query('processed_sms');
        
        int success = 0;
        int failed = 0;
        int pending = 0;
        
        for (var sms in allSms) {
          switch ((sms['status'] as String).toUpperCase()) {
            case 'SUCCESS':
              success++;
              break;
            case 'FAILED':
              failed++;
              break;
            case 'PENDING':
              pending++;
              break;
          }
        }

        return {
          'total': allSms.length,
          'success': success,
          'failed': failed,
          'pending': pending,
        };
      }
    } catch (e) {
      throw Exception('Error getting statistics: $e');
    }
  }

  /// Close database connection
  Future<void> close() async {
    if (kIsWeb && _driftDatabase != null) {
      await _driftDatabase!.close();
    }
    // SQLiteDatabase doesn't need explicit close
  }
}
