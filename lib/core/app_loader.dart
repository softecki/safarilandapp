import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class AppLoader {
  static bool _isInitialized = false;
  static final Completer<void> _initCompleter = Completer<void>();
  
  /// Initialize the app with progressive loading
  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // Phase 1: Critical resources (immediate)
      await _loadCriticalResources();
      
      // Phase 2: Non-critical resources (background)
      _loadNonCriticalResources();
      
      _isInitialized = true;
      _initCompleter.complete();
    } catch (e) {
      debugPrint('App initialization failed: $e');
      _initCompleter.completeError(e);
    }
  }
  
  /// Load critical resources that are needed immediately
  static Future<void> _loadCriticalResources() async {
    // Load only essential resources
    debugPrint('Loading critical resources...');
    
    // Add any critical initialization here
    await Future.delayed(const Duration(milliseconds: 100));
  }
  
  /// Load non-critical resources in background
  static void _loadNonCriticalResources() {
    // Run in background without blocking
    Future.microtask(() async {
      try {
        debugPrint('Loading non-critical resources...');
        
        // Add non-critical initialization here
        await Future.delayed(const Duration(milliseconds: 500));
        
        debugPrint('Non-critical resources loaded');
      } catch (e) {
        debugPrint('Non-critical resources failed: $e');
      }
    });
  }
  
  /// Check if app is fully initialized
  static bool get isInitialized => _isInitialized;
  
  /// Wait for initialization to complete
  static Future<void> waitForInitialization() => _initCompleter.future;
}

/// Widget that shows loading state while app initializes
class AppLoadingWidget extends StatefulWidget {
  final Widget child;
  final Widget? loadingWidget;
  
  const AppLoadingWidget({
    Key? key,
    required this.child,
    this.loadingWidget,
  }) : super(key: key);
  
  @override
  _AppLoadingWidgetState createState() => _AppLoadingWidgetState();
}

class _AppLoadingWidgetState extends State<AppLoadingWidget> {
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _checkInitialization();
  }
  
  void _checkInitialization() async {
    try {
      await AppLoader.waitForInitialization();
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('App initialization error: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return widget.loadingWidget ?? const _DefaultLoadingWidget();
    }
    
    return widget.child;
  }
}

class _DefaultLoadingWidget extends StatelessWidget {
  const _DefaultLoadingWidget();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text(
              'Loading...',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
