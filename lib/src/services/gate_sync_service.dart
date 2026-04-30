import '../../core/gate_access_api.dart';
import '../../core/gate_access_session.dart';
import 'gate_scan_queue_service.dart';

class GateSyncSummary {
  GateSyncSummary({
    required this.total,
    required this.succeeded,
    required this.failed,
    this.message,
    this.faceSummary,
  });

  final int total;
  final int succeeded;
  final int failed;
  final String? message;
  final String? faceSummary;
}

class GateSyncService {
  final GateScanQueueService _queue = GateScanQueueService();

  Future<GateSyncSummary> syncPending({String? latestLocalRef}) async {
    await _queue.initialize();
    final token = await GateAccessSession.scannerToken;
    if (token == null || token.isEmpty) {
      return GateSyncSummary(
          total: 0, succeeded: 0, failed: 0, message: 'No active gate session');
    }

    final pendingAll = await _queue.pending(limit: 200);
    final pending = (latestLocalRef == null || latestLocalRef.isEmpty)
        ? pendingAll
        : pendingAll
            .where((row) => row['local_ref']?.toString() == latestLocalRef)
            .toList();
    if (pending.isEmpty) {
      return GateSyncSummary(total: 0, succeeded: 0, failed: 0);
    }

    final records = pending
        .map((row) => {
              'local_ref': row['local_ref'],
              'scanned_at_device': row['scanned_at_device'],
              'qr_token': row['qr_token'],
              'device_id': row['device_id'],
              'lat': row['lat'],
              'lng': row['lng'],
              'scan_type': row['scan_type'] ?? 'check_in',
              'face_image_base64': row['face_image_base64'],
            })
        .toList();

    int succeeded = 0;
    int failed = 0;
    String? faceSummary;
    String? lastMessage;

    try {
      final response =
          await _pushBatchWithRetry(token: token, records: records);
      final results = (response['results'] as List<dynamic>? ?? []);

      for (final item in results) {
        final map = item as Map<String, dynamic>;
        final localRef = map['local_ref']?.toString() ?? '';
        final status = map['status']?.toString() ?? 'error';
        lastMessage = map['message']?.toString();
        if (localRef.isEmpty) continue;

        if (status == 'ok' || status == 'already_recorded') {
          await _queue.markSynced(
              localRef: localRef, statusCode: 200, payload: map);
          succeeded++;
        } else {
          await _queue.markError(
              localRef: localRef,
              error: map['message']?.toString() ?? 'Unknown error',
              statusCode: 422,
              payload: map);
          failed++;
        }

        final fv = map['face_verification'] as Map<String, dynamic>?;
        if (fv != null) {
          final matched = fv['matched'] == true;
          final similarity = fv['similarity']?.toString();
          faceSummary = matched
              ? 'Face matched${similarity != null ? ' ($similarity%)' : ''}.'
              : 'Face mismatch${similarity != null ? ' ($similarity%)' : '.'}';
        }
      }
    } on GateAccessApiException catch (e) {
      for (final row in pending) {
        await _queue.markError(
          localRef: row['local_ref'].toString(),
          error: e.message,
          statusCode: e.statusCode,
        );
      }
      failed = pending.length;
      return GateSyncSummary(
        total: pending.length,
        succeeded: succeeded,
        failed: failed,
        message: e.statusCode == 408
            ? 'Timeout after 3 attempts (45s each).'
            : e.message,
        faceSummary: faceSummary,
      );
    } catch (e) {
      for (final row in pending) {
        await _queue.markError(
            localRef: row['local_ref'].toString(), error: e.toString());
      }
      failed = pending.length;
      return GateSyncSummary(
        total: pending.length,
        succeeded: succeeded,
        failed: failed,
        message: e.toString(),
        faceSummary: faceSummary,
      );
    }

    return GateSyncSummary(
        total: pending.length,
        succeeded: succeeded,
        failed: failed,
        message: lastMessage,
        faceSummary: faceSummary);
  }

  Future<Map<String, dynamic>> _pushBatchWithRetry({
    required String token,
    required List<Map<String, dynamic>> records,
  }) async {
    GateAccessApiException? lastTimeoutError;
    for (var attempt = 1; attempt <= 3; attempt++) {
      try {
        return await GateAccessApi.pushBatch(
            scannerToken: token, records: records);
      } on GateAccessApiException catch (e) {
        if (e.statusCode == 408) {
          lastTimeoutError = e;
          if (attempt < 3) {
            continue;
          }
        }
        rethrow;
      }
    }
    throw lastTimeoutError ??
        GateAccessApiException(408, 'Timeout after 3 attempts.');
  }
}
