import 'package:flutter/foundation.dart';
import 'package:wicom/core/whatslipa_local_db.dart';
import 'package:wicom/core/whatslipa_maps_log.dart';
import 'package:wicom/core/whatslipa_maps_script_stub.dart'
    if (dart.library.js_util) 'package:wicom/core/whatslipa_maps_script_web.dart';

/// Sync Maps API key from login/config. On web, injects the Maps JavaScript API script.
Future<WhatsLipaMapsInitResult> initWhatsLipaGoogleMaps() async {
  WhatsLipaMapsLog.info('initWhatsLipaGoogleMaps start (kIsWeb=$kIsWeb)');

  final key = await WhatsLipaLocalDb.getGoogleMapsApiKey();
  if (key == null || key.isEmpty) {
    WhatsLipaMapsLog.warn(
      'No API key in local storage — sign in online or set GOOGLE_MAPS_API_KEY on the Laravel portal.',
    );
    return const WhatsLipaMapsInitResult(
      keyPresent: false,
      webPluginRegistered: false,
    );
  }

  WhatsLipaMapsLog.info('API key present (${key.length} chars, prefix ${key.substring(0, key.length.clamp(0, 8))}…)');

  if (!kIsWeb) {
    WhatsLipaMapsLog.info('Native platform — use Maps SDK for Android/iOS (not JavaScript API).');
    return const WhatsLipaMapsInitResult(
      keyPresent: true,
      webPluginRegistered: true,
    );
  }

  try {
    final loaded = await ensureWebMapsScript(key);
    if (!loaded) {
      return const WhatsLipaMapsInitResult(
        keyPresent: true,
        webPluginRegistered: false,
        error: 'Maps JavaScript API script failed to load',
      );
    }
    WhatsLipaMapsLog.info('Maps JavaScript API ready (window.google.maps available)');
    WhatsLipaMapsLog.info(
      'If map tiles are blank: enable "Maps JavaScript API" in Google Cloud (Android SDK does not apply to web).',
    );
    WhatsLipaMapsLog.info(
      'Add HTTP referrer for this site, e.g. https://lotigasapp.softecki.com/*',
    );
    return const WhatsLipaMapsInitResult(
      keyPresent: true,
      webPluginRegistered: true,
    );
  } catch (e, st) {
    WhatsLipaMapsLog.error('Web Maps script injection failed', err: e, stack: st);
    return WhatsLipaMapsInitResult(
      keyPresent: true,
      webPluginRegistered: false,
      error: '$e',
    );
  }
}
