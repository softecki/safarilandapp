import 'package:flutter/foundation.dart';

// Conditional import: use web implementation on web, mobile stub otherwise
import 'font_loader_web.dart' if (dart.library.io) 'font_loader_mobile.dart' as loader;

class FontLoader {
  static bool _fontsLoaded = false;
  static bool _isLoading = false;

  /// Preload Google Fonts for Safari compatibility
  static Future<void> preloadFonts() async {
    if (_fontsLoaded || _isLoading) return;
    
    _isLoading = true;
    
    try {
      if (kIsWeb) {
        // Preload Inter font for Safari
        await loader.FontLoaderImpl.preloadFont('Inter', [
          'https://fonts.gstatic.com/s/inter/v12/UcCO3FwrK3iLTeHuS_fvQtMwCp50KnMw2boKoduKmMEVuLyfAZ9hiJ-Ek-_EeA.woff2'
        ]);
        
        // Preload Roboto font as fallback
        await loader.FontLoaderImpl.preloadFont('Roboto', [
          'https://fonts.gstatic.com/s/roboto/v30/KFOmCnqEu92Fr1Mu4mxK.woff2'
        ]);
        
        // Force font rendering for Safari
        await loader.FontLoaderImpl.forceFontRendering();
      } else {
        // Mobile platforms - use stub implementation (no-op)
        await loader.FontLoaderImpl.preloadFont('Inter', []);
        await loader.FontLoaderImpl.preloadFont('Roboto', []);
        await loader.FontLoaderImpl.forceFontRendering();
      }
      
      _fontsLoaded = true;
    } catch (e) {
      debugPrint('Font loading error: $e');
    } finally {
      _isLoading = false;
    }
  }

  /// Check if fonts are loaded
  static bool get fontsLoaded => _fontsLoaded;
}
