import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:wicom/faidabiz/faidabiz_api.dart';
import 'package:wicom/faidabiz/faidabiz_offline.dart';

/// Watches connectivity (Android + Flutter web) and syncs the offline outbox
/// whenever the network becomes available.
class FaidaBizNetworkSync {
  FaidaBizNetworkSync._();

  static StreamSubscription<List<ConnectivityResult>>? _sub;
  static bool _syncing = false;
  static bool _wasOffline = true;

  /// Start listening once at app boot.
  static Future<void> start() async {
    if (_sub != null) return;
    await FaidaBizOffline.load();

    // Initial state
    try {
      final current = await Connectivity().checkConnectivity();
      _wasOffline = _isDisconnected(current);
      if (!_wasOffline && FaidaBizApi.isLoggedIn) {
        unawaited(syncNow(reason: 'startup'));
      }
    } catch (_) {}

    _sub = Connectivity().onConnectivityChanged.listen((results) {
      final offline = _isDisconnected(results);
      if (_wasOffline && !offline) {
        // Network just came back
        unawaited(syncNow(reason: 'network_restored'));
      }
      if (!offline && FaidaBizOffline.isOffline.value && FaidaBizApi.isLoggedIn) {
        unawaited(syncNow(reason: 'online_while_offline_flag'));
      }
      _wasOffline = offline;
    });
  }

  static bool _isDisconnected(List<ConnectivityResult> results) {
    if (results.isEmpty) return true;
    return results.every((r) => r == ConnectivityResult.none);
  }

  /// Push queued offline writes, then mark online when successful.
  static Future<SyncResult> syncNow({String reason = 'manual'}) async {
    if (_syncing) return const SyncResult(synced: 0, failed: 0);
    if (!FaidaBizApi.isLoggedIn) return const SyncResult(synced: 0, failed: 0);

    _syncing = true;
    try {
      if (kDebugMode) {
        debugPrint('FaidaBizNetworkSync: syncing ($reason)');
      }
      final result = await FaidaBizApi.flushPendingSync();
      if (result.failed == 0) {
        await FaidaBizOffline.setOfflineMode(false);
      }
      return result;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('FaidaBizNetworkSync: sync failed — $e');
      }
      return const SyncResult(synced: 0, failed: 1);
    } finally {
      _syncing = false;
    }
  }

  static Future<void> stop() async {
    await _sub?.cancel();
    _sub = null;
  }
}
