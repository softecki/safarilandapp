import 'dart:js_util' as js_util;

bool isGoogleMapsJsReady() {
  final google = js_util.getProperty(js_util.globalThis, 'google');
  if (google == null) {
    return false;
  }
  return js_util.hasProperty(google, 'maps');
}

String? readWebMapsAuthError() {
  final err = js_util.getProperty(js_util.globalThis, '__whatslipaMapsAuthError');
  return err?.toString();
}
