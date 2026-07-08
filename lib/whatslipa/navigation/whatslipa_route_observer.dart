import 'package:flutter/material.dart';

/// Tracks route visibility so camera scanners pause when another screen is pushed on top.
final RouteObserver<ModalRoute<void>> whatsLipaRouteObserver = RouteObserver<ModalRoute<void>>();
