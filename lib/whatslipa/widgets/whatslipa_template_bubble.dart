import 'package:flutter/material.dart';

/// Renders outbound WhatsApp template messages like native template cards.
class WhatsLipaTemplateBubble extends StatelessWidget {
  const WhatsLipaTemplateBubble({super.key, required this.message, this.outbound = true});

  final String message;
  final bool outbound;

  static bool isTemplateMessage(String? text) {
    if (text == null || text.isEmpty) return false;
    return text.contains('WhatsApp template:') || text.contains('Meta name:');
  }

  static Map<String, String> parse(String text) {
    final lines = text.split('\n');
    String code = '';
    String meta = '';
    String lang = '';
    final content = <String>[];
    var inContent = false;

    for (final line in lines) {
      final t = line.trim();
      if (t.startsWith('WhatsApp template:')) {
        code = t.replaceAll('WhatsApp template:', '').replaceAll('«', '').replaceAll('»', '').trim();
      } else if (t.startsWith('Meta name:')) {
        final parts = t.replaceFirst('Meta name:', '').split('·');
        meta = parts.first.trim();
        if (parts.length > 1) {
          lang = parts[1].replaceAll('language:', '').trim();
        }
      } else if (t.startsWith('Content:')) {
        inContent = true;
        final rest = t.replaceFirst('Content:', '').trim();
        if (rest.isNotEmpty) content.add(rest);
      } else if (inContent && t.isNotEmpty) {
        content.add(t);
      }
    }

    return {
      'code': code,
      'meta': meta,
      'lang': lang,
      'body': content.join('\n'),
    };
  }

  @override
  Widget build(BuildContext context) {
    final p = parse(message);
    final buttons = _defaultButtons(p['code'] ?? '');

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Color(0xFFF7F8FA),
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: Row(
              children: [
                const Icon(Icons.verified, size: 16, color: Color(0xFF25D366)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    p['code']?.isNotEmpty == true ? p['code']! : 'Template',
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if ((p['body'] ?? '').isNotEmpty)
                  Text(p['body']!, style: const TextStyle(fontSize: 14, height: 1.35)),
                if (p['meta']?.isNotEmpty == true) ...[
                  const SizedBox(height: 8),
                  Text(
                    '${p['meta']}${p['lang']?.isNotEmpty == true ? ' · ${p['lang']}' : ''}',
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                  ),
                ],
              ],
            ),
          ),
          ...buttons.map((label) => Divider(height: 1, color: Colors.grey.shade300)),
          ...buttons.map(
            (label) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF027EB5),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<String> _defaultButtons(String code) {
    final c = code.toLowerCase();
    if (c.contains('welcome')) return ['View catalog', 'Chat with us'];
    if (c.contains('order_received') || c.contains('confirmation')) return ['Confirm order', 'Need help'];
    return ['Reply'];
  }
}
