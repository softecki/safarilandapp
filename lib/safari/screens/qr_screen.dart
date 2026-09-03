import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wicom/safari/safari_api.dart';
import 'package:wicom/safari/safari_brand.dart';
import 'package:wicom/safari/safari_theme.dart';
import 'package:wicom/safari/safari_ui.dart';

class SafariQrScreen extends StatefulWidget {
  const SafariQrScreen({super.key});

  @override
  State<SafariQrScreen> createState() => _SafariQrScreenState();
}

class _SafariQrScreenState extends State<SafariQrScreen> {
  List assets = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final json = await SafariApi.get('/referral-assets');
      assets = List.from((SafariApi.data(json)['assets'] as List?) ?? []);
      assets.sort((a, b) {
        final ap = a is Map && (a['is_permanent'] == true || a['is_permanent'] == 1);
        final bp = b is Map && (b['is_permanent'] == true || b['is_permanent'] == 1);
        if (ap == bp) return 0;
        return ap ? -1 : 1;
      });
    } catch (e) {
      await safariError(context, e);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  String _url(Map a) {
    final url = a['url']?.toString();
    if (url != null && url.isNotEmpty) return url;
    return '${SafariApi.guestBase()}/g/${a['public_code']}';
  }

  Future<void> _add() async {
    const sources = ['VEHICLE', 'WHATSAPP', 'MOBILE', 'BUSINESS_CARD', 'HOTEL', 'FLYER', 'OTHER'];
    final source = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: SafariTheme.cream,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => ListView(
        children: sources.map((s) => ListTile(title: Text(s.replaceAll('_', ' ')), onTap: () => Navigator.pop(ctx, s))).toList(),
      ),
    );
    if (source == null) return;
    try {
      await SafariApi.post('/referral-assets', {'source_type': source});
      await _load();
    } catch (e) {
      await safariError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My QR'),
        actions: [
          IconButton(onPressed: _add, icon: const Icon(Icons.add_rounded)),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              color: SafariTheme.gold,
              onRefresh: () async {
                setState(() => loading = true);
                await _load();
              },
              child: assets.isEmpty
                  ? ListView(children: const [SafariEmpty('Create a QR so guests can open a shopping pass.', icon: Icons.qr_code_2)])
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
                      itemCount: assets.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, i) {
                        final a = assets[i] as Map;
                        final url = _url(a);
                        final permanent = a['is_permanent'] == true || a['is_permanent'] == 1;
                        return SafariCard(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Row(children: [
                              Expanded(
                                child: Text(
                                  permanent ? 'Permanent profile QR' : '${a['label'] ?? a['source_type']}',
                                  style: const TextStyle(fontWeight: FontWeight.w800),
                                ),
                              ),
                              SafariStatusChip(
                                permanent ? 'PERMANENT' : '${a['source_type']}',
                                tone: SafariChipTone.gold,
                              ),
                            ]),
                            const SizedBox(height: 12),
                            Center(
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                                child: QrImageView(
                                  data: url,
                                  size: permanent ? 280 : 168,
                                  backgroundColor: Colors.white,
                                  errorCorrectionLevel: QrErrorCorrectLevel.H,
                                  embeddedImage: permanent ? const AssetImage(SafariBrand.logoAsset) : null,
                                  embeddedImageStyle: permanent
                                      ? const QrEmbeddedImageStyle(size: Size(88, 88))
                                      : null,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(url, style: const TextStyle(fontSize: 12, color: SafariTheme.muted)),
                            Row(children: [
                              TextButton(onPressed: () => Clipboard.setData(ClipboardData(text: url)), child: const Text('Copy')),
                              TextButton(onPressed: () => Share.share(url), child: const Text('Share')),
                            ]),
                          ]),
                        );
                      },
                    ),
            ),
    );
  }
}
