package com.softecki.access;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Handler;
import android.os.IBinder;
import android.os.Looper;
import android.util.Log;
import org.json.JSONObject;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.security.MessageDigest;
import java.util.ArrayList;
import java.util.List;

/**
 * Foreground Service for processing SMS in the background
 * This service runs continuously and periodically checks for pending SMS
 * It processes them even when the app is closed
 */
public class SmsProcessingService extends Service {
    private static final String TAG = "SmsProcessingService";
    private static final String CHANNEL_ID = "sms_processing_channel";
    private static final int NOTIFICATION_ID = 1001;
    private static final String PREFS_NAME = "sms_receiver_prefs";
    private static final String PENDING_SMS_KEY = "pending_sms_list";
    private static final int MAX_PENDING_SMS = 100;
    private static final long CHECK_INTERVAL_MS = 30000; // Check every 30 seconds
    private static final String API_BASE_URL = "https://wicompay.softecki.com/api"; // Default API URL (from AppData.url)
    private static final String API_URL_PREF_KEY = "api_base_url"; // Key to store custom API URL in SharedPreferences
    private static final String APP_LAST_ACTIVE_KEY = "app_last_active_timestamp"; // Track when app was last active
    private static final long APP_ACTIVE_THRESHOLD_MS = 10000; // If app was active within last 10 seconds, skip native processing
    private static final String PROCESSED_SMS_KEY = "processed_sms_timestamps"; // Track processed SMS by timestamp+sender+message hash
    
    private Handler handler;
    private Runnable checkRunnable;
    private boolean isProcessing = false;

    @Override
    public void onCreate() {
        super.onCreate();
        Log.d(TAG, "SmsProcessingService created");
        
        createNotificationChannel();
        startForeground(NOTIFICATION_ID, createNotification());
        
        handler = new Handler(Looper.getMainLooper());
        checkRunnable = new Runnable() {
            @Override
            public void run() {
                if (!isProcessing) {
                    checkAndProcessPendingSms();
                }
                // Schedule next check
                handler.postDelayed(this, CHECK_INTERVAL_MS);
            }
        };
        
        // Start periodic checking
        handler.postDelayed(checkRunnable, CHECK_INTERVAL_MS);
        Log.d(TAG, "Started periodic SMS checking");
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        Log.d(TAG, "SmsProcessingService started");
        // Process immediately when service starts
        checkAndProcessPendingSms();
        // Return START_STICKY to ensure service restarts if killed
        return START_STICKY;
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        Log.d(TAG, "SmsProcessingService destroyed");
        if (handler != null && checkRunnable != null) {
            handler.removeCallbacks(checkRunnable);
        }
    }

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    private void createNotificationChannel() {
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
            // Use IMPORTANCE_LOW for minimal notification, but ensure it's not silent
            // Samsung devices may require higher importance for background services
            NotificationChannel channel = new NotificationChannel(
                CHANNEL_ID,
                "SMS Payment Processing",
                NotificationManager.IMPORTANCE_LOW
            );
            channel.setDescription("Processes SMS payment messages in the background");
            // Enable sound and vibration for Samsung devices (optional, can be removed if not needed)
            channel.setShowBadge(true);
            // Ensure channel is not blocked
            channel.setBypassDnd(false);
            NotificationManager manager = getSystemService(NotificationManager.class);
            if (manager != null) {
                manager.createNotificationChannel(channel);
                // Ensure notification channel is not blocked (Samsung requirement)
                if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.N) {
                    if (!channel.canBypassDnd()) {
                        // Channel is properly configured
                    }
                }
            }
        }
    }

    private Notification createNotification() {
        Intent notificationIntent = new Intent(this, MainActivity.class);
        PendingIntent pendingIntent = PendingIntent.getActivity(
            this,
            0,
            notificationIntent,
            PendingIntent.FLAG_IMMUTABLE | PendingIntent.FLAG_UPDATE_CURRENT
        );

        return new Notification.Builder(this, CHANNEL_ID)
            .setContentTitle("SMS Payment Processing")
            .setContentText("Processing payment SMS messages in the background")
            .setSmallIcon(android.R.drawable.ic_dialog_info)
            .setContentIntent(pendingIntent)
            .setOngoing(true)
            .build();
    }

    /**
     * Check for pending SMS and process them
     */
    private void checkAndProcessPendingSms() {
        if (isProcessing) {
            Log.d(TAG, "Already processing, skipping check");
            return;
        }

        // Check if Flutter app is active - if so, let Flutter handle processing
        SharedPreferences prefs = getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE);
        long lastActiveTime = prefs.getLong(APP_LAST_ACTIVE_KEY, 0);
        long timeSinceActive = System.currentTimeMillis() - lastActiveTime;
        
        if (timeSinceActive < APP_ACTIVE_THRESHOLD_MS) {
            Log.d(TAG, "App was active " + (timeSinceActive / 1000) + " seconds ago, skipping native processing (Flutter will handle)");
            return;
        }

        isProcessing = true;
        try {
            int count = prefs.getInt(PENDING_SMS_KEY + "_count", 0);
            
            if (count == 0) {
                Log.d(TAG, "No pending SMS to process");
                isProcessing = false;
                return;
            }

            Log.d(TAG, "Found " + count + " pending SMS, app inactive, processing from native service...");
            
            List<String> smsList = new ArrayList<>();
            for (int i = 0; i < count && i < MAX_PENDING_SMS; i++) {
                String sms = prefs.getString(PENDING_SMS_KEY + "_" + i, null);
                if (sms != null && !sms.isEmpty()) {
                    smsList.add(sms);
                }
            }

            if (smsList.isEmpty()) {
                Log.d(TAG, "No valid SMS found after loading");
                isProcessing = false;
                return;
            }

            // Process each SMS
            processSmsList(smsList, prefs);
            
        } catch (Exception e) {
            Log.e(TAG, "Error checking pending SMS", e);
            isProcessing = false;
        }
    }

    /**
     * Process a list of SMS messages
     */
    private void processSmsList(List<String> smsList, SharedPreferences prefs) {
        // Try to process via Flutter first (if app is running)
        if (tryProcessViaFlutter(smsList)) {
            Log.d(TAG, "SMS processing triggered via Flutter");
            isProcessing = false;
            return;
        }

        // Otherwise, process directly from native code
        Log.d(TAG, "Flutter not available, processing SMS directly from native");
        processSmsDirectly(smsList, prefs);
    }

    /**
     * Try to trigger Flutter processing via MethodChannel
     * Returns true if Flutter is available and processing was triggered
     */
    private boolean tryProcessViaFlutter(List<String> smsList) {
        try {
            // This would require access to the Flutter engine/MethodChannel
            // For now, we'll process directly from native
            // In a full implementation, you could use FlutterEngineCache to get the engine
            return false;
        } catch (Exception e) {
            Log.d(TAG, "Flutter processing not available: " + e.getMessage());
            return false;
        }
    }

    /**
     * Process SMS directly from native code using HTTP API calls
     */
    private void processSmsDirectly(List<String> smsList, SharedPreferences prefs) {
        new Thread(() -> {
            try {
                List<String> processedIndices = new ArrayList<>();
                
                for (int i = 0; i < smsList.size(); i++) {
                    try {
                        String smsJsonStr = smsList.get(i);
                        JSONObject smsData = new JSONObject(smsJsonStr);
                        String sender = smsData.optString("sender", "");
                        String message = smsData.optString("message", "");
                        long timestamp = smsData.optLong("timestamp", System.currentTimeMillis());

                        // Create unique key for this SMS using timestamp + sender + message hash
                        String smsKey = createSmsKey(sender, message, timestamp);
                        
                        // Check if this SMS was already processed
                        if (isSmsAlreadyProcessed(prefs, smsKey)) {
                            Log.d(TAG, "SMS already processed (duplicate), skipping: " + smsKey);
                            processedIndices.add(String.valueOf(i)); // Mark as processed to remove from list
                            continue;
                        }
                        
                        // Mark as being processed BEFORE processing (prevents duplicate processing)
                        markSmsAsProcessed(prefs, smsKey);

                        Log.d(TAG, "Processing SMS " + (i + 1) + "/" + smsList.size() + " from: " + sender + ", key: " + smsKey);

                        // Parse and validate SMS (basic validation)
                        SMSProcessingResult result = parseAndValidateSms(message, sender, timestamp);
                        result.originalMessage = message; // Store original message for hash generation
                        
                        if (result.isValid) {
                            // Send to API
                            boolean apiSuccess = sendToApi(result, sender, timestamp);
                            Log.d(TAG, "API call result for SMS " + (i + 1) + ": " + (apiSuccess ? "SUCCESS" : "FAILED"));
                        } else {
                            Log.w(TAG, "Invalid SMS format, skipping: " + message);
                        }
                        
                        processedIndices.add(String.valueOf(i));
                        
                    } catch (Exception e) {
                        Log.e(TAG, "Error processing SMS " + (i + 1), e);
                    }
                }

                // Clear processed SMS from SharedPreferences
                clearProcessedSms(prefs, processedIndices);
                Log.d(TAG, "Processed " + processedIndices.size() + " SMS messages");
                
            } catch (Exception e) {
                Log.e(TAG, "Error in processSmsDirectly", e);
            } finally {
                isProcessing = false;
            }
        }).start();
    }

    /**
     * Parse and validate SMS message
     * Supports both formats:
     * - New: LIPA*amount*SERVICE*phone (e.g., LIPA*1800*VODACOM*0765438924)
     * - Old: PAY/LIPA <amount> <phone> (e.g., LIPA 1800 0765438924)
     */
    private SMSProcessingResult parseAndValidateSms(String message, String sender, long timestamp) {
        SMSProcessingResult result = new SMSProcessingResult();
        
        try {
            String upperMessage = message.toUpperCase().trim();
            
            // First, try new format: LIPA*amount*SERVICE*phone
            // Regex: ^LIPA\*(\d+)\*(VODACOM|YAS|TIGO|AIRTEL|HALOTEL)\*(0\d{9})$
            java.util.regex.Pattern newFormatPattern = java.util.regex.Pattern.compile(
                "^LIPA\\*(\\d+)\\*(VODACOM|YAS|TIGO|AIRTEL|HALOTEL)\\*(0\\d{9})$", 
                java.util.regex.Pattern.CASE_INSENSITIVE
            );
            java.util.regex.Matcher newFormatMatcher = newFormatPattern.matcher(upperMessage);
            
            if (newFormatMatcher.find()) {
                try {
                    String amountStr = newFormatMatcher.group(1);
                    String service = newFormatMatcher.group(2).toUpperCase();
                    String phone = newFormatMatcher.group(3);
                    
                    int amount = Integer.parseInt(amountStr);
                    
                    // Validate amount range (100 to 1,000,000) - matches Flutter
                    if (amount < 100 || amount > 1000000) {
                        result.isValid = false;
                        result.error = "Amount must be between 100 and 1000000";
                        return result;
                    }
                    
                    // Validate phone number format
                    if (!phone.matches("^0\\d{9}$")) {
                        result.isValid = false;
                        result.error = "Invalid phone number format";
                        return result;
                    }
                    
                    // Validate service provider
                    String[] validServices = {"VODACOM", "YAS", "TIGO", "AIRTEL", "HALOTEL"};
                    boolean isValidService = false;
                    for (String validService : validServices) {
                        if (service.equals(validService)) {
                            isValidService = true;
                            break;
                        }
                    }
                    
                    if (!isValidService) {
                        result.isValid = false;
                        result.error = "Invalid service provider. Must be one of: VODACOM, YAS, TIGO, AIRTEL, HALOTEL";
                        return result;
                    }
                    
                    // Valid new format SMS
                    result.isValid = true;
                    result.command = "LIPA";
                    result.amount = amount;
                    result.phone = phone;
                    result.service = service; // Store service provider
                    result.normalizedMessage = "LIPA " + amount + " " + service + " " + phone;
                    return result;
                    
                } catch (NumberFormatException e) {
                    result.isValid = false;
                    result.error = "Invalid amount format";
                    return result;
                }
            }
            
            // Fallback to old format: Normalize and parse
            // Normalize message: uppercase, replace * with spaces, collapse spaces
            String normalized = upperMessage
                .replace("*", " ")
                .replaceAll("\\s+", " ")
                .trim();
            
            // Regex: ^(PAY|LIPA)\s+(\d+)\s+(0\d{9})$
            java.util.regex.Pattern oldFormatPattern = java.util.regex.Pattern.compile("^(PAY|LIPA)\\s+(\\d+)\\s+(0\\d{9})$");
            java.util.regex.Matcher oldFormatMatcher = oldFormatPattern.matcher(normalized);
            
            if (oldFormatMatcher.find()) {
                try {
                    result.isValid = true;
                    result.command = oldFormatMatcher.group(1);
                    result.amount = Integer.parseInt(oldFormatMatcher.group(2));
                    result.phone = oldFormatMatcher.group(3);
                    result.normalizedMessage = normalized;
                    
                    // Validate amount range (100 to 1,000,000) - matches Flutter
                    if (result.amount < 100 || result.amount > 1000000) {
                        result.isValid = false;
                        result.error = "Amount must be between 100 and 1000000";
                    }
                } catch (NumberFormatException e) {
                    result.isValid = false;
                    result.error = "Invalid amount format";
                }
            } else {
                result.isValid = false;
                result.error = "Invalid SMS format. Expected: LIPA*amount*SERVICE*phone or PAY/LIPA <amount> <phone>";
            }
        } catch (Exception e) {
            result.isValid = false;
            result.error = "Parsing error: " + e.getMessage();
        }
        
        return result;
    }

    /**
     * Get API base URL from SharedPreferences or use default
     */
    private String getApiBaseUrl() {
        try {
            SharedPreferences prefs = getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE);
            String customUrl = prefs.getString(API_URL_PREF_KEY, null);
            return customUrl != null && !customUrl.isEmpty() ? customUrl : API_BASE_URL;
        } catch (Exception e) {
            Log.w(TAG, "Error reading API URL from preferences, using default", e);
            return API_BASE_URL;
        }
    }

    /**
     * Send parsed SMS data to API
     */
    private boolean sendToApi(SMSProcessingResult result, String sender, long timestamp) {
        try {
            String apiBaseUrl = getApiBaseUrl();
            String apiUrl = apiBaseUrl + "/sms-payment/trigger";
            
            // Create JSON payload
            JSONObject payload = new JSONObject();
            payload.put("command", result.command);
            payload.put("amount", result.amount);
            payload.put("phone", result.phone);
            payload.put("sender", sender);
            payload.put("timestamp", timestamp);
            payload.put("original_message", result.originalMessage);
            payload.put("normalized_message", result.normalizedMessage);
            // Add service if available (new format includes service provider)
            if (result.service != null && !result.service.isEmpty()) {
                payload.put("service", result.service);
            }
            
            // Generate hash for duplicate detection using SHA-256
            // Use pipe separator to match Flutter's format: sender|messageBody|timestamp
            String hashInput = sender + "|" + result.originalMessage + "|" + timestamp;
            String messageHash = generateHash(hashInput);
            payload.put("message_hash", messageHash);
            
            URL url = new URL(apiUrl);
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("POST");
            connection.setRequestProperty("Content-Type", "application/json");
            connection.setRequestProperty("Accept", "application/json");
            connection.setDoOutput(true);
            // Increased timeouts: 30 seconds connect, 60 seconds read
            connection.setConnectTimeout(30000);
            connection.setReadTimeout(60000);
            
            // Write payload
            try (OutputStream os = connection.getOutputStream()) {
                byte[] input = payload.toString().getBytes("utf-8");
                os.write(input, 0, input.length);
            }
            
            // Read response
            int responseCode = connection.getResponseCode();
            Log.d(TAG, "API response code: " + responseCode);
            
            StringBuilder response = new StringBuilder();
            try (BufferedReader br = new BufferedReader(new InputStreamReader(
                    responseCode >= 200 && responseCode < 300 
                        ? connection.getInputStream() 
                        : connection.getErrorStream(), "utf-8"))) {
                String responseLine;
                while ((responseLine = br.readLine()) != null) {
                    response.append(responseLine.trim());
                }
            }
            
            Log.d(TAG, "API response: " + response.toString());
            
            return responseCode >= 200 && responseCode < 300;
            
        } catch (Exception e) {
            Log.e(TAG, "Error sending to API", e);
            return false;
        }
    }

    /**
     * Generate SHA-256 hash for duplicate detection
     */
    private String generateHash(String input) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(input.getBytes("UTF-8"));
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (Exception e) {
            Log.e(TAG, "Error generating hash, using fallback", e);
            // Fallback to simple hash if SHA-256 fails
            return String.valueOf(input.hashCode());
        }
    }

    /**
     * Create a unique key for SMS using timestamp, sender, and message hash
     * This key is used to track processed SMS and prevent duplicates
     * Format: timestamp_sender_hash (matches Flutter's format)
     */
    private String createSmsKey(String sender, String message, long timestamp) {
        // Use timestamp + sender + message hash to create unique key
        // Timestamp ensures uniqueness even if same message received multiple times
        // Use pipe separator format to match Flutter: sender|message|timestamp
        String hashInput = sender + "|" + message + "|" + timestamp;
        String messageHash = generateHash(hashInput);
        // Use first 16 chars of hash for shorter key
        String shortHash = messageHash.substring(0, Math.min(16, messageHash.length()));
        return timestamp + "_" + sender + "_" + shortHash;
    }

    /**
     * Check if SMS was already processed by checking the processed keys
     */
    private boolean isSmsAlreadyProcessed(SharedPreferences prefs, String smsKey) {
        try {
            String processedKeys = prefs.getString(PROCESSED_SMS_KEY, "");
            return processedKeys != null && processedKeys.contains(smsKey);
        } catch (Exception e) {
            Log.e(TAG, "Error checking if SMS already processed", e);
            return false;
        }
    }

    /**
     * Mark SMS as processed by adding its key to the processed list
     */
    private void markSmsAsProcessed(SharedPreferences prefs, String smsKey) {
        try {
            String processedKeys = prefs.getString(PROCESSED_SMS_KEY, "");
            if (processedKeys == null) {
                processedKeys = "";
            }
            
            // Add new key if not already present
            if (!processedKeys.contains(smsKey)) {
                processedKeys = processedKeys.isEmpty() ? smsKey : processedKeys + "," + smsKey;
                
                // Limit stored keys to last 1000 to prevent excessive storage
                String[] keys = processedKeys.split(",");
                if (keys.length > 1000) {
                    // Keep only last 1000 keys
                    StringBuilder sb = new StringBuilder();
                    int start = keys.length - 1000;
                    for (int i = start; i < keys.length; i++) {
                        if (sb.length() > 0) sb.append(",");
                        sb.append(keys[i]);
                    }
                    processedKeys = sb.toString();
                }
                
                SharedPreferences.Editor editor = prefs.edit();
                editor.putString(PROCESSED_SMS_KEY, processedKeys);
                editor.commit();
                Log.d(TAG, "Marked SMS as processed: " + smsKey);
            }
        } catch (Exception e) {
            Log.e(TAG, "Error marking SMS as processed", e);
        }
    }

    /**
     * Clear processed SMS from SharedPreferences
     */
    private void clearProcessedSms(SharedPreferences prefs, List<String> processedIndices) {
        try {
            int currentCount = prefs.getInt(PENDING_SMS_KEY + "_count", 0);
            List<String> remainingSms = new ArrayList<>();
            
            // Collect non-processed SMS
            for (int i = 0; i < currentCount && i < MAX_PENDING_SMS; i++) {
                if (!processedIndices.contains(String.valueOf(i))) {
                    String sms = prefs.getString(PENDING_SMS_KEY + "_" + i, null);
                    if (sms != null && !sms.isEmpty()) {
                        remainingSms.add(sms);
                    }
                }
            }
            
            // Save remaining SMS
            SharedPreferences.Editor editor = prefs.edit();
            editor.putInt(PENDING_SMS_KEY + "_count", remainingSms.size());
            for (int i = 0; i < remainingSms.size(); i++) {
                editor.putString(PENDING_SMS_KEY + "_" + i, remainingSms.get(i));
            }
            // Remove excess entries
            for (int i = remainingSms.size(); i < currentCount; i++) {
                editor.remove(PENDING_SMS_KEY + "_" + i);
            }
            editor.commit();
            
            Log.d(TAG, "Cleared " + processedIndices.size() + " processed SMS, " + remainingSms.size() + " remaining");
        } catch (Exception e) {
            Log.e(TAG, "Error clearing processed SMS", e);
        }
    }

    /**
     * Inner class to hold SMS processing result
     */
    private static class SMSProcessingResult {
        boolean isValid = false;
        String command = "";
        int amount = 0;
        String phone = "";
        String service = ""; // Service provider (VODACOM, YAS, TIGO, AIRTEL, HALOTEL) - for new format
        String normalizedMessage = "";
        String originalMessage = "";
        String error = "";
    }
}

