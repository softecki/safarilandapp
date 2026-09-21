import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform, kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wicom/safari/safari_api.dart';

class SafariGoogleAuth {
  static GoogleSignIn? _client;
  static String? _webClientId;
  static String? _iosClientId;

  static Future<Map<String, dynamic>> loadConfig() async {
    final json = await SafariApi.get('/auth/google/config');
    return Map<String, dynamic>.from(SafariApi.data(json) as Map);
  }

  static Future<void> configure({required String webClientId, String? iosClientId}) async {
    final web = webClientId.trim();
    final ios = (iosClientId ?? '').trim();
    if (_client != null && _webClientId == web && _iosClientId == ios) return;
    _webClientId = web;
    _iosClientId = ios;
    String? clientId;
    if (kIsWeb) {
      clientId = web;
    } else if (defaultTargetPlatform == TargetPlatform.iOS && ios.isNotEmpty) {
      clientId = ios;
    }
    _client = GoogleSignIn(
      scopes: const ['email', 'profile'],
      clientId: clientId,
      serverClientId: kIsWeb || web.isEmpty ? null : web,
    );
  }

  /// Returns a Google ID token, or null if the user cancelled.
  static Future<String?> signIn() async {
    final config = await loadConfig();
    final enabled = config['enabled'] == true;
    final webClientId = config['web_client_id']?.toString() ?? '';
    if (!enabled || webClientId.isEmpty) {
      throw Exception('Google Sign-In is not enabled yet. Ask Safari Land to add the Web client ID in Settings.');
    }
    await configure(
      webClientId: webClientId,
      iosClientId: config['ios_client_id']?.toString(),
    );
    final client = _client;
    if (client == null) {
      throw Exception('Google Sign-In could not start.');
    }
    try {
      await client.signOut();
    } catch (_) {}
    final account = await client.signIn();
    if (account == null) return null;
    final auth = await account.authentication;
    final idToken = auth.idToken;
    if (idToken == null || idToken.isEmpty) {
      throw Exception('Google did not return an ID token. Confirm the Web client ID is set and try again.');
    }
    return idToken;
  }
}
