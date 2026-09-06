import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wicom/safari/safari_api.dart';
import 'package:wicom/safari/safari_brand.dart';
import 'package:wicom/safari/safari_theme.dart';

class SafariLogo extends StatelessWidget {
  const SafariLogo({
    super.key,
    this.height = 72,
    this.variant = SafariLogoVariant.wordmark,
  });

  final double height;
  final SafariLogoVariant variant;

  @override
  Widget build(BuildContext context) {
    final asset = variant == SafariLogoVariant.poster ? SafariBrand.posterAsset : SafariBrand.logoAsset;
    return Image.asset(
      asset,
      height: height,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      errorBuilder: (_, __, ___) => Text(
        SafariBrand.shortName.toUpperCase(),
        style: GoogleFonts.playfairDisplay(
          fontSize: height * 0.42,
          fontWeight: FontWeight.w700,
          color: variant == SafariLogoVariant.poster ? Colors.white : SafariTheme.black,
          letterSpacing: 2,
        ),
      ),
    );
  }
}

class SafariCard extends StatelessWidget {
  const SafariCard({super.key, required this.child, this.onTap, this.padding, this.goldEdge = false});
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final bool goldEdge;

  @override
  Widget build(BuildContext context) {
    final body = Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(SafariTheme.cardRadius),
        border: goldEdge
            ? const Border(
                left: BorderSide(color: SafariTheme.gold, width: 4),
                top: BorderSide(color: SafariTheme.cardBorder),
                right: BorderSide(color: SafariTheme.cardBorder),
                bottom: BorderSide(color: SafariTheme.cardBorder),
              )
            : Border.all(color: SafariTheme.cardBorder),
        boxShadow: [
          BoxShadow(color: SafariTheme.maroon.withValues(alpha: 0.10), blurRadius: 32, offset: const Offset(0, 12)),
        ],
      ),
      child: child,
    );
    if (onTap == null) return body;
    return Material(
      color: Colors.transparent,
      child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(SafariTheme.cardRadius), child: body),
    );
  }
}

class SafariHero extends StatelessWidget {
  const SafariHero({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [SafariTheme.maroon, SafariTheme.maroonDark],
        ),
      ),
      child: DefaultTextStyle.merge(style: const TextStyle(color: Colors.white), child: child),
    );
  }
}

class SafariTagline extends StatelessWidget {
  const SafariTagline({super.key, this.light = false});
  final bool light;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          SafariBrand.tagline,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: light ? SafariTheme.goldSoft : SafariTheme.muted,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 3.2,
          ),
        ),
        const SizedBox(height: 10),
        Container(height: 1.2, width: 72, color: light ? SafariTheme.gold : SafariTheme.gold),
      ],
    );
  }
}

class SafariSectionTitle extends StatelessWidget {
  const SafariSectionTitle(this.text, {super.key, this.action, this.onAction});
  final String text;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.headlineSmall),
          ),
          if (action != null)
            TextButton(onPressed: onAction, child: Text(action!)),
        ],
      ),
    );
  }
}

class SafariStatusChip extends StatelessWidget {
  const SafariStatusChip(this.label, {super.key, this.tone = SafariChipTone.neutral});
  final String label;
  final SafariChipTone tone;

  @override
  Widget build(BuildContext context) {
    final colors = switch (tone) {
      SafariChipTone.success => (const Color(0xFF1F6B3A), const Color(0xFFE4F4EA)),
      SafariChipTone.warn => (const Color(0xFF8A5A12), const Color(0xFFF8EDD8)),
      SafariChipTone.danger => (const Color(0xFF8B1E1E), const Color(0xFFF8E4E4)),
      SafariChipTone.gold => (SafariTheme.maroonDark, SafariTheme.goldSoft),
      SafariChipTone.neutral => (SafariTheme.muted, const Color(0xFFF0EAE2)),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: colors.$2, borderRadius: BorderRadius.circular(999)),
      child: Text(label, style: TextStyle(color: colors.$1, fontWeight: FontWeight.w700, fontSize: 11, letterSpacing: 0.4)),
    );
  }
}

enum SafariChipTone { success, warn, danger, gold, neutral }

SafariChipTone statusTone(String? status) {
  switch ((status ?? '').toUpperCase()) {
    case 'ACTIVE':
    case 'PAID':
    case 'AVAILABLE':
    case 'APPROVED':
      return SafariChipTone.success;
    case 'PENDING':
    case 'REQUESTED':
    case 'PROCESSING':
    case 'PENDING_PROVIDER':
    case 'INITIATED':
      return SafariChipTone.warn;
    case 'FAILED':
    case 'REJECTED':
    case 'SUSPENDED':
    case 'CANCELLED':
      return SafariChipTone.danger;
    default:
      return SafariChipTone.neutral;
  }
}

class SafariEmpty extends StatelessWidget {
  const SafariEmpty(this.message, {super.key, this.icon = Icons.inbox_outlined});
  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28),
      child: Column(
        children: [
          Icon(icon, color: SafariTheme.gold, size: 36),
          const SizedBox(height: 10),
          Text(message, textAlign: TextAlign.center, style: const TextStyle(color: SafariTheme.muted)),
        ],
      ),
    );
  }
}

class SafariActionTile extends StatelessWidget {
  const SafariActionTile({super.key, required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SafariCard(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: SafariTheme.maroon.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: SafariTheme.maroon),
          ),
          const SizedBox(height: 10),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
        ],
      ),
    );
  }
}

Future<void> safariError(BuildContext context, Object e) async {
  final msg = e.toString().replaceFirst('Exception: ', '');
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}

String money(dynamic n) {
  final v = n is num ? n : int.tryParse('$n') ?? 0;
  return 'TZS ${qtyFmt(v)}';
}

String qtyFmt(dynamic n) {
  final v = n is num ? n.round() : int.tryParse('$n') ?? 0;
  return v.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]},');
}

class SafariCountUp extends StatelessWidget {
  const SafariCountUp(
    this.value, {
    super.key,
    this.moneyFormat = false,
    this.prefix = '',
    this.suffix = '',
    this.style,
    this.duration = const Duration(milliseconds: 900),
  });

  final dynamic value;
  final bool moneyFormat;
  final String prefix;
  final String suffix;
  final TextStyle? style;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final end = value is num ? value.toDouble() : (double.tryParse('$value') ?? 0);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: end),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (_, n, __) {
        final core = moneyFormat ? money(n.round()) : qtyFmt(n.round());
        return Text('$prefix$core$suffix', style: style);
      },
    );
  }
}

String safariInitials(dynamic name) {
  final parts = '$name'.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).take(2);
  if (parts.isEmpty) return 'G';
  return parts.map((p) => p[0].toUpperCase()).join();
}

String safariGuestName(dynamic raw) {
  if (raw is! Map) return 'Guest';
  final tourist = raw['tourist'];
  return (raw['alias'] ??
          (tourist is Map ? tourist['first_name'] : null) ??
          raw['first_name'] ??
          raw['name'] ??
          'Guest')
      .toString();
}

List<String> safariCsv(dynamic raw) {
  if (raw is List) return raw.map((e) => '$e'.trim()).where((e) => e.isNotEmpty).toList();
  return '$raw'.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
}

String safariDate(dynamic v) {
  if (v == null || '$v'.isEmpty) return '';
  final dt = DateTime.tryParse(v.toString())?.toLocal();
  if (dt == null) return '$v';
  final d = dt.day.toString().padLeft(2, '0');
  final m = dt.month.toString().padLeft(2, '0');
  return '$d/$m/${dt.year}';
}

String ledgerTypeLabel(dynamic type) {
  switch ('$type'.toUpperCase()) {
    case 'COMMISSION':
      return 'Commission';
    case 'GRATUITY':
      return 'Gratuity';
    default:
      return '$type';
  }
}

class SafariLedgerCard extends StatelessWidget {
  const SafariLedgerCard({super.key, required this.row, this.onTap});
  final Map<String, dynamic> row;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final inbound = '${row['direction']}' == 'IN';
    final type = ledgerTypeLabel(row['ledger_type']);
    final note = row['note']?.toString() ?? row['reference']?.toString() ?? '';
    final date = safariDate(row['created_at']);
    return SafariCard(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            inbound ? Icons.south_west_rounded : Icons.north_east_rounded,
            color: inbound ? const Color(0xFF1F6B3A) : SafariTheme.maroon,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(type, style: const TextStyle(fontWeight: FontWeight.w800)),
                if (note.isNotEmpty)
                  Text(note, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: SafariTheme.muted, fontSize: 12)),
                if (date.isNotEmpty)
                  Text(date, style: const TextStyle(color: SafariTheme.muted, fontSize: 11)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${inbound ? '+' : '−'} ${money(row['amount'])}',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: inbound ? const Color(0xFF1F6B3A) : SafariTheme.maroon,
            ),
          ),
        ],
      ),
    );
  }
}

enum SafariLogoVariant { wordmark, poster }

class SafariStickyHeader extends StatelessWidget {
  const SafariStickyHeader({super.key, this.onNotify, this.unread = 0});
  final VoidCallback? onNotify;
  final int unread;

  @override
  Widget build(BuildContext context) {
    final d = SafariApi.driver ?? {};
    final name = (d['name'] ?? 'Guide').toString();
    final first = name.split(' ').first;
    final initials = name.split(' ').where((p) => p.isNotEmpty).take(2).map((p) => p[0]).join().toUpperCase();
    final tier = (d['tier_category']?['label'] ?? d['loyalty']?['label'] ?? 'Guide').toString();
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20, MediaQuery.paddingOf(context).top + 12, 20, 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [SafariTheme.maroon, SafariTheme.maroonDark],
        ),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Expanded(child: SafariLogo(height: 36)),
          if (onNotify != null)
            IconButton(
              onPressed: onNotify,
              icon: Badge(isLabelVisible: unread > 0, child: const Icon(Icons.notifications_outlined, color: Colors.white)),
            ),
          CircleAvatar(
            radius: 19,
            backgroundColor: Colors.white.withValues(alpha: 0.18),
            child: Text(initials.isEmpty ? 'G' : initials, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13)),
          ),
        ]),
        const SizedBox(height: 14),
        const Text('Driver-Guide Partner', style: TextStyle(color: Colors.white70, fontSize: 12, letterSpacing: 0.6)),
        const SizedBox(height: 4),
        Text('Karibu, $first', style: GoogleFonts.playfairDisplay(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
          ),
          child: Text(tier, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 11)),
        ),
      ]),
    );
  }
}

class SafariWalletHero extends StatelessWidget {
  const SafariWalletHero({
    super.key,
    required this.label,
    required this.amount,
    this.actionLabel,
    this.onAction,
  });
  final String label;
  final dynamic amount;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(colors: [Colors.white, Color(0xFFF4E9D4)]),
        border: Border.all(color: SafariTheme.cardBorder),
        boxShadow: [BoxShadow(color: SafariTheme.maroon.withValues(alpha: 0.10), blurRadius: 32, offset: const Offset(0, 12))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(color: SafariTheme.muted, fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        SafariCountUp(amount, moneyFormat: true, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: SafariTheme.maroon)),
        if (actionLabel != null) ...[
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(onPressed: onAction, child: Text(actionLabel!)),
          ),
        ],
      ]),
    );
  }
}

class SafariStatRow extends StatelessWidget {
  const SafariStatRow({super.key, required this.items});
  final List<(String, dynamic, {bool money, String suffix})> items;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: SafariTheme.statFill, borderRadius: BorderRadius.circular(14)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SafariCountUp(
                  items[i].$2,
                  moneyFormat: items[i].money,
                  suffix: items[i].suffix,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: SafariTheme.maroon),
                ),
                const SizedBox(height: 4),
                Text(items[i].$1, style: const TextStyle(color: SafariTheme.muted, fontSize: 11)),
              ]),
            ),
          ),
        ],
      ],
    );
  }
}

class SafariActionGrid extends StatelessWidget {
  const SafariActionGrid({super.key, required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) const SizedBox(width: 10),
          Expanded(child: children[i]),
        ],
      ],
    );
  }
}

class SafariFeatureGrid extends StatelessWidget {
  const SafariFeatureGrid({super.key, required this.items});
  final List<(String, String, VoidCallback)> items;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 9,
      crossAxisSpacing: 9,
      childAspectRatio: 1.35,
      children: items
          .map((item) => SafariCard(
                onTap: item.$3,
                padding: const EdgeInsets.all(14),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(item.$1, style: const TextStyle(fontWeight: FontWeight.w800, color: SafariTheme.maroon)),
                  const SizedBox(height: 6),
                  Text(item.$2, style: const TextStyle(color: SafariTheme.muted, fontSize: 12)),
                ]),
              ))
          .toList(),
    );
  }
}

class SafariFilterTabs extends StatelessWidget {
  const SafariFilterTabs({super.key, required this.tabs, required this.index, required this.onChanged});
  final List<String> tabs;
  final int index;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < tabs.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          GestureDetector(
            onTap: () => onChanged(i),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: i == index ? SafariTheme.maroon : SafariTheme.altFill,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                tabs[i],
                style: TextStyle(color: i == index ? Colors.white : SafariTheme.maroon, fontWeight: FontWeight.w800, fontSize: 12),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class SafariDreamCard extends StatelessWidget {
  const SafariDreamCard({super.key, required this.title, required this.body, this.onEdit});
  final String title;
  final String body;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3EAD9),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: SafariTheme.gold, width: 1.4, strokeAlign: BorderSide.strokeAlignInside),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('MY NEXT CHAPTER', style: TextStyle(color: SafariTheme.muted, fontSize: 11, letterSpacing: 1.4, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Text(title, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 6),
        Text(body, style: const TextStyle(color: SafariTheme.muted)),
        if (onEdit != null)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(onPressed: onEdit, child: const Text('Edit Goals')),
          ),
      ]),
    );
  }
}

class SafariFarewellHero extends StatelessWidget {
  const SafariFarewellHero({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [SafariTheme.maroonDark, SafariTheme.gold]),
      ),
      child: DefaultTextStyle.merge(style: const TextStyle(color: Colors.white), child: child),
    );
  }
}

class SafariGoldButton extends StatelessWidget {
  const SafariGoldButton({super.key, required this.label, required this.onPressed});
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(backgroundColor: SafariTheme.gold, foregroundColor: SafariTheme.maroonDark, minimumSize: const Size(0, 46)),
      child: Text(label),
    );
  }
}

class SafariAltButton extends StatelessWidget {
  const SafariAltButton({super.key, required this.label, required this.onPressed});
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(backgroundColor: SafariTheme.altFill, foregroundColor: SafariTheme.maroon, minimumSize: const Size(0, 46)),
      child: Text(label),
    );
  }
}

class SafariStatBox extends StatelessWidget {
  const SafariStatBox({super.key, required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: SafariTheme.statFill, borderRadius: BorderRadius.circular(14)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.w800, color: SafariTheme.maroon, fontSize: 16)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: SafariTheme.muted, fontSize: 11)),
      ]),
    );
  }
}

class SafariFeatureTile extends StatelessWidget {
  const SafariFeatureTile({super.key, required this.title, required this.subtitle, required this.onTap});
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SafariCard(
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w800, color: SafariTheme.maroon)),
        const SizedBox(height: 4),
        Text(subtitle, style: const TextStyle(color: SafariTheme.muted, fontSize: 12)),
      ]),
    );
  }
}

Future<T?> safariSheet<T>(BuildContext context, Widget child) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    backgroundColor: SafariTheme.canvas,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (ctx) => Padding(
      padding: EdgeInsets.fromLTRB(22, 18, 22, 22 + MediaQuery.viewInsetsOf(ctx).bottom),
      child: child,
    ),
  );
}
