import 'package:flutter/material.dart';
import 'package:wicom/faidabiz/faidabiz_theme.dart';

/// Full-bleed green→black landing atmosphere.
class FaidaBizLandingBackdrop extends StatelessWidget {
  const FaidaBizLandingBackdrop({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF166534),
                FaidaBizTheme.green,
                Color(0xFF0B1A12),
                FaidaBizTheme.black,
              ],
              stops: [0, 0.35, 0.7, 1],
            ),
          ),
        ),
        Positioned(
          top: -80,
          right: -60,
          child: Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.08),
            ),
          ),
        ),
        Positioned(
          bottom: 120,
          left: -40,
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: FaidaBizTheme.green.withOpacity(0.25),
            ),
          ),
        ),
        // Soft leaf-like bars
        Positioned(
          top: 160,
          left: 24,
          child: Transform.rotate(
            angle: -0.4,
            child: Container(
              width: 90,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.07),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
