/// SMS Parser Service
/// Handles normalization, validation, and parsing of SMS payment commands
class SmsParserService {
  // Minimum and maximum amount limits
  static const int minAmount = 100;
  static const int maxAmount = 1000000;

  /// Normalizes SMS message text
  /// - Converts to uppercase
  /// - Replaces * with spaces
  /// - Collapses multiple spaces into single space
  /// - Trims leading/trailing whitespace
  static String normalizeMessage(String message) {
    if (message.isEmpty) return message;

    return message
        .toUpperCase()
        .replaceAll('*', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  /// Valid service providers
  static const List<String> validServices = ['VODACOM', 'YAS', 'TIGO', 'AIRTEL', 'HALOTEL'];

  /// Validates service provider name
  static bool isValidService(String? service) {
    if (service == null || service.isEmpty) return false;
    return validServices.contains(service.toUpperCase());
  }

  /// Parses SMS message and extracts payment command details
  /// Supports both old and new formats:
  /// Old: PAY/LIPA <amount> <phone> or *PAY*amount*phone* or *LIPA*amount*phone*
  /// New: LIPA*amount*SERVICE*phone (where SERVICE is VODACOM, YAS, TIGO, AIRTEL, or HALOTEL)
  /// Returns ParsedSmsResult with command, amount, service, and phone if valid, null otherwise
  static ParsedSmsResult? parseSms(String message, String sender, int timestamp) {
    try {
      // First, try new format: LIPA*amount*SERVICE*phone
      final newFormatRegex = RegExp(r'^LIPA\*(\d+)\*(VODACOM|YAS|TIGO|AIRTEL|HALOTEL)\*(0\d{9})$', caseSensitive: false);
      final newFormatMatch = newFormatRegex.firstMatch(message.toUpperCase());

      if (newFormatMatch != null) {
        final amountStr = newFormatMatch.group(1) ?? '';
        final service = newFormatMatch.group(2)?.toUpperCase() ?? '';
        final phone = newFormatMatch.group(3) ?? '';

        // Parse amount
        final amount = int.tryParse(amountStr);
        if (amount == null) {
          return ParsedSmsResult(
            isValid: false,
            error: 'Invalid amount format',
            sender: sender,
            originalMessage: message,
            timestamp: timestamp,
          );
        }

        // Validate amount range
        if (amount < minAmount || amount > maxAmount) {
          return ParsedSmsResult(
            isValid: false,
            error: 'Amount must be between $minAmount and $maxAmount',
            sender: sender,
            originalMessage: message,
            timestamp: timestamp,
          );
        }

        // Validate phone number
        if (!isValidPhoneNumber(phone)) {
          return ParsedSmsResult(
            isValid: false,
            error: 'Invalid phone number format',
            sender: sender,
            originalMessage: message,
            timestamp: timestamp,
          );
        }

        // Validate service
        if (!isValidService(service)) {
          return ParsedSmsResult(
            isValid: false,
            error: 'Invalid service provider. Must be one of: ${validServices.join(", ")}',
            sender: sender,
            originalMessage: message,
            timestamp: timestamp,
          );
        }

        return ParsedSmsResult(
          isValid: true,
          command: 'LIPA',
          amount: amount,
          service: service,
          phone: phone,
          sender: sender,
          originalMessage: message,
          normalizedMessage: 'LIPA $amount $service $phone',
          timestamp: timestamp,
        );
      }

      // Fallback to old format: Normalize and parse
      final normalized = normalizeMessage(message);

      // Regex pattern: ^(PAY|LIPA)\s+(\d+)\s+(0\d{9})$
      // Groups: 1=command, 2=amount, 3=phone
      final oldFormatRegex = RegExp(r'^(PAY|LIPA)\s+(\d+)\s+(0\d{9})$');
      final oldFormatMatch = oldFormatRegex.firstMatch(normalized);

      if (oldFormatMatch == null) {
        return ParsedSmsResult(
          isValid: false,
          error: 'Invalid SMS format. Expected: LIPA*amount*SERVICE*phone or PAY/LIPA <amount> <phone>',
          sender: sender,
          originalMessage: message,
          timestamp: timestamp,
        );
      }

      final command = oldFormatMatch.group(1) ?? '';
      final amountStr = oldFormatMatch.group(2) ?? '';
      final phone = oldFormatMatch.group(3) ?? '';

      // Parse amount
      final amount = int.tryParse(amountStr);
      if (amount == null) {
        return ParsedSmsResult(
          isValid: false,
          error: 'Invalid amount format',
          sender: sender,
          originalMessage: message,
          timestamp: timestamp,
        );
      }

      // Validate amount range
      if (amount < minAmount || amount > maxAmount) {
        return ParsedSmsResult(
          isValid: false,
          error: 'Amount must be between $minAmount and $maxAmount',
          sender: sender,
          originalMessage: message,
          timestamp: timestamp,
        );
      }

      // Validate phone number (already validated by regex, but double-check)
      if (!isValidPhoneNumber(phone)) {
        return ParsedSmsResult(
          isValid: false,
          error: 'Invalid phone number format',
          sender: sender,
          originalMessage: message,
          timestamp: timestamp,
        );
      }

      // Old format doesn't have service, so set to null
      return ParsedSmsResult(
        isValid: true,
        command: command,
        amount: amount,
        service: null, // Old format doesn't include service
        phone: phone,
        sender: sender,
        originalMessage: message,
        normalizedMessage: normalized,
        timestamp: timestamp,
      );
    } catch (e) {
      return ParsedSmsResult(
        isValid: false,
        error: 'Error parsing SMS: $e',
        sender: sender,
        originalMessage: message,
        timestamp: timestamp,
      );
    }
  }

  /// Validates phone number format (exactly 10 digits starting with 0)
  static bool isValidPhoneNumber(String phone) {
    if (phone.length != 10) return false;
    if (!phone.startsWith('0')) return false;
    return RegExp(r'^0\d{9}$').hasMatch(phone);
  }

  /// Validates if message contains only numeric amount (no words)
  static bool hasNumericAmount(String message) {
    // Check if amount part contains only digits
    final regex = RegExp(r'^(PAY|LIPA)\s+(\d+)\s+');
    return regex.hasMatch(message.toUpperCase());
  }
}

/// Result of SMS parsing
class ParsedSmsResult {
  final bool isValid;
  final String? command; // PAY or LIPA
  final int? amount;
  final String? service; // VODACOM, YAS, TIGO, AIRTEL, or HALOTEL
  final String? phone;
  final String sender;
  final String originalMessage;
  final String? normalizedMessage;
  final int timestamp;
  final String? error;

  ParsedSmsResult({
    required this.isValid,
    this.command,
    this.amount,
    this.service,
    this.phone,
    required this.sender,
    required this.originalMessage,
    this.normalizedMessage,
    required this.timestamp,
    this.error,
  });

  /// Converts to JSON for API payload
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'command': command ?? '',
      'amount': amount ?? 0,
      'phone': phone ?? '',
      'sender': sender,
      'timestamp': timestamp,
    };
    
    // Add service if available
    if (service != null && service!.isNotEmpty) {
      json['service'] = service!;
    }
    
    return json;
  }

  @override
  String toString() {
    if (isValid) {
      return 'ParsedSmsResult(command: $command, amount: $amount, service: $service, phone: $phone)';
    } else {
      return 'ParsedSmsResult(error: $error)';
    }
  }
}

