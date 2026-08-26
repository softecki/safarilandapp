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
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFFE6DFD8)),
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
        color: SafariTheme.maroon,
        borderRadius: BorderRadius.all(Radius.circular(4)),
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
            color: light ? Colors.white : SafariTheme.black,
            fontSize: 11,
            fontWeight: FontWeight.w500,
            letterSpacing: 3.2,
          ),
        ),
        const SizedBox(height: 8),
        Container(height: 1, color: light ? Colors.white : SafariTheme.black),
      ],
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
