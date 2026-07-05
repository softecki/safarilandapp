import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wicom/core/app_color.dart';
import 'package:wicom/core/whatslipa_api.dart';
import 'package:wicom/src/view/widgets/neumorphic_widgets.dart';
import 'package:wicom/whatslipa/widgets/whatslipa_theme.dart';

class WhatsLipaCustomerProfileScreen extends StatefulWidget {
  const WhatsLipaCustomerProfileScreen({
    super.key,
    required this.customerId,
    this.name = '',
    this.phone = '',
  });

  final int customerId;
  final String name;
  final String phone;

  @override
  State<WhatsLipaCustomerProfileScreen> createState() => _WhatsLipaCustomerProfileScreenState();
}

class _WhatsLipaCustomerProfileScreenState extends State<WhatsLipaCustomerProfileScreen> {
  Map<String, dynamic>? _profile;
  bool _loading = true;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _loadError = null;
    });
    try {
      _profile = await WhatsLipaApi.customerProfile(widget.customerId);
    } catch (e) {
      _loadError = e.toString();
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _call(String? phone) async {
    if (phone == null || phone.isEmpty) return;
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final primary = WhatsLipaTheme.primary;
    final p = _profile;
    final name = p?['name']?.toString() ?? widget.name;
    final phone = p?['phone']?.toString() ?? widget.phone;

    return Scaffold(
      backgroundColor: AppColor.neumorphicBase,
      appBar: WhatsLipaTheme.appBar(title: 'Customer profile'),
      body: NeuScreenCanvas(
        child: _loading
            ? Center(child: CircularProgressIndicator(color: primary))
            : ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Neumorphic(
                    style: NeumorphicStyle(
                      depth: 6,
                      boxShape: const NeumorphicBoxShape.circle(),
                      color: primary,
                    ),
                    padding: const EdgeInsets.all(28),
                    child: Text(
                      name.isNotEmpty ? name[0].toUpperCase() : '?',
                      style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(name, textAlign: TextAlign.center, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Text(phone, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, color: AppColor.textSecondary)),
                  if (_loadError != null) ...[
                    const SizedBox(height: 12),
                    NeuPanel(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        _loadError!,
                        style: const TextStyle(fontSize: 12, color: Colors.redAccent),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  _infoTile(Icons.shopping_bag, 'Total orders', '${p?['total_orders'] ?? '—'}', primary),
                  _infoTile(Icons.stars, 'Loyalty points', '${p?['loyalty_points'] ?? '—'}', primary),
                  if (p?['last_order_at'] != null)
                    _infoTile(Icons.schedule, 'Last order', p!['last_order_at'].toString().substring(0, 16), primary),
                  const SizedBox(height: 24),
                  NeuPrimaryButton(
                    label: 'Call customer',
                    icon: Icons.phone,
                    onPressed: phone.isEmpty ? null : () => _call(phone),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String value, Color primary) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: NeuPanel(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            Icon(icon, color: primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontSize: 12, color: AppColor.textSecondary)),
                  Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
