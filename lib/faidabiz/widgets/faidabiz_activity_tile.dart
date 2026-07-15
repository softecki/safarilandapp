import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wicom/faidabiz/faidabiz_theme.dart';

/// Shared activity row used on Home (last 5) and the full Activity screen.
class FaidaBizActivityTile extends StatelessWidget {
  const FaidaBizActivityTile({
    super.key,
    required this.item,
    this.compact = false,
  });

  final Map<String, dynamic> item;
  final bool compact;

  static Color colorFor(String? type) {
    switch ((type ?? '').toLowerCase()) {
      case 'sale':
        return FaidaBizTheme.green;
      case 'purchase':
        return FaidaBizTheme.black;
      case 'stock':
      case 'product':
        return const Color(0xFF0369A1);
      case 'expense':
        return const Color(0xFFC2410C);
      case 'debt':
      case 'debt_payment':
        return const Color(0xFFB45309);
      case 'system':
        return const Color(0xFF475569);
      default:
        return FaidaBizTheme.greenDark;
    }
  }

  static IconData iconFor(String? type) {
    switch ((type ?? '').toLowerCase()) {
      case 'sale':
        return Icons.point_of_sale_rounded;
      case 'purchase':
        return Icons.add_box_rounded;
      case 'stock':
      case 'product':
        return Icons.inventory_2_outlined;
      case 'expense':
        return Icons.payments_outlined;
      case 'debt':
        return Icons.handshake_outlined;
      case 'debt_payment':
        return Icons.money_rounded;
      case 'system':
        return Icons.info_outline_rounded;
      default:
        return Icons.receipt_long_rounded;
    }
  }

  String _formatWhen(String? raw) {
    if (raw == null || raw.isEmpty) return '';
    try {
      final dt = DateTime.parse(raw).toLocal();
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final day = DateTime(dt.year, dt.month, dt.day);
      final time = DateFormat('HH:mm').format(dt);
      if (day == today) return '${'activity.today_at'.tr()} $time';
      if (day == today.subtract(const Duration(days: 1))) {
        return '${'activity.yesterday_at'.tr()} $time';
      }
      return DateFormat('d MMM yyyy · HH:mm').format(dt);
    } catch (_) {
      return raw;
    }
  }

  @override
  Widget build(BuildContext context) {
    final type = item['type']?.toString();
    final color = colorFor(type);
    final title = item['title']?.toString() ?? '';
    final description = item['description']?.toString() ?? '';
    final when = _formatWhen(item['occurred_at']?.toString());
    final amount = item['amount'];
    final hasAmount = amount != null && FaidaBizTheme.asDouble(amount) != 0;

    return Container(
      margin: EdgeInsets.only(bottom: compact ? 8 : 10),
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 12 : 14,
        vertical: compact ? 12 : 14,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.12)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: compact ? 40 : 44,
            height: compact ? 40 : 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(iconFor(type), color: color, size: compact ? 20 : 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: compact ? 14 : 15,
                    color: FaidaBizTheme.black,
                    height: 1.25,
                  ),
                ),
                if (description.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    description,
                    maxLines: compact ? 1 : 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: Colors.grey.shade700,
                      height: 1.3,
                    ),
                  ),
                ],
                if (when.isNotEmpty) ...[
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.schedule_rounded, size: 13, color: Colors.grey.shade500),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          when,
                          style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          if (hasAmount) ...[
            const SizedBox(width: 8),
            Text(
              FaidaBizTheme.money(amount),
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: compact ? 13 : 14,
                color: color,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
