/// Stub file for SQLite on web platform
/// This file provides dummy classes to prevent compilation errors on web

// Stub classes for sqflite types
class Database {
  Future<void> execute(String sql, [List<dynamic>? arguments]) async {
    throw UnsupportedError('SQLite is not supported on web');
  }

  Future<List<Map<String, dynamic>>> query(
    String table, {
    bool? distinct,
    List<String>? columns,
    String? where,
    List<dynamic>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    throw UnsupportedError('SQLite is not supported on web');
  }

  Future<int> insert(
    String table,
    Map<String, dynamic> values, {
    String? nullColumnHack,
    ConflictAlgorithm? conflictAlgorithm,
  }) async {
    throw UnsupportedError('SQLite is not supported on web');
  }

  Future<int> update(
    String table,
    Map<String, dynamic> values, {
    String? where,
    List<dynamic>? whereArgs,
    ConflictAlgorithm? conflictAlgorithm,
  }) async {
    throw UnsupportedError('SQLite is not supported on web');
  }

  Future<int> delete(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    throw UnsupportedError('SQLite is not supported on web');
  }

  Future<List<Map<String, dynamic>>> rawQuery(
    String sql, [
    List<dynamic>? arguments,
  ]) async {
    throw UnsupportedError('SQLite is not supported on web');
  }

  Future<int> rawInsert(String sql, [List<dynamic>? arguments]) async {
    throw UnsupportedError('SQLite is not supported on web');
  }

  Future<int> rawUpdate(String sql, [List<dynamic>? arguments]) async {
    throw UnsupportedError('SQLite is not supported on web');
  }

  Future<int> rawDelete(String sql, [List<dynamic>? arguments]) async {
    throw UnsupportedError('SQLite is not supported on web');
  }
}

enum ConflictAlgorithm {
  rollback,
  abort,
  fail,
  ignore,
  replace,
}

Future<Database> openDatabase(
  String path, {
  int? version,
  OnDatabaseConfigureFn? onConfigure,
  OnDatabaseCreateFn? onCreate,
  OnDatabaseVersionChangeFn? onUpgrade,
  OnDatabaseVersionChangeFn? onDowngrade,
  OnDatabaseOpenFn? onOpen,
  bool readOnly = false,
  bool singleInstance = true,
}) async {
  throw UnsupportedError('SQLite is not supported on web');
}

Future<String> getDatabasesPath() async {
  throw UnsupportedError('SQLite is not supported on web');
}

typedef OnDatabaseConfigureFn = Future<void> Function(Database db);
typedef OnDatabaseCreateFn = Future<void> Function(Database db, int version);
typedef OnDatabaseVersionChangeFn = Future<void> Function(
    Database db, int oldVersion, int newVersion);
typedef OnDatabaseOpenFn = Future<void> Function(Database db);
