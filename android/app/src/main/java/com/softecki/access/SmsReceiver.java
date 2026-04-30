package com.softecki.access;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.telephony.SmsMessage;
import android.util.Log;
import org.json.JSONObject;
import java.util.ArrayList;
import java.util.List;

public class SmsReceiver extends BroadcastReceiver {
    private static final String TAG = "SmsReceiver";
    private static final String PREFS_NAME = "sms_receiver_prefs";
    private static final String PENDING_SMS_KEY = "pending_sms_list";
    private static final int MAX_PENDING_SMS = 100;

    @Override
    public void onReceive(Context context, Intent intent) {
        if (!"android.provider.Telephony.SMS_RECEIVED".equals(intent.getAction())) {
            return;
        }

        Bundle bundle = intent.getExtras();
        if (bundle == null) {
            return;
        }

        try {
            Object[] pdus = (Object[]) bundle.get("pdus");
            if (pdus == null || pdus.length == 0) {
                return;
            }

            SmsMessage[] messages = new SmsMessage[pdus.length];
            StringBuilder fullMessage = new StringBuilder();
            String sender = null;

            for (int i = 0; i < pdus.length; i++) {
                String format = bundle.getString("format");
                messages[i] = SmsMessage.createFromPdu((byte[]) pdus[i], format);
                if (sender == null) {
                    sender = messages[i].getOriginatingAddress();
                }
                fullMessage.append(messages[i].getMessageBody());
            }

            String messageBody = fullMessage.toString();
            long timestamp = System.currentTimeMillis();

            Log.d(TAG, "SMS received from: " + sender + ", body: " + messageBody);

            // Store SMS in SharedPreferences for Flutter to process
            storeSmsForProcessing(context, sender, messageBody, timestamp);

            // Send broadcast to notify app that new SMS was received
            // This allows MainActivity to trigger Flutter processing if app is running
            Intent smsReceivedIntent = new Intent("com.softecki.access.SMS_RECEIVED");
            smsReceivedIntent.setPackage(context.getPackageName());
            context.sendBroadcast(smsReceivedIntent);
            Log.d(TAG, "Sent broadcast for SMS received notification");

        } catch (Exception e) {
            Log.e(TAG, "Error processing SMS", e);
        }
    }

    private void storeSmsForProcessing(Context context, String sender, String messageBody, long timestamp) {
        try {
            SharedPreferences prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE);
            List<String> pendingSms = new ArrayList<>();
            
            // Load existing pending SMS
            int existingCount = prefs.getInt(PENDING_SMS_KEY + "_count", 0);
            for (int i = 0; i < existingCount && i < MAX_PENDING_SMS; i++) {
                String sms = prefs.getString(PENDING_SMS_KEY + "_" + i, null);
                if (sms != null) {
                    pendingSms.add(sms);
                }
            }

            // Create JSON object for SMS data
            JSONObject smsJson = new JSONObject();
            smsJson.put("sender", sender != null ? sender : "");
            smsJson.put("message", messageBody != null ? messageBody : "");
            smsJson.put("timestamp", timestamp);

            // Add to pending list
            pendingSms.add(smsJson.toString());

            // Limit the size to prevent excessive storage
            if (pendingSms.size() > MAX_PENDING_SMS) {
                // Remove oldest entries (keep last MAX_PENDING_SMS)
                pendingSms = pendingSms.subList(pendingSms.size() - MAX_PENDING_SMS, pendingSms.size());
            }

            // Save back to SharedPreferences
            SharedPreferences.Editor editor = prefs.edit();
            editor.putInt(PENDING_SMS_KEY + "_count", pendingSms.size());
            for (int i = 0; i < pendingSms.size(); i++) {
                editor.putString(PENDING_SMS_KEY + "_" + i, pendingSms.get(i));
            }
            // Remove any excess entries
            for (int i = pendingSms.size(); i < existingCount; i++) {
                editor.remove(PENDING_SMS_KEY + "_" + i);
            }
            // Use commit() instead of apply() to ensure synchronous write
            boolean committed = editor.commit();

            Log.d(TAG, "Stored SMS for processing. Pending count: " + pendingSms.size() + ", committed: " + committed);
            
            // Verify the save by reading back
            int verifyCount = prefs.getInt(PENDING_SMS_KEY + "_count", 0);
            Log.d(TAG, "Verified saved count: " + verifyCount);
        } catch (Exception e) {
            Log.e(TAG, "Error storing SMS for processing", e);
        }
    }
}

