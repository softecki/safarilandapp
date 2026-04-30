# SMS Listener Module for Payment Trigger

## Overview
This module automatically reads incoming SMS messages, parses payment commands, and sends the parsed data to a backend API that triggers USSD payments via telecom infrastructure.

## Features Implemented

### 1. SMS Reading (Automatic)
- ✅ Android native SMS BroadcastReceiver integrated with Flutter
- ✅ Required permissions: RECEIVE_SMS, READ_SMS, INTERNET
- ✅ Runtime permission handling
- ✅ Works even when app is in background

### 2. Supported SMS Formats
The app supports multiple SMS command formats:

**New Format (Recommended):**
- `LIPA*1000*VODACOM*0765438924`
- `LIPA*1000*YAS*0765438924`
- `LIPA*1000*TIGO*0765438924`
- `LIPA*1000*AIRTEL*0765438924`
- `LIPA*1000*HALOTEL*0765438924`

**Legacy Formats (Still Supported):**
- `PAY 1000 0765438924`
- `*PAY*1000*0765438924`
- `LIPA 1000 0765438924`
- `*LIPA*1000*0765438924`

**Rules:**
- **New Format**: `LIPA*amount*SERVICE*phone`
  - Command: LIPA (required)
  - Amount: numeric only (100 - 1,000,000)
  - Service: VODACOM, YAS, TIGO, AIRTEL, or HALOTEL (required)
  - Phone: exactly 10 digits starting with 0
- **Legacy Format**: `PAY/LIPA <amount> <phone>`
  - Command keywords: PAY or LIPA
  - Amount must be numeric only (100 - 1,000,000)
  - Phone number must be exactly 10 digits starting with 0
  - Service is optional (defaults to null)
- Rejects messages where amount is written in words or phone is invalid

### 3. SMS Normalization Logic
- Converts message to uppercase
- Replaces * with spaces
- Collapses multiple spaces into single space
- After normalization, all valid messages look like: `PAY 1000 0765438924`

### 4. Parsing & Validation
- **New Format**: Uses regex: `^LIPA\*(\d+)\*(VODACOM|YAS|TIGO|AIRTEL|HALOTEL)\*(0\d{9})$`
  - Extracts: command (LIPA), amount, service, phone
  - Validates service provider (must be one of: VODACOM, YAS, TIGO, AIRTEL, HALOTEL)
- **Legacy Format**: Uses regex: `^(PAY|LIPA)\s+(\d+)\s+(0\d{9})$`
  - Extracts: command, amount, phone (service is null)
- Validates min/max amount (100 - 1,000,000) for both formats
- Rejects invalid formats

### 5. Backend API Communication
- Sends parsed data to backend PHP API using HTTP POST (JSON)
- Payload format:
```json
{
  "command": "LIPA",
  "amount": 1000,
  "phone": "0765438924",
  "sender": "<SMS_SENDER_NUMBER>",
  "timestamp": "<SMS_TIMESTAMP>"
}
```
- Uses HTTPS and supports API key header (configurable)
- Endpoint: `{AppData.url}/sms-payment/trigger`

### 6. Background Processing
- Uses WorkManager for background processing
- SMS stored in SharedPreferences when received (native side)
- Flutter processes pending SMS on app startup and can be triggered manually
- API calls queued via WorkManager
- Messages queued locally if network is unavailable

### 7. Duplicate Protection
- Generates unique hash using: `SHA-256(sender + message body + timestamp)`
- Ignores duplicate SMS processing
- Hash stored in database for duplicate detection

### 8. Logging & Monitoring
- Logs incoming SMS, parsed values, API response, and errors
- UI screen shows last 50 processed SMS with status (SUCCESS / FAILED / PENDING)
- Statistics dashboard showing total, success, failed, and pending counts

## Architecture

### File Structure
```
lib/src/
├── services/
│   ├── sms_listener_service.dart      # Main service (permissions, initialization)
│   ├── sms_parser_service.dart        # SMS parsing and validation
│   ├── sms_api_service.dart           # Backend API communication
│   ├── sms_database_service.dart      # Database operations
│   ├── sms_hash_service.dart          # Duplicate detection hashing
│   ├── sms_processing_service.dart    # Main processing logic & WorkManager
│   └── sms_pending_service.dart       # Pending SMS management
├── view/screen/
│   └── sms_log_screen.dart            # UI for viewing processed SMS
└── data/
    └── drift_database.dart            # Database schema (ProcessedSms table)

android/app/src/main/
├── AndroidManifest.xml                # Permissions & BroadcastReceiver
└── java/com/softecki/wicom/
    ├── MainActivity.java              # MethodChannel setup
    └── SmsReceiver.java               # Native SMS BroadcastReceiver
```

### Key Components

1. **SmsReceiver (Java)**: Native Android BroadcastReceiver that listens for incoming SMS and stores them in SharedPreferences
2. **SmsListenerService**: Flutter service that handles permissions and initializes the module
3. **SmsParserService**: Parses and validates SMS messages using regex
4. **SmsProcessingService**: Orchestrates the processing flow (parsing, duplicate checking, API queuing)
5. **SmsApiService**: Handles HTTP POST requests to backend API
6. **SmsDatabaseService**: Manages database operations for storing processed SMS records
7. **WorkManager**: Handles background API calls

## Setup Instructions

### 1. Install Dependencies
Dependencies are already added to `pubspec.yaml`:
- `permission_handler: ^11.3.1`
- `workmanager: ^0.5.2`
- `crypto: ^3.0.5`

Run:
```bash
flutter pub get
```

### 2. Generate Database Code
Since we added a new table (`ProcessedSms`), you need to regenerate Drift database code:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 3. Configure API Endpoint
The API endpoint is configured in `lib/src/services/sms_api_service.dart`:
- Default: `${AppData.url}/sms-payment/trigger`
- API Key can be set using `SmsApiService.setApiKey('your-api-key')`

### 4. Request Permissions
Permissions are automatically requested when `SmsListenerService.initialize()` is called (already integrated in `main.dart`).

### 5. Access SMS Log Screen
Navigate to Profile Screen → "SMS Payment Log" option to view processed SMS messages.

## Usage

### Initialization
The SMS listener is automatically initialized when the app starts (in `main.dart`).

### Manual Processing
To manually process pending SMS (useful for testing or manual triggers):
```dart
await SmsListenerService.checkPendingSms();
```

### Manual SMS Entry (for testing)
```dart
await SmsListenerService.processSmsManually(
  sender: '1234567890',
  message: 'PAY 1000 0765438924',
  timestamp: DateTime.now().millisecondsSinceEpoch,
);
```

## Database Schema

### ProcessedSms Table
- `id` (int, auto-increment, primary key)
- `sender` (text) - SMS sender number
- `originalMessage` (text) - Original SMS message
- `normalizedMessage` (text, nullable) - Normalized message
- `messageHash` (text) - SHA-256 hash for duplicate detection
- `command` (text, nullable) - PAY or LIPA
- `amount` (int, nullable) - Payment amount
- `phone` (text, nullable) - Recipient phone number
- `status` (text) - SUCCESS, FAILED, or PENDING
- `errorMessage` (text, nullable) - Error details if failed
- `apiStatusCode` (int, nullable) - HTTP status code from API
- `smsTimestamp` (datetime) - When SMS was received
- `processedAt` (datetime) - When SMS was processed

## API Integration

### Backend Endpoint
The module sends POST requests to: `{BASE_URL}/sms-payment/trigger`

### Request Headers
```
Content-Type: application/json
Accept: application/json
X-API-Key: <optional-api-key>
```

### Request Body
```json
{
  "command": "PAY",
  "amount": 1000,
  "phone": "0765438924",
  "sender": "+255123456789",
  "timestamp": 1703123456789
}
```

### Expected Response
- Status 200-299: Success
- Status 400+: Failure
- Response body is logged but not required

## Testing

### Test SMS Formats
1. Valid: `PAY 1000 0765438924`
2. Valid: `*LIPA*5000*0765438924`
3. Valid: `lipa 2000 0765438924` (case insensitive)
4. Invalid: `PAY one thousand 0765438924` (amount in words)
5. Invalid: `PAY 1000 123456789` (invalid phone format)
6. Invalid: `PAY 50 0765438924` (amount too low)
7. Invalid: `PAY 2000000 0765438924` (amount too high)

### Testing Flow
1. Send test SMS to device
2. Open app (or wait for background processing)
3. Navigate to Profile → SMS Payment Log
4. Verify SMS appears with correct status

## Troubleshooting

### SMS Not Being Processed
1. Check if SMS permissions are granted (Settings → Apps → App Permissions)
2. Verify SMS format matches supported patterns
3. Check logs for parsing errors
4. Verify network connectivity for API calls

### Database Errors
1. Run `flutter pub run build_runner build --delete-conflicting-outputs`
2. Ensure schema version is updated (currently version 4)

### API Errors
1. Verify API endpoint URL is correct
2. Check API key if required
3. Verify network connectivity
4. Check API response in SMS log screen

## Security Considerations

1. **API Key**: Should be stored securely (consider using flutter_secure_storage)
2. **SMS Content**: Sensitive data is stored in local database - consider encryption for production
3. **Permissions**: SMS permissions are sensitive - ensure proper user consent
4. **HTTPS**: Ensure API endpoint uses HTTPS in production
5. **Input Validation**: All SMS input is validated before processing

## Future Enhancements

- [ ] Add SMS filtering by sender whitelist
- [ ] Add rate limiting for API calls
- [ ] Add retry mechanism for failed API calls
- [ ] Add encryption for stored SMS data
- [ ] Add export functionality for SMS logs
- [ ] Add push notifications for successful payments
- [ ] Add iOS support (requires different approach)

## Notes

- This module is Android-only (SMS reading requires native Android implementation)
- Background processing uses WorkManager which requires device-specific configuration
- Duplicate detection uses hash-based approach - very low probability of collisions
- The module processes SMS asynchronously to avoid blocking the UI thread

