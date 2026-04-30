import 'package:drift/drift.dart';

// Conditional imports for platform-specific implementations
import 'drift_database_connection_mobile.dart'
    if (dart.library.html) 'drift_database_connection_web.dart';

/// Platform-agnostic database connection factory
QueryExecutor createDriftConnection() {
  return createPlatformConnection();
}
