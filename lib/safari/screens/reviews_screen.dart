import 'package:flutter/material.dart';
import 'package:wicom/safari/safari_api.dart';
import 'package:wicom/safari/safari_theme.dart';
import 'package:wicom/safari/safari_ui.dart';

class SafariReviewsScreen extends StatefulWidget {
  const SafariReviewsScreen({super.key});

  @override
  State<SafariReviewsScreen> createState() => _SafariReviewsScreenState();
}

class _SafariReviewsScreenState extends State<SafariReviewsScreen> {
  List rows = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    SafariApi.get('/reviews').then((json) {
      rows = (SafariApi.data(json) as List?) ?? [];
      if (mounted) setState(() => loading = false);
    }).catchError((e) {
      safariError(context, e);
      if (mounted) setState(() => loading = false);
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reviews')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : rows.isEmpty
              ? const Center(child: SafariEmpty('No verified reviews yet.', icon: Icons.star_outline))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: rows.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) {
                    final r = rows[i] as Map;
                    return SafariCard(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Verified trip · ${r['overall']}/5', style: const TextStyle(fontWeight: FontWeight.w800)),
                        const SizedBox(height: 6),
                        Text(r['comment']?.toString() ?? '', style: const TextStyle(color: SafariTheme.muted)),
                      ]),
                    );
                  },
                ),
    );
  }
}
