import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:wicom/pamoja/app_nav.dart';
import 'package:wicom/pamoja/brand.dart';
import 'package:wicom/pamoja/mini_programs.dart';
import 'package:wicom/pamoja/ops_api.dart';
import 'package:wicom/pamoja/session.dart';
import 'package:wicom/pamoja/widgets.dart';

class PamojaFanIdScreen extends StatelessWidget {
  const PamojaFanIdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = PamojaSession.instance;
    return Scaffold(
      body: Column(
        children: [
          const PamojaBackBar(title: 'Fan ID', subtitle: 'Identity'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: const LinearGradient(colors: [PamojaBrand.lake, PamojaBrand.indigo]),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          Text('PAMOJA', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, letterSpacing: 1.2)),
                          Spacer(),
                          Text('FAN ID', style: TextStyle(color: PamojaBrand.gold, fontWeight: FontWeight.w800)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Container(
                            width: 72,
                            height: 88,
                            decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(8)),
                            child: const Icon(Icons.person, color: Colors.white, size: 42),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(s.fullName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                                Text(s.fanId, style: const TextStyle(color: Colors.white70)),
                                const SizedBox(height: 6),
                                const PamojaPill('Verified', tone: 'ok'),
                                Text('${s.nationality.toUpperCase()} · FAN', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                              ],
                            ),
                          ),
                          Container(
                            color: Colors.white,
                            padding: const EdgeInsets.all(4),
                            child: QrImageView(data: s.fanId, size: 72, backgroundColor: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                PamojaRow(title: 'Upgrade to Traveller Fan ID', subtitle: 'Passport', onTap: () => pushPamoja(context, const PamojaTravellerScreen())),
                PamojaRow(title: 'eVisa status', trailing: const PamojaPill('Review', tone: 'warn'), onTap: () => pushPamoja(context, const PamojaVisaScreen())),
                const PamojaRow(title: 'Officials ID', trailing: Text('Not assigned')),
                PamojaRow(title: 'Share credential', subtitle: 'Brightness on', onTap: () => pamojaToast(context, 'QR ready for stadium and immigration scan')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PamojaTravellerScreen extends StatefulWidget {
  const PamojaTravellerScreen({super.key});

  @override
  State<PamojaTravellerScreen> createState() => _PamojaTravellerScreenState();
}

class _PamojaTravellerScreenState extends State<PamojaTravellerScreen> {
  int step = 1;
  final passport = TextEditingController(text: 'A0458123');
  String host = 'Tanzania';

  @override
  void dispose() {
    passport.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const PamojaBackBar(title: 'Traveller Fan ID', subtitle: 'Passport wizard'),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Row(
              children: List.generate(
                5,
                (i) => Expanded(
                  child: Container(
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      color: i <= step ? PamojaBrand.lake : PamojaBrand.border,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text('Step ${step + 1} of 5 · Passport. We match document labels and explain why data is needed.', style: const TextStyle(color: PamojaBrand.muted)),
                const SizedBox(height: 16),
                TextField(controller: passport, decoration: const InputDecoration(labelText: 'Passport number')),
                const SizedBox(height: 12),
                const TextField(decoration: InputDecoration(labelText: 'Nationality', hintText: 'Kenya')),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: host,
                  items: const [
                    DropdownMenuItem(value: 'Tanzania', child: Text('Tanzania')),
                    DropdownMenuItem(value: 'Kenya', child: Text('Kenya')),
                    DropdownMenuItem(value: 'Uganda', child: Text('Uganda')),
                  ],
                  onChanged: (v) => setState(() => host = v ?? 'Tanzania'),
                  decoration: const InputDecoration(labelText: 'Host country'),
                ),
                const SizedBox(height: 12),
                const PamojaCard(child: Text('Face capture and Immigration eligibility use sandbox / mock APIs until authority integration is live.')),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    if (step < 4) {
                      setState(() => step++);
                      return;
                    }
                    final s = PamojaSession.instance;
                    try {
                      if (s.token.isNotEmpty) {
                        await OpsApi.fanId(s.token, {'passport': passport.text, 'hostCity': s.city});
                        final result = await OpsApi.visaSubmit(s.token, {
                          'passport': passport.text,
                          'host': host,
                          'nationality': s.nationality,
                          'purpose': 'AFCON match attendance',
                        });
                        if (result['fan'] is Map) s.applyFan(Map<String, dynamic>.from(result['fan'] as Map));
                        if (!context.mounted) return;
                        pamojaToast(context, 'eVisa ${result['visa']?['case'] ?? ''} sent to Immigration via Pamoja OPS.');
                      } else {
                        pamojaToast(context, 'Traveller Fan ID draft saved. QR will issue after eligibility.');
                      }
                    } catch (e) {
                      if (!context.mounted) return;
                      pamojaToast(context, '$e');
                    }
                    if (context.mounted) Navigator.pop(context);
                  },
                  child: Text(step < 4 ? 'Continue' : 'Submit to Immigration'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PamojaVisaScreen extends StatelessWidget {
  const PamojaVisaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const PamojaBackBar(title: 'eVisa', subtitle: 'Immigration'),
          Expanded(
            child: ListView(
              children: const [
                PamojaRow(title: 'Eligibility', trailing: PamojaPill('Passed', tone: 'ok')),
                PamojaRow(title: 'Application', trailing: PamojaPill('With Immigration', tone: 'warn')),
                PamojaRow(title: 'Fan ID link', trailing: PamojaPill('Linked', tone: 'ok')),
                PamojaRow(title: 'Authority API', trailing: PamojaPill('Sandbox', tone: 'info')),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('If government APIs are not live, this step stays integration-ready and shows Coming soon.'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PamojaArrivalScreen extends StatelessWidget {
  const PamojaArrivalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const PamojaBackBar(title: 'My Arrival'),
          Expanded(
            child: ListView(
              children: [
                PamojaRow(title: 'Fan ID', trailing: const PamojaPill('Ready', tone: 'ok'), onTap: () => pushPamoja(context, const PamojaFanIdScreen())),
                PamojaRow(title: 'eVisa', trailing: const PamojaPill('Pending', tone: 'warn'), onTap: () => pushPamoja(context, const PamojaVisaScreen())),
                const PamojaRow(title: 'Flight KQ 482', trailing: PamojaPill('Set', tone: 'ok')),
                const PamojaRow(title: 'eSIM', trailing: PamojaPill('Ready', tone: 'ok')),
                PamojaRow(title: 'Hotel Serena', trailing: const PamojaPill('Booked', tone: 'ok'), onTap: () => pushPamoja(context, const PamojaHotelScreen())),
                PamojaRow(title: 'Airport transfer', trailing: const PamojaPill('Book', tone: 'warn'), onTap: () => pushPamoja(context, const PamojaTransportScreen())),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PamojaWalletScreen extends StatelessWidget {
  const PamojaWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: PamojaSession.instance,
      builder: (context, _) {
        final s = PamojaSession.instance;
    return Scaffold(
      body: Column(
        children: [
          const PamojaBackBar(title: 'Wallet', subtitle: 'Powered by Unlimit'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                PamojaCard(
                  color: PamojaBrand.indigo,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Available balance', style: TextStyle(color: Colors.white70)),
                      Text('TZS ${s.wallet}', style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => pushPamoja(context, const PamojaTopUpScreen()),
                              child: const Text('Top up'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Colors.white70)),
                              onPressed: () => pamojaSheet(
                                context,
                                title: 'Add payment method',
                                child: Column(
                                  children: [
                                    const TextField(decoration: InputDecoration(labelText: 'Card number')),
                                    const SizedBox(height: 8),
                                    ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Save card')),
                                  ],
                                ),
                              ),
                              child: const Text('Add card'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const PamojaRow(title: 'SwifPack airport ride', trailing: Text('−12,000')),
                const PamojaRow(title: 'Match ticket deposit', trailing: Text('−35,000')),
                const PamojaRow(title: 'NMB top-up', trailing: Text('+100,000')),
                PamojaRow(title: 'Pamoja Points', trailing: Text('${s.points} pts')),
              ],
            ),
          ),
        ],
      ),
    );
      },
    );
  }
}

class PamojaMeScreen extends StatelessWidget {
  const PamojaMeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = PamojaSession.instance;
    return Column(
      children: [
        Container(
          color: Colors.white,
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.fullName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: PamojaBrand.indigo)),
                Text('${s.fanId} · ${s.nationality}'),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              PamojaRow(title: 'Digital Fan ID', trailing: const PamojaPill('Verified', tone: 'ok'), onTap: () => pushPamoja(context, const PamojaFanIdScreen())),
              PamojaRow(title: 'Wallet and points', trailing: Text('${s.points}'), onTap: () => pushPamoja(context, const PamojaWalletScreen())),
              PamojaRow(
                title: 'Language',
                trailing: Text(s.lang == 'EN' ? 'English' : 'Kiswahili'),
                onTap: () => s.setLang(s.lang == 'EN' ? 'SW' : 'EN'),
              ),
              const PamojaRow(title: 'Privacy', trailing: Text('FanVerse visible')),
              PamojaRow(
                title: 'Notifications',
                trailing: const Text('WhatsApp on'),
                onTap: () => pamojaSheet(
                  context,
                  title: 'Notifications',
                  child: const Column(
                    children: [
                      PamojaRow(title: 'WhatsApp', trailing: Text('On')),
                      PamojaRow(title: 'Match reminders', trailing: Text('On')),
                      PamojaRow(title: 'eVisa updates', trailing: Text('On')),
                    ],
                  ),
                ),
              ),
              const PamojaRow(title: 'Help and support'),
              ListTile(
                title: const Text('Sign out', style: TextStyle(color: PamojaBrand.danger, fontWeight: FontWeight.w700)),
                onTap: () async {
                  final ok = await pamojaConfirm(
                    context,
                    title: 'Sign out?',
                    message: 'Your Fan ID stays issued. You will need OTP to sign back in.',
                    confirmLabel: 'Sign out',
                    danger: true,
                  );
                  if (!ok) return;
                  await s.logout();
                  pamojaSignOutToLogin();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
