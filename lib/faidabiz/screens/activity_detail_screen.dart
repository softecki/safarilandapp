import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wicom/faidabiz/faidabiz_theme.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_chrome.dart';

/// Credit (+) / debit (−) for activity types.
enum FaidaBizCashFlow { credit, debit, none }

FaidaBizCashFlow faidaBizCashFlowFor(String? type) {
  switch ((type ?? '').toLowerCase()) {
    case 'sale':
    case 'debt_payment':
      return FaidaBizCashFlow.credit;
    case 'expense':
    case 'purchase':
    case 'debt':
      return FaidaBizCashFlow.debit;
    default:
      return FaidaBizCashFlow.none;
  }
}

String faidaBizSignedMoney(Object? amount, String? type) {
  final n = FaidaBizTheme.asDouble(amount).abs();
  final money = FaidaBizTheme.money(n);
  switch (faidaBizCashFlowFor(type)) {
    case FaidaBizCashFlow.credit:
      return '+ $money';
    case FaidaBizCashFlow.debit:
      return '− $money';
    case FaidaBizCashFlow.none:
      return money;
  }
}

Color faidaBizAmountColor(String? type) {
  switch (faidaBizCashFlowFor(type)) {
    case FaidaBizCashFlow.credit:
      return FaidaBizTheme.green;
    case FaidaBizCashFlow.debit:
      return const Color(0xFFC2410C);
    case FaidaBizCashFlow.none:
      return FaidaBizTheme.greenDark;
  }
}

/// Full detail for one activity log row.
class FaidaBizActivityDetailScreen extends StatelessWidget {
  const FaidaBizActivityDetailScreen({super.key, required this.item});
  final Map<String, dynamic> item;

  String _fmtWhen(String? raw) {
    if (raw == null || raw.isEmpty) return '—';
    try {
      return DateFormat('d MMM yyyy · HH:mm').format(DateTime.parse(raw).toLocal());
    } catch (_) {
      return raw;
    }
  }

  @override
  Widget build(BuildContext context) {
    final type = item['type']?.toString() ?? '';
    final title = item['title']?.toString() ?? '';
    final description = item['description']?.toString() ?? '';
    final amount = item['amount'];
    final hasAmount = amount != null && FaidaBizTheme.asDouble(amount) != 0;
    final color = faidaBizAmountColor(type);

    return Scaffold(
      backgroundColor: FaidaBizTheme.canvas,
      appBar: faidaBizAppBar(title: 'activity.detail'.tr()),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: color.withValues(alpha: 0.15)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, height: 1.3)),
                const SizedBox(height: 10),
                Text(_fmtWhen(item['occurred_at']?.toString()), style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                if (type.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text('${'activity.type'.tr()}: $type', style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
                ],
                if (hasAmount) ...[
                  const SizedBox(height: 16),
                  Text(
                    faidaBizSignedMoney(amount, type),
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 26, color: color),
                  ),
                ],
              ],
            ),
          ),
          if (description.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text('activity.description'.tr(), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
            const SizedBox(height: 8),
            Text(description, style: TextStyle(color: Colors.grey.shade800, height: 1.45, fontSize: 14)),
          ],
        ],
      ),
    );
  }
}
