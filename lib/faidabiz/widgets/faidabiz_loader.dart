import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:wicom/faidabiz/faidabiz_theme.dart';

/// FaidaBiz branded loader — use this everywhere instead of [CircularProgressIndicator].
///
/// Variants:
/// - [FaidaBizLoader.page] — full-screen / scaffold body
/// - [FaidaBizLoader.body] — centered section (lists, forms loading)
/// - [FaidaBizLoader.button] — compact white spinner for primary buttons
/// - [FaidaBizLoader.inline] — small green spinner for row/inline
/// - [FaidaBizLoader.splash] — white spinner for dark/green splash
class FaidaBizLoader extends StatefulWidget {
  const FaidaBizLoader({
    super.key,
    this.size = FaidaBizLoaderSize.body,
    this.message,
    this.color,
    this.showBrand = false,
  });

  final FaidaBizLoaderSize size;
  final String? message;
  final Color? color;
  final bool showBrand;

  /// Full scaffold / page body loading.
  static Widget page({String? message, bool showBrand = true}) => Center(
        child: FaidaBizLoader(
          size: FaidaBizLoaderSize.page,
          message: message,
          showBrand: showBrand,
        ),
      );

  /// Centered list/section loading.
  static Widget body({String? message}) => Center(
        child: FaidaBizLoader(
          size: FaidaBizLoaderSize.body,
          message: message,
        ),
      );

  /// Compact spinner for elevated buttons (white on green).
  static Widget button({Color color = Colors.white}) => FaidaBizLoader(
        size: FaidaBizLoaderSize.button,
        color: color,
      );

  /// Small green spinner for inline UI.
  static Widget inline({Color? color}) => FaidaBizLoader(
        size: FaidaBizLoaderSize.inline,
        color: color,
      );

  /// Splash / dark backdrop (white).
  static Widget splash({String? message, bool showBrand = true}) => Center(
        child: FaidaBizLoader(
          size: FaidaBizLoaderSize.splash,
          message: message,
          showBrand: showBrand,
          color: Colors.white,
        ),
      );

  @override
  State<FaidaBizLoader> createState() => _FaidaBizLoaderState();
}

enum FaidaBizLoaderSize { page, body, button, inline, splash }

class _FaidaBizLoaderState extends State<FaidaBizLoader> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  double get _diameter {
    switch (widget.size) {
      case FaidaBizLoaderSize.page:
        return 64;
      case FaidaBizLoaderSize.body:
        return 48;
      case FaidaBizLoaderSize.splash:
        return 56;
      case FaidaBizLoaderSize.button:
        return 22;
      case FaidaBizLoaderSize.inline:
        return 20;
    }
  }

  double get _stroke {
    switch (widget.size) {
      case FaidaBizLoaderSize.page:
      case FaidaBizLoaderSize.splash:
        return 3.5;
      case FaidaBizLoaderSize.body:
        return 3.2;
      case FaidaBizLoaderSize.button:
      case FaidaBizLoaderSize.inline:
        return 2.4;
    }
  }

  bool get _compact =>
      widget.size == FaidaBizLoaderSize.button || widget.size == FaidaBizLoaderSize.inline;

  @override
  Widget build(BuildContext context) {
    final color = widget.color ??
        (widget.size == FaidaBizLoaderSize.splash ? Colors.white : FaidaBizTheme.green);
    final soft = color.withValues(alpha: 0.18);

    final mark = AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        return SizedBox(
          width: _diameter,
          height: _diameter,
          child: CustomPaint(
            painter: _FaidaBizLoaderPainter(
              progress: _c.value,
              color: color,
              trackColor: soft,
              strokeWidth: _stroke,
              showMark: !_compact,
            ),
          ),
        );
      },
    );

    if (_compact) return mark;

    final isSplash = widget.size == FaidaBizLoaderSize.splash;
    final titleColor = isSplash ? Colors.white : FaidaBizTheme.black;
    final msgColor = isSplash ? Colors.white.withValues(alpha: 0.85) : const Color(0xFF666666);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showBrand) ...[
          Text(
            'FaidaBiz',
            style: TextStyle(
              fontSize: widget.size == FaidaBizLoaderSize.page || isSplash ? 22 : 18,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.6,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 16),
        ],
        mark,
        if (widget.message != null && widget.message!.trim().isNotEmpty) ...[
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              widget.message!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: msgColor,
                height: 1.35,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _FaidaBizLoaderPainter extends CustomPainter {
  _FaidaBizLoaderPainter({
    required this.progress,
    required this.color,
    required this.trackColor,
    required this.strokeWidth,
    required this.showMark,
  });

  final double progress;
  final Color color;
  final Color trackColor;
  final double strokeWidth;
  final bool showMark;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide - strokeWidth) / 2;

    final track = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final arc = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, track);

    // Sweeping arc (notebook “orbit”)
    final start = progress * math.pi * 2 - math.pi / 2;
    const sweep = math.pi * 1.15;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      start,
      sweep,
      false,
      arc,
    );

    if (!showMark) return;

    // Soft inner disc + “ledger” mark (two horizontal lines = notebook)
    final innerR = radius * 0.42;
    final fill = Paint()..color = color.withValues(alpha: 0.12);
    canvas.drawCircle(center, innerR, fill);

    final line = Paint()
      ..color = color
      ..strokeWidth = strokeWidth * 0.85
      ..strokeCap = StrokeCap.round;

    final w = innerR * 0.9;
    canvas.drawLine(
      Offset(center.dx - w, center.dy - innerR * 0.28),
      Offset(center.dx + w, center.dy - innerR * 0.28),
      line,
    );
    canvas.drawLine(
      Offset(center.dx - w, center.dy + innerR * 0.08),
      Offset(center.dx + w * 0.35, center.dy + innerR * 0.08),
      line,
    );
  }

  @override
  bool shouldRepaint(covariant _FaidaBizLoaderPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
