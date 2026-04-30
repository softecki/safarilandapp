import 'dart:convert';
import 'package:crypto/crypto.dart';

/// Service for generating hash for duplicate SMS detection
/// Hash is generated from: sender + message body + timestamp
class SmsHashService {
  /// Generate unique hash for SMS message
  /// Uses SHA-256 to create hash from sender, message body, and timestamp
  static String generateHash(String sender, String messageBody, int timestamp) {
    // Combine sender, message body, and timestamp
    final combined = '$sender|$messageBody|$timestamp';
    
    // Generate SHA-256 hash
    final bytes = utf8.encode(combined);
    final digest = sha256.convert(bytes);
    
    return digest.toString();
  }

  /// Generate hash from normalized message (for consistency)
  static String generateHashFromNormalized(
    String sender,
    String normalizedMessage,
    int timestamp,
  ) {
    return generateHash(sender, normalizedMessage, timestamp);
  }
}

