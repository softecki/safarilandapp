import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:intl/intl.dart';
import 'package:wicom/core/app_color.dart';
import 'package:wicom/core/whatslipa_api.dart';
import 'package:wicom/src/view/widgets/neumorphic_widgets.dart';
import 'package:wicom/whatslipa/widgets/whatslipa_theme.dart';

class WhatsLipaReportsScreen extends StatefulWidget {
  const WhatsLipaReportsScreen({super.key});

  @override
  State<WhatsLipaReportsScreen> createState() => _WhatsLipaReportsScreenState();
}

class _WhatsLipaReportsScreenState extends State<WhatsLipaReportsScreen> {
  List<dynamic> _packages = [];
  List<dynamic> _history = [];
  final Map<String, TextEditingController> _agentQtyCtrls = {};
  final Map<String, TextEditingController> _customerQtyCtrls = {};
  final _commentCtrl = TextEditingController();
  DateTime _salesDate = DateTime.now();
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    for (final c in _agentQtyCtrls.values) {
      c.dispose();
    }
    for (final c in _customerQtyCtrls.values) {
      c.dispose();
    }
    _commentCtrl.dispose();
    super.dispose();
  }

  void _ensureControllers(List<dynamic> packages) {
    for (final p in packages) {
      if (p is! Map) continue;
      final id = '${Map<String, dynamic>.from(p)['id']}';
      _agentQtyCtrls.putIfAbsent(id, () => TextEditingController(text: '0'));
      _customerQtyCtrls.putIfAbsent(id, () => TextEditingController(text: '0'));
    }
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final form = await WhatsLipaApi.salesRecordPackages();
      _packages = form;
      _ensureControllers(_packages);

      final dateStr = DateFormat('yyyy-MM-dd').format(_salesDate);
      final data = await WhatsLipaApi.salesRecordForDate(dateStr);

      final agentQty = data['agent_quantities'];
      if (agentQty is Map) {
        for (final entry in Map<String, dynamic>.from(agentQty).entries) {
          _agentQtyCtrls[entry.key]?.text = entry.value.toString();
        }
      }
      final customerQty = data['customer_quantities'] ?? data['quantities'];
      if (customerQty is Map) {
        for (final entry in Map<String, dynamic>.from(customerQty).entries) {
          _customerQtyCtrls[entry.key]?.text = entry.value.toString();
        }
      }

      _commentCtrl.text = data['comment']?.toString() ?? '';
      _history = await WhatsLipaApi.salesRecordHistory();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _salesDate,
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _salesDate = picked);
      await _load();
    }
  }

  Map<String, int> _collectQuantities(Map<String, TextEditingController> ctrls) {
    final out = <String, int>{};
    for (final entry in ctrls.entries) {
      out[entry.key] = int.tryParse(entry.value.text) ?? 0;
    }
    return out;
  }

  Future<void> _submit() async {
    setState(() => _saving = true);
    try {
      await WhatsLipaApi.submitSalesRecord(
        salesDate: DateFormat('yyyy-MM-dd').format(_salesDate),
        agentQuantities: _collectQuantities(_agentQtyCtrls),
        customerQuantities: _collectQuantities(_customerQtyCtrls),
        comment: _commentCtrl.text.trim(),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Report saved')));
        await _load();
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
    if (mounted) setState(() => _saving = false);
  }

  Widget _productRow(Map<String, dynamic> m, TextEditingController ctrl, String priceLabel) {
    final id = '${m['id']}';
    final price = m['agent_price'] != null && priceLabel.contains('Agent')
        ? m['agent_price']
        : (m['customer_price'] ?? m['price']);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Neumorphic(
        style: NeumorphicStyle(
          depth: 3,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(m['name']?.toString() ?? '', style: const TextStyle(fontWeight: FontWeight.w600)),
                  if (price != null)
                    Text('$priceLabel: $price TZS', style: const TextStyle(fontSize: 12, color: AppColor.textSecondary)),
                ],
              ),
            ),
            SizedBox(
              width: 72,
              child: TextField(
                controller: ctrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Qty',
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = WhatsLipaTheme.primary;

    return Scaffold(
      backgroundColor: AppColor.neumorphicBase,
      appBar: WhatsLipaTheme.appBar(
        title: 'Daily sales report',
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: _load)],
      ),
      body: NeuScreenCanvas(
        child: _loading
            ? Center(child: CircularProgressIndicator(color: primary))
            : RefreshIndicator(
                color: primary,
                onRefresh: _load,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Neumorphic(
                      style: NeumorphicStyle(depth: 4, boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(14))),
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Sales date', style: TextStyle(fontWeight: FontWeight.w600)),
                                Text(DateFormat('EEEE, d MMMM yyyy').format(_salesDate)),
                              ],
                            ),
                          ),
                          OutlinedButton(onPressed: _pickDate, child: const Text('Change')),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('Products sold (agent price)', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: primary)),
                    const SizedBox(height: 4),
                    const Text(
                      'Sales to agents / resellers at agent price',
                      style: TextStyle(fontSize: 12, color: AppColor.textSecondary),
                    ),
                    const SizedBox(height: 8),
                    if (_packages.isEmpty)
                      const Text('No active products on server.', style: TextStyle(color: AppColor.textSecondary))
                    else
                      ..._packages.whereType<Map>().map((p) {
                        final m = Map<String, dynamic>.from(p);
                        return _productRow(m, _agentQtyCtrls['${m['id']}']!, 'Agent price');
                      }),
                    const SizedBox(height: 20),
                    const Text('Products sold (customer price)', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                    const SizedBox(height: 4),
                    const Text(
                      'Direct sales to customers at retail price',
                      style: TextStyle(fontSize: 12, color: AppColor.textSecondary),
                    ),
                    const SizedBox(height: 8),
                    if (_packages.isEmpty)
                      const SizedBox.shrink()
                    else
                      ..._packages.whereType<Map>().map((p) {
                        final m = Map<String, dynamic>.from(p);
                        return _productRow(m, _customerQtyCtrls['${m['id']}']!, 'Customer price');
                      }),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _commentCtrl,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Comment (optional)',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: AppColor.neumorphicSurface,
                      ),
                    ),
                    const SizedBox(height: 16),
                    NeuPrimaryButton(
                      label: 'Submit daily report',
                      icon: Icons.check_rounded,
                      loading: _saving,
                      onPressed: _saving ? null : _submit,
                    ),
                    if (_history.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      const Text('Recent reports', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                      const SizedBox(height: 8),
                      ..._history.whereType<Map>().map((r) {
                        final m = Map<String, dynamic>.from(r);
                        return ListTile(
                          title: Text(m['sales_date']?.toString() ?? ''),
                          trailing: Text('${m['total_qty'] ?? 0} units'),
                        );
                      }),
                    ],
                  ],
                ),
              ),
      ),
    );
  }
}
