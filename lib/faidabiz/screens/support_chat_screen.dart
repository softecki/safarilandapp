import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:wicom/faidabiz/faidabiz_api.dart';
import 'package:wicom/faidabiz/faidabiz_theme.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_chrome.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_loader.dart';

/// WhatsApp-style support chat: business owner ↔ platform admin.
class FaidaBizSupportChatScreen extends StatefulWidget {
  const FaidaBizSupportChatScreen({super.key});

  @override
  State<FaidaBizSupportChatScreen> createState() => _FaidaBizSupportChatScreenState();
}

class _FaidaBizSupportChatScreenState extends State<FaidaBizSupportChatScreen> {
  final _text = TextEditingController();
  final _scroll = ScrollController();
  final _picker = ImagePicker();
  List<Map<String, dynamic>> messages = [];
  bool loading = true;
  bool sending = false;
  String? error;
  Timer? _poll;

  @override
  void initState() {
    super.initState();
    _load(initial: true);
    _poll = Timer.periodic(const Duration(seconds: 8), (_) => _load(silent: true));
  }

  @override
  void dispose() {
    _poll?.cancel();
    _text.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _load({bool initial = false, bool silent = false}) async {
    if (initial) setState(() => loading = true);
    try {
      final res = await FaidaBizApi.get('/support-chat/messages');
      final list = (res['data'] as List?) ?? [];
      final next = list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      if (!mounted) return;
      final jumped = next.length != messages.length;
      setState(() {
        messages = next;
        loading = false;
        error = null;
      });
      await FaidaBizApi.post('/support-chat/read', {});
      if (jumped || initial) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scroll.hasClients) {
            _scroll.jumpTo(_scroll.position.maxScrollExtent);
          }
        });
      }
    } catch (e) {
      if (!silent && mounted) {
        setState(() {
          error = e.toString();
          loading = false;
        });
      }
    }
  }

  Future<void> _sendText() async {
    final body = _text.text.trim();
    if (body.isEmpty || sending) return;
    setState(() => sending = true);
    try {
      await FaidaBizApi.post('/support-chat/messages', {'body': body});
      _text.clear();
      await _load(silent: true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => sending = false);
    }
  }

  Future<void> _pickMedia({required bool video}) async {
    final x = video
        ? await _picker.pickVideo(source: ImageSource.gallery)
        : await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (x == null) return;
    setState(() => sending = true);
    try {
      final bytes = await x.readAsBytes();
      await FaidaBizApi.postMultipart(
        '/support-chat/messages/media',
        fileField: 'file',
        filePath: kIsWeb ? null : x.path,
        fileBytes: bytes,
        filename: x.name,
        fields: {
          'media_type': video ? 'video' : 'image',
          if (_text.text.trim().isNotEmpty) 'caption': _text.text.trim(),
        },
      );
      _text.clear();
      await _load(silent: true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const bubbleGreen = Color(0xFFDCF8C6);
    const bubbleWhite = Colors.white;
    const chatBg = Color(0xFFEFEAE2);

    return Scaffold(
      backgroundColor: chatBg,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('chat.title'.tr(), style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
            Text('chat.subtitle'.tr(), style: const TextStyle(fontSize: 11, color: Colors.white70)),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: loading
                ? FaidaBizLoader.body()
                : error != null && messages.isEmpty
                    ? Center(child: Text(error!, textAlign: TextAlign.center))
                    : messages.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Text(
                                'chat.empty'.tr(),
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey.shade700),
                              ),
                            ),
                          )
                        : ListView.builder(
                            controller: _scroll,
                            padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
                            itemCount: messages.length,
                            itemBuilder: (_, i) {
                              final m = messages[i];
                              final mine = m['mine'] == true || m['sender_type'] == 'business_user';
                              return _Bubble(
                                message: m,
                                mine: mine,
                                bubbleColor: mine ? bubbleGreen : bubbleWhite,
                              );
                            },
                          ),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(8, 8, 8, 8 + MediaQuery.of(context).padding.bottom),
            child: Row(
              children: [
                IconButton(
                  onPressed: sending ? null : () => _pickMedia(video: false),
                  icon: const Icon(Icons.image_outlined, color: FaidaBizTheme.green),
                  tooltip: 'chat.attach_image'.tr(),
                ),
                IconButton(
                  onPressed: sending ? null : () => _pickMedia(video: true),
                  icon: const Icon(Icons.videocam_outlined, color: FaidaBizTheme.green),
                  tooltip: 'chat.attach_video'.tr(),
                ),
                Expanded(
                  child: TextField(
                    controller: _text,
                    minLines: 1,
                    maxLines: 4,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: 'chat.placeholder'.tr(),
                      filled: true,
                      fillColor: const Color(0xFFF5F5F5),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(22),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (_) => _sendText(),
                  ),
                ),
                const SizedBox(width: 4),
                CircleAvatar(
                  backgroundColor: FaidaBizTheme.green,
                  child: sending
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : IconButton(
                          onPressed: _sendText,
                          icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
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

class _Bubble extends StatelessWidget {
  const _Bubble({
    required this.message,
    required this.mine,
    required this.bubbleColor,
  });

  final Map<String, dynamic> message;
  final bool mine;
  final Color bubbleColor;

  @override
  Widget build(BuildContext context) {
    final body = message['body']?.toString() ?? '';
    final mediaType = message['media_type']?.toString();
    final mediaUrl = message['media_url']?.toString();
    final time = _timeLabel(message['created_at']?.toString());

    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 6),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(14),
              topRight: const Radius.circular(14),
              bottomLeft: Radius.circular(mine ? 14 : 4),
              bottomRight: Radius.circular(mine ? 4 : 14),
            ),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 1)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (mediaType == 'image' && mediaUrl != null && mediaUrl.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    mediaUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 180,
                    errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                  ),
                ),
              if (mediaType == 'video' && mediaUrl != null && mediaUrl.isNotEmpty)
                _VideoThumb(url: mediaUrl),
              if (mediaType == 'file' && mediaUrl != null)
                Row(
                  children: [
                    const Icon(Icons.attach_file, size: 18),
                    const SizedBox(width: 6),
                    Expanded(child: Text(message['media_name']?.toString() ?? 'chat.file'.tr(), maxLines: 1, overflow: TextOverflow.ellipsis)),
                  ],
                ),
              if (body.isNotEmpty) ...[
                if (mediaType != null) const SizedBox(height: 6),
                Text(body, style: const TextStyle(fontSize: 15, height: 1.3, color: Color(0xFF111111))),
              ],
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerRight,
                child: Text(time, style: TextStyle(fontSize: 10.5, color: Colors.grey.shade700)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _timeLabel(String? raw) {
    if (raw == null || raw.isEmpty) return '';
    try {
      return DateFormat('HH:mm').format(DateTime.parse(raw).toLocal());
    } catch (_) {
      return '';
    }
  }
}

class _VideoThumb extends StatefulWidget {
  const _VideoThumb({required this.url});
  final String url;

  @override
  State<_VideoThumb> createState() => _VideoThumbState();
}

class _VideoThumbState extends State<_VideoThumb> {
  VideoPlayerController? _c;
  bool ready = false;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) return;
    _c = VideoPlayerController.networkUrl(Uri.parse(widget.url))
      ..initialize().then((_) {
        if (mounted) setState(() => ready = true);
      }).catchError((_) {});
  }

  @override
  void dispose() {
    _c?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return InkWell(
        onTap: () {},
        child: Container(
          height: 140,
          width: double.infinity,
          alignment: Alignment.center,
          color: Colors.black12,
          child: const Icon(Icons.play_circle_fill, size: 48, color: FaidaBizTheme.green),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        if (_c == null || !ready) return;
        setState(() {
          _c!.value.isPlaying ? _c!.pause() : _c!.play();
        });
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          height: 180,
          width: double.infinity,
          child: ready && _c != null
              ? Stack(
                  alignment: Alignment.center,
                  children: [
                    AspectRatio(aspectRatio: _c!.value.aspectRatio, child: VideoPlayer(_c!)),
                    if (!_c!.value.isPlaying)
                      const Icon(Icons.play_circle_fill, size: 48, color: Colors.white),
                  ],
                )
              : Container(color: Colors.black12, child: const Center(child: CircularProgressIndicator())),
        ),
      ),
    );
  }
}

// End of file
