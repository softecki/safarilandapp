import 'package:flutter/material.dart';
import 'package:wicom/pamoja/brand.dart';
import 'package:wicom/pamoja/community_screen.dart';
import 'package:wicom/pamoja/session.dart';
import 'package:wicom/pamoja/widgets.dart';

class PamojaLiveScreen extends StatelessWidget {
  const PamojaLiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PamojaMatchCentreScreen(embedded: true);
  }
}

class PamojaMatchCentreScreen extends StatelessWidget {
  const PamojaMatchCentreScreen({super.key, this.embedded = false});
  final bool embedded;

  @override
  Widget build(BuildContext context) {
    final body = ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        PamojaCard(
          color: PamojaBrand.indigo,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('MINUTE 67', style: TextStyle(color: PamojaBrand.gold, fontWeight: FontWeight.w800, letterSpacing: 1, fontSize: 11)),
                  Spacer(),
                  PamojaPill('LIVE', tone: 'danger'),
                ],
              ),
              SizedBox(height: 8),
              Text('TAN 1 – 1 KEN', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800)),
              Text('National Stadium · Companion mode', style: TextStyle(color: Colors.white70)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.6,
          children: [
            PamojaCard(onTap: () => pushPamoja(context, const PamojaPredictScreen()), child: const _Tile(Icons.sports_soccer, PamojaBrand.gold, 'Predict', 'Next goal')),
            PamojaCard(onTap: () => pushPamoja(context, const PamojaVoteScreen()), child: const _Tile(Icons.how_to_vote, PamojaBrand.indigo, 'Vote', 'Player of match')),
            PamojaCard(onTap: () => pushPamoja(context, const PamojaPulseScreen()), child: const _Tile(Icons.favorite, PamojaBrand.red, 'Pulse', '73% believe')),
            PamojaCard(onTap: () => pushPamoja(context, const PamojaFanversePage()), child: const _Tile(Icons.forum, PamojaBrand.lake, 'Room', '12.4k fans')),
          ],
        ),
        const SizedBox(height: 12),
        const PamojaRow(title: "67' Yellow card · Kenya 8", trailing: Text('Stat')),
        const PamojaRow(title: "61' Goal Tanzania", trailing: Text('Moment')),
      ],
    );

    if (embedded) {
      return Column(
        children: [
          Container(
            color: Colors.white,
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
            child: const SafeArea(
              bottom: false,
              child: Row(
                children: [
                  Text('Match Centre', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: PamojaBrand.indigo)),
                  SizedBox(width: 8),
                  PamojaPill('LIVE', tone: 'danger'),
                ],
              ),
            ),
          ),
          Expanded(child: body),
        ],
      );
    }

    return Scaffold(
      body: Column(
        children: [
          const PamojaBackBar(title: 'Match Centre', trailing: PamojaPill('LIVE', tone: 'danger')),
          Expanded(child: body),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile(this.icon, this.color, this.title, this.subtitle);
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color),
        const Spacer(),
        Text(title, style: const TextStyle(fontWeight: FontWeight.w800, color: PamojaBrand.indigo)),
        Text(subtitle, style: const TextStyle(fontSize: 11, color: PamojaBrand.muted)),
      ],
    );
  }
}

class PamojaPredictScreen extends StatelessWidget {
  const PamojaPredictScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = PamojaSession.instance;
    const options = ['Tanzania', 'Kenya', 'No more goals'];
    return Scaffold(
      body: Column(
        children: [
          const PamojaBackBar(title: 'Predict', subtitle: 'Free to play'),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Text('Next team to score · +25 points', style: TextStyle(color: PamojaBrand.muted)),
          ),
          Expanded(
            child: ListView(
              children: options
                  .map(
                    (o) => PamojaRow(
                      title: o,
                      trailing: Text(s.prediction == o ? 'Locked' : 'Select', style: const TextStyle(color: PamojaBrand.lake, fontWeight: FontWeight.w700)),
                      onTap: () {
                        s.setPrediction(o);
                        s.addPoints(25);
                        pamojaToast(context, 'Prediction locked: $o · not a bet');
                      },
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

class PamojaVoteScreen extends StatelessWidget {
  const PamojaVoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = PamojaSession.instance;
    const options = ['Msuva · TAN 10', 'Olunga · KEN 9', 'Salum · TAN 1'];
    return Scaffold(
      body: Column(
        children: [
          const PamojaBackBar(title: 'Player of the Match', subtitle: 'One Fan ID vote'),
          Expanded(
            child: ListView(
              children: options
                  .map(
                    (o) => PamojaRow(
                      title: o,
                      trailing: Text(s.vote == o ? 'Voted' : 'Vote'),
                      onTap: () {
                        s.setVote(o);
                        pamojaToast(context, 'Vote recorded. Results publish after admin approval.');
                      },
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

class PamojaPulseScreen extends StatelessWidget {
  const PamojaPulseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = PamojaSession.instance;
    const options = ['Very confident', 'Confident', 'Unsure', 'Worried', "It's over"];
    return Scaffold(
      body: Column(
        children: [
          const PamojaBackBar(title: 'Pamoja Pulse'),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('How confident are you?', style: TextStyle(fontWeight: FontWeight.w800, color: PamojaBrand.indigo, fontSize: 18)),
          ),
          ...options.map(
            (o) => PamojaRow(
              title: o,
              trailing: s.pulse == o ? const PamojaPill('You', tone: 'ok') : null,
              onTap: () {
                s.setPulse(o);
                pamojaToast(context, '73% of Tanzania fans believe they will win.');
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: const LinearProgressIndicator(
                value: 0.73,
                minHeight: 10,
                color: PamojaBrand.green,
                backgroundColor: PamojaBrand.border,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
