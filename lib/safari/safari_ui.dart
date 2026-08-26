import 'package:flutter/material.dart';
import 'package:wicom/safari/safari_theme.dart';

class SafariCard extends StatelessWidget {
  const SafariCard({super.key, required this.child, this.onTap});
  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final body = Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 16, offset: const Offset(0, 6))],
      ),
      child: child,
    );
    if (onTap == null) return body;
    return GestureDetector(onTap: onTap, child: body);
  }
}

class SafariHero extends StatelessWidget {
  const SafariHero({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [SafariTheme.greenDark, SafariTheme.green]),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: DefaultTextStyle.merge(style: const TextStyle(color: Colors.white), child: child),
    );
  }
}

Future<void> safariError(BuildContext context, Object e) async {
  final msg = e.toString().replaceFirst('Exception: ', '');
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}

String money(dynamic n) {
  final v = n is num ? n : int.tryParse('$n') ?? 0;
  return 'TZS ${v.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]},')}';
}
