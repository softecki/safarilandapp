import 'package:flutter/material.dart';
import 'package:wicom/pamoja/brand.dart';
import 'package:wicom/pamoja/session.dart';
import 'package:wicom/pamoja/widgets.dart';
class PamojaSimpleProgram extends StatelessWidget {
  const PamojaSimpleProgram({super.key, required this.title, required this.partner, required this.rows});
  final String title;
  final String partner;
  final List<List<String>> rows;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          PamojaBackBar(title: title, subtitle: partner),
          Expanded(
            child: ListView(
              children: rows.map((r) => PamojaRow(title: r[0], trailing: Text(r[1], style: const TextStyle(color: PamojaBrand.muted)))).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class PamojaTransportScreen extends StatefulWidget {
  const PamojaTransportScreen({super.key});

  @override
  State<PamojaTransportScreen> createState() => _PamojaTransportScreenState();
}

class _PamojaTransportScreenState extends State<PamojaTransportScreen> {
  String? vehicle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const PamojaBackBar(title: 'Transport', subtitle: 'Powered by SwifPack'),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFFD7E8F2), borderRadius: BorderRadius.circular(16)),
              child: const Center(child: Icon(Icons.place, color: PamojaBrand.lake, size: 42)),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('JNIA Terminal 3 · pickup zone B detected', style: TextStyle(color: PamojaBrand.muted, fontSize: 12)),
                const SizedBox(height: 8),
                const TextField(decoration: InputDecoration(hintText: 'Serena Hotel, Dar es Salaam')),
                const SizedBox(height: 8),
                ...[
                  ['Standard', 'TZS 28,000 · 32 min'],
                  ['Comfort', 'TZS 42,000 · 32 min'],
                  ['XL', 'TZS 55,000 · 35 min'],
                ].map(
                  (v) => ListTile(
                    selected: vehicle == v[0],
                    title: Text(v[0], style: const TextStyle(fontWeight: FontWeight.w700)),
                    trailing: Text(v[1]),
                    onTap: () => setState(() => vehicle = v[0]),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final ok = await pamojaConfirm(
                      context,
                      title: 'Confirm ride',
                      message: 'Pay TZS 28,000 for a ${vehicle ?? 'Standard'} SwifPack ride to Serena?',
                      confirmLabel: 'Pay',
                    );
                    if (!ok || !context.mounted) return;
                    PamojaSession.instance.pay(28000);
                    pamojaToast(context, '${vehicle ?? 'Standard'} ride confirmed. Pay on arrival with Wallet.');
                  },
                  child: const Text('Confirm ride'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PamojaTicketsScreen extends StatelessWidget {
  const PamojaTicketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const PamojaBackBar(title: 'Tickets', subtitle: 'Matches and events'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                PamojaCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('TAN vs KEN', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: PamojaBrand.indigo)),
                      const Text('Cat 2 · National Stadium · Fan ID required'),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => pushPamoja(context, const PamojaTicketCheckoutScreen()),
                        child: const Text('Buy ticket'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const PamojaCard(child: PamojaRow(title: 'Fan festival', trailing: Text('Free with Fan ID'))),
                PamojaCard(child: PamojaRow(title: 'Group booking', trailing: const Text('Open'), onTap: () => pushPamoja(context, const PamojaTicketCheckoutScreen()))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PamojaMarketScreen extends StatelessWidget {
  const PamojaMarketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const PamojaBackBar(title: 'Marketplace', subtitle: 'Official vendors'),
          Expanded(
            child: ListView(
              children: [
                PamojaRow(
                  title: 'Replica jersey',
                  subtitle: 'Official merch',
                  trailing: const Text('TZS 45,000'),
                  onTap: () => pushPamoja(context, const PamojaCheckoutScreen(title: 'Replica jersey', amount: 45000)),
                ),
                PamojaRow(
                  title: 'Scarf pack',
                  trailing: const Text('TZS 18,000'),
                  onTap: () => pushPamoja(context, const PamojaCheckoutScreen(title: 'Scarf pack', amount: 18000)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PamojaSafetyScreen extends StatelessWidget {
  const PamojaSafetyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const PamojaBackBar(title: 'Safety', subtitle: 'SOS'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                PamojaCard(
                  color: PamojaBrand.red,
                  onTap: () => pamojaToast(context, 'SOS demo sent with Fan ID and live location (demo only).'),
                  child: const Column(
                    children: [
                      Icon(Icons.sos, color: Colors.white, size: 42),
                      SizedBox(height: 8),
                      Text('Hold to send SOS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18)),
                      Text('Shares Fan ID, GPS and incident type', style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const PamojaRow(title: 'Share live location', trailing: PamojaPill('On', tone: 'ok')),
                const PamojaRow(title: 'Call emergency', trailing: Text('112')),
                const PamojaRow(title: 'Report incident', trailing: Text('With Fan ID')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PamojaAiScreen extends StatefulWidget {
  const PamojaAiScreen({super.key});

  @override
  State<PamojaAiScreen> createState() => _PamojaAiScreenState();
}

class _PamojaAiScreenState extends State<PamojaAiScreen> {
  final input = TextEditingController();
  final chat = <Map<String, String>>[
    {'who': 'guide', 'text': 'Ask about visa, stadium routes, FanVerse groups or match times.'},
  ];

  @override
  void dispose() {
    input.dispose();
    super.dispose();
  }

  void _ask(String q) {
    final s = PamojaSession.instance;
    String a = 'I can help with Fan ID, eVisa, tickets and travel.';
    final t = q.toLowerCase();
    if (t.contains('visa')) a = 'Your eVisa is currently "${s.visaStatus}". Fan ID ${s.fanId} is already linked.';
    if (t.contains('stadium') || t.contains('route')) a = 'National Stadium is about 32 minutes from Serena by SwifPack Standard.';
    if (t.contains('group') || t.contains('fanverse')) a = 'Open FanVerse → This match. 12.4k fans are already in the room.';
    setState(() {
      chat.add({'who': 'me', 'text': q});
      chat.add({'who': 'guide', 'text': a});
    });
    input.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const PamojaBackBar(title: 'Ask Pamoja', subtitle: 'AI guide'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: chat
                  .map(
                    (m) => Align(
                      alignment: m['who'] == 'me' ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: m['who'] == 'me' ? PamojaBrand.lake : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(m['text']!, style: TextStyle(color: m['who'] == 'me' ? Colors.white : PamojaBrand.text)),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            child: Row(
              children: [
                Expanded(child: TextField(controller: input, decoration: const InputDecoration(hintText: 'How do I get to the stadium?'))),
                IconButton(onPressed: () => _ask(input.text.isEmpty ? 'How do I get to the stadium?' : input.text), icon: const Icon(Icons.send, color: PamojaBrand.lake)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PamojaTicketCheckoutScreen extends StatefulWidget {
  const PamojaTicketCheckoutScreen({super.key});

  @override
  State<PamojaTicketCheckoutScreen> createState() => _PamojaTicketCheckoutScreenState();
}

class _PamojaTicketCheckoutScreenState extends State<PamojaTicketCheckoutScreen> {
  int qty = 1;

  @override
  Widget build(BuildContext context) {
    final amount = 35000 * qty;
    return Scaffold(
      body: Column(
        children: [
          const PamojaBackBar(title: 'Ticket checkout', subtitle: 'TAN vs KEN · Cat 2'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text('This purchase stays on its own screen and is linked to your Fan ID.', style: TextStyle(color: PamojaBrand.muted)),
                const SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  value: qty,
                  decoration: const InputDecoration(labelText: 'Quantity'),
                  items: const [1, 2, 3, 4].map((n) => DropdownMenuItem(value: n, child: Text('$n'))).toList(),
                  onChanged: (v) => setState(() => qty = v ?? 1),
                ),
                const SizedBox(height: 16),
                Text('TZS $amount', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: PamojaBrand.indigo)),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final ok = await pamojaConfirm(
                      context,
                      title: 'Confirm ticket purchase',
                      message: 'Pay TZS $amount from Wallet for $qty ticket${qty == 1 ? '' : 's'}?',
                      confirmLabel: 'Pay now',
                    );
                    if (!ok || !context.mounted) return;
                    PamojaSession.instance.pay(amount);
                    pamojaToast(context, 'Ticket reserved and linked to ${PamojaSession.instance.fanId}');
                    Navigator.pop(context);
                  },
                  child: const Text('Continue to pay'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PamojaCheckoutScreen extends StatelessWidget {
  const PamojaCheckoutScreen({super.key, required this.title, required this.amount});
  final String title;
  final int amount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          PamojaBackBar(title: 'Checkout', subtitle: title),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text('Checkout is a full-page payment journey.', style: TextStyle(color: PamojaBrand.muted)),
                const SizedBox(height: 16),
                Text('TZS $amount', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: PamojaBrand.indigo)),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final ok = await pamojaConfirm(
                      context,
                      title: 'Confirm purchase',
                      message: 'Pay TZS $amount for $title from Wallet?',
                      confirmLabel: 'Pay now',
                    );
                    if (!ok || !context.mounted) return;
                    PamojaSession.instance.pay(amount);
                    pamojaToast(context, 'Paid with Wallet · courier via SwifPack');
                    Navigator.pop(context);
                  },
                  child: const Text('Continue to pay'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PamojaHotelScreen extends StatefulWidget {
  const PamojaHotelScreen({super.key});

  @override
  State<PamojaHotelScreen> createState() => _PamojaHotelScreenState();
}

class _PamojaHotelScreenState extends State<PamojaHotelScreen> {
  String area = 'All';
  String dates = '12–15 Jun';
  List<Object>? selected;
  final hotels = const [
    ['Serena Hotel', 'City centre', 185000],
    ['Hyatt Regency', 'Waterfront', 210000],
    ['Four Points', 'Airport', 142000],
  ];

  @override
  Widget build(BuildContext context) {
    if (selected != null) {
      final hotel = selected!;
      return Scaffold(
        body: Column(
          children: [
            PamojaBackBar(title: 'Book ${hotel[0]}', subtitle: '${hotel[1]} · $dates', onBack: () => setState(() => selected = null)),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const Text('Hotel booking is a full journey. Dates open in a short sheet.', style: TextStyle(color: PamojaBrand.muted)),
                  const SizedBox(height: 16),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Dates'),
                    subtitle: Text(dates),
                    onTap: () => pamojaSheet(
                      context,
                      title: 'Select dates',
                      child: Column(
                        children: ['11–14 Jun', '12–15 Jun', '13–16 Jun']
                            .map(
                              (d) => ListTile(
                                title: Text(d),
                                onTap: () {
                                  setState(() => dates = d);
                                  Navigator.pop(context);
                                },
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                  Text('TZS ${hotel[2]}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: PamojaBrand.indigo)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      final ok = await pamojaConfirm(
                        context,
                        title: 'Confirm hotel booking',
                        message: 'Pay TZS ${hotel[2]} for ${hotel[0]} ($dates) from Wallet?',
                        confirmLabel: 'Pay now',
                      );
                      if (!ok || !context.mounted) return;
                      PamojaSession.instance.pay(hotel[2] as int);
                      pamojaToast(context, '${hotel[0]} booked for $dates');
                      setState(() => selected = null);
                    },
                    child: const Text('Continue to pay'),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
    final visible = hotels.where((h) => area == 'All' || h[1] == area).toList();
    return Scaffold(
      body: Column(
        children: [
          const PamojaBackBar(title: 'Hotels', subtitle: 'Stay in host cities'),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Row(
              children: [
                const Expanded(child: TextField(decoration: InputDecoration(hintText: 'Search hotels'))),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () {
                    pamojaSheet(
                      context,
                      title: 'Filter hotels',
                      child: Column(
                        children: ['All', 'City centre', 'Waterfront', 'Airport']
                            .map(
                              (a) => ListTile(
                                title: Text(a),
                                trailing: area == a ? const Icon(Icons.check, color: PamojaBrand.lake) : null,
                                onTap: () {
                                  setState(() => area = a);
                                  Navigator.pop(context);
                                },
                              ),
                            )
                            .toList(),
                      ),
                    );
                  },
                  child: const Text('Filter'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: visible
                  .map(
                    (h) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: PamojaCard(
                        onTap: () => setState(() => selected = h),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(h[0] as String, style: const TextStyle(fontWeight: FontWeight.w800, color: PamojaBrand.indigo)),
                          subtitle: Text('${h[1]} · $dates'),
                          trailing: Text('TZS ${h[2]}'),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class PamojaTopUpScreen extends StatelessWidget {
  const PamojaTopUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const PamojaBackBar(title: 'Top up wallet', subtitle: 'NMB · Unlimit'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text('Choose an amount. Adding a card is a short sheet.', style: TextStyle(color: PamojaBrand.muted)),
                const SizedBox(height: 12),
                ...[50000, 100000, 250000].map(
                  (n) => ListTile(
                    title: Text('TZS $n', style: const TextStyle(fontWeight: FontWeight.w800)),
                    trailing: const Text('Visa ···· 4412'),
                    onTap: () async {
                      final ok = await pamojaConfirm(
                        context,
                        title: 'Confirm top-up',
                        message: 'Add TZS $n with Visa ···· 4412?',
                        confirmLabel: 'Confirm',
                      );
                      if (!ok || !context.mounted) return;
                      PamojaSession.instance.topUp(n);
                      pamojaToast(context, 'NMB top-up +$n');
                      Navigator.pop(context);
                    },
                  ),
                ),
                OutlinedButton(
                  onPressed: () => pamojaSheet(
                    context,
                    title: 'Add payment method',
                    child: Column(
                      children: [
                        const TextField(decoration: InputDecoration(labelText: 'Card number')),
                        const SizedBox(height: 8),
                        const TextField(decoration: InputDecoration(labelText: 'Expiry')),
                        const SizedBox(height: 12),
                        ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Save card')),
                      ],
                    ),
                  ),
                  child: const Text('Add a payment method'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
