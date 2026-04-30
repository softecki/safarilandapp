// Web-specific implementation using dart:html
import 'dart:html' as html;
import 'package:flutter/foundation.dart';

class FontLoaderImpl {
  static Future<void> preloadFont(String fontFamily, List<String> fontUrls) async {
    for (String url in fontUrls) {
      try {
        final link = html.LinkElement()
          ..rel = 'preload'
          ..href = url
          ..as = 'font'
          ..type = 'font/woff2'
          ..crossOrigin = 'anonymous';
        
        html.document.head?.append(link);
        
        // Wait for font to load
        await Future.delayed(const Duration(milliseconds: 100));
      } catch (e) {
        debugPrint('Failed to preload font $fontFamily: $e');
      }
    }
  }

  static Future<void> forceFontRendering() async {
    try {
      // Create a temporary element to force font rendering
      final testElement = html.DivElement()
        ..style.fontFamily = 'Inter, -apple-system, BlinkMacSystemFont, sans-serif'
        ..style.position = 'absolute'
        ..style.left = '-9999px'
        ..style.visibility = 'hidden'
        ..text = 'Test';
      
      html.document.body?.append(testElement);
      
      // Force reflow
      testElement.offsetHeight;
      
      // Remove test element
      testElement.remove();
      
      await Future.delayed(const Duration(milliseconds: 50));
    } catch (e) {
      debugPrint('Font rendering test failed: $e');
    }
  }
}

