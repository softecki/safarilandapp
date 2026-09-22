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
  Object? loadError;

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
      loadError = null;
    } catch (e) {
      loadError = e;
      if (!safariIsOffline(e)) {
        if (!context.mounted) return;
        await safariError(context, e);
      }
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  String _url(Map a) {
    final url = a['url']?.toString();
    if (url != null && url.isNotEmpty) return url;
    return '${SafariApi.guestBase()}/g/${a['public_code']}';
  }

  bool _permanent(Map a) => a['is_permanent'] == true || a['is_permanent'] == 1;
  bool _disabled(Map a) => '${a['status']}'.toUpperCase() == 'DISABLED';

  Future<void> _add() async {
    const sources = ['VEHICLE', 'WHATSAPP', 'MOBILE', 'BUSINESS_CARD', 'HOTEL', 'FLYER', 'OTHER'];
    final source = await safariSheet<String>(
      context,
      Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('New referral QR', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        const Text('Create a source-specific code. The permanent profile QR stays active.', style: TextStyle(color: SafariTheme.muted)),
        const SizedBox(height: 12),
        ...sources.map((s) => ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(s.replaceAll('_', ' ')),
              onTap: () => Navigator.pop(context, s),
            )),
      ]),
    );
    if (source == null) return;
    try {
      await SafariApi.post('/referral-assets', {'source_type': source});
      await _load();
    } catch (e) {
      if (!context.mounted) return;
      await safariError(context, e);
    }
  }

  Future<void> _disable(Map a) async {
    final ok = await safariSheet<bool>(
      context,
      Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Disable this QR?', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        const Text('Guests will no longer be able to open a shopping pass from this code. Your permanent QR stays active.', style: TextStyle(color: SafariTheme.muted)),
        const SizedBox(height: 16),
        ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Disable QR')),
      ]),
    );
    if (ok != true) return;
    try {
      await SafariApi.post('/referral-assets/${a['id']}/disable');
      await _load();
    } catch (e) {
      if (!context.mounted) return;
      await safariError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final permanent = assets.cast<dynamic>().whereType<Map>().cast<Map>().where(_permanent).toList();
    final others = assets.cast<dynamic>().whereType<Map>().cast<Map>().where((a) => !_permanent(a)).toList();
    final hero = permanent.isNotEmpty ? permanent.first : (others.isNotEmpty ? others.first : null);

    return Scaffold(
      appBar: Navigator.canPop(context) ? AppBar(title: const Text('My QR')) : null,
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : loadError != null
              ? SafariOffline(
                  onRetry: () {
                    setState(() {
                      loading = true;
                      loadError = null;
                    });
                    _load();
                  },
                )
          : RefreshIndicator(
              color: SafariTheme.wine,
              onRefresh: () async {
                setState(() => loading = true);
                await _load();
              },
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 88),
                children: [
                  Row(children: [
                    Expanded(child: Text('My QR', style: SafariTheme.display(size: 28))),
                    TextButton(onPressed: _add, child: const Text('Add source')),
                  ]),
                  const SizedBox(height: 6),
                  const Text('Your permanent code sits with scans and passes — share it, copy it, keep it with you.', style: TextStyle(color: SafariTheme.muted, fontSize: 13)),
                  const SizedBox(height: 8),
                  if (hero == null)
                    const SafariEmpty('Create a QR so guests can open a shopping pass.', icon: Icons.qr_code_2)
                  else
                    SafariCard(
                      child: Column(children: [
                        const Text('Permanent profile QR', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                        const SizedBox(height: 2),
                        const Text('Share this with every guest. It never expires.', style: TextStyle(color: SafariTheme.muted, fontSize: 12)),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(color: SafariTheme.sand, borderRadius: BorderRadius.circular(20)),
                          child: QrImageView(
                            data: _url(hero),
                            size: 180,
                            backgroundColor: Colors.white,
                            errorCorrectionLevel: QrErrorCorrectLevel.H,
                            embeddedImage: const AssetImage(SafariBrand.logoAsset),
                            embeddedImageStyle: const QrEmbeddedImageStyle(size: Size(48, 48)),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(_url(hero), textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: SafariTheme.muted)),
                        const SizedBox(height: 8),
                        Row(children: [
                          Expanded(child: SafariStatBox(value: qtyFmt(hero['scans']), label: 'Scans')),
                          const SizedBox(width: 8),
                          Expanded(child: SafariStatBox(value: qtyFmt(hero['pass_conversions']), label: 'Passes')),
                        ]),
                        const SizedBox(height: 8),
                        Row(children: [
                          TextButton(onPressed: () => Clipboard.setData(ClipboardData(text: _url(hero))), child: const Text('Copy')),
                          TextButton(onPressed: () => Share.share(_url(hero)), child: const Text('Share')),
                        ]),
                      ]),
                    ),
                  if (others.isNotEmpty) const SafariSectionTitle('Source QR codes'),
                  ...others.map((a) {
                    final url = _url(a);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: SafariCard(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(children: [
                            Expanded(child: Text('${a['label'] ?? a['source_type']}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
                            SafariStatusChip(_disabled(a) ? 'DISABLED' : '${a['source_type']}', tone: _disabled(a) ? SafariChipTone.danger : SafariChipTone.gold),
                          ]),
                          const SizedBox(height: 10),
                          Center(
                            child: Opacity(
                              opacity: _disabled(a) ? 0.35 : 1,
                              child: QrImageView(data: url, size: 110, backgroundColor: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(children: [
                            Expanded(child: SafariStatBox(value: qtyFmt(a['scans']), label: 'Scans')),
                            const SizedBox(width: 8),
                            Expanded(child: SafariStatBox(value: qtyFmt(a['pass_conversions']), label: 'Passes')),
                          ]),
                          Row(children: [
                            TextButton(onPressed: () => Clipboard.setData(ClipboardData(text: url)), child: const Text('Copy')),
                            TextButton(onPressed: () => Share.share(url), child: const Text('Share')),
                            if (!_disabled(a))
                              TextButton(onPressed: () => _disable(a), child: const Text('Disable')),
                          ]),
                        ]),
                      ),
                    );
                  }),
                ],
              ),
            ),
    );
  }
}
