import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wicom/safari/safari_brand.dart';
import 'package:wicom/safari/safari_theme.dart';

class SafariLogo extends StatelessWidget {
  const SafariLogo({
    super.key,
    this.height = 72,
    this.variant = SafariLogoVariant.wordmark,
  });

  final double height;
  final SafariLogoVariant variant;

  @override
  Widget build(BuildContext context) {
    final asset = variant == SafariLogoVariant.poster ? SafariBrand.posterAsset : SafariBrand.logoAsset;
    return Image.asset(
      asset,
      height: height,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      errorBuilder: (_, __, ___) => Text(
        SafariBrand.shortName.toUpperCase(),
        style: GoogleFonts.playfairDisplay(
          fontSize: height * 0.42,
          fontWeight: FontWeight.w700,
          color: variant == SafariLogoVariant.poster ? Colors.white : SafariTheme.black,
          letterSpacing: 2,
        ),
      ),
    );
  }
}

class SafariCard extends StatelessWidget {
  const SafariCard({super.key, required this.child, this.onTap, this.padding});
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final body = Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: SafariTheme.cream,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE8DCCB)),
      ),
      child: child,
    );
    if (onTap == null) return body;
    return Material(
      color: Colors.transparent,
      child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(22), child: body),
    );
  }
}

class SafariHero extends StatelessWidget {
  const SafariHero({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [SafariTheme.maroon, SafariTheme.maroonDark],
        ),
      ),
      child: DefaultTextStyle.merge(style: const TextStyle(color: Colors.white), child: child),
    );
  }
}

class SafariTagline extends StatelessWidget {
  const SafariTagline({super.key, this.light = false});
  final bool light;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          SafariBrand.tagline,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: light ? SafariTheme.goldSoft : SafariTheme.muted,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 3.2,
          ),
        ),
        const SizedBox(height: 10),
        Container(height: 1.2, width: 72, color: light ? SafariTheme.gold : SafariTheme.gold),
      ],
    );
  }
}

class SafariSectionTitle extends StatelessWidget {
  const SafariSectionTitle(this.text, {super.key, this.action, this.onAction});
  final String text;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.headlineSmall),
          ),
          if (action != null)
            TextButton(onPressed: onAction, child: Text(action!)),
        ],
      ),
    );
  }
}

class SafariStatusChip extends StatelessWidget {
  const SafariStatusChip(this.label, {super.key, this.tone = SafariChipTone.neutral});
  final String label;
  final SafariChipTone tone;

  @override
  Widget build(BuildContext context) {
    final colors = switch (tone) {
      SafariChipTone.success => (const Color(0xFF1F6B3A), const Color(0xFFE4F4EA)),
      SafariChipTone.warn => (const Color(0xFF8A5A12), const Color(0xFFF8EDD8)),
      SafariChipTone.danger => (const Color(0xFF8B1E1E), const Color(0xFFF8E4E4)),
      SafariChipTone.gold => (SafariTheme.maroonDark, SafariTheme.goldSoft),
      SafariChipTone.neutral => (SafariTheme.muted, const Color(0xFFF0EAE2)),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: colors.$2, borderRadius: BorderRadius.circular(999)),
      child: Text(label, style: TextStyle(color: colors.$1, fontWeight: FontWeight.w700, fontSize: 11, letterSpacing: 0.4)),
    );
  }
}

enum SafariChipTone { success, warn, danger, gold, neutral }

SafariChipTone statusTone(String? status) {
  switch ((status ?? '').toUpperCase()) {
    case 'ACTIVE':
    case 'PAID':
    case 'AVAILABLE':
    case 'APPROVED':
      return SafariChipTone.success;
    case 'PENDING':
    case 'REQUESTED':
    case 'PROCESSING':
    case 'PENDING_PROVIDER':
    case 'INITIATED':
      return SafariChipTone.warn;
    case 'FAILED':
    case 'REJECTED':
    case 'SUSPENDED':
    case 'CANCELLED':
      return SafariChipTone.danger;
    default:
      return SafariChipTone.neutral;
  }
}

class SafariEmpty extends StatelessWidget {
  const SafariEmpty(this.message, {super.key, this.icon = Icons.inbox_outlined});
  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28),
      child: Column(
        children: [
          Icon(icon, color: SafariTheme.gold, size: 36),
          const SizedBox(height: 10),
          Text(message, textAlign: TextAlign.center, style: const TextStyle(color: SafariTheme.muted)),
        ],
      ),
    );
  }
}

class SafariActionTile extends StatelessWidget {
  const SafariActionTile({super.key, required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SafariCard(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: SafariTheme.maroon.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: SafariTheme.maroon),
          ),
          const SizedBox(height: 10),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
        ],
      ),
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

enum SafariLogoVariant { wordmark, poster }
