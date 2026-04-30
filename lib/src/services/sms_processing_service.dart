import 'package:workmanager/workmanager.dart';
import 'sms_parser_service.dart';
import 'sms_api_service.dart';
import 'sms_database_service.dart';
import 'sms_hash_service.dart';

/// Main SMS Processing Service
/// Handles parsing, validation, duplicate checking, and API calls
class SmsProcessingService {
  static const String taskName = 'sms_processing_task';
  static final SmsDatabaseService _dbService = SmsDatabaseService();

  /// Initialize WorkManager for background processing
  static Future<void> initialize() async {
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: false,
    );
  }

  /// Process incoming SMS message
  /// This method should be called when SMS is received
  static Future<void> processSms({
    required String sender,
    required String messageBody,
    required int timestamp,
  }) async {
    try {
      // Generate hash for duplicate detection
      final messageHash = SmsHashService.generateHash(sender, messageBody, timestamp);

      // Check for duplicates
      final isDuplicate = await _dbService.isDuplicateHash(messageHash);
      if (isDuplicate) {
        print('Duplicate SMS detected, skipping: $messageHash');
        return;
      }

      // Parse SMS
      final parsedResult = SmsParserService.parseSms(messageBody, sender, timestamp);

      // Save to database with PENDING status first
      final recordId = await _dbService.saveProcessedSms(
        sender: sender,
        originalMessage: messageBody,
        normalizedMessage: parsedResult?.normalizedMessage,
        messageHash: messageHash,
        command: parsedResult?.command,
        amount: parsedResult?.amount,
        service: parsedResult?.service,
        phone: parsedResult?.phone,
        status: 'PENDING',
        errorMessage: parsedResult?.error,
        smsTimestamp: DateTime.fromMillisecondsSinceEpoch(timestamp),
      );

      // If parsing failed, update status to FAILED
      if (parsedResult == null || !parsedResult.isValid) {
        await _dbService.updateSmsStatus(
          id: recordId,
          status: 'FAILED',
          errorMessage: parsedResult?.error ?? 'Failed to parse SMS',
        );
        return;
      }

      // Queue for background processing (API call)
      await _queueForApiProcessing(recordId, parsedResult);

    } catch (e) {
      print('Error processing SMS: $e');
      // Still save the record with error status
      try {
        await _dbService.saveProcessedSms(
          sender: sender,
          originalMessage: messageBody,
          messageHash: SmsHashService.generateHash(sender, messageBody, timestamp),
          status: 'FAILED',
          errorMessage: 'Processing error: $e',
          smsTimestamp: DateTime.fromMillisecondsSinceEpoch(timestamp),
        );
      } catch (dbError) {
        print('Error saving failed SMS record: $dbError');
      }
    }
  }

  // Track processed record IDs to prevent duplicate API calls
  static final Set<int> _processingRecordIds = <int>{};
  
  /// Queue SMS for API processing using WorkManager
  /// Falls back to direct API call if WorkManager fails
  static Future<void> _queueForApiProcessing(
    int recordId,
    ParsedSmsResult parsedResult,
  ) async {
    // Check if this record is already being processed
    if (_processingRecordIds.contains(recordId)) {
      print('SmsProcessingService: Record $recordId is already being processed, skipping duplicate');
      return;
    }
    
    _processingRecordIds.add(recordId);
    
    try {
      print('SmsProcessingService: Attempting to queue API task via WorkManager for record $recordId');
      
      // Try to use WorkManager for background processing
      try {
        await Workmanager().registerOneOffTask(
          '$taskName-$recordId-${DateTime.now().millisecondsSinceEpoch}',
          taskName,
          inputData: {
            'recordId': recordId,
            'command': parsedResult.command,
            'amount': parsedResult.amount,
            'service': parsedResult.service,
            'phone': parsedResult.phone,
            'sender': parsedResult.sender,
            'timestamp': parsedResult.timestamp,
          },
          constraints: Constraints(
            networkType: NetworkType.connected,
          ),
        );
        print('SmsProcessingService: Successfully queued API task via WorkManager');
        // Don't remove from set here - let WorkManager callback remove it
        return;
      } catch (workManagerError) {
        print('SmsProcessingService: WorkManager failed: $workManagerError');
        print('SmsProcessingService: Falling back to direct API call');
        
        // Fallback: Call API directly if WorkManager fails
        await _processApiCallDirectly(recordId, parsedResult);
        _processingRecordIds.remove(recordId);
      }
    } catch (e) {
      print('SmsProcessingService: Error in API processing queue: $e');
      _processingRecordIds.remove(recordId);
      // Update status to FAILED if everything fails
      await _dbService.updateSmsStatus(
        id: recordId,
        status: 'FAILED',
        errorMessage: 'Failed to process API call: $e',
      );
    }
  }

  /// Process API call directly (fallback when WorkManager is not available)
  static Future<void> _processApiCallDirectly(
    int recordId,
    ParsedSmsResult parsedResult,
  ) async {
    try {
      print('SmsProcessingService: Processing API call directly for record $recordId');
      
      // Make API call directly
      final apiResponse = await SmsApiService.sendPaymentTrigger(parsedResult);

      // Update database with result
      await _dbService.updateSmsStatus(
        id: recordId,
        status: apiResponse.success ? 'SUCCESS' : 'FAILED',
        errorMessage: apiResponse.success ? null : apiResponse.message,
        apiStatusCode: apiResponse.statusCode,
      );

      print('SmsProcessingService: Direct API call completed for record $recordId: ${apiResponse.success}');
    } catch (e) {
      print('SmsProcessingService: Error in direct API call: $e');
      await _dbService.updateSmsStatus(
        id: recordId,
        status: 'FAILED',
        errorMessage: 'Direct API call error: $e',
      );
    }
  }

  /// Process API call for SMS record
  static Future<void> processApiCall(Map<String, dynamic> inputData) async {
    final recordId = inputData['recordId'] as int;
    final dbService = SmsDatabaseService();

    // Check if already processed (WorkManager might retry)
    // Note: We check the processing set, but also verify in database to handle retries
    try {
      final existing = await dbService.getProcessedSmsById(recordId);
      if (existing != null) {
        // Extract status from either ProcessedSm object or Map
        String? status;
        if (existing is Map) {
          status = existing['status']?.toString();
        } else {
          try {
            status = (existing as dynamic).status?.toString();
          } catch (e) {
            // Try to get status from object
            status = null;
          }
        }
        
        if (status != null && (status == 'SUCCESS' || status == 'FAILED')) {
          print('SmsProcessingService: Record $recordId already has final status ($status), skipping duplicate processing');
          _processingRecordIds.remove(recordId);
          return;
        }
      }
    } catch (e) {
      print('SmsProcessingService: Error checking existing record: $e');
    }
    
    _processingRecordIds.add(recordId);

    try {
      // Create ParsedSmsResult from input data
      final parsedResult = ParsedSmsResult(
        isValid: true,
        command: inputData['command'] as String?,
        amount: inputData['amount'] as int?,
        service: inputData['service'] as String?,
        phone: inputData['phone'] as String?,
        sender: inputData['sender'] as String,
        originalMessage: '',
        timestamp: inputData['timestamp'] as int,
      );

      // Make API call
      final apiResponse = await SmsApiService.sendPaymentTrigger(parsedResult);

      // Update database with result
      await dbService.updateSmsStatus(
        id: recordId,
        status: apiResponse.success ? 'SUCCESS' : 'FAILED',
        errorMessage: apiResponse.success ? null : apiResponse.message,
        apiStatusCode: apiResponse.statusCode,
      );

      print('API processing completed for record $recordId: ${apiResponse.success}');
    } catch (e) {
      print('Error in API processing: $e');
      await dbService.updateSmsStatus(
        id: recordId,
        status: 'FAILED',
        errorMessage: 'API processing error: $e',
      );
    } finally {
      _processingRecordIds.remove(recordId);
      await dbService.close();
    }
  }
}

/// Background callback dispatcher for WorkManager
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      if (task == SmsProcessingService.taskName && inputData != null) {
        await SmsProcessingService.processApiCall(
          Map<String, dynamic>.from(inputData),
        );
        return Future.value(true);
      }
      return Future.value(false);
    } catch (e) {
      print('Background task error: $e');
      return Future.value(false);
    }
  });
}

