import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wicom/faidabiz/faidabiz_api.dart';
import 'package:wicom/faidabiz/faidabiz_network_sync.dart';
import 'package:wicom/faidabiz/faidabiz_offline.dart';
import 'package:wicom/faidabiz/faidabiz_theme.dart';

/// Compact banner when the app is in offline mode (Android + web).
class FaidaBizOfflineBanner extends StatelessWidget {
  const FaidaBizOfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: FaidaBizOffline.isOffline,
      builder: (context, offline, _) {
        if (!offline) return const SizedBox.shrink();
        return ValueListenableBuilder<int>(
          valueListenable: FaidaBizOffline.pendingCount,
          builder: (context, pending, _) {
            final left = FaidaBizOffline.remainingOfflineWindow;
            final hours = left == null ? 0 : left.inHours;
            return Material(
              color: const Color(0xFF1F2937),
              child: SafeArea(
                bottom: false,
                child: InkWell(
                  onTap: () async {
                    try {
                      await FaidaBizNetworkSync.syncNow(reason: 'banner_tap');
                      await FaidaBizApi.validateSession();
                    } catch (_) {}
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.cloud_off_outlined, color: Colors.white, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            pending > 0
                                ? '${'auth.offline_banner'.tr()} · ${'auth.offline_pending'.tr(args: ['$pending'])}'
                                : '${'auth.offline_banner'.tr()}${hours > 0 ? ' (~${hours}h)' : ''}',
                            style: const TextStyle(color: Colors.white, fontSize: 12, height: 1.25),
                          ),
                        ),
                        Text(
                          'common.retry'.tr(),
                          style: const TextStyle(
                            color: FaidaBizTheme.green,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
