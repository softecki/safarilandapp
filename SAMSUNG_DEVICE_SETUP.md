# Samsung Device Setup Guide for SMS Reading

Samsung devices (especially Samsung Note 9 and newer) have additional security features that can prevent SMS reading and background processing. Follow these steps to ensure the app works correctly.

## Required Settings on Samsung Note 9

### 1. Grant SMS Permissions
1. Open **Settings** → **Apps** → **Wicom Pay**
2. Tap **Permissions**
3. Enable **SMS** permission (both **Receive SMS** and **Read SMS**)
4. If prompted, grant **Phone** permission as well

### 2. Disable Battery Optimization
**Critical for background SMS processing:**
1. Open **Settings** → **Device care** → **Battery**
2. Tap **App power management** or **Unmonitored apps**
3. Find **Wicom Pay** and add it to **Unmonitored apps**
   - OR tap **Wicom Pay** → **Optimize battery usage** → Select **All apps** → Find **Wicom Pay** → Set to **Don't optimize**

Alternative path (varies by Samsung version):
- **Settings** → **Apps** → **Wicom Pay** → **Battery** → **Optimize battery usage** → **Don't optimize**

### 3. Enable Auto-Start (Samsung-specific)
**Required for SMS receiver to work when device restarts:**
1. Open **Settings** → **Apps** → **Wicom Pay**
2. Look for **Auto-start** or **Allow background activity** option
3. Enable **Auto-start** for Wicom Pay

Alternative path:
- **Settings** → **Device care** → **Battery** → **App power management** → **Auto-start** → Enable for **Wicom Pay**

### 4. Allow Background Activity
1. Open **Settings** → **Apps** → **Wicom Pay**
2. Tap **Battery**
3. Enable **Allow background activity** or **Background activity**

### 5. Disable Do Not Disturb for App (Optional)
If notifications are not showing:
1. Open **Settings** → **Notifications** → **App notifications**
2. Find **Wicom Pay**
3. Ensure notifications are enabled
4. Check **Do Not Disturb** settings and allow Wicom Pay

### 6. Set as Default SMS App (If Required)
Some Samsung devices require this:
1. Open **Settings** → **Apps** → **Default apps**
2. Check if **SMS** requires a default app
3. If needed, temporarily set Wicom Pay as default (if supported), then change back

### 7. Disable Samsung's App Optimization
1. Open **Settings** → **Device care** → **Battery** → **App power management**
2. Find **Wicom Pay** and ensure it's **Not optimized** or **Unmonitored**

### 8. Check Notification Settings
1. Open **Settings** → **Apps** → **Wicom Pay** → **Notifications**
2. Ensure **All Wicom Pay notifications** are enabled
3. Check that **SMS Payment Processing** channel is enabled

## Verification Steps

After applying all settings:

1. **Test SMS Reception:**
   - Send a test SMS with format: `LIPA*1000*VODACOM*0765438924`
   - Check app logs or notification to confirm SMS was received

2. **Test Background Processing:**
   - Close the app completely
   - Send an SMS
   - Wait 30 seconds
   - Check if SMS was processed (check API logs or app when reopened)

3. **Check Service Status:**
   - Open **Settings** → **Apps** → **Wicom Pay** → **App info**
   - Look for **SMS Payment Processing** notification (should be visible)
   - If notification is missing, the foreground service may not be running

## Troubleshooting

### SMS Not Being Received
- **Check permissions:** Ensure SMS permissions are granted
- **Check receiver priority:** The app uses priority 1000 (highest) - ensure no other app has higher priority
- **Restart device:** Sometimes required after permission changes
- **Reinstall app:** If issues persist, uninstall and reinstall

### Background Processing Not Working
- **Check battery optimization:** Most common issue - ensure app is not optimized
- **Check auto-start:** Enable auto-start for the app
- **Check foreground service:** Look for persistent notification "SMS Payment Processing"
- **Check logs:** Use `adb logcat` to see if SMS receiver is being triggered

### Notifications Not Showing
- **Check notification permissions:** Android 13+ requires explicit notification permission
- **Check Do Not Disturb:** Ensure app is allowed in DND settings
- **Check notification channel:** Ensure "SMS Payment Processing" channel is enabled

## Samsung-Specific Features

Samsung devices have additional security layers:
- **Samsung Knox:** May block background services - ensure app is trusted
- **Samsung Game Booster:** May optimize app - disable optimization for Wicom Pay
- **Samsung Secure Folder:** If app is in secure folder, SMS receiver may not work

## Additional Notes

- The app uses a **Foreground Service** with a persistent notification to ensure background processing
- The **SMS Receiver** has the highest priority (1000) to ensure SMS is received before other apps
- The service runs continuously and checks for pending SMS every 30 seconds
- SMS are stored in SharedPreferences and processed even when the app is closed

## Support

If issues persist after following all steps:
1. Check device logs: `adb logcat | grep -i "SmsReceiver\|SmsProcessingService"`
2. Verify permissions: `adb shell dumpsys package com.softecki.wicom | grep -i permission`
3. Check service status: `adb shell dumpsys activity services com.softecki.wicom`

