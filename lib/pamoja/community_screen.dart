import 'package:flutter/material.dart';
import 'package:wicom/pamoja/brand.dart';
import 'package:wicom/pamoja/session.dart';
import 'package:wicom/pamoja/widgets.dart';

class PamojaCommunityScreen extends StatelessWidget {
  const PamojaCommunityScreen({super.key, this.showBack = false});
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    final s = PamojaSession.instance;
    final posts = [
      ['1', 'Amina · Kenya · Verified', 'Anyone going Serena to the stadium together? SwifPack group ride.'],
      ['2', 'Joseph · TZ · Same match', 'Pulse is wild after that equaliser.'],
      ['3', 'Taifa Stars community', 'Who should start on Saturday? Vote in Match Centre.'],
    ];
    return Column(
      children: [
        if (showBack)
          const PamojaBackBar(title: 'FanVerse', subtitle: 'Verified fans')
        else
          Container(
            color: Colors.white,
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
            child: const SafeArea(
              bottom: false,
              child: Text('FanVerse', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: PamojaBrand.indigo)),
            ),
          ),
        SizedBox(
          height: 44,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: ['Taifa Stars', 'Harambee Stars', 'This match', 'Companions']
                .map((c) => Padding(padding: const EdgeInsets.only(right: 8), child: Chip(label: Text(c))))
                .toList(),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
            children: [
              ...posts.map(
                (p) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: PamojaCard(
                    onTap: () => s.like(p[0]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p[1], style: const TextStyle(fontWeight: FontWeight.w700, color: PamojaBrand.indigo, fontSize: 12)),
                        const SizedBox(height: 6),
                        Text(p[2]),
                        const SizedBox(height: 8),
                        Text(
                          s.likedPosts.contains(p[0]) ? 'Liked · Report · Share' : 'Like · Comment · Share',
                          style: const TextStyle(color: PamojaBrand.lake, fontSize: 12, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              PamojaRow(title: 'Find a companion', subtitle: 'Same match', onTap: () => pamojaToast(context, 'Matching fans attending TAN vs KEN')),
              PamojaRow(title: 'Direct messages', subtitle: '3 unread', onTap: () => pamojaToast(context, 'Demo inbox: Juma, Joseph, Taifa Stars group')),
            ],
          ),
        ),
      ],
    );
  }
}

class PamojaFanversePage extends StatelessWidget {
  const PamojaFanversePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: PamojaCommunityScreen(showBack: true));
  }
}
