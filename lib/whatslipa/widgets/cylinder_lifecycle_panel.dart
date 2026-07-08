import 'package:flutter/material.dart';
import 'package:wicom/core/whatslipa_brand.dart';

/// Cylinder journey: Inventory In → Out → Delivered → Empty Returned
class CylinderLifecyclePanel extends StatelessWidget {
  const CylinderLifecyclePanel({
    super.key,
    this.lifecycle,
    this.compact = false,
    this.title = 'Cylinder journey',
  });

  final Map<String, dynamic>? lifecycle;
  final bool compact;
  final String title;

  static const _defaultStages = [
    {'key': 'inventory_in', 'label': 'In', 'short_label': 'In', 'state': 'current'},
    {'key': 'inventory_out', 'label': 'Out', 'short_label': 'Out', 'state': 'pending'},
    {'key': 'delivered', 'label': 'Delivered', 'short_label': 'Delivered', 'state': 'pending'},
    {'key': 'empty_returned', 'label': 'Returned', 'short_label': 'Returned', 'state': 'pending'},
  ];

  List<Map<String, dynamic>> get _stages {
    final raw = lifecycle?['stages'];
    if (raw is List && raw.isNotEmpty) {
      return raw.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    }
    return _defaultStages.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  int get _progress => lifecycle?['progress_percent'] is int
      ? lifecycle!['progress_percent'] as int
      : (lifecycle?['progress_percent'] as num?)?.toInt() ?? 0;

  Color get _accent => WhatsLipaBrand.primary;
  Color get _onAccent => WhatsLipaBrand.onPrimary;

  @override
  Widget build(BuildContext context) {
    final stages = _stages;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!compact) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              Text('$_progress%', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: (_progress / 100).clamp(0.0, 1.0),
              minHeight: 6,
              backgroundColor: Colors.grey.shade200,
              color: _accent,
            ),
          ),
          const SizedBox(height: 14),
        ],
        Row(
          children: [
            for (var i = 0; i < stages.length; i++) ...[
              Expanded(child: _StageDot(stage: stages[i], index: i, accent: _accent, onAccent: _onAccent, compact: compact)),
              if (i < stages.length - 1)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    size: compact ? 14 : 18,
                    color: stages[i]['state'] == 'completed' ? Colors.green.shade600 : Colors.grey.shade300,
                  ),
                ),
            ],
          ],
        ),
      ],
    );
  }
}

class _StageDot extends StatelessWidget {
  const _StageDot({
    required this.stage,
    required this.index,
    required this.accent,
    required this.onAccent,
    required this.compact,
  });

  final Map<String, dynamic> stage;
  final int index;
  final Color accent;
  final Color onAccent;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final state = stage['state']?.toString() ?? 'pending';
    final label = compact
        ? (stage['short_label'] ?? stage['label'] ?? '').toString()
        : (stage['label'] ?? '').toString();

    Color fill;
    Color border;
    Color textColor;
    Widget child;

    if (state == 'completed') {
      fill = Colors.green.shade500;
      border = Colors.green.shade700;
      textColor = Colors.white;
      child = const Icon(Icons.check, size: 14, color: Colors.white);
    } else if (state == 'current') {
      fill = accent;
      border = WhatsLipaBrand.secondary;
      textColor = onAccent;
      child = Text('${index + 1}', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: onAccent));
    } else {
      fill = Colors.grey.shade100;
      border = Colors.grey.shade300;
      textColor = Colors.grey.shade500;
      child = Text('${index + 1}', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: textColor));
    }

    return Column(
      children: [
        Container(
          width: compact ? 26 : 36,
          height: compact ? 26 : 36,
          decoration: BoxDecoration(
            color: fill,
            shape: BoxShape.circle,
            border: Border.all(color: border, width: 2),
            boxShadow: state == 'current'
                ? [BoxShadow(color: accent.withValues(alpha: 0.35), blurRadius: 8)]
                : null,
          ),
          alignment: Alignment.center,
          child: child,
        ),
        const SizedBox(height: 6),
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: compact ? 9 : 10,
            fontWeight: FontWeight.w700,
            color: state == 'pending' ? Colors.grey.shade500 : Colors.black87,
            height: 1.1,
          ),
        ),
        if (state == 'current' && !compact)
          Container(
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text('Current', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w700, color: onAccent == Colors.black ? Colors.black87 : accent)),
          ),
      ],
    );
  }
}

/// Lifecycle scan stage options mapped to API event types.
class CylinderLifecycleStages {
  CylinderLifecycleStages._();

  static const options = [
    _StageOption('stock_in', 'Inventory In', 'inventory_in'),
    _StageOption('stock_out', 'Inventory Out', 'inventory_out'),
    _StageOption('agent_receive', 'With Agent', 'inventory_out'),
    _StageOption('deliver', 'Delivered', 'delivered'),
    _StageOption('return_empty', 'Empty Returned', 'empty_returned'),
  ];

  static String? suggestedEventType(Map<String, dynamic>? lifecycle) {
    final next = lifecycle?['next_event_type']?.toString();
    if (next != null && next.isNotEmpty) return next;
    return 'stock_in';
  }
}

class _StageOption {
  const _StageOption(this.eventType, this.label, this.stageKey);
  final String eventType;
  final String label;
  final String stageKey;
}
