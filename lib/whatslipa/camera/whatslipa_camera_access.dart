import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

enum WhatsLipaCameraAccessResult {
  granted,
  denied,
  permanentlyDenied,
}

/// Cross-platform camera permission helpers for QR scanning.
class WhatsLipaCameraAccess {
  WhatsLipaCameraAccess._();

  static Future<WhatsLipaCameraAccessResult> status() async {
    if (kIsWeb) return WhatsLipaCameraAccessResult.granted;

    final permission = await Permission.camera.status;
    return _map(permission);
  }

  static Future<WhatsLipaCameraAccessResult> request() async {
    if (kIsWeb) return WhatsLipaCameraAccessResult.granted;

    final permission = await Permission.camera.request();
    return _map(permission);
  }

  static Future<void> openSettings() => openAppSettings();

  static WhatsLipaCameraAccessResult _map(PermissionStatus permission) {
    if (permission.isGranted || permission.isLimited) {
      return WhatsLipaCameraAccessResult.granted;
    }
    if (permission.isPermanentlyDenied) {
      return WhatsLipaCameraAccessResult.permanentlyDenied;
    }
    return WhatsLipaCameraAccessResult.denied;
  }
}
