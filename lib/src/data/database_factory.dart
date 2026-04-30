import 'package:flutter/foundation.dart' show kIsWeb;
import 'database_interface.dart';
import 'sqlite_database.dart';
import 'drift_database_impl.dart';

/// Factory class to create the appropriate database implementation
/// based on the current platform
class DatabaseFactory {
  static DatabaseInterface? _instance;

  /// Get the singleton database instance
  /// Returns DriftDatabaseImpl for web, SQLiteDatabase for mobile
  static DatabaseInterface get instance {
    if (_instance == null) {
      if (kIsWeb) {
        _instance = DriftDatabaseImpl();
      } else {
        _instance = SQLiteDatabase();
      }
    }
    return _instance!;
  }

  /// Check if running on web platform
  static bool get isWeb => kIsWeb;

  /// Check if running on mobile platform
  static bool get isMobile => !kIsWeb;

  /// Reset the instance (useful for testing)
  static void reset() {
    _instance = null;
  }
}
