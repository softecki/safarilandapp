# Web Build Fix - SQLite Exclusion

## Problem
The initial web build failed because SQLite packages (which use FFI - Foreign Function Interface) were being included in the web build. FFI is not supported in web browsers, causing compilation errors.

## Solution
Implemented conditional imports to exclude platform-specific code from web builds.

### Changes Made

#### 1. Created Platform-Specific Connection Files

**`drift_database_connection.dart`** - Main entry point
- Uses conditional imports to select the correct implementation
- Exports a single `createDriftConnection()` function

**`drift_database_connection_web.dart`** - Web implementation
- Uses Drift's `WebDatabase` (IndexedDB)
- Only imported when building for web

**`drift_database_connection_mobile.dart`** - Mobile implementation
- Uses Drift's `NativeDatabase` (SQLite)
- Only imported when building for mobile
- Includes all native dependencies (dart:io, path_provider, etc.)

#### 2. Updated drift_database.dart
```dart
// Before:
import 'dart:io';
import 'package:drift/native.dart';
import 'package:drift/web.dart';
import 'package:path_provider/path_provider.dart';

// After:
import 'package:drift/drift.dart';
import 'drift_database_connection.dart';
```

#### 3. Simplified AppDatabase
```dart
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(createDriftConnection());
  
  @override
  int get schemaVersion => 1;
}
```

### How Conditional Imports Work

Dart's conditional imports allow different files to be imported based on the platform:

```dart
import 'drift_database_connection_mobile.dart'
    if (dart.library.html) 'drift_database_connection_web.dart';
```

- **Mobile build**: Imports `drift_database_connection_mobile.dart`
- **Web build**: Imports `drift_database_connection_web.dart`
- The `dart.library.html` check detects if we're building for web

### Files Created

1. `lib/src/data/drift_database_connection.dart` - Platform-agnostic interface
2. `lib/src/data/drift_database_connection_web.dart` - Web-specific implementation
3. `lib/src/data/drift_database_connection_mobile.dart` - Mobile-specific implementation
4. `lib/src/data/sqlite_stub.dart` - Stub for SQLite types (backup solution)
5. `lib/src/data/path_provider_stub.dart` - Stub for path_provider (backup solution)

### Benefits

1. **Clean Separation**: Platform-specific code is isolated
2. **No Runtime Checks**: Platform detection happens at compile time
3. **Smaller Bundles**: Web build doesn't include mobile-only code
4. **Type Safety**: Each platform gets the correct types
5. **Maintainable**: Easy to add platform-specific features

### Testing

#### Test Web Build
```bash
flutter build web --release
```

#### Test Mobile Build
```bash
flutter build apk --release
```

#### Run on Web
```bash
flutter run -d chrome
```

#### Run on Mobile
```bash
flutter run
```

### Architecture

```
┌─────────────────────────────────────┐
│      drift_database_connection      │
│    (Conditional Import Switch)      │
└──────────┬──────────────────┬───────┘
           │                  │
           ▼                  ▼
┌──────────────────┐  ┌──────────────────┐
│  connection_web  │  │ connection_mobile│
│   (IndexedDB)    │  │    (SQLite)      │
└──────────────────┘  └──────────────────┘
```

### Notes

- SQLite packages (`sqflite`, `sqlite3_flutter_libs`) remain in dependencies
- They are only compiled for mobile builds
- Web builds use Drift's built-in IndexedDB support
- No changes needed to existing database operations

### Verification

After build completes successfully:
1. Check `build/web` folder exists
2. Verify no SQLite-related errors in console
3. Test database operations in browser DevTools
4. Confirm IndexedDB is being used (check Application tab in DevTools)

## Status

✅ Conditional imports implemented
✅ Platform-specific connections created  
✅ Build runner regenerated code
⏳ Web build in progress

The web build should now complete successfully without SQLite-related errors!
