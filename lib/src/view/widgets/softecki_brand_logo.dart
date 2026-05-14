import 'package:flutter/material.dart';
import 'package:wicom/generated/assets.dart';

/// Softecki wordmark on brand background (matches web/portal `logo.png`).
class SofteckiBrandLogo extends StatelessWidget {
  const SofteckiBrandLogo({super.key, this.height = 44});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Image.asset(
        Assets.imagesLogo,
        height: height,
        fit: BoxFit.contain,
      ),
    );
  }
}
