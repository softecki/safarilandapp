import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wicom/safari/safari_api.dart';
import 'package:wicom/safari/safari_ui.dart';

class SafariPassportScreen extends StatefulWidget {
  const SafariPassportScreen({super.key});

  @override
  State<SafariPassportScreen> createState() => _SafariPassportScreenState();
}

class _SafariPassportScreenState extends State<SafariPassportScreen> {
  Map<String, dynamic>? data;

  @override
  void initState() {
    super.initState();
    SafariApi.get('/passport').then((json) {
      data = Map<String, dynamic>.from(SafariApi.data(json) as Map);
      if (mounted) setState(() {});
    }).catchError((e) {
      safariError(context, e);
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final d = data?['driver'] as Map? ?? {};
    return Scaffold(
      appBar: AppBar(title: const Text('Guide Passport')),
      body: data == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                SafariHero(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('${d['name']}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                    Text('${d['member_no']} · ${data!['verified_rating'] ?? '—'} / 5'),
                    Text('${data!['verified_review_count'] ?? 0} verified reviews'),
                  ]),
                ),
                const SizedBox(height: 12),
                if (d['public_url'] != null)
                  ElevatedButton(onPressed: () => Share.share(d['public_url'].toString()), child: const Text('Share profile')),
              ],
            ),
    );
  }
}
