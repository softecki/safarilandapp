import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wicom/faidabiz/faidabiz_theme.dart';

/// Asks for delete reason + account password before soft-deleting.
Future<({String reason, String password})?> showFaidaBizDeleteDialog({
  required BuildContext context,
  required String title,
  String? itemLabel,
}) async {
  final reason = TextEditingController();
  final password = TextEditingController();
  String? error;

  final result = await showDialog<({String reason, String password})>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (ctx, setLocal) {
          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'delete.soft_hint'.tr(),
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700, height: 1.35),
                  ),
                  if (itemLabel != null && itemLabel.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(itemLabel, style: const TextStyle(fontWeight: FontWeight.w700)),
                  ],
                  const SizedBox(height: 14),
                  TextField(
                    controller: reason,
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: 'delete.reason'.tr(),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: password,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'delete.password'.tr(),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  if (error != null) ...[
                    const SizedBox(height: 10),
                    Text(error!, style: const TextStyle(color: Colors.red, fontSize: 13)),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: Text('delete.cancel'.tr())),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade700, foregroundColor: Colors.white),
                onPressed: () {
                  if (reason.text.trim().length < 3) {
                    setLocal(() => error = 'delete.reason_required'.tr());
                    return;
                  }
                  if (password.text.isEmpty) {
                    setLocal(() => error = 'delete.password_required'.tr());
                    return;
                  }
                  Navigator.pop(ctx, (reason: reason.text.trim(), password: password.text));
                },
                child: Text('delete.confirm'.tr()),
              ),
            ],
          );
        },
      );
    },
  );

  reason.dispose();
  password.dispose();
  return result;
}

Future<bool> confirmAndSoftDelete({
  required BuildContext context,
  required String title,
  String? itemLabel,
  required Future<void> Function(String reason, String password) onConfirm,
}) async {
  final creds = await showFaidaBizDeleteDialog(context: context, title: title, itemLabel: itemLabel);
  if (creds == null) return false;
  try {
    await onConfirm(creds.reason, creds.password);
    return true;
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red.shade700),
      );
    }
    return false;
  }
}

/// Style helper for delete buttons in lists.
Color get faidaBizDeleteColor => Colors.red.shade700;
