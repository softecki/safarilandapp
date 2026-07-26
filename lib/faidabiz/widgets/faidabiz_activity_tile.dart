import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wicom/faidabiz/faidabiz_theme.dart';
import 'package:wicom/faidabiz/screens/activity_detail_screen.dart';

/// Shared activity row — title + time + signed amount + chevron (no description).
class FaidaBizActivityTile extends StatefulWidget {
  const FaidaBizActivityTile({
    super.key,
    required this.item,
    this.compact = false,
    this.animateAmount = true,
  });

  final Map<String, dynamic> item;
  final bool compact;
  final bool animateAmount;

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

  @override
  State<FaidaBizActivityTile> createState() => _FaidaBizActivityTileState();
}

class _FaidaBizActivityTileState extends State<FaidaBizActivityTile> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );
  late final Animation<double> _tween = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);

  @override
  void initState() {
    super.initState();
    if (widget.animateAmount) {
      _controller.forward();
    } else {
      _controller.value = 1;
    }
  }

  @override
  void didUpdateWidget(covariant FaidaBizActivityTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.item['id'] != widget.item['id'] || oldWidget.item['amount'] != widget.item['amount']) {
      if (widget.animateAmount) {
        _controller.forward(from: 0);
      } else {
        _controller.value = 1;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
    final type = widget.item['type']?.toString();
    final color = FaidaBizActivityTile.colorFor(type);
    final amountColor = faidaBizAmountColor(type);
    final title = widget.item['title']?.toString() ?? '';
    final when = _formatWhen(widget.item['occurred_at']?.toString());
    final amount = widget.item['amount'];
    final hasAmount = amount != null && FaidaBizTheme.asDouble(amount) != 0;
    final compact = widget.compact;
    final flow = faidaBizCashFlowFor(type);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => FaidaBizActivityDetailScreen(item: widget.item)),
          );
        },
        child: Container(
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
            children: [
              Container(
                width: compact ? 40 : 44,
                height: compact ? 40 : 44,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(FaidaBizActivityTile.iconFor(type), color: color, size: compact ? 20 : 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: compact ? 14 : 15,
                        color: FaidaBizTheme.black,
                        height: 1.25,
                      ),
                    ),
                    if (when.isNotEmpty) ...[
                      const SizedBox(height: 5),
                      Text(
                        when,
                        style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ],
                ),
              ),
              if (hasAmount) ...[
                const SizedBox(width: 8),
                AnimatedBuilder(
                  animation: _tween,
                  builder: (_, __) {
                    final target = FaidaBizTheme.asDouble(amount).abs();
                    final shown = target * _tween.value;
                    final money = FaidaBizTheme.money(shown);
                    final signed = switch (flow) {
                      FaidaBizCashFlow.credit => '+ $money',
                      FaidaBizCashFlow.debit => '− $money',
                      FaidaBizCashFlow.none => money,
                    };
                    return Text(
                      signed,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: compact ? 13 : 14,
                        color: amountColor,
                      ),
                    );
                  },
                ),
              ],
              const SizedBox(width: 4),
              Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }
}
