# Database Migration Guide - Platform-Aware Implementation

## Overview
The wicomPaymentApp has been redesigned to support both web (PWA) and mobile platforms with platform-specific database implementations:
- **Web Platform**: Uses Drift database (IndexedDB-backed)
- **Mobile Platforms**: Uses SQLite database

## Key Changes

### 1. Dependencies Added
```yaml
dependencies:
  drift: ^2.16.0
  sqlite3_flutter_libs: ^0.5.0
  path_provider: ^2.1.0
  flutter_web_plugins:
    sdk: flutter

dev_dependencies:
  drift_dev: ^2.16.0
  build_runner: ^2.4.0
```

### 2. New Architecture

#### Database Interface (`database_interface.dart`)
- Abstract interface for database operations
- Common API for both SQLite and Drift implementations
- Platform detection utilities

#### Platform-Specific Implementations
- **SQLite Implementation** (`sqlite_database.dart`): For mobile platforms (Android, iOS)
- **Drift Implementation** (`drift_database_impl.dart`): For web platform

#### Database Factory (`database_factory.dart`)
- Automatically selects the correct database implementation based on platform
- Uses `kIsWeb` to detect platform at runtime

#### Drift Schema (`drift_database.dart`)
- Complete database schema defined using Drift's type-safe API
- All 23 tables migrated from SQLite schema
- Automatic code generation via build_runner

### 3. Updated DatabaseHelper
The `DatabaseHelper` class now:
- Uses the platform-aware database factory
- Maintains the same API for backward compatibility
- Automatically switches between SQLite and Drift based on platform
- All existing methods work without changes to calling code

### 4. PWA Enhancements

#### manifest.json Updates
- Updated app name and description
- Added categories for app store classification
- Improved orientation settings
- Added scope for better PWA behavior

#### index.html Updates
- Added viewport meta tag for responsive design
- Enhanced PWA meta tags for better mobile experience
- Updated app title and description

## Usage

### Platform Detection
```dart
// Check current platform
if (DatabaseHelper.instance.isWeb) {
  // Running on web
} else if (DatabaseHelper.instance.isMobile) {
  // Running on mobile
}
```

### Database Operations
All database operations remain the same:
```dart
// Insert data
await DatabaseHelper.instance.insertUser(userData);

// Query data
final users = await DatabaseHelper.instance.getUsers();

// Update data
await DatabaseHelper.instance.updateUserStatus(userId);

// Delete data
await DatabaseHelper.instance.logOutUser();
```

## Building the App

### For Mobile (Android/iOS)
```bash
flutter build apk
# or
flutter build ios
```

### For Web (PWA)
```bash
flutter build web --release
```

### Generate Drift Code (After Schema Changes)
```bash
dart run build_runner build --delete-conflicting-outputs
```

## Database Schema
All 23 tables have been migrated:
1. users
2. app_transaction
3. balance
4. customer
5. loan
6. mechant_charge_configurations
7. account_setup
8. students
9. fees_assignments
10. fees_assign_children
11. exam_types
12. classes
13. transactions
14. bank_accounts
15. subject_assign_childrens
16. subject_assigns
17. user_credentials
18. staff
19. marks_grade
20. parent_details
21. notice_boards
22. students_list
23. status

## Testing

### Test on Web
```bash
flutter run -d chrome
```

### Test on Mobile
```bash
flutter run -d <device_id>
```

## Important Notes

1. **Data Persistence**: 
   - Web: Data is stored in browser's IndexedDB
   - Mobile: Data is stored in SQLite database file

2. **Data Migration**: 
   - Existing mobile app data will continue to work
   - Web version starts with a fresh database

3. **Performance**: 
   - Both implementations are optimized for their respective platforms
   - Web uses IndexedDB which is asynchronous and non-blocking

4. **Offline Support**: 
   - Both platforms support full offline functionality
   - PWA can be installed and used without internet connection

## Troubleshooting

### Build Runner Issues
If you encounter issues with code generation:
```bash
flutter clean
flutter pub get
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

### Web Database Issues
Clear browser cache and IndexedDB:
- Chrome: DevTools > Application > Storage > Clear site data

### Mobile Database Issues
Uninstall and reinstall the app to reset the database.

## Future Enhancements
- Add database migration scripts for schema updates
- Implement data sync between web and mobile
- Add database backup/restore functionality
- Implement encrypted database support
