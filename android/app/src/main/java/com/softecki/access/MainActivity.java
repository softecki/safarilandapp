package com.softecki.access;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.util.Log;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String TAG = "MainActivity";
    private static final String CHANNEL = "com.softecki.access/sms_receiver";
    private BroadcastReceiver smsReceivedReceiver;
    private MethodChannel methodChannel;

    @Override
    public void configureFlutterEngine(FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        methodChannel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL);
        Log.d(TAG, "MethodChannel created: " + CHANNEL);
        methodChannel.setMethodCallHandler((call, result) -> {
            Log.d(TAG, "MethodChannel call received: " + call.method);
            if (call.method.equals("getPendingSms")) {
                Log.d(TAG, "Processing getPendingSms request");
                // Read pending SMS from native SharedPreferences and return to Flutter
                try {
                    android.content.SharedPreferences prefs = MainActivity.this.getSharedPreferences("sms_receiver_prefs", Context.MODE_PRIVATE);
                    int count = prefs.getInt("pending_sms_list_count", 0);
                    java.util.ArrayList<String> smsList = new java.util.ArrayList<>();
                    
                    for (int i = 0; i < count && i < 100; i++) {
                        String sms = prefs.getString("pending_sms_list_" + i, null);
                        if (sms != null && !sms.isEmpty()) {
                            smsList.add(sms);
                        }
                    }
                    
                    Log.d(TAG, "Returning " + smsList.size() + " SMS to Flutter");
                    result.success(smsList);
                } catch (Exception e) {
                    Log.e(TAG, "Error getting pending SMS", e);
                    result.error("ERROR", "Failed to get pending SMS: " + e.getMessage(), null);
                }
            } else if (call.method.equals("clearPendingSms")) {
                Log.d(TAG, "Processing clearPendingSms request");
                // Clear pending SMS from native SharedPreferences
                try {
                    android.content.SharedPreferences prefs = MainActivity.this.getSharedPreferences("sms_receiver_prefs", Context.MODE_PRIVATE);
                    android.content.SharedPreferences.Editor editor = prefs.edit();
                    int count = prefs.getInt("pending_sms_list_count", 0);
                    
                    editor.remove("pending_sms_list_count");
                    for (int i = 0; i < count; i++) {
                        editor.remove("pending_sms_list_" + i);
                    }
                    editor.commit();
                    
                    Log.d(TAG, "Cleared " + count + " pending SMS from SharedPreferences");
                    result.success(true);
                } catch (Exception e) {
                    Log.e(TAG, "Error clearing pending SMS", e);
                    result.error("ERROR", "Failed to clear pending SMS: " + e.getMessage(), null);
                }
            } else if (call.method.equals("startSmsProcessingService")) {
                // Start the foreground service from Flutter
                try {
                    startSmsProcessingService();
                    result.success(true);
                } catch (Exception e) {
                    Log.e(TAG, "Error starting service from Flutter", e);
                    result.error("ERROR", "Failed to start service: " + e.getMessage(), null);
                }
            } else if (call.method.equals("stopSmsProcessingService")) {
                // Stop the foreground service from Flutter
                try {
                    Intent serviceIntent = new Intent(MainActivity.this, SmsProcessingService.class);
                    stopService(serviceIntent);
                    Log.d(TAG, "Stopped SMS Processing Service from Flutter");
                    result.success(true);
                } catch (Exception e) {
                    Log.e(TAG, "Error stopping service from Flutter", e);
                    result.error("ERROR", "Failed to stop service: " + e.getMessage(), null);
                }
            } else if (call.method.equals("markSmsAsProcessed")) {
                // Mark SMS as processed using timestamp-based key (for duplicate prevention)
                try {
                    String sender = call.argument("sender");
                    String message = call.argument("message");
                    Long timestamp = call.argument("timestamp");
                    
                    if (sender != null && message != null && timestamp != null) {
                        // Create the same key format as native service
                        String hashInput = sender + "|" + message + "|" + timestamp;
                        String messageHash = generateSimpleHash(hashInput);
                        String smsKey = timestamp + "_" + sender + "_" + messageHash.substring(0, Math.min(16, messageHash.length()));
                        
                        android.content.SharedPreferences prefs = getSharedPreferences("sms_receiver_prefs", Context.MODE_PRIVATE);
                        String processedKeys = prefs.getString("processed_sms_timestamps", "");
                        if (processedKeys == null) processedKeys = "";
                        
                        if (!processedKeys.contains(smsKey)) {
                            processedKeys = processedKeys.isEmpty() ? smsKey : processedKeys + "," + smsKey;
                            
                            // Limit to last 1000 keys
                            String[] keys = processedKeys.split(",");
                            if (keys.length > 1000) {
                                StringBuilder sb = new StringBuilder();
                                int start = keys.length - 1000;
                                for (int i = start; i < keys.length; i++) {
                                    if (sb.length() > 0) sb.append(",");
                                    sb.append(keys[i]);
                                }
                                processedKeys = sb.toString();
                            }
                            
                            android.content.SharedPreferences.Editor editor = prefs.edit();
                            editor.putString("processed_sms_timestamps", processedKeys);
                            editor.commit();
                            Log.d(TAG, "Marked SMS as processed from Flutter: " + smsKey);
                        }
                        result.success(true);
                    } else {
                        result.error("ERROR", "Missing required arguments (sender, message, timestamp)", null);
                    }
                } catch (Exception e) {
                    Log.e(TAG, "Error marking SMS as processed from Flutter", e);
                    result.error("ERROR", "Failed to mark SMS as processed: " + e.getMessage(), null);
                }
            } else if (call.method.equals("setApiBaseUrl")) {
                // Sync API base URL from Flutter to native service
                try {
                    String apiUrl = call.argument("url");
                    if (apiUrl != null && !apiUrl.isEmpty()) {
                        android.content.SharedPreferences prefs = getSharedPreferences("sms_receiver_prefs", Context.MODE_PRIVATE);
                        android.content.SharedPreferences.Editor editor = prefs.edit();
                        editor.putString("api_base_url", apiUrl);
                        editor.commit();
                        Log.d(TAG, "API base URL synced from Flutter: " + apiUrl);
                        result.success(true);
                    } else {
                        result.error("ERROR", "API URL is null or empty", null);
                    }
                } catch (Exception e) {
                    Log.e(TAG, "Error setting API base URL from Flutter", e);
                    result.error("ERROR", "Failed to set API base URL: " + e.getMessage(), null);
                }
            } else {
                Log.w(TAG, "Unknown method called: " + call.method);
                result.notImplemented();
            }
        });
        Log.d(TAG, "MethodChannel handler registered successfully");
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        // Mark app as active so native service knows Flutter is handling processing
        markAppAsActive();
        
        // Start the foreground service for background SMS processing
        startSmsProcessingService();
        
        // Register broadcast receiver to listen for SMS received events
        smsReceivedReceiver = new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                Log.d(TAG, "SMS received broadcast received, notifying Flutter");
                
                // Read the actual count from SharedPreferences to pass to Flutter
                android.content.SharedPreferences prefs = context.getSharedPreferences("sms_receiver_prefs", Context.MODE_PRIVATE);
                int pendingCount = prefs.getInt("pending_sms_list_count", 0);
                Log.d(TAG, "Current pending SMS count from SharedPreferences: " + pendingCount);
                
                // Notify Flutter to process pending SMS
                // Note: We don't pass arguments since MethodChannel doesn't support Bundle
                // Flutter will read the count directly from SharedPreferences
                if (methodChannel != null) {
                    methodChannel.invokeMethod("onSmsReceived", null);
                }
            }
        };
        
        IntentFilter filter = new IntentFilter("com.softecki.access.SMS_RECEIVED");
        registerReceiver(smsReceivedReceiver, filter);
        Log.d(TAG, "Registered SMS received broadcast receiver");
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (smsReceivedReceiver != null) {
            unregisterReceiver(smsReceivedReceiver);
            Log.d(TAG, "Unregistered SMS received broadcast receiver");
        }
        // Note: We don't stop the service here so it continues running in background
        // The service will keep processing SMS even when app is closed
    }
    
    /**
     * Start the SMS Processing Foreground Service
     */
    private void startSmsProcessingService() {
        try {
            Intent serviceIntent = new Intent(this, SmsProcessingService.class);
            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
                startForegroundService(serviceIntent);
            } else {
                startService(serviceIntent);
            }
            Log.d(TAG, "Started SMS Processing Service");
        } catch (Exception e) {
            Log.e(TAG, "Error starting SMS Processing Service", e);
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
        // Mark app as active so native service knows Flutter is handling processing
        markAppAsActive();
        
        // When app comes to foreground, trigger processing of pending SMS
        Log.d(TAG, "App resumed, triggering pending SMS check");
        if (methodChannel != null) {
            methodChannel.invokeMethod("checkPendingSms", null);
        }
        // Ensure service is running
        startSmsProcessingService();
    }
    
    /**
     * Mark app as active by updating timestamp in SharedPreferences
     * This tells the native service that Flutter is handling SMS processing
     */
    private void markAppAsActive() {
        try {
            android.content.SharedPreferences prefs = getSharedPreferences("sms_receiver_prefs", Context.MODE_PRIVATE);
            android.content.SharedPreferences.Editor editor = prefs.edit();
            editor.putLong("app_last_active_timestamp", System.currentTimeMillis());
            editor.apply();
        } catch (Exception e) {
            Log.e(TAG, "Error marking app as active", e);
        }
    }
    
    /**
     * Simple hash generation for SMS key (matches native service format)
     */
    private String generateSimpleHash(String input) {
        return String.valueOf(input.hashCode());
    }
}
