import 'package:wicom/safari/safari_api.dart';

class SafariPasses {
  static Future<Map<String, dynamic>> createTripWithPasses({
    required String label,
    required int guestCount,
  }) async {
    final json = await SafariApi.post('/trips', {
      'label': label,
      'guest_count': guestCount,
    });
    final trip = Map<String, dynamic>.from(SafariApi.data(json) as Map);
    final guests = (trip['guests'] as List?) ?? [];
    if (guests.length >= guestCount) return trip;

    for (var i = guests.length + 1; i <= guestCount; i++) {
      final passJson = await SafariApi.post('/passes', {
        'first_name': 'Guest $i',
        'last_name': label,
      });
      final pass = Map<String, dynamic>.from(SafariApi.data(passJson) as Map? ?? {});
      await SafariApi.post('/trips/${trip['id']}/guests', {
        'pass_code': pass['pass_code'] ?? pass['token'],
        'alias': 'Guest $i',
      });
    }
    return trip;
  }

  static Future<void> addPassToTrip(dynamic tripId, {String? firstName, String? groupName}) async {
    try {
      await SafariApi.post('/trips/$tripId/guests', {
        if (firstName != null && firstName.isNotEmpty) 'first_name': firstName,
      });
    } catch (_) {
      final passJson = await SafariApi.post('/passes', {
        'first_name': (firstName == null || firstName.isEmpty) ? 'Guest' : firstName,
        if (groupName != null && groupName.isNotEmpty) 'last_name': groupName,
      });
      final pass = Map<String, dynamic>.from(SafariApi.data(passJson) as Map? ?? {});
      await SafariApi.post('/trips/$tripId/guests', {
        'pass_code': pass['pass_code'] ?? pass['token'],
        if (firstName != null && firstName.isNotEmpty) 'alias': firstName,
      });
    }
  }

  static String urlFor(Map r) {
    final url = r['url']?.toString();
    if (url != null && url.isNotEmpty) return url;
    final code = (r['pass_code'] ?? r['token'] ?? '').toString();
    return code.isEmpty ? '' : '${SafariApi.guestBase()}/pass/$code';
  }
}
