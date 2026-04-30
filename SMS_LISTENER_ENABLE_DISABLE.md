# SMS Listener Enable/Disable Configuration

## Overview
The SMS Listener can be enabled or disabled using a hardcoded default value in the Flutter app. Users can also toggle it on/off from the Profile screen.

## Hardcoded Default Setting

### Location
File: `lib/src/services/sms_listener_service.dart`

### Configuration
```dart
// ========================================================================
// HARDCODED DEFAULT: Change this value to set default enabled/disabled
// Set to false to disable SMS listener by default
// Set to true to enable SMS listener by default
// ========================================================================
static const bool _defaultEnabled = true;
```

### How to Change

1. **To Disable SMS Listener by Default:**
   Change `_defaultEnabled` to `false`:
   ```dart
   static const bool _defaultEnabled = false;
   ```

2. **To Enable SMS Listener by Default:**
   Change `_defaultEnabled` to `true`:
   ```dart
   static const bool _defaultEnabled = true;
   ```

3. **Save the file and rebuild the app**

## User Toggle (Profile Screen)

Users can enable/disable the SMS listener from the Profile screen:

1. Navigate to **Profile** tab
2. Find **"SMS Payment Listener"** option
3. Toggle the switch ON/OFF
4. Status will be saved in SharedPreferences

### Behavior

- **When Enabled:**
  - SMS listener initializes on app startup
  - Incoming SMS are automatically processed
  - Payment commands are parsed and sent to backend API

- **When Disabled:**
  - SMS listener does NOT initialize
  - Incoming SMS are ignored
  - No background processing occurs
  - Manual SMS processing is also disabled

## Implementation Details

### Storage
The enabled/disabled status is stored in SharedPreferences with key: `sms_listener_enabled`

### Priority
1. **User Setting** (from Profile screen toggle) - highest priority
2. **Hardcoded Default** - used only if user hasn't set a preference

### Code Flow

1. App starts → `main.dart` calls `SmsListenerService.isEnabled()`
2. Checks SharedPreferences for user setting
3. If not set, uses `_defaultEnabled` hardcoded value
4. If enabled, initializes SMS listener
5. If disabled, skips initialization

### Methods Available

```dart
// Check if SMS listener is enabled
Future<bool> isEnabled()

// Enable SMS listener
Future<bool> enable()

// Disable SMS listener
Future<bool> disable()

// Set enabled status
Future<bool> setEnabled(bool enabled)
```

## Testing

### Test Disabled State
1. Set `_defaultEnabled = false` in `sms_listener_service.dart`
2. Rebuild app
3. Send test SMS
4. Verify SMS is NOT processed

### Test Enabled State
1. Set `_defaultEnabled = true` in `sms_listener_service.dart`
2. Rebuild app
3. Send test SMS with format: `PAY 1000 0765438924`
4. Verify SMS is processed (check SMS Log screen)

### Test User Toggle
1. Open app
2. Go to Profile screen
3. Toggle SMS Listener switch OFF
4. Send test SMS - should NOT be processed
5. Toggle switch ON
6. Send test SMS - should be processed

## Notes

- Changing the hardcoded default only affects NEW installations or when user clears app data
- Existing users who have already toggled the setting will keep their preference
- The setting persists across app restarts
- Disabling SMS listener does NOT delete existing SMS logs

