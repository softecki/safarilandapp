import 'package:flutter/foundation.dart';

/// Delivery-route / maps diagnostics. On web uses [print] so logs appear in the
/// browser DevTools console even in release builds.
class WhatsLipaMapsLog {
  WhatsLipaMapsLog._();

  static final List<String> _buffer = [];
  static const int _maxLines = 40;

  static List<String> get recentLines => List.unmodifiable(_buffer);

  static void info(String message) => _log('INFO', message);

  static void warn(String message) => _log('WARN', message);

  static void error(String message, {Object? err, StackTrace? stack}) {
    final detail = err != null ? '$message | $err' : message;
    _log('ERROR', detail);
    if (stack != null) {
      _emit('ERROR', stack.toString());
    }
  }

  static void clear() => _buffer.clear();

  static void _log(String level, String message) {
    _emit(level, message);
  }

  static void _emit(String level, String message) {
    final line = '[WhatsLipa Maps][$level] $message';
    _buffer.add(line);
    if (_buffer.length > _maxLines) {
      _buffer.removeAt(0);
    }
    if (kIsWeb) {
      // ignore: avoid_print — intentional for browser DevTools on production web builds
      print(line);
    } else if (kDebugMode) {
      debugPrint(line);
    }
  }
}

/// Result of [initWhatsLipaGoogleMaps].
class WhatsLipaMapsInitResult {
  const WhatsLipaMapsInitResult({
    required this.keyPresent,
    required this.webPluginRegistered,
    this.error,
  });

  final bool keyPresent;
  final bool webPluginRegistered;
  final String? error;

  bool get ok => keyPresent && (!kIsWeb || webPluginRegistered);

  String get summary {
    if (!keyPresent) {
      return 'No Google Maps API key in app storage. Sign in online so the portal can sync GOOGLE_MAPS_API_KEY.';
    }
    if (kIsWeb && !webPluginRegistered) {
      return error ?? 'Web Maps plugin failed to register.';
    }
    if (kIsWeb) {
      return 'Web: key loaded. Ensure Maps JavaScript API is enabled (not only Android SDK) and this site is in HTTP referrer restrictions.';
    }
    return 'Maps key loaded for mobile.';
  }
}
