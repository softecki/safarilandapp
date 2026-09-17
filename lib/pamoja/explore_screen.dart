import 'package:flutter/material.dart';
import 'package:wicom/pamoja/brand.dart';
import 'package:wicom/pamoja/catalog.dart';
import 'package:wicom/pamoja/session.dart';
import 'package:wicom/pamoja/widgets.dart';

class PamojaExploreScreen extends StatelessWidget {
  const PamojaExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: PamojaSession.instance,
      builder: (context, _) {
        final s = PamojaSession.instance;
        final groups = s.catalog.isNotEmpty
            ? s.catalog
            : [
                CatalogGroup(
                  name: 'Certified services',
                  apps: pamojaPrograms
                      .map((p) => CatalogApp(slug: p.id, name: p.title, partner: p.partner, group: 'Lifestyle', status: 'Live'))
                      .toList(),
                ),
              ];
        return Column(
          children: [
            Container(
              color: Colors.white,
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: SafeArea(
                bottom: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Explore', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: PamojaBrand.indigo)),
                    Text(
                      s.group.isEmpty ? 'Mini-apps registered in Pamoja OPS' : 'Assigned to ${s.group}',
                      style: const TextStyle(color: PamojaBrand.muted, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            const PamojaSearch(hint: 'Find a certified service'),
            Expanded(
              child: ListView(
                children: [
                  for (final group in groups) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
                      child: Text(group.name, style: const TextStyle(fontWeight: FontWeight.w800, color: PamojaBrand.indigo)),
                    ),
                    ...group.apps.map(
                      (app) => PamojaRow(
                        title: app.name,
                        subtitle: '${app.partner} · ${app.status}',
                        trailing: const Text('Open', style: TextStyle(color: PamojaBrand.lake, fontWeight: FontWeight.w700)),
                        onTap: () => openCatalogApp(context, app),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
