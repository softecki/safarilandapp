import 'package:flutter/foundation.dart' show kIsWeb;

/// Abstract interface for database operations
/// This allows us to have a common interface for both SQLite and Drift implementations
abstract class DatabaseInterface {
  Future<void> initialize();
  Future<List<Map<String, dynamic>>> query(String table, {String? where, List<dynamic>? whereArgs});
  Future<int> insert(String table, Map<String, dynamic> data, {ConflictAlgorithm? conflictAlgorithm});
  Future<int> update(String table, Map<String, dynamic> data, {String? where, List<dynamic>? whereArgs});
  Future<int> delete(String table, {String? where, List<dynamic>? whereArgs});
  Future<List<Map<String, dynamic>>> rawQuery(String sql, [List<dynamic>? arguments]);
  Future<int> rawInsert(String sql, [List<dynamic>? arguments]);
  Future<int> rawUpdate(String sql, [List<dynamic>? arguments]);
  Future<int> rawDelete(String sql, [List<dynamic>? arguments]);
  Future<void> execute(String sql, [List<dynamic>? arguments]);
}

enum ConflictAlgorithm {
  rollback,
  abort,
  fail,
  ignore,
  replace,
}

/// Platform detection utility
class PlatformHelper {
  static bool get isWeb => kIsWeb;
  static bool get isMobile => !kIsWeb;
}
