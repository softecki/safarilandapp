import 'package:flutter/material.dart';
import 'package:wicom/safari/safari_api.dart';
import 'package:wicom/safari/safari_shell.dart';
import 'package:wicom/safari/screens/guest_screen.dart';
import 'package:wicom/safari/screens/pending_screen.dart';

class SafariGate {
  static bool get isGuest {
    final d = SafariApi.driver ?? {};
    final type = '${d['account_type'] ?? ''}'.toUpperCase();
    if (type == 'GUEST') return true;
    if (type == 'DRIVER') return false;
    return d['is_driver'] == false;
  }

  static Widget home() {
    if (isGuest) return const SafariGuestScreen();
    final status = (SafariApi.driver?['status'] ?? '').toString();
    return status == 'ACTIVE' ? const SafariShell() : const SafariPendingScreen();
  }
}
