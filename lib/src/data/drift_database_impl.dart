import 'package:drift/drift.dart';
import 'drift_database.dart';
import 'database_interface.dart' as db_interface;

/// Drift implementation for web platform
class DriftDatabaseImpl implements db_interface.DatabaseInterface {
  static AppDatabase? _database;

  AppDatabase get database {
    _database ??= AppDatabase();
    return _database!;
  }

  @override
  Future<void> initialize() async {
    // Drift database is initialized in the constructor
    _database ??= AppDatabase();
  }

  @override
  Future<List<Map<String, dynamic>>> query(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    await initialize();
    
    // Build a custom query based on table name
    final query = 'SELECT * FROM $table${where != null ? ' WHERE $where' : ''}';
    final result = await database.customSelect(
      query,
      variables: whereArgs?.map((e) => Variable(e)).toList() ?? [],
      readsFrom: {},
    ).get();
    
    return result.map((row) => row.data).toList();
  }

  @override
  Future<int> insert(
    String table,
    Map<String, dynamic> data, {
    db_interface.ConflictAlgorithm? conflictAlgorithm,
  }) async {
    await initialize();
    
    final columns = data.keys.join(', ');
    final placeholders = List.generate(data.length, (i) => '?').join(', ');
    final query = 'INSERT ${_getInsertMode(conflictAlgorithm)} INTO $table ($columns) VALUES ($placeholders)';
    
    return await database.customInsert(
      query,
      variables: data.values.map((e) => Variable(e)).toList(),
    );
  }

  @override
  Future<int> update(
    String table,
    Map<String, dynamic> data, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    await initialize();
    
    final setClauses = data.keys.map((key) => '$key = ?').join(', ');
    final query = 'UPDATE $table SET $setClauses${where != null ? ' WHERE $where' : ''}';
    
    final allArgs = [...data.values, ...?whereArgs];
    
    return await database.customUpdate(
      query,
      variables: allArgs.map((e) => Variable(e)).toList(),
      updates: {},
    );
  }

  @override
  Future<int> delete(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    await initialize();
    
    final query = 'DELETE FROM $table${where != null ? ' WHERE $where' : ''}';
    
    return await database.customUpdate(
      query,
      variables: whereArgs?.map((e) => Variable(e)).toList() ?? [],
      updates: {},
    );
  }

  @override
  Future<List<Map<String, dynamic>>> rawQuery(String sql, [List<dynamic>? arguments]) async {
    await initialize();
    
    final result = await database.customSelect(
      sql,
      variables: arguments?.map((e) => Variable(e)).toList() ?? [],
      readsFrom: {},
    ).get();
    
    return result.map((row) => row.data).toList();
  }

  @override
  Future<int> rawInsert(String sql, [List<dynamic>? arguments]) async {
    await initialize();
    
    return await database.customInsert(
      sql,
      variables: arguments?.map((e) => Variable(e)).toList() ?? [],
    );
  }

  @override
  Future<int> rawUpdate(String sql, [List<dynamic>? arguments]) async {
    await initialize();
    
    return await database.customUpdate(
      sql,
      variables: arguments?.map((e) => Variable(e)).toList() ?? [],
      updates: {},
    );
  }

  @override
  Future<int> rawDelete(String sql, [List<dynamic>? arguments]) async {
    await initialize();
    
    return await database.customUpdate(
      sql,
      variables: arguments?.map((e) => Variable(e)).toList() ?? [],
      updates: {},
    );
  }

  @override
  Future<void> execute(String sql, [List<dynamic>? arguments]) async {
    await initialize();
    
    await database.customStatement(sql);
  }

  String _getInsertMode(db_interface.ConflictAlgorithm? algorithm) {
    if (algorithm == null || algorithm == db_interface.ConflictAlgorithm.abort) {
      return '';
    }
    
    switch (algorithm) {
      case db_interface.ConflictAlgorithm.replace:
        return 'OR REPLACE';
      case db_interface.ConflictAlgorithm.ignore:
        return 'OR IGNORE';
      case db_interface.ConflictAlgorithm.rollback:
        return 'OR ROLLBACK';
      case db_interface.ConflictAlgorithm.fail:
        return 'OR FAIL';
      default:
        return '';
    }
  }
}
