import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wicom/faidabiz/faidabiz_theme.dart';

/// Horizontal date filter: Today · Yesterday · Pick date. Default = today.
class FaidaBizDateFilter extends StatelessWidget {
  const FaidaBizDateFilter({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final DateTime selected;
  final ValueChanged<DateTime> onChanged;

  DateTime get _today {
    final n = DateTime.now();
    return DateTime(n.year, n.month, n.day);
  }

  DateTime get _yesterday => _today.subtract(const Duration(days: 1));

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String get label {
    if (_sameDay(selected, _today)) return 'home.filter_today'.tr();
    if (_sameDay(selected, _yesterday)) return 'home.filter_yesterday'.tr();
    return DateFormat('EEE, d MMM yyyy').format(selected);
  }

  Future<void> _pick(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selected,
      firstDate: DateTime(2020),
      lastDate: _today,
      helpText: 'home.pick_date'.tr(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: FaidaBizTheme.green,
                  onPrimary: Colors.white,
                ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      onChanged(DateTime(picked.year, picked.month, picked.day));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isToday = _sameDay(selected, _today);
    final isYesterday = _sameDay(selected, _yesterday);

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: FaidaBizTheme.green.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _Chip(
              label: 'home.filter_today'.tr(),
              selected: isToday,
              onTap: () => onChanged(_today),
            ),
          ),
          Expanded(
            child: _Chip(
              label: 'home.filter_yesterday'.tr(),
              selected: isYesterday,
              onTap: () => onChanged(_yesterday),
            ),
          ),
          Expanded(
            child: _Chip(
              label: isToday || isYesterday ? 'home.filter_pick'.tr() : DateFormat('d/M').format(selected),
              selected: !isToday && !isYesterday,
              icon: Icons.calendar_month_rounded,
              onTap: () => _pick(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? FaidaBizTheme.green : Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: selected ? Colors.white : FaidaBizTheme.green),
                const SizedBox(width: 4),
              ],
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: selected ? Colors.white : FaidaBizTheme.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String faidaBizDateQuery(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
