import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:wicom/core/app_color.dart';
import 'package:wicom/core/whatslipa_api.dart';
import 'package:wicom/whatslipa/widgets/whatslipa_theme.dart';
import 'package:wicom/core/whatslipa_maps_init.dart';
import 'package:wicom/whatslipa/screens/whatslipa_delivery_route_screen.dart';
import 'package:wicom/src/view/widgets/neumorphic_widgets.dart';

class WhatsLipaDeliveryScreen extends StatefulWidget {
  const WhatsLipaDeliveryScreen({super.key});

  @override
  State<WhatsLipaDeliveryScreen> createState() => _WhatsLipaDeliveryScreenState();
}

class _WhatsLipaDeliveryScreenState extends State<WhatsLipaDeliveryScreen> {
  List<dynamic> _orders = [];
  final Set<int> _selectedOrderIds = {};
  bool _loading = true;
  bool _mapsReady = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    _mapsReady = (await initWhatsLipaGoogleMaps()).ok;
    await _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      _orders = await WhatsLipaApi.deliveryOrders();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
    if (mounted) setState(() => _loading = false);
  }

  void _startRoute() {
    if (_selectedOrderIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Select at least one order')));
      return;
    }
    if (!_mapsReady) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maps not ready. Connect online once to sync the map key.')),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute<bool>(
        builder: (_) => WhatsLipaDeliveryRouteScreen(orderIds: _selectedOrderIds.toList()),
      ),
    ).then((changed) {
      if (changed == true) _load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final primary = WhatsLipaTheme.primary;

    return Scaffold(
      backgroundColor: AppColor.neumorphicBase,
      appBar: WhatsLipaTheme.appBar(
        title: 'Delivery',
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _load),
        ],
      ),
      floatingActionButton: _selectedOrderIds.isEmpty
          ? null
          : FloatingActionButton.extended(
              backgroundColor: primary,
              onPressed: _startRoute,
              icon: const Icon(Icons.navigation, color: Colors.white),
              label: const Text('Start route', style: TextStyle(color: Colors.white)),
            ),
      body: NeuScreenCanvas(
        child: _loading
            ? Center(child: CircularProgressIndicator(color: primary))
            : RefreshIndicator(
                color: primary,
                onRefresh: _load,
                child: _orders.isEmpty
                    ? ListView(
                        children: const [
                          SizedBox(height: 80),
                          Center(child: Text('No deliveries assigned to you')),
                        ],
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(12, 12, 12, 88),
                        itemCount: _orders.length,
                        itemBuilder: (context, i) {
                          final o = _orders[i] as Map<String, dynamic>;
                          final id = o['id'] as int;
                          final hasLoc = o['latitude'] != null && o['longitude'] != null;
                          final phone = o['customer_phone']?.toString() ?? '';

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Neumorphic(
                              style: NeumorphicStyle(
                                depth: 4,
                                boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                              ),
                              child: CheckboxListTile(
                                value: _selectedOrderIds.contains(id),
                                onChanged: hasLoc
                                    ? (v) {
                                        setState(() {
                                          if (v == true) {
                                            _selectedOrderIds.add(id);
                                          } else {
                                            _selectedOrderIds.remove(id);
                                          }
                                        });
                                      }
                                    : null,
                                title: Text(
                                  phone.isNotEmpty ? phone : '#$id',
                                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  o['delivery_address']?.toString() ?? o['items_text']?.toString() ?? '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 12),
                                ),
                                secondary: hasLoc
                                    ? Icon(Icons.location_on, color: primary)
                                    : const Icon(Icons.location_off, color: Colors.grey),
                                controlAffinity: ListTileControlAffinity.leading,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                              ),
                            ),
                          );
                        },
                      ),
              ),
      ),
    );
  }
}
