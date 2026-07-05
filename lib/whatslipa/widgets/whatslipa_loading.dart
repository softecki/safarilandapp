import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';
import 'package:wicom/core/whatslipa_brand.dart';
import 'package:wicom/whatslipa/widgets/whatslipa_ui.dart';

/// Full-screen loading overlay with status message (portal connect, login, fetch).
/// All overlay mutations are deferred until after the current frame (safe from initState).
class WhatsLipaLoading {
  WhatsLipaLoading._();

  static OverlayEntry? _entry;
  static final _message = ValueNotifier<String>('Please wait…');

  static bool get isShowing => _entry != null;

  static void _afterFrame(void Function() action) {
    final phase = SchedulerBinding.instance.schedulerPhase;
    if (phase == SchedulerPhase.idle) {
      action();
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => action());
  }

  static void show(BuildContext context, {String message = 'Please wait…'}) {
    _message.value = message;
    _afterFrame(() {
      if (!context.mounted) return;
      if (_entry != null) {
        _entry!.markNeedsBuild();
        return;
      }
      final overlay = Overlay.maybeOf(context, rootOverlay: true);
      if (overlay == null) return;

      _entry = OverlayEntry(
        builder: (ctx) => Material(
          color: Colors.black.withValues(alpha: 0.5),
          child: Center(
            child: ValueListenableBuilder<String>(
              valueListenable: _message,
              builder: (_, msg, __) => Container(
                width: 280,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                decoration: WhatsLipaUi.glassCard(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 42,
                      height: 42,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: WhatsLipaBrand.primary,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      msg,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      overlay.insert(_entry!);
    });
  }

  static void update(String message) {
    _afterFrame(() {
      if (_message.value == message && _entry != null) {
        _entry!.markNeedsBuild();
        return;
      }
      _message.value = message;
      _entry?.markNeedsBuild();
    });
  }

  static void hide() {
    _afterFrame(() {
      _entry?.remove();
      _entry = null;
    });
  }
}
