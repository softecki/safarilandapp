import 'package:flutter/material.dart';
import 'package:wicom/pamoja/community_screen.dart';
import 'package:wicom/pamoja/identity_screens.dart';
import 'package:wicom/pamoja/live_screen.dart';
import 'package:wicom/pamoja/mini_programs.dart';
import 'package:wicom/pamoja/session.dart';
import 'package:wicom/pamoja/widgets.dart';

class PamojaProgram {
  const PamojaProgram(this.id, this.title, this.partner, this.builder);
  final String id;
  final String title;
  final String partner;
  final Widget Function() builder;
}

final pamojaPrograms = <PamojaProgram>[
  PamojaProgram('transport', 'Transport', 'SwifPack Posta', () => const PamojaTransportScreen()),
  PamojaProgram('hotels', 'Hotels', 'Stay in host cities', () => const PamojaHotelScreen()),
  PamojaProgram('food', 'Food delivery', 'SwifPack', () => const PamojaSimpleProgram(title: 'Food delivery', partner: 'SwifPack', rows: [['Near Serena Hotel', '22 min'], ['Nyama platter', 'TZS 18,000'], ['Deliver to room', 'Hotel policy']])),
  PamojaProgram('courier', 'Courier', 'Marketplace fulfilment', () => const PamojaSimpleProgram(title: 'Courier', partner: 'Marketplace fulfilment', rows: [['Official jersey', 'Out for delivery'], ['Track SP-88341', '2 stops'], ['Hotel handover', 'Reception']])),
  PamojaProgram('car-hire', 'Car hire', 'Self-drive or chauffeur', () => const PamojaSimpleProgram(title: 'Car hire', partner: 'Partner catalogue', rows: [['When do you need it?', '7 days'], ['SUV with driver', 'From TZS 180,000'], ['Deliver to hotel', 'Serena']])),
  PamojaProgram('car', 'Car hire', 'Self-drive or chauffeur', () => const PamojaSimpleProgram(title: 'Car hire', partner: 'Partner catalogue', rows: [['When do you need it?', '7 days'], ['SUV with driver', 'From TZS 180,000'], ['Deliver to hotel', 'Serena']])),
  PamojaProgram('tickets', 'Tickets', 'Matches and side events', () => const PamojaTicketsScreen()),
  PamojaProgram('marketplace', 'Marketplace', 'Official merchandise', () => const PamojaMarketScreen()),
  PamojaProgram('market', 'Marketplace', 'Official merchandise', () => const PamojaMarketScreen()),
  PamojaProgram('arrival', 'My Arrival', 'Flight, visa, hotel', () => const PamojaArrivalScreen()),
  PamojaProgram('visa', 'eVisa', 'Immigration journey', () => const PamojaVisaScreen()),
  PamojaProgram('match-centre', 'Match Centre', 'Predict · Vote · Pulse', () => const PamojaMatchCentreScreen()),
  PamojaProgram('live', 'Match Centre', 'Predict · Vote · Pulse', () => const PamojaMatchCentreScreen()),
  PamojaProgram('fanverse', 'FanVerse', 'Communities and chat', () => const PamojaFanversePage()),
  PamojaProgram('health', 'Health', 'Care access', () => const PamojaSimpleProgram(title: 'Health', partner: 'Care access', rows: [['Nearest clinic', '2.1 km'], ['Travel insurance', 'Linked'], ['Emergency', 'Use Safety']])),
  PamojaProgram('safety', 'Safety', 'SOS and incidents', () => const PamojaSafetyScreen()),
  PamojaProgram('lottery', 'Lottery', 'Licensed operator', () => const PamojaSimpleProgram(title: 'AFCON lottery', partner: 'Licensed operator · 18+', rows: [['Age and KYC', 'Required'], ['Pamoja does not operate the draw', 'Partner'], ['Results in Wallet offers', 'If eligible']])),
  PamojaProgram('betting', 'Betting', 'Betika · 18+', () => const PamojaSimpleProgram(title: 'Betting', partner: 'Betika · 18+', rows: [['Location and age check', 'Required'], ['Pamoja does not run a sportsbook', 'API'], ['Responsible play tools', 'Partner']])),
  PamojaProgram('bet', 'Betting', 'Betika · 18+', () => const PamojaSimpleProgram(title: 'Betting', partner: 'Betika · 18+', rows: [['Location and age check', 'Required'], ['Pamoja does not run a sportsbook', 'API'], ['Responsible play tools', 'Partner']])),
  PamojaProgram('ai', 'AI guide', 'Ask Pamoja', () => const PamojaAiScreen()),
  PamojaProgram('guide', 'Tanzania Guide', 'Stadiums and FAQs', () => const PamojaSimpleProgram(title: 'Tanzania Guide', partner: 'Destinations', rows: [['National Stadium', 'Access and gates'], ['Serena to stadium', '32 min'], ['Emergency numbers', '112 / 114']])),
];

PamojaProgram? programBySlug(String slug) {
  try {
    return pamojaPrograms.firstWhere((p) => p.id == slug);
  } catch (_) {
    return null;
  }
}

void openCatalogApp(BuildContext context, CatalogApp app) {
  final local = programBySlug(app.slug);
  if (local != null) {
    pushPamoja(context, local.builder());
    return;
  }
  pushPamoja(
    context,
    PamojaSimpleProgram(
      title: app.name,
      partner: '${app.partner} · powered by Pamoja',
      rows: [
        ['Group', app.group],
        ['Status', app.status],
        ['Partner', app.partner],
        ['About', app.description.isEmpty ? 'Registered in Pamoja OPS.' : app.description],
      ],
    ),
  );
}
