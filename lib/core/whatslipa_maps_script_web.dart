import 'dart:async';

import 'package:web/web.dart' as web;
import 'package:wicom/core/whatslipa_maps_js_check_web.dart';
import 'package:wicom/core/whatslipa_maps_log.dart';

const _scriptId = 'whatslipa-google-maps-js';

Future<bool> ensureWebMapsScript(String apiKey) async {
  if (isGoogleMapsJsReady()) {
    WhatsLipaMapsLog.info('window.google.maps already available');
    return true;
  }

  final existing = web.document.getElementById(_scriptId);
  if (existing == null) {
    WhatsLipaMapsLog.info('Injecting Maps JavaScript API script tag…');
    final script = web.document.createElement('script') as web.HTMLScriptElement;
    script.id = _scriptId;
    script.async = true;
    script.defer = true;
    script.src = 'https://maps.googleapis.com/maps/api/js?key=${Uri.encodeComponent(apiKey)}';
    web.document.head?.appendChild(script);
  } else {
    WhatsLipaMapsLog.info('Maps script tag already in document; waiting for google.maps…');
  }

  for (var i = 0; i < 150; i++) {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    if (isGoogleMapsJsReady()) {
      return true;
    }
    final authErr = readWebMapsAuthError();
    if (authErr != null) {
      WhatsLipaMapsLog.error(authErr);
      return false;
    }
  }

  WhatsLipaMapsLog.warn('Timed out waiting for window.google.maps after 15s');
  return false;
}
