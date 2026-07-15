import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wicom/faidabiz/faidabiz_api.dart';
import 'package:wicom/faidabiz/faidabiz_theme.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_activity_tile.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_date_filter.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_loader.dart';

class FaidaBizActivityScreen extends StatefulWidget {
  const FaidaBizActivityScreen({super.key, this.initialDate});

  /// Optional day filter (same as home). Null = all recent pages from API.
  final DateTime? initialDate;

  @override
  State<FaidaBizActivityScreen> createState() => _FaidaBizActivityScreenState();
}

class _FaidaBizActivityScreenState extends State<FaidaBizActivityScreen> {
  List items = [];
  bool loading = true;
  String? error;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
    _load();
  }

  Future<void> _load() async {
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final query = <String, String>{};
      if (selectedDate != null) {
        query['date'] = faidaBizDateQuery(selectedDate!);
      }
      final res = await FaidaBizApi.get('/activity', query: query.isEmpty ? null : query);
      final page = res['data'];
      if (page is Map) {
        items = (page['data'] as List?) ?? [];
      } else if (page is List) {
        items = page;
      } else {
        items = [];
      }
    } catch (e) {
      error = e.toString();
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final n = DateTime.now();
    final today = DateTime(n.year, n.month, n.day);

    return Scaffold(
      appBar: AppBar(title: Text('settings.activity'.tr())),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: FaidaBizDateFilter(
              selected: selectedDate ?? today,
              onChanged: (d) {
                setState(() => selectedDate = d);
                _load();
              },
            ),
          ),
          Expanded(
            child: loading
                ? FaidaBizLoader.body()
                : error != null
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(error!, textAlign: TextAlign.center),
                            TextButton(onPressed: _load, child: Text('common.retry'.tr())),
                          ],
                        ),
                      )
                    : items.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Text(
                                'home.recent_empty'.tr(),
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _load,
                            color: FaidaBizTheme.green,
                            child: ListView.builder(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                              itemCount: items.length,
                              itemBuilder: (_, i) {
                                final m = Map<String, dynamic>.from(items[i] as Map);
                                return FaidaBizActivityTile(item: m);
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }
}
