# Log Lines Reference (Lines 913-946)

## 📍 Where These Logs Come From

Based on the terminal output you selected, here's where each log line originates:

### Lines 913-916: SMS Received & Stored
**File**: `android/app/src/main/java/com/softecki/wicom/SmsReceiver.java`

```java
// Line 53
Log.d(TAG, "SMS received from: " + sender + ", body: " + messageBody);

// Line 112
Log.d(TAG, "Stored SMS for processing. Pending count: " + pendingSms.size() + ", committed: " + committed);

// Line 116
Log.d(TAG, "Verified saved count: " + verifyCount);

// Line 63
Log.d(TAG, "Sent broadcast for SMS received notification");
```

**Location in Code**:
- **Line 913**: `SmsReceiver.java` line 53 - SMS received log
- **Line 914**: `SmsReceiver.java` line 112 - Stored SMS log
- **Line 915**: `SmsReceiver.java` line 116 - Verified count log
- **Line 916**: `SmsReceiver.java` line 63 - Broadcast sent log

---

### Line 917: Broadcast Received
**File**: `android/app/src/main/java/com/softecki/wicom/MainActivity.java`

```java
// Line 172
Log.d(TAG, "SMS received broadcast received, notifying Flutter");
```

**Location in Code**:
- **Line 917**: `MainActivity.java` line 172 - Broadcast receiver log

---

### Line 918: Health Check Error
**File**: Flutter Dart code (likely `lib/src/services/health_check_service.dart`)

```dart
// Error sending health check to backend: TimeoutException
```

**Location in Code**:
- **Line 918**: Flutter health check service - Timeout error

---

### Lines 919-922: SMS Processing from Native Service
**File**: `android/app/src/main/java/com/softecki/wicom/SmsProcessingService.java`

```java
// Line 170
Log.d(TAG, "Found " + count + " pending SMS, app inactive, processing from native service...");

// Line 207
Log.d(TAG, "Flutter not available, processing SMS directly from native");

// Line 221 (approximate)
Log.d(TAG, "Marked SMS as processed: " + smsKey);

// Line 256
Log.d(TAG, "Processing SMS " + (i + 1) + "/" + smsList.size() + " from: " + sender + ", key: " + smsKey);
```

**Location in Code**:
- **Line 919**: `SmsProcessingService.java` line 170 - Found pending SMS
- **Line 920**: `SmsProcessingService.java` line 207 - Flutter not available
- **Line 921**: `SmsProcessingService.java` line ~221 - Marked as processed
- **Line 922**: `SmsProcessingService.java` line 256 - Processing SMS

---

### Lines 923-933: Network Timeout Errors
**File**: `android/app/src/main/java/com/softecki/wicom/SmsProcessingService.java`

```java
// Line 480
Log.e(TAG, "Error sending to API", e);
// Where e is: java.net.SocketTimeoutException: timeout
```

**Location in Code**:
- **Lines 923-928**: System/OkHttp logs (internal Android/OkHttp library)
- **Lines 929-930**: OkHttp request logs
- **Lines 931-933**: `SmsProcessingService.java` line 480 - Error sending to API

---

## 🔍 Code Locations Summary

| Log Line | File | Line Number | Description |
|----------|------|-------------|-------------|
| 913 | `SmsReceiver.java` | 53 | SMS received log |
| 914 | `SmsReceiver.java` | 112 | Stored SMS log |
| 915 | `SmsReceiver.java` | 116 | Verified count log |
| 916 | `SmsReceiver.java` | 63 | Broadcast sent log |
| 917 | `MainActivity.java` | 172 | Broadcast received log |
| 918 | `health_check_service.dart` | ~ | Health check timeout |
| 919 | `SmsProcessingService.java` | 170 | Found pending SMS |
| 920 | `SmsProcessingService.java` | 207 | Flutter not available |
| 921 | `SmsProcessingService.java` | ~221 | Marked as processed |
| 922 | `SmsProcessingService.java` | 256 | Processing SMS |
| 923-928 | System/OkHttp | - | Internal library logs |
| 929-930 | OkHttp | - | Request logs |
| 931-933 | `SmsProcessingService.java` | 480 | API error |

---

## 🐛 Issue Identified

**Problem**: `SocketTimeoutException: timeout` when sending SMS to API

**Location**: `SmsProcessingService.java` around line 480

**Cause**: The native service is trying to send SMS data to your Laravel backend API, but the request is timing out (likely after 10 seconds based on the health check timeout).

**Solution**: 
1. Check API endpoint URL in `SmsProcessingService.java`
2. Increase timeout value in OkHttp client configuration
3. Check network connectivity
4. Verify API server is accessible

---

## 📝 Quick Reference

To find these logs in your codebase:

1. **SMS Receiving**: `android/app/src/main/java/com/softecki/wicom/SmsReceiver.java`
2. **SMS Processing**: `android/app/src/main/java/com/softecki/wicom/SmsProcessingService.java`
3. **MainActivity Broadcast**: `android/app/src/main/java/com/softecki/wicom/MainActivity.java`
4. **Health Check**: `lib/src/services/health_check_service.dart`

