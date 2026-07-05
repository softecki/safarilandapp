import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wicom/core/whatslipa_api.dart';
import 'package:wicom/core/whatslipa_session.dart';

class WhatsLipaPortalScreen extends StatefulWidget {
  const WhatsLipaPortalScreen({
    super.key,
    required this.title,
    required this.path,
    this.external = false,
    this.showAppBar = true,
  });

  final String title;
  /// Relative path under portal (e.g. `orders`) or full external path (`/mobile`).
  final String path;
  final bool external;
  final bool showAppBar;

  @override
  State<WhatsLipaPortalScreen> createState() => _WhatsLipaPortalScreenState();
}

class _WhatsLipaPortalScreenState extends State<WhatsLipaPortalScreen> {
  WebViewController? _controller;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      String url;
      if (widget.external) {
        url = await WhatsLipaApi.createBridgeUrl(widget.path);
      } else {
        final prefix = await WhatsLipaSession.portalPrefix;
        var path = widget.path;
        if (!path.startsWith('$prefix/') && !path.startsWith('afm/') && !path.startsWith('sokofresh/')) {
          path = '$prefix/$path';
        }
        url = await WhatsLipaApi.createBridgeUrl(path);
      }
      final c = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageFinished: (_) {
              if (mounted) setState(() => _loading = false);
            },
            onWebResourceError: (e) {
              if (mounted) setState(() => _error = e.description);
            },
          ),
        )
        ..loadRequest(Uri.parse(url));
      setState(() {
        _controller = c;
        _loading = true;
        _error = null;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              title: Text(widget.title),
              backgroundColor: const Color(0xFF1B4332),
              foregroundColor: Colors.white,
            )
          : null,
      body: Stack(
        children: [
          if (_controller != null) WebViewWidget(controller: _controller!),
          if (_loading)
            const Center(child: CircularProgressIndicator(color: Color(0xFF25D366))),
          if (_error != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_error!, textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    FilledButton(onPressed: _init, child: const Text('Retry')),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
