import 'package:flutter/material.dart';
import 'package:wicom/core/whatslipa_brand.dart';

/// Shows a centered scan-result popup with an X close control.
Future<void> showWhatsLipaScanResultDialog({
  required BuildContext context,
  required String message,
  bool success = true,
  String? title,
  String? detail,
  Color? accentColor,
}) {
  final accent = accentColor ?? WhatsLipaBrand.primary;
  final resolvedTitle = title ?? (success ? 'Scan recorded' : 'Scan failed');
  final iconColor = success ? Colors.green.shade700 : Colors.red.shade700;
  final icon = success ? Icons.check_circle_rounded : Icons.error_rounded;

  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (ctx) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 8, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  tooltip: 'Close',
                  onPressed: () => Navigator.of(ctx).pop(),
                  icon: const Icon(Icons.close),
                ),
              ),
              Icon(icon, size: 52, color: iconColor),
              const SizedBox(height: 12),
              Text(
                resolvedTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: accent,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                  ),
                ),
              ),
              if (detail != null && detail.trim().isNotEmpty) ...[
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Text(
                    detail,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: accent,
                      foregroundColor: WhatsLipaBrand.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text('OK'),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
