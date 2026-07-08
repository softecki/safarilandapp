import 'package:flutter/material.dart';
import 'package:wicom/core/whatslipa_brand.dart';
import 'package:wicom/whatslipa/widgets/whatslipa_ui.dart';

/// User-facing loader messages — strips URLs and raw HTTP lines.
class WhatsLipaLoaderMessages {
  WhatsLipaLoaderMessages._();

  static final _urlPattern = RegExp(
    r'https?://\S+|www\.\S+',
    caseSensitive: false,
  );

  static String sanitize(String raw) {
    final lines = raw.split('\n').map((l) => l.trim()).where((l) => l.isNotEmpty);
    final cleaned = <String>[];

    for (final line in lines) {
      final upper = line.toUpperCase();
      if (upper.startsWith('POST ') || upper.startsWith('GET ') || upper.startsWith('PUT ')) {
        continue;
      }
      if (_urlPattern.hasMatch(line) && line.replaceAll(_urlPattern, '').trim().isEmpty) {
        continue;
      }
      var text = line.replaceAll(_urlPattern, '').trim();
      if (text.endsWith('…') == false && text.endsWith('...') == false) {
        text = text.replaceAll(RegExp(r'\s{2,}'), ' ').trim();
      }
      if (text.isNotEmpty) cleaned.add(text);
    }

    if (cleaned.isEmpty) return 'Please wait…';
    return cleaned.join('\n');
  }
}

/// Branded spinner + logo + message for splash, overlays, and inline loaders.
class WhatsLipaBrandedLoaderPanel extends StatelessWidget {
  const WhatsLipaBrandedLoaderPanel({
    super.key,
    required this.message,
    this.compact = false,
    this.showLogo = true,
    this.showBrandName = false,
  });

  final String message;
  final bool compact;
  final bool showLogo;
  final bool showBrandName;

  @override
  Widget build(BuildContext context) {
    final isLotiGas = WhatsLipaBrand.isLotiGas;
    final displayMessage = WhatsLipaLoaderMessages.sanitize(message);
    final spinnerColor = isLotiGas ? WhatsLipaBrand.lotiGasBlack : WhatsLipaBrand.primary;
    final textColor = isLotiGas ? WhatsLipaBrand.lotiGasBlack : const Color(0xFF1A1A1A);

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showLogo && !compact) ...[
          WhatsLipaBrandLogo(size: isLotiGas ? 72 : 56),
          const SizedBox(height: 16),
        ],
        if (showBrandName && !compact) ...[
          Text(
            WhatsLipaBrand.name,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: textColor,
            ),
          ),
          const SizedBox(height: 6),
        ],
        SizedBox(
          width: compact ? 32 : 40,
          height: compact ? 32 : 40,
          child: CircularProgressIndicator(strokeWidth: 3, color: spinnerColor),
        ),
        if (displayMessage.isNotEmpty) ...[
          SizedBox(height: compact ? 14 : 18),
          Text(
            displayMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: compact ? 13 : 14,
              fontWeight: FontWeight.w600,
              color: textColor.withValues(alpha: isLotiGas ? 0.85 : 1),
              height: 1.4,
            ),
          ),
        ],
      ],
    );

    if (compact) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: content,
      );
    }

    return Container(
      width: 300,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      decoration: isLotiGas
          ? BoxDecoration(
              color: WhatsLipaBrand.lotiGasYellow,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: WhatsLipaBrand.lotiGasBlack.withValues(alpha: 0.12)),
              boxShadow: [
                BoxShadow(
                  color: WhatsLipaBrand.lotiGasBlack.withValues(alpha: 0.12),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            )
          : WhatsLipaUi.glassCard(),
      child: content,
    );
  }
}

/// Full-screen branded splash/loader scaffold.
class WhatsLipaBrandedLoaderScreen extends StatelessWidget {
  const WhatsLipaBrandedLoaderScreen({
    super.key,
    required this.message,
    this.showBrandName = true,
  });

  final String message;
  final bool showBrandName;

  @override
  Widget build(BuildContext context) {
    final isLotiGas = WhatsLipaBrand.isLotiGas;

    return Scaffold(
      backgroundColor: isLotiGas ? WhatsLipaBrand.lotiGasYellow : const Color(0xFFF7FBF8),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: WhatsLipaBrandedLoaderPanel(
            message: message,
            showLogo: true,
            showBrandName: showBrandName,
          ),
        ),
      ),
    );
  }
}
