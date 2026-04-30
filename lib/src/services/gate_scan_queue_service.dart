import 'dart:convert';

import '../data/database_factory.dart';
import '../data/database_interface.dart';

class GateScanQueueService {
  static const table = 'gate_scan_queue';

  final DatabaseInterface _db = DatabaseFactory.instance;

  Future<void> initialize() async {
    await _db.initialize();
    await _db.execute('''
      CREATE TABLE IF NOT EXISTS $table (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        local_ref TEXT NOT NULL UNIQUE,
        scanned_at_device TEXT NOT NULL,
        qr_token TEXT NOT NULL,
        device_id TEXT,
        lat REAL,
        lng REAL,
        scan_type TEXT NOT NULL DEFAULT 'check_in',
        face_image_base64 TEXT,
        sync_status TEXT NOT NULL DEFAULT 'pending',
        pushed_at TEXT,
        ack_at TEXT,
        server_response_code INTEGER,
        server_response_payload TEXT,
        retry_count INTEGER NOT NULL DEFAULT 0,
        last_error TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');
    try {
      await _db.execute('ALTER TABLE $table ADD COLUMN face_image_base64 TEXT');
    } catch (_) {}
  }

  Future<void> enqueueScan({
    required String localRef,
    required String qrToken,
    required String scannedAtDevice,
    required String deviceId,
    double? lat,
    double? lng,
    String scanType = 'check_in',
    String? faceImageBase64,
  }) async {
    await initialize();
    final now = DateTime.now().toIso8601String();
    await _db.insert(
        table,
        {
          'local_ref': localRef,
          'scanned_at_device': scannedAtDevice,
          'qr_token': qrToken,
          'device_id': deviceId,
          'lat': lat,
          'lng': lng,
          'scan_type': scanType,
          'face_image_base64': faceImageBase64,
          'sync_status': 'pending',
          'created_at': now,
          'updated_at': now,
        },
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<List<Map<String, dynamic>>> pending({int limit = 100}) async {
    await initialize();
    return _db.rawQuery(
      'SELECT * FROM $table WHERE sync_status IN (?, ?) ORDER BY id ASC LIMIT ?',
      ['pending', 'ack_error', limit],
    );
  }

  Future<void> markSynced({
    required String localRef,
    required int statusCode,
    required Map<String, dynamic> payload,
  }) async {
    final now = DateTime.now().toIso8601String();
    await _db.update(
      table,
      {
        'sync_status': 'ack_ok',
        'pushed_at': now,
        'ack_at': now,
        'server_response_code': statusCode,
        'server_response_payload': jsonEncode(payload),
        'last_error': null,
        'updated_at': now,
      },
      where: 'local_ref = ?',
      whereArgs: [localRef],
    );
  }

  Future<void> markError({
    required String localRef,
    required String error,
    int? statusCode,
    Map<String, dynamic>? payload,
  }) async {
    final now = DateTime.now().toIso8601String();
    await _db.rawUpdate(
      'UPDATE $table SET sync_status=?, pushed_at=?, server_response_code=?, server_response_payload=?, retry_count=retry_count+1, last_error=?, updated_at=? WHERE local_ref=?',
      [
        'ack_error',
        now,
        statusCode,
        payload == null ? null : jsonEncode(payload),
        error,
        now,
        localRef,
      ],
    );
  }

  Future<List<Map<String, dynamic>>> allInRange({
    required DateTime from,
    required DateTime to,
  }) async {
    await initialize();
    return _db.rawQuery(
      'SELECT * FROM $table WHERE scanned_at_device >= ? AND scanned_at_device <= ? ORDER BY scanned_at_device ASC',
      [from.toIso8601String(), to.toIso8601String()],
    );
  }
}
