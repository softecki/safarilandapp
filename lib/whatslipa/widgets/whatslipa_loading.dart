import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';
import 'package:wicom/whatslipa/widgets/whatslipa_branded_loader.dart';

/// Full-screen loading overlay with brand-aware UI (no URLs shown).
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
    _message.value = WhatsLipaLoaderMessages.sanitize(message);
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
          color: Colors.black.withValues(alpha: 0.45),
          child: Center(
            child: ValueListenableBuilder<String>(
              valueListenable: _message,
              builder: (_, msg, __) => WhatsLipaBrandedLoaderPanel(
                message: msg,
                showLogo: true,
                showBrandName: false,
              ),
            ),
          ),
        ),
      );
      overlay.insert(_entry!);
    });
  }

  static void update(String message) {
    final sanitized = WhatsLipaLoaderMessages.sanitize(message);
    _afterFrame(() {
      if (_message.value == sanitized && _entry != null) {
        _entry!.markNeedsBuild();
        return;
      }
      _message.value = sanitized;
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
