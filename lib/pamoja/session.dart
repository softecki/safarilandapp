import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wicom/pamoja/ops_api.dart';

class CatalogApp {
  CatalogApp({required this.slug, required this.name, required this.partner, required this.group, required this.status, this.description = ''});
  final String slug;
  final String name;
  final String partner;
  final String group;
  final String status;
  final String description;
}

class CatalogGroup {
  CatalogGroup({required this.name, required this.apps});
  final String name;
  final List<CatalogApp> apps;
}

class PamojaSession extends ChangeNotifier {
  PamojaSession._();
  static final PamojaSession instance = PamojaSession._();

  bool loggedIn = false;
  String lang = 'EN';
  String country = 'Tanzania';
  String city = 'Dar es Salaam';
  String firstName = 'Amina';
  String lastName = 'W. Kassim';
  String phone = '+254 754 000 184';
  String email = 'amina.kassim@pamoja.demo';
  String fanId = 'PEA-2027-001284';
  String nationality = 'Kenya';
  String fanStatus = 'Verified';
  int wallet = 84500;
  int points = 1240;
  String visaStatus = 'With Immigration';
  String group = '';
  String token = '';
  String prediction = '';
  String vote = '';
  String pulse = '';
  List<CatalogGroup> catalog = [];
  final List<Map<String, String>> messages = [];
  final List<String> likedPosts = [];

  String get fullName => '$firstName $lastName'.toUpperCase();
  String get greeting {
    final h = DateTime.now().hour;
    if (h < 12) return lang == 'SW' ? 'Habari za asubuhi' : 'Good morning';
    if (h < 17) return lang == 'SW' ? 'Habari za mchana' : 'Good afternoon';
    return lang == 'SW' ? 'Habari za jioni' : 'Good evening';
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    loggedIn = prefs.getBool('pamoja_logged_in') ?? false;
    lang = prefs.getString('pamoja_lang') ?? 'EN';
    token = prefs.getString('pamoja_token') ?? '';
    if (token.isNotEmpty) {
      try {
        final data = await OpsApi.me(token);
        applyFan(Map<String, dynamic>.from(data['fan'] as Map), token);
        loggedIn = true;
      } catch (_) {}
    }
    await refreshCatalog();
    notifyListeners();
  }

  void applyFan(Map<String, dynamic> fan, [String? nextToken]) {
    fanId = '${fan['id'] ?? fanId}';
    nameFrom(fan['name']?.toString() ?? '', fan['firstName']?.toString(), fan['lastName']?.toString());
    email = '${fan['email'] ?? email}';
    phone = '${fan['phone'] ?? phone}';
    nationality = '${fan['nationality'] ?? nationality}';
    country = '${fan['country'] ?? country}';
    city = '${fan['city'] ?? city}';
    fanStatus = '${fan['status'] ?? fanStatus}';
    visaStatus = '${fan['visa'] ?? visaStatus}';
    group = '${fan['group'] ?? group}';
    wallet = _num(fan['wallet'], wallet);
    points = _num(fan['points'], points);
    if (nextToken != null) token = nextToken;
    notifyListeners();
  }

  void nameFrom(String name, String? first, String? last) {
    if (first != null && first.isNotEmpty) {
      firstName = first;
      lastName = last ?? lastName;
      return;
    }
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isNotEmpty) firstName = parts.first;
    if (parts.length > 1) lastName = parts.sublist(1).join(' ');
  }

  int _num(dynamic value, int fallback) {
    if (value is num) return value.toInt();
    return int.tryParse('${value ?? ''}'.replaceAll(RegExp(r'[^\d-]'), '')) ?? fallback;
  }

  Future<void> refreshCatalog() async {
    try {
      final data = await OpsApi.catalog(token.isEmpty ? null : token);
      catalog = (data['groups'] as List? ?? []).map((g) {
        final map = Map<String, dynamic>.from(g as Map);
        final apps = ((map['apps'] as List?) ?? []).map((a) {
          final app = Map<String, dynamic>.from(a as Map);
          return CatalogApp(
            slug: '${app['slug']}',
            name: '${app['name']}',
            partner: '${app['partner']}',
            group: '${app['group']}',
            status: '${app['status']}',
            description: '${app['description'] ?? ''}',
          );
        }).toList();
        return CatalogGroup(name: '${map['name']}', apps: apps);
      }).toList();
      notifyListeners();
    } catch (_) {}
  }

  Future<void> login() async {
    loggedIn = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('pamoja_logged_in', true);
    await prefs.setString('pamoja_token', token);
    await refreshCatalog();
    notifyListeners();
  }

  Future<void> logout() async {
    loggedIn = false;
    token = '';
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('pamoja_logged_in', false);
    await prefs.remove('pamoja_token');
    notifyListeners();
  }

  Future<void> setLang(String value) async {
    lang = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pamoja_lang', value);
    notifyListeners();
  }

  void topUp(int amount) {
    wallet += amount;
    notifyListeners();
    if (token.isNotEmpty) {
      OpsApi.walletMove(token, 'topup', amount).then((data) {
        if (data['fan'] is Map) applyFan(Map<String, dynamic>.from(data['fan'] as Map));
      }).catchError((_) => null);
    }
  }

  void pay(int amount) {
    wallet = (wallet - amount).clamp(0, 1 << 30);
    notifyListeners();
    if (token.isNotEmpty) {
      OpsApi.walletMove(token, 'pay', amount).then((data) {
        if (data['fan'] is Map) applyFan(Map<String, dynamic>.from(data['fan'] as Map));
      }).catchError((_) => null);
    }
  }

  void addPoints(int value) {
    points += value;
    notifyListeners();
  }

  void setPrediction(String value) {
    prediction = value;
    notifyListeners();
  }

  void setVote(String value) {
    vote = value;
    notifyListeners();
  }

  void setPulse(String value) {
    pulse = value;
    notifyListeners();
  }

  void like(String id) {
    if (likedPosts.contains(id)) {
      likedPosts.remove(id);
    } else {
      likedPosts.add(id);
    }
    notifyListeners();
  }
}
