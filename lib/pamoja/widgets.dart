import 'package:flutter/material.dart';
import 'package:wicom/pamoja/brand.dart';

class PamojaPill extends StatelessWidget {
  const PamojaPill(this.label, {super.key, this.tone = 'info'});
  final String label;
  final String tone;

  @override
  Widget build(BuildContext context) {
    final colors = switch (tone) {
      'ok' => (const Color(0xFFE6F6EC), PamojaBrand.success),
      'warn' => (const Color(0xFFFFF4DE), PamojaBrand.warning),
      'danger' => (const Color(0xFFFDECEC), PamojaBrand.danger),
      _ => (const Color(0xFFE7F6FB), PamojaBrand.info),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: colors.$1, borderRadius: BorderRadius.circular(999)),
      child: Text(label, style: TextStyle(color: colors.$2, fontSize: 11, fontWeight: FontWeight.w700)),
    );
  }
}

class PamojaCard extends StatelessWidget {
  const PamojaCard({super.key, required this.child, this.onTap, this.padding, this.color});
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final body = Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: PamojaBrand.border),
      ),
      child: child,
    );
    if (onTap == null) return body;
    return InkWell(onTap: onTap, borderRadius: BorderRadius.circular(16), child: body);
  }
}

class PamojaBackBar extends StatelessWidget {
  const PamojaBackBar({super.key, required this.title, this.subtitle, this.trailing, this.onBack});
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(8, 4, 16, 10),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            IconButton(
              onPressed: onBack ?? () => Navigator.maybePop(context),
              icon: const Icon(Icons.arrow_back_rounded, color: PamojaBrand.indigo),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w800, color: PamojaBrand.indigo, fontSize: 16)),
                  if (subtitle != null)
                    Text(subtitle!, style: const TextStyle(color: PamojaBrand.muted, fontSize: 11, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}

class PamojaRow extends StatelessWidget {
  const PamojaRow({super.key, required this.title, this.subtitle, this.trailing, this.onTap});
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: PamojaBrand.indigo)),
      subtitle: subtitle == null ? null : Text(subtitle!, style: const TextStyle(fontSize: 12, color: PamojaBrand.muted)),
      trailing: trailing ?? const Icon(Icons.chevron_right_rounded, color: PamojaBrand.muted),
    );
  }
}

class PamojaSearch extends StatelessWidget {
  const PamojaSearch({super.key, this.hint = 'Search matches, rides, visas, shops'});
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: PamojaBrand.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: PamojaBrand.muted, size: 20),
          const SizedBox(width: 8),
          Text(hint, style: const TextStyle(color: PamojaBrand.muted, fontSize: 13)),
        ],
      ),
    );
  }
}

void pamojaToast(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

Future<T?> pamojaSheet<T>(BuildContext context, {required String title, required Widget child}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (ctx) => Padding(
      padding: EdgeInsets.fromLTRB(20, 8, 20, 24 + MediaQuery.of(ctx).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: PamojaBrand.indigo)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    ),
  );
}

Future<bool> pamojaConfirm(
  BuildContext context, {
  required String title,
  required String message,
  String confirmLabel = 'Confirm',
  bool danger = false,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800, color: PamojaBrand.indigo)),
      content: Text(message),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(confirmLabel, style: TextStyle(color: danger ? PamojaBrand.danger : PamojaBrand.lake, fontWeight: FontWeight.w800)),
        ),
      ],
    ),
  );
  return result ?? false;
}

Future<T?> pushPamoja<T>(BuildContext context, Widget page) {
  return Navigator.of(context).push<T>(
    PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
      transitionDuration: const Duration(milliseconds: 220),
    ),
  );
}
