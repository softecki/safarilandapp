import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:wicom/core/whatslipa_api.dart';
import 'package:wicom/core/whatslipa_config.dart';
import 'package:wicom/whatslipa/screens/whatslipa_customer_profile_screen.dart';
import 'package:wicom/whatslipa/widgets/whatslipa_template_bubble.dart';
import 'package:wicom/whatslipa/widgets/whatslipa_theme.dart';

/// WhatsApp-style inbox with live search, unread badges, media send/view.
class WhatsLipaWhatsappScreen extends StatefulWidget {
  const WhatsLipaWhatsappScreen({super.key});

  @override
  State<WhatsLipaWhatsappScreen> createState() => _WhatsLipaWhatsappScreenState();
}

class _WhatsLipaWhatsappScreenState extends State<WhatsLipaWhatsappScreen> {
  List<dynamic> _chats = [];
  bool _loading = true;
  final _searchCtrl = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(_onSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _loadChats();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (mounted) {
        setState(() {});
        _loadChats(silent: true);
      }
    });
  }

  Future<void> _loadChats({bool silent = false}) async {
    if (!silent) setState(() => _loading = true);
    await WhatsLipaConfig.ensurePortalLoaded();
    try {
      final q = _searchCtrl.text.trim();
      _chats = await WhatsLipaApi.chats(q: q.isEmpty ? null : q);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      }
    }
    if (mounted) setState(() => _loading = false);
  }

  void _openThread(Map<String, dynamic> chat) {
    final customer = Map<String, dynamic>.from(chat['customer'] as Map);
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => _WhatsLipaThreadScreen(
          customerId: customer['id'] as int,
          customerName: customer['name']?.toString() ?? customer['phone']?.toString() ?? 'Customer',
          customerPhone: customer['phone']?.toString() ?? '',
        ),
      ),
    ).then((_) => _loadChats(silent: true));
  }

  @override
  Widget build(BuildContext context) {
    final brand = WhatsLipaTheme.primary;

    return Scaffold(
      backgroundColor: const Color(0xFFECE5DD),
      appBar: WhatsLipaTheme.appBar(
        title: 'WhatsApp',
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: () => _loadChats()),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'Search name or phone',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchCtrl.clear();
                          _loadChats(silent: true);
                        },
                      )
                    : null,
                filled: true,
                fillColor: const Color(0xFFF0F2F5),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
              ),
            ),
          ),
          Expanded(
            child: _loading
                ? Center(child: CircularProgressIndicator(color: brand))
                : RefreshIndicator(
                    onRefresh: () => _loadChats(),
                    child: _chats.isEmpty
                        ? ListView(children: const [SizedBox(height: 80), Center(child: Text('No conversations yet'))])
                        : ListView.builder(
                            itemCount: _chats.length,
                            itemBuilder: (context, i) {
                              final chat = _chats[i] as Map<String, dynamic>;
                              final customer = Map<String, dynamic>.from(chat['customer'] as Map);
                              final latest = Map<String, dynamic>.from(chat['latest_message'] as Map);
                              final name = customer['name']?.toString() ?? customer['phone']?.toString() ?? '?';
                              final unread = (chat['has_unread'] == true) || ((chat['unread_count'] as int? ?? 0) > 0);
                              var preview = latest['message']?.toString() ?? '';
                              final mt = latest['media_type']?.toString();
                              if (mt == 'image') preview = '📷 Photo';
                              if (mt == 'video') preview = '🎬 Video';
                              if (mt == 'audio') preview = '🎵 Audio';
                              final time = latest['created_at']?.toString() ?? '';
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: const Color(0xFF25D366),
                                  child: Text(name.isNotEmpty ? name[0].toUpperCase() : '?', style: const TextStyle(color: Colors.white)),
                                ),
                                title: Text(
                                  name,
                                  style: TextStyle(
                                    fontWeight: unread ? FontWeight.w800 : FontWeight.w600,
                                  ),
                                ),
                                subtitle: Text(
                                  preview,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: unread ? FontWeight.w600 : FontWeight.normal,
                                    color: unread ? Colors.black87 : Colors.black54,
                                  ),
                                ),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(time.length > 16 ? time.substring(11, 16) : '', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                                    if (unread)
                                      Container(
                                        margin: const EdgeInsets.only(top: 4),
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF25D366),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          '${chat['unread_count'] ?? ''}',
                                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                  ],
                                ),
                                onTap: () => _openThread(chat),
                              );
                            },
                          ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _WhatsLipaThreadScreen extends StatefulWidget {
  const _WhatsLipaThreadScreen({
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
  });

  final int customerId;
  final String customerName;
  final String customerPhone;

  @override
  State<_WhatsLipaThreadScreen> createState() => _WhatsLipaThreadScreenState();
}

class _WhatsLipaThreadScreenState extends State<_WhatsLipaThreadScreen> {
  final _input = TextEditingController();
  final _picker = ImagePicker();
  Map<String, dynamic>? _thread;
  bool _loading = true;
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      await WhatsLipaApi.openChatThread(widget.customerId);
      _thread = await WhatsLipaApi.thread(widget.customerId);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _send() async {
    final text = _input.text.trim();
    if (text.isEmpty) return;
    setState(() => _sending = true);
    try {
      await WhatsLipaApi.sendChatMessage(widget.customerId, text);
      _input.clear();
      await _load();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
    if (mounted) setState(() => _sending = false);
  }

  Future<void> _sendMediaFile(String path, String mediaType) async {
    setState(() => _sending = true);
    try {
      await WhatsLipaApi.sendChatMedia(
        widget.customerId,
        filePath: path,
        mediaType: mediaType,
        caption: _input.text.trim().isEmpty ? null : _input.text.trim(),
      );
      _input.clear();
      await _load();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
    if (mounted) setState(() => _sending = false);
  }

  Future<void> _pickImage(ImageSource source) async {
    final file = await _picker.pickImage(
      source: source,
      imageQuality: 70,
      maxWidth: 1280,
      maxHeight: 1280,
    );
    if (file == null) return;
    await _sendMediaFile(file.path, 'image');
  }

  Future<void> _pickVideo(ImageSource source) async {
    final file = await _picker.pickVideo(
      source: source,
      maxDuration: const Duration(minutes: 3),
    );
    if (file == null) return;
    await _sendMediaFile(file.path, 'video');
  }

  void _showAttachMenu() {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.photo_library, color: WhatsLipaTheme.primary),
              title: const Text('Photo from gallery'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt, color: WhatsLipaTheme.primary),
              title: const Text('Take photo'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.video_library, color: WhatsLipaTheme.primary),
              title: const Text('Video from gallery'),
              onTap: () {
                Navigator.pop(ctx);
                _pickVideo(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: Icon(Icons.videocam, color: WhatsLipaTheme.primary),
              title: const Text('Record video'),
              onTap: () {
                Navigator.pop(ctx);
                _pickVideo(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _openMedia(Map<String, dynamic> msg) {
    final url = msg['media_url']?.toString();
    final type = msg['media_type']?.toString() ?? 'text';
    if (url == null || url.isEmpty) return;

    if (type == 'image') {
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (_) => _MediaViewScreen(
            title: 'Photo',
            child: InteractiveViewer(
              child: Image.network(url, fit: BoxFit.contain),
            ),
          ),
        ),
      );
      return;
    }

    if (type == 'video') {
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (_) => _VideoPlayerScreen(url: url),
        ),
      );
      return;
    }

    launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final days = (_thread?['days'] as List<dynamic>?) ?? [];
    final brand = WhatsLipaTheme.primary;

    return Scaffold(
      backgroundColor: const Color(0xFFECE5DD),
      appBar: WhatsLipaTheme.appBar(
        titleWidget: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => WhatsLipaCustomerProfileScreen(
                  customerId: widget.customerId,
                  name: widget.customerName,
                  phone: widget.customerPhone,
                ),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.customerName,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                widget.customerPhone,
                style: const TextStyle(fontSize: 12, color: Colors.white70),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _load),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _loading
                ? Center(child: CircularProgressIndicator(color: brand))
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: days.length,
                    itemBuilder: (context, di) {
                      final day = days[di] as Map<String, dynamic>;
                      final messages = day['messages'] as List<dynamic>;
                      return Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(day['label']?.toString() ?? day['date']?.toString() ?? '', style: const TextStyle(fontSize: 11)),
                          ),
                          ...messages.map((m) {
                            final msg = m as Map<String, dynamic>;
                            final outbound = msg['direction'] == 'outbound';
                            final read = msg['read'] == true;
                            final mediaUrl = msg['media_url']?.toString();
                            final mediaType = msg['media_type']?.toString();

                            Widget body;
                            if (mediaUrl != null && mediaUrl.isNotEmpty && mediaType == 'image') {
                              body = GestureDetector(
                                onTap: () => _openMedia(msg),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    mediaUrl,
                                    width: 200,
                                    height: 160,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 48),
                                  ),
                                ),
                              );
                            } else if (mediaUrl != null && mediaUrl.isNotEmpty && mediaType == 'video') {
                              body = GestureDetector(
                                onTap: () => _openMedia(msg),
                                child: Container(
                                  width: 200,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: Colors.black26,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.play_circle_fill, size: 48, color: WhatsLipaTheme.primary),
                                      const SizedBox(height: 4),
                                      const Text('Tap to play video', style: TextStyle(fontSize: 11)),
                                    ],
                                  ),
                                ),
                              );
                            } else if (mediaUrl != null && mediaUrl.isNotEmpty) {
                              body = InkWell(
                                onTap: () => _openMedia(msg),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(mediaType == 'audio' ? Icons.audiotrack : Icons.videocam, size: 18),
                                    const SizedBox(width: 6),
                                    Flexible(child: Text(msg['message']?.toString() ?? 'Open media', style: const TextStyle(fontSize: 14))),
                                  ],
                                ),
                              );
                            } else {
                              final text = msg['message']?.toString() ?? '';
                              if (WhatsLipaTemplateBubble.isTemplateMessage(text)) {
                                body = WhatsLipaTemplateBubble(message: text, outbound: outbound);
                              } else {
                                body = Text(text, style: const TextStyle(fontSize: 14));
                              }
                            }

                            return Align(
                              alignment: outbound ? Alignment.centerRight : Alignment.centerLeft,
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 6),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
                                decoration: BoxDecoration(
                                  color: outbound ? const Color(0xFFD9FDD3) : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 2)],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    body,
                                    if (outbound)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 2),
                                        child: Icon(
                                          read ? Icons.done_all : Icons.done,
                                          size: 14,
                                          color: read ? Colors.blue : Colors.grey,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ],
                      );
                    },
                  ),
          ),
          Container(
            color: const Color(0xFFF0F2F5),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.attach_file), onPressed: _sending ? null : _showAttachMenu),
                Expanded(
                  child: TextField(
                    controller: _input,
                    decoration: InputDecoration(
                      hintText: 'Message',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                    minLines: 1,
                    maxLines: 4,
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: const Color(0xFF25D366),
                  child: IconButton(
                    icon: _sending
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.send, color: Colors.white),
                    onPressed: _sending ? null : _send,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MediaViewScreen extends StatelessWidget {
  const _MediaViewScreen({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final primary = WhatsLipaTheme.primary;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(title, style: const TextStyle(color: Colors.white)),
      ),
      body: Center(child: child),
    );
  }
}

class _VideoPlayerScreen extends StatefulWidget {
  const _VideoPlayerScreen({required this.url});

  final String url;

  @override
  State<_VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<_VideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _ready = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url))
      ..initialize().then((_) {
        if (mounted) setState(() => _ready = true);
        _controller.play();
      }).catchError((e) {
        if (mounted) setState(() => _error = e.toString());
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = WhatsLipaTheme.primary;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Video', style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: _error != null
            ? Padding(
                padding: const EdgeInsets.all(24),
                child: Text(_error!, style: const TextStyle(color: Colors.white), textAlign: TextAlign.center),
              )
            : !_ready
                ? const CircularProgressIndicator(color: Colors.white)
                : AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
      ),
      floatingActionButton: _ready
          ? FloatingActionButton(
              backgroundColor: primary,
              onPressed: () {
                setState(() {
                  _controller.value.isPlaying ? _controller.pause() : _controller.play();
                });
              },
              child: Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white),
            )
          : null,
    );
  }
}
