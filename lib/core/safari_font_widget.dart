import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:html' as html;

class SafariFontWidget extends StatelessWidget {
  final Widget child;
  final String? fontFamily;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;

  const SafariFontWidget({
    Key? key,
    required this.child,
    this.fontFamily,
    this.fontSize,
    this.fontWeight,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      return child;
    }

    return _SafariFontWrapper(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      child: child,
    );
  }
}

class _SafariFontWrapper extends StatefulWidget {
  final Widget child;
  final String? fontFamily;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;

  const _SafariFontWrapper({
    required this.child,
    this.fontFamily,
    this.fontSize,
    this.fontWeight,
    this.color,
  });

  @override
  _SafariFontWrapperState createState() => _SafariFontWrapperState();
}

class _SafariFontWrapperState extends State<_SafariFontWrapper> {
  bool _fontLoaded = false;

  @override
  void initState() {
    super.initState();
    _checkFontLoading();
  }

  void _checkFontLoading() {
    if (kIsWeb) {
      // Check if we're on Safari
      final userAgent = html.window.navigator.userAgent.toLowerCase();
      final isSafari = userAgent.contains('safari') && !userAgent.contains('chrome');
      
      if (isSafari) {
        _loadFontForSafari();
      } else {
        setState(() {
          _fontLoaded = true;
        });
      }
    } else {
      setState(() {
        _fontLoaded = true;
      });
    }
  }

  void _loadFontForSafari() {
    // Force font loading for Safari
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          _fontLoaded = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_fontLoaded) {
      return DefaultTextStyle(
        style: TextStyle(
          fontFamily: '-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif',
          fontSize: widget.fontSize,
          fontWeight: widget.fontWeight,
          color: widget.color,
        ),
        child: widget.child,
      );
    }

    return DefaultTextStyle(
      style: TextStyle(
        fontFamily: widget.fontFamily ?? 'Inter',
        fontSize: widget.fontSize,
        fontWeight: widget.fontWeight,
        color: widget.color,
      ),
      child: widget.child,
    );
  }
}

// Helper function to create Safari-compatible text styles
TextStyle createSafariTextStyle({
  String? fontFamily,
  double? fontSize,
  FontWeight? fontWeight,
  Color? color,
  double? height,
  double? letterSpacing,
}) {
  if (kIsWeb) {
    final userAgent = html.window.navigator.userAgent.toLowerCase();
    final isSafari = userAgent.contains('safari') && !userAgent.contains('chrome');
    
    if (isSafari) {
      // Use system fonts for Safari to avoid corruption
      return TextStyle(
        fontFamily: '-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif',
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        height: height,
        letterSpacing: letterSpacing,
      );
    }
  }

  // Use Google Fonts for other browsers
  return GoogleFonts.inter(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    height: height,
    letterSpacing: letterSpacing,
  );
}
