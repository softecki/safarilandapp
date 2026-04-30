import 'package:drift/drift.dart';
import 'package:drift/web.dart';

/// Web-specific database connection using IndexedDB (same as betap)
QueryExecutor createPlatformConnection() {
  return WebDatabase('wicom_db');
}
