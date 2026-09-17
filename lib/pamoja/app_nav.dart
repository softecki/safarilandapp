import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> pamojaNavigatorKey = GlobalKey<NavigatorState>();

VoidCallback? pamojaOnLogout;

void pamojaSignOutToLogin() {
  pamojaOnLogout?.call();
}
