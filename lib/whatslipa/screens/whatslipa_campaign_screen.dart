import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:wicom/core/app_color.dart';
import 'package:wicom/core/whatslipa_api.dart';
import 'package:wicom/src/view/widgets/neumorphic_widgets.dart';
import 'package:wicom/whatslipa/widgets/whatslipa_theme.dart';

class WhatsLipaCampaignScreen extends StatefulWidget {
  const WhatsLipaCampaignScreen({super.key});

  @override
  State<WhatsLipaCampaignScreen> createState() => _WhatsLipaCampaignScreenState();
}

class _WhatsLipaCampaignScreenState extends State<WhatsLipaCampaignScreen> {
  List<dynamic> _campaigns = [];
  Map<String, dynamic>? _queueStatus;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      _campaigns = await WhatsLipaApi.campaignsList();
      try {
        _queueStatus = await WhatsLipaApi.campaignQueueStatus();
      } catch (_) {}
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _openComposer() async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute(builder: (_) => const _CampaignComposerScreen()),
    );
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final primary = WhatsLipaTheme.primary;

    return Scaffold(
      backgroundColor: AppColor.neumorphicBase,
      appBar: WhatsLipaTheme.appBar(title: 'Campaign'),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primary,
        onPressed: _openComposer,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: NeuScreenCanvas(
        child: _loading
          ? Center(child: CircularProgressIndicator(color: primary))
          : RefreshIndicator(
              color: primary,
              onRefresh: _load,
              child: ListView(
                children: [
                  if (_queueStatus != null) _QueueStatusCard(status: _queueStatus!),
                  if (_campaigns.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 80),
                      child: Center(child: Text('No campaigns yet.\nTap + to send a message.')),
                    )
                  else
                    ..._campaigns.map((c) {
                      final m = c as Map<String, dynamic>;
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        child: ListTile(
                          title: Text('${m['channel']?.toString().toUpperCase()} · ${m['status']}'),
                          subtitle: Text(m['message_preview']?.toString() ?? ''),
                          trailing: Text('${m['recipient_count'] ?? 0}'),
                        ),
                      );
                    }),
                ],
              ),
            ),
      ),
    );
  }
}

class _QueueStatusCard extends StatelessWidget {
  const _QueueStatusCard({required this.status});
  final Map<String, dynamic> status;

  @override
  Widget build(BuildContext context) {
    final active = status['active_campaign'] as Map<String, dynamic>?;
    final batch = status['batch_size'];
    final mins = status['batch_interval_minutes'];

    return Card(
      margin: const EdgeInsets.all(12),
      color: AppColor.neumorphicSurface,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Message queue', style: TextStyle(fontWeight: FontWeight.w800)),
            Text('Batches of $batch every $mins min', style: const TextStyle(fontSize: 12)),
            if (active != null) ...[
              const SizedBox(height: 8),
              Text('Active: #${active['id']} · ${active['status']} · ${active['recipient_count']} recipients'),
            ] else
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text('No active queue', style: TextStyle(color: Colors.black54)),
              ),
          ],
        ),
      ),
    );
  }
}

class _CampaignComposerScreen extends StatefulWidget {
  const _CampaignComposerScreen();

  @override
  State<_CampaignComposerScreen> createState() => _CampaignComposerScreenState();
}

class _CampaignComposerScreenState extends State<_CampaignComposerScreen> {
  final _messageCtrl = TextEditingController();
  String _channel = 'whatsapp';
  bool _sendToAll = true;
  List<dynamic> _customers = [];
  final Set<int> _selected = {};
  bool _loadingCustomers = true;
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _loadCustomers();
    _loadTemplates();
  }

  Future<void> _loadTemplates() async {
    try {
      final t = await WhatsLipaApi.campaignTemplates();
      final welcome = t['welcome_template'] as Map<String, dynamic>?;
      if (welcome != null) {
        _messageCtrl.text = 'Template: ${welcome['title'] ?? welcome['code']} (${welcome['meta_template_name']})';
      }
      if (_channel == 'sms' && t['default_sms'] != null) {
        _messageCtrl.text = t['default_sms'].toString();
      }
    } catch (_) {}
  }

  Future<void> _loadCustomers() async {
    try {
      _customers = await WhatsLipaApi.campaignCustomers();
    } catch (_) {}
    if (mounted) setState(() => _loadingCustomers = false);
  }

  Future<void> _send() async {
    final msg = _messageCtrl.text.trim();
    if (msg.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter a message')));
      return;
    }
    if (!_sendToAll && _selected.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Select at least one customer')));
      return;
    }
    setState(() => _sending = true);
    try {
      await WhatsLipaApi.createCampaign(
        channel: _channel,
        message: msg,
        sendToAll: _sendToAll,
        customerIds: _sendToAll ? null : _selected.toList(),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Campaign queued')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
    if (mounted) setState(() => _sending = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WhatsLipaTheme.appBar(title: 'New campaign'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'whatsapp', label: Text('WhatsApp')),
              ButtonSegment(value: 'sms', label: Text('SMS')),
            ],
            selected: {_channel},
            onSelectionChanged: (v) {
              setState(() => _channel = v.first);
              _loadTemplates();
            },
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _messageCtrl,
            maxLines: 6,
            decoration: const InputDecoration(
              labelText: 'Message',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Send to all customers'),
            value: _sendToAll,
            onChanged: (v) => setState(() => _sendToAll = v),
          ),
          if (!_sendToAll) ...[
            const Text('Select customers', style: TextStyle(fontWeight: FontWeight.w600)),
            if (_loadingCustomers)
              const Padding(padding: EdgeInsets.all(24), child: Center(child: CircularProgressIndicator()))
            else
              ..._customers.map((c) {
                final m = c as Map<String, dynamic>;
                final id = m['id'] as int;
                return CheckboxListTile(
                  value: _selected.contains(id),
                  onChanged: (v) {
                    setState(() {
                      if (v == true) {
                        _selected.add(id);
                      } else {
                        _selected.remove(id);
                      }
                    });
                  },
                  title: Text(m['name']?.toString() ?? ''),
                  subtitle: Text(m['phone']?.toString() ?? ''),
                );
              }),
          ],
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _sending ? null : _send,
            style: FilledButton.styleFrom(backgroundColor: WhatsLipaTheme.primary),
            child: _sending
                ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text('Queue campaign'),
          ),
        ],
      ),
    );
  }
}
