import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wicom/core/whatslipa_api.dart';
import 'package:wicom/whatslipa/widgets/whatslipa_theme.dart';

class WhatsLipaOrderDetailScreen extends StatefulWidget {
  const WhatsLipaOrderDetailScreen({super.key, required this.orderId});
  final int orderId;

  @override
  State<WhatsLipaOrderDetailScreen> createState() => _WhatsLipaOrderDetailScreenState();
}

class _WhatsLipaOrderDetailScreenState extends State<WhatsLipaOrderDetailScreen> {
  Map<String, dynamic>? _order;
  List<dynamic> _agents = [];
  List<dynamic> _catalogItems = [];
  List<dynamic> _catalogPackages = [];
  bool _loading = true;
  String? _selectedStatus;
  int? _selectedAgentId;
  int? _addItemId;
  bool _addIsPackage = true;
  final _addQtyCtrl = TextEditingController(text: '1');
  bool _addingItems = false;
  bool _sendingConfirmation = false;

  static const _statuses = ['New', 'Confirmed', 'Packing', 'Packed', 'On delivery', 'Delivered', 'Cancelled'];

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _addQtyCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      _order = await WhatsLipaApi.orderDetail(widget.orderId);
      _selectedStatus = _order?['status']?.toString();
      _selectedAgentId = _order?['assigned_to'] as int?;
      _agents = await WhatsLipaApi.deliveryAgents();
      final catalog = await WhatsLipaApi.orderCatalogItems();
      _catalogItems = List<dynamic>.from(catalog['items'] as List? ?? []);
      _catalogPackages = List<dynamic>.from(catalog['packages'] as List? ?? []);
      if (_catalogPackages.isNotEmpty) {
        _addItemId = _catalogPackages.first['id'] as int;
        _addIsPackage = true;
      } else if (_catalogItems.isNotEmpty) {
        _addItemId = _catalogItems.first['id'] as int;
        _addIsPackage = false;
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _call(String? phone) async {
    if (phone == null || phone.isEmpty) return;
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _saveStatus() async {
    if (_selectedStatus == null) return;
    try {
      await WhatsLipaApi.updateOrderStatus(widget.orderId, _selectedStatus!);
      await _load();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Status → $_selectedStatus')));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  Future<void> _addItems() async {
    if (_addItemId == null) return;
    final qty = double.tryParse(_addQtyCtrl.text.trim());
    if (qty == null || qty <= 0) return;
    setState(() => _addingItems = true);
    try {
      final line = _addIsPackage
          ? {'package_id': _addItemId, 'quantity': qty}
          : {'item_id': _addItemId, 'quantity': qty};
      await WhatsLipaApi.addOrderItems(widget.orderId, [line]);
      await _load();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Items added')));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
    if (mounted) setState(() => _addingItems = false);
  }

  Future<void> _sendConfirmation() async {
    setState(() => _sendingConfirmation = true);
    try {
      await WhatsLipaApi.sendOrderConfirmation(widget.orderId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Confirmation sent on WhatsApp')));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
    if (mounted) setState(() => _sendingConfirmation = false);
  }

  Future<void> _saveAssign() async {
    if (_selectedAgentId == null) return;
    try {
      await WhatsLipaApi.assignOrder(widget.orderId, _selectedAgentId!);
      await _load();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Delivery person assigned')));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = WhatsLipaTheme.primary;

    if (_loading) {
      return Scaffold(
        appBar: WhatsLipaTheme.appBar(title: 'Order #${widget.orderId}'),
        body: Center(child: CircularProgressIndicator(color: primary)),
      );
    }

    final o = _order!;
    final customer = o['customer'] as Map<String, dynamic>?;
    final phone = customer?['phone']?.toString() ?? '';
    final deliveryPerson = o['delivery_person'] as Map<String, dynamic>?;

    return Scaffold(
      appBar: WhatsLipaTheme.appBar(
        title: 'Order #${o['id']}',
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _load),
          if (phone.isNotEmpty) IconButton(icon: const Icon(Icons.phone), onPressed: () => _call(phone)),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Status: ${o['status']}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('${o['total_amount']} TZS · ${o['payment_method'] ?? '—'}'),
            const SizedBox(height: 16),
            Text('Customer', style: Theme.of(context).textTheme.titleSmall),
            Text('${customer?['name'] ?? ''}\n$phone'),
            if (deliveryPerson != null) ...[
              const SizedBox(height: 8),
              Text('Assigned: ${deliveryPerson['name']}', style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
            const SizedBox(height: 16),
            Text('Items', style: Theme.of(context).textTheme.titleSmall),
            Text(o['items_text']?.toString() ?? '—'),
            if (o['delivery_address'] != null) ...[
              const SizedBox(height: 16),
              Text('Delivery', style: Theme.of(context).textTheme.titleSmall),
              Text(o['delivery_address'].toString()),
            ],
            const SizedBox(height: 24),
            const Text('Update status', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedStatus,
              items: _statuses.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (v) => setState(() => _selectedStatus = v),
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 8),
            FilledButton(onPressed: _saveStatus, child: const Text('Update status')),
            const SizedBox(height: 24),
            const Text('Add items to order', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _addIsPackage ? 'package' : 'item',
              isExpanded: true,
              items: const [
                DropdownMenuItem(value: 'package', child: Text('Package')),
                DropdownMenuItem(value: 'item', child: Text('Item')),
              ],
              onChanged: (v) {
                setState(() {
                  _addIsPackage = v == 'package';
                  final list = _addIsPackage ? _catalogPackages : _catalogItems;
                  _addItemId = list.isNotEmpty ? list.first['id'] as int : null;
                });
              },
              decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Type'),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<int>(
              value: _addItemId,
              isExpanded: true,
              items: (_addIsPackage ? _catalogPackages : _catalogItems).map((e) {
                final m = e as Map<String, dynamic>;
                return DropdownMenuItem(
                  value: m['id'] as int,
                  child: Text(m['name']?.toString() ?? '', overflow: TextOverflow.ellipsis),
                );
              }).toList(),
              onChanged: (v) => setState(() => _addItemId = v),
              decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Product'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _addQtyCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Quantity', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _addingItems ? null : _addItems,
                child: _addingItems
                    ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Add to order'),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _sendingConfirmation ? null : _sendConfirmation,
              icon: const Icon(Icons.chat),
              label: _sendingConfirmation
                  ? const Text('Sending…')
                  : const Text('Send order confirmation (WhatsApp)'),
            ),
            if (_agents.isNotEmpty) ...[
              const SizedBox(height: 24),
              const Text('Assign delivery person', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                value: _selectedAgentId,
                items: _agents
                    .map((a) => DropdownMenuItem(
                          value: a['id'] as int,
                          child: Text(a['name']?.toString() ?? ''),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _selectedAgentId = v),
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 8),
              FilledButton(onPressed: _saveAssign, child: const Text('Assign & save')),
            ],
          ],
        ),
      ),
    );
  }
}
