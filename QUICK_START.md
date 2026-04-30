# Quick Start Guide - Platform-Aware Database

## 🚀 Quick Commands

### Run on Web (PWA)
```bash
flutter run -d chrome
```

### Run on Mobile
```bash
flutter run
```

### Build for Web
```bash
flutter build web --release
```

### Build for Android
```bash
flutter build apk --release
```

### Regenerate Database Code (if schema changes)
```bash
dart run build_runner build --delete-conflicting-outputs
```

## 🔧 How It Works

The app automatically detects the platform and uses:
- **Web**: Drift database (IndexedDB)
- **Mobile**: SQLite database

No code changes needed - it just works! ✨

## 📱 Platform Detection in Code

```dart
import 'package:wicom/src/data/database_helper.dart';

// Check platform
if (DatabaseHelper.instance.isWeb) {
  print('Running on web');
} else {
  print('Running on mobile');
}
```

## 💾 Database Usage (Same as Before)

```dart
// All existing code works without changes!

// Insert
await DatabaseHelper.instance.insertUser(userData);

// Query
final users = await DatabaseHelper.instance.getUsers();

// Update
await DatabaseHelper.instance.updateUserStatus(userId);

// Delete
await DatabaseHelper.instance.logOutUser();
```

## 🐛 Troubleshooting

### Build errors?
```bash
flutter clean
flutter pub get
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

### Web database not working?
- Clear browser cache
- Clear IndexedDB in DevTools

### Mobile database not working?
- Uninstall and reinstall app

## 📚 More Info

- See `IMPLEMENTATION_SUMMARY.md` for complete details
- See `DATABASE_MIGRATION_GUIDE.md` for architecture info

## ✅ What's New

- ✅ Web support (PWA)
- ✅ Automatic platform detection
- ✅ Same API, works everywhere
- ✅ Offline support on all platforms
- ✅ Enhanced PWA features

**That's it! Your app now runs on web and mobile! 🎉**
