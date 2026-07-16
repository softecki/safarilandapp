import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wicom/faidabiz/faidabiz_api.dart';
import 'package:wicom/faidabiz/faidabiz_theme.dart';

class FaidaBizSettingsMigrationsScreen extends StatefulWidget {
  const FaidaBizSettingsMigrationsScreen({super.key});

  @override
  State<FaidaBizSettingsMigrationsScreen> createState() => _FaidaBizSettingsMigrationsScreenState();
}

class _FaidaBizSettingsMigrationsScreenState extends State<FaidaBizSettingsMigrationsScreen> {
  List<Map<String, dynamic>> _migrations = [];
  List<Map<String, dynamic>> _queries = [];
  List<dynamic>? _lastResults;
  String? _msg;
  String? _error;
  bool _loading = true;
  String? _running;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await FaidaBizApi.fetchMigrations();
      if (!mounted) return;
      setState(() {
        _migrations = data['migrations'];
        _queries = data['queries'];
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _run(String file, {required String kind}) async {
    setState(() {
      _running = file;
      _msg = null;
      _error = null;
      _lastResults = null;
    });
    try {
      final res = await FaidaBizApi.runMigrationSql(file: file, kind: kind);
      if (!mounted) return;
      setState(() {
        _msg = res['message']?.toString();
        _lastResults = res['results'] as List<dynamic>?;
      });
      if (kind == 'migration') await _load();
    } on FaidaBizApiException catch (e) {
      if (!mounted) return;
      setState(() => _error = e.message);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _running = null);
    }
  }

  String _label(Map<String, dynamic> item) {
    final file = item['file']?.toString() ?? '';
    if (file.contains('purchase_sales_funding') || file.contains('01_purchase')) {
      return 'settings.sql_purchase_funding'.tr();
    }
    if (file.contains('business_users') || file.contains('05_business')) {
      return 'settings.sql_business_users'.tr();
    }
    if (file.contains('02_verify_purchases')) return 'settings.sql_verify_purchases'.tr();
    if (file.contains('03_verify_expenses')) return 'settings.sql_verify_expenses'.tr();
    if (file.contains('04_verify_purchase')) return 'settings.sql_verify_links'.tr();
    if (file.contains('soft_delete')) return 'settings.sql_soft_delete'.tr();
    if (file.contains('expense_histories')) return 'settings.sql_expense_history'.tr();
    if (file.contains('support_chat')) return 'settings.sql_support_chat'.tr();
    if (file.contains('notebook') || file.contains('faidabiz')) return 'settings.sql_notebook'.tr();
    return file;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('settings.migrations'.tr())),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: FaidaBizTheme.green))
          : RefreshIndicator(
              onRefresh: _load,
              color: FaidaBizTheme.green,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text('settings.migrations_hint'.tr(), style: TextStyle(color: Colors.grey.shade700)),
                  if (_msg != null) ...[
                    const SizedBox(height: 12),
                    Text(_msg!, style: const TextStyle(color: FaidaBizTheme.green, fontWeight: FontWeight.w600)),
                  ],
                  if (_error != null) ...[
                    const SizedBox(height: 12),
                    Text(_error!, style: const TextStyle(color: Colors.red)),
                  ],
                  if (_lastResults != null && _lastResults!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text('settings.query_results'.tr(), style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 8),
                    ..._lastResults!.map((block) {
                      final b = block is Map ? Map<String, dynamic>.from(block) : <String, dynamic>{};
                      final type = b['type']?.toString() ?? '';
                      if (type == 'select') {
                        final rows = (b['rows'] as List?) ?? [];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${b['count'] ?? rows.length} row(s)', style: const TextStyle(fontWeight: FontWeight.w600)),
                                const SizedBox(height: 8),
                                if (rows.isEmpty)
                                  Text('settings.query_empty'.tr())
                                else
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Text(rows.take(20).map((r) => r.toString()).join('\n')),
                                  ),
                              ],
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                  ],
                  const SizedBox(height: 16),
                  Text('settings.migrations_section'.tr(), style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 8),
                  ..._migrations.map((m) => _SqlCard(
                        item: m,
                        label: _label(m),
                        running: _running == m['file'],
                        onRun: () => _run(m['file'].toString(), kind: 'migration'),
                      )),
                  const SizedBox(height: 16),
                  Text('settings.queries_section'.tr(), style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 4),
                  Text('settings.queries_hint'.tr(), style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                  const SizedBox(height: 8),
                  ..._queries.map((q) => _SqlCard(
                        item: q,
                        label: _label(q),
                        running: _running == q['file'],
                        onRun: () => _run(q['file'].toString(), kind: 'query'),
                      )),
                ],
              ),
            ),
    );
  }
}

class _SqlCard extends StatelessWidget {
  const _SqlCard({
    required this.item,
    required this.label,
    required this.running,
    required this.onRun,
  });

  final Map<String, dynamic> item;
  final String label;
  final bool running;
  final VoidCallback onRun;

  @override
  Widget build(BuildContext context) {
    final ran = item['ran'] == true;
    final sql = item['sql']?.toString() ?? '';
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
                      Text(item['file']?.toString() ?? '', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                      if (item['kind'] == 'migration')
                        Text(
                          ran ? 'settings.migration_ran'.tr() : 'settings.migration_pending'.tr(),
                          style: TextStyle(fontSize: 12, color: ran ? FaidaBizTheme.green : Colors.orange.shade800),
                        ),
                    ],
                  ),
                ),
                FilledButton(
                  onPressed: running ? null : onRun,
                  style: FilledButton.styleFrom(backgroundColor: FaidaBizTheme.green),
                  child: running
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : Text('settings.run_raw'.tr()),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: const Color(0xFF111111), borderRadius: BorderRadius.circular(8)),
              child: Text(
                sql.length > 600 ? '${sql.substring(0, 600)}…' : sql,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 11, color: Color(0xFFBBF7D0)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
