import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wicom/faidabiz/faidabiz_theme.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_chrome.dart';

/// In-app guide grouped by home menu features (SW/EN via easy_localization).
class FaidaBizUserManualScreen extends StatelessWidget {
  const FaidaBizUserManualScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sections = [
      _ManualSection(Icons.point_of_sale, 'manual.sales_title'.tr(), 'manual.sales_body'.tr(), FaidaBizTheme.green),
      _ManualSection(Icons.handshake_outlined, 'manual.debts_title'.tr(), 'manual.debts_body'.tr(), Colors.orange.shade800),
      _ManualSection(Icons.payments, 'manual.expenses_title'.tr(), 'manual.expenses_body'.tr(), Colors.deepOrange.shade700),
      _ManualSection(Icons.inventory_2, 'manual.products_title'.tr(), 'manual.products_body'.tr(), FaidaBizTheme.greenDark),
      _ManualSection(Icons.shopping_bag_outlined, 'manual.purchases_title'.tr(), 'manual.purchases_body'.tr(), FaidaBizTheme.black),
      _ManualSection(Icons.bar_chart, 'manual.reports_title'.tr(), 'manual.reports_body'.tr(), Colors.indigo),
      _ManualSection(Icons.settings_outlined, 'manual.settings_title'.tr(), 'manual.settings_body'.tr(), Colors.blueGrey),
      _ManualSection(Icons.workspace_premium_outlined, 'manual.subscription_title'.tr(), 'manual.subscription_body'.tr(), Colors.teal.shade700),
      _ManualSection(Icons.delete_outline, 'manual.delete_title'.tr(), 'manual.delete_body'.tr(), Colors.red.shade700),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF3F7F4),
      appBar: faidaBizAppBar(title: 'manual.title'.tr()),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          Text('manual.intro'.tr(), style: TextStyle(color: Colors.grey.shade800, height: 1.45, fontSize: 14)),
          const SizedBox(height: 16),
          ...sections.map((s) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: s.color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(s.icon, color: s.color),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(s.title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                            const SizedBox(height: 4),
                            Text(s.body, style: TextStyle(fontSize: 13, height: 1.4, color: Colors.grey.shade800)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

class _ManualSection {
  const _ManualSection(this.icon, this.title, this.body, this.color);
  final IconData icon;
  final String title;
  final String body;
  final Color color;
}
