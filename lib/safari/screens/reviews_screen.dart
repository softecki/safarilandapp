import 'package:flutter/material.dart';
import 'package:wicom/safari/safari_api.dart';
import 'package:wicom/safari/safari_ui.dart';

class SafariReviewsScreen extends StatefulWidget {
  const SafariReviewsScreen({super.key});

  @override
  State<SafariReviewsScreen> createState() => _SafariReviewsScreenState();
}

class _SafariReviewsScreenState extends State<SafariReviewsScreen> {
  List rows = [];

  @override
  void initState() {
    super.initState();
    SafariApi.get('/reviews').then((json) {
      rows = (SafariApi.data(json) as List?) ?? [];
      if (mounted) setState(() {});
    }).catchError((e) {
      safariError(context, e);
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reviews')),
      body: ListView(
        children: rows
            .map((r) => ListTile(
                  title: Text('Verified trip · ${r['overall']}/5'),
                  subtitle: Text(r['comment']?.toString() ?? ''),
                ))
            .toList(),
      ),
    );
  }
}
