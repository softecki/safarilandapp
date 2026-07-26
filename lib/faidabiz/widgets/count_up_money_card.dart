import 'package:flutter/material.dart';
import 'package:wicom/faidabiz/faidabiz_theme.dart';

/// Card with amount that animates from 0 to [value].
class CountUpMoneyCard extends StatefulWidget {
  const CountUpMoneyCard({
    super.key,
    required this.label,
    required this.value,
    required this.color,
    this.icon,
    this.delay = Duration.zero,
    this.onTap,
  });

  final String label;
  final Object? value;
  final Color color;
  final IconData? icon;
  final Duration delay;
  final VoidCallback? onTap;

  @override
  State<CountUpMoneyCard> createState() => _CountUpMoneyCardState();
}

class _CountUpMoneyCardState extends State<CountUpMoneyCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _tween;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _tween = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _fade = CurvedAnimation(parent: _controller, curve: const Interval(0, 0.4, curve: Curves.easeOut));
    _slide = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    Future<void>.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void didUpdateWidget(covariant CountUpMoneyCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (FaidaBizTheme.asDouble(oldWidget.value) != FaidaBizTheme.asDouble(widget.value)) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final card = FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: widget.color.withValues(alpha: 0.18)),
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  if (widget.icon != null) ...[
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: widget.color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(widget.icon, size: 16, color: widget.color),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: Text(
                      widget.label,
                      style: TextStyle(color: Colors.grey.shade700, fontSize: 13, fontWeight: FontWeight.w500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (widget.onTap != null)
                    Icon(Icons.chevron_right_rounded, size: 18, color: Colors.grey.shade400),
                ],
              ),
              const SizedBox(height: 10),
              AnimatedBuilder(
                animation: _tween,
                builder: (_, __) {
                  final target = FaidaBizTheme.asDouble(widget.value);
                  final shown = target * _tween.value;
                  return Text(
                    FaidaBizTheme.money(shown),
                    style: TextStyle(
                      color: widget.color,
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      letterSpacing: -0.3,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );

    if (widget.onTap == null) return card;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: widget.onTap,
        child: card,
      ),
    );
  }
}
