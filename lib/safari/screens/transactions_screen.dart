import 'package:flutter/material.dart';
import 'package:wicom/safari/safari_api.dart';
import 'package:wicom/safari/safari_nav.dart';
import 'package:wicom/safari/safari_theme.dart';
import 'package:wicom/safari/safari_ui.dart';
import 'package:wicom/safari/screens/ledger_detail_screen.dart';

class SafariTransactionsScreen extends StatefulWidget {
  const SafariTransactionsScreen({super.key});

  @override
  State<SafariTransactionsScreen> createState() => _SafariTransactionsScreenState();
}

class _SafariTransactionsScreenState extends State<SafariTransactionsScreen> {
  List items = [];
  bool loading = true;
  bool loadingMore = false;
  int page = 1;
  int lastPage = 1;
  DateTime? from;
  DateTime? to;
  String? ledgerType;

  @override
  void initState() {
    super.initState();
    _load(reset: true);
  }

  String _ymd(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> _load({bool reset = false}) async {
    if (reset) {
      page = 1;
      items = [];
      loading = true;
      if (mounted) setState(() {});
    } else {
      setState(() => loadingMore = true);
    }
    final params = <String, String>{
      'limit': '50',
      'page': '$page',
    };
    if (from != null) params['from'] = _ymd(from!);
    if (to != null) params['to'] = _ymd(to!);
    if (ledgerType != null) params['ledger_type'] = ledgerType!;
    final q = params.entries.map((e) => '${Uri.encodeQueryComponent(e.key)}=${Uri.encodeQueryComponent(e.value)}').join('&');
    try {
      final json = await SafariApi.get('/wallet/ledger?$q');
      final data = SafariApi.data(json) as Map? ?? {};
      final next = (data['items'] as List?) ?? [];
      lastPage = (data['last_page'] is num) ? (data['last_page'] as num).toInt() : 1;
      items = reset ? List.from(next) : [...items, ...next];
    } catch (e) {
      await safariError(context, e);
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
          loadingMore = false;
        });
      }
    }
  }

  Future<void> _pickDate({required bool isFrom}) async {
    final now = DateTime.now();
    final initial = isFrom ? (from ?? to ?? now) : (to ?? from ?? now);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: now,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: SafariTheme.maroon,
            onPrimary: Colors.white,
            surface: SafariTheme.cream,
          ),
        ),
        child: child!,
      ),
    );
    if (picked == null) return;
    setState(() {
      if (isFrom) {
        from = picked;
        if (to != null && to!.isBefore(from!)) to = from;
      } else {
        to = picked;
        if (from != null && from!.isAfter(to!)) from = to;
      }
    });
    await _load(reset: true);
  }

  void _setType(String? type) {
    if (ledgerType == type) return;
    setState(() => ledgerType = type);
    _load(reset: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: SafariCard(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Filter by date', style: TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: _dateField('From', from, () => _pickDate(isFrom: true))),
                      const SizedBox(width: 10),
                      Expanded(child: _dateField('To', to, () => _pickDate(isFrom: false))),
                    ],
                  ),
                  if (from != null || to != null) ...[
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            from = null;
                            to = null;
                          });
                          _load(reset: true);
                        },
                        child: const Text('Clear dates'),
                      ),
                    ),
                  ],
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 8,
                    children: [
                      _typeChip('All', null),
                      _typeChip('Commission', 'COMMISSION'),
                      _typeChip('Gratuity', 'GRATUITY'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    color: SafariTheme.gold,
                    onRefresh: () => _load(reset: true),
                    child: items.isEmpty
                        ? ListView(
                            children: const [
                              SafariEmpty('No commission or gratuity in this period.', icon: Icons.receipt_long_outlined),
                            ],
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
                            itemCount: items.length + (page < lastPage ? 1 : 0),
                            separatorBuilder: (_, __) => const SizedBox(height: 10),
                            itemBuilder: (_, i) {
                              if (i == items.length) {
                                return TextButton(
                                  onPressed: loadingMore
                                      ? null
                                      : () {
                                          page += 1;
                                          _load();
                                        },
                                  child: Text(loadingMore ? 'Loading…' : 'Load more'),
                                );
                              }
                              final row = Map<String, dynamic>.from(items[i] as Map);
                              return SafariLedgerCard(
                                row: row,
                                onTap: () => SafariNav.push(context, SafariLedgerDetailScreen(id: row['id'])),
                              );
                            },
                          ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _dateField(String label, DateTime? value, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: SafariTheme.canvas,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE8DCCB)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: SafariTheme.muted, fontSize: 11, fontWeight: FontWeight.w600)),
            const SizedBox(height: 2),
            Text(
              value == null ? 'Any' : safariDate(value.toIso8601String()),
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }

  Widget _typeChip(String label, String? value) {
    final on = ledgerType == value;
    return ChoiceChip(
      label: Text(label),
      selected: on,
      onSelected: (_) => _setType(value),
      selectedColor: SafariTheme.goldSoft,
      labelStyle: TextStyle(
        fontWeight: FontWeight.w700,
        color: on ? SafariTheme.maroonDark : SafariTheme.muted,
      ),
      side: BorderSide(color: on ? SafariTheme.gold : const Color(0xFFE8DCCB)),
    );
  }
}
