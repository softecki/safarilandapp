import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wicom/faidabiz/faidabiz_api.dart';
import 'package:wicom/faidabiz/faidabiz_theme.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_chrome.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_activity_tile.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_date_filter.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_loader.dart';

class FaidaBizActivityScreen extends StatefulWidget {
  const FaidaBizActivityScreen({
    super.key,
    this.initialDate,
    this.filterType,
    this.title,
    this.showSignedAmounts = true,
  });

  /// Optional day filter (same as home). Null = all recent pages from API.
  final DateTime? initialDate;

  /// Filter by activity type: sale | expense | purchase. Null = all (e.g. Faida).
  final String? filterType;

  /// Optional AppBar title override (e.g. Historia ya miamala — Mauzo).
  final String? title;

  final bool showSignedAmounts;

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

  String get _appBarTitle {
    if (widget.title != null && widget.title!.isNotEmpty) return widget.title!;
    switch (widget.filterType) {
      case 'sale':
        return 'activity.history_sales'.tr();
      case 'expense':
        return 'activity.history_expenses'.tr();
      case 'purchase':
        return 'activity.history_purchases'.tr();
      default:
        return widget.filterType == null && widget.initialDate != null
            ? 'home.recent'.tr()
            : 'settings.activity'.tr();
    }
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
      if (widget.filterType != null && widget.filterType!.isNotEmpty) {
        query['type'] = widget.filterType!;
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
      backgroundColor: FaidaBizTheme.canvas,
      appBar: faidaBizAppBar(title: _appBarTitle),
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
                                return FaidaBizActivityTile(
                                  item: m,
                                  animateAmount: widget.showSignedAmounts,
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
