import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wicom/safari/safari_api.dart';
import 'package:wicom/safari/safari_brand.dart';
import 'package:wicom/safari/safari_theme.dart';

class SafariLogo extends StatelessWidget {
  const SafariLogo({
    super.key,
    this.height = 56,
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
        style: SafariTheme.display(
          size: height * 0.42,
          weight: FontWeight.w700,
          color: variant == SafariLogoVariant.poster ? Colors.white : SafariTheme.black,
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
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(SafariTheme.cardRadius),
        border: goldEdge
            ? Border.all(color: SafariTheme.gold.withValues(alpha: 0.55))
            : Border.all(color: SafariTheme.cardBorder),
        boxShadow: SafariTheme.quietShadow,
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
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SafariTheme.cardRadius),
        gradient: SafariTheme.heroGradient,
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
            letterSpacing: 1.8,
          ),
        ),
        const SizedBox(height: 6),
        Container(height: 1, width: 48, color: SafariTheme.gold),
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
      padding: const EdgeInsets.only(bottom: 8, top: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.titleMedium),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: colors.$2, borderRadius: BorderRadius.circular(999)),
      child: Text(label, style: TextStyle(color: colors.$1, fontWeight: FontWeight.w600, fontSize: 10, letterSpacing: 0.2)),
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
    case 'ARRIVED':
    case 'PURCHASED':
      return SafariChipTone.success;
    case 'PENDING':
    case 'REQUESTED':
    case 'PROCESSING':
    case 'PENDING_PROVIDER':
    case 'INITIATED':
    case 'CREATED':
      return SafariChipTone.warn;
    case 'FAILED':
    case 'REJECTED':
    case 'SUSPENDED':
    case 'CANCELLED':
    case 'EXPIRED':
    case 'DISPUTED':
      return SafariChipTone.danger;
    default:
      return SafariChipTone.neutral;
  }
}

int safariGuestCount(dynamic raw) {
  if (raw is! Map) return 0;
  final guests = raw['guests'];
  final listed = guests is List ? guests.length : 0;
  for (final key in ['guest_count', 'guests_count', 'eta_guest_count']) {
    final n = raw[key];
    final v = n is num ? n.toInt() : int.tryParse('$n') ?? 0;
    if (v > 0) return v;
  }
  return listed;
}

String safariPassStatus(dynamic status) {
  final s = '$status'.trim();
  if (s.isEmpty || s == 'null') return 'Created';
  return s.replaceAll('_', ' ');
}

class SafariEmpty extends StatelessWidget {
  const SafariEmpty(this.message, {super.key, this.icon = Icons.inbox_outlined, this.actionLabel, this.onAction});
  final String message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 12),
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(color: SafariTheme.sand, borderRadius: BorderRadius.circular(16)),
            child: Icon(icon, color: SafariTheme.wine, size: 26),
          ),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center, style: const TextStyle(color: SafariTheme.muted, fontSize: 13, height: 1.4)),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 14),
            SizedBox(
              height: 44,
              child: OutlinedButton(onPressed: onAction, child: Text(actionLabel!)),
            ),
          ],
        ],
      ),
    );
  }
}

bool safariIsOffline(Object e) {
  final s = e.toString().toLowerCase();
  return s.contains('socketexception') ||
      s.contains('failed host lookup') ||
      s.contains('network is unreachable') ||
      s.contains('connection refused') ||
      s.contains('connection reset') ||
      s.contains('timed out') ||
      s.contains('timeout') ||
      s.contains('clientexception') ||
      s.contains('xmlhttprequest') ||
      s.contains('network error');
}

class SafariOffline extends StatelessWidget {
  const SafariOffline({super.key, required this.onRetry, this.message});
  final VoidCallback onRetry;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SafariEmpty(
        message ?? 'You appear to be offline. Check your connection and try again.',
        icon: Icons.wifi_off_outlined,
        actionLabel: 'Try again',
        onAction: onRetry,
      ),
    );
  }
}

class SafariStepBar extends StatelessWidget {
  const SafariStepBar({super.key, required this.steps, required this.index, this.onBack});
  final List<String> steps;
  final int index;
  final ValueChanged<int>? onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            for (var i = 0; i < steps.length; i++) ...[
              _dot(i),
              if (i < steps.length - 1)
                Expanded(
                  child: Container(
                    height: 1,
                    color: i < index ? SafariTheme.wine : SafariTheme.cardBorder,
                  ),
                ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            for (var i = 0; i < steps.length; i++)
              Expanded(
                child: Text(
                  steps[i],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: i == index ? FontWeight.w700 : FontWeight.w500,
                    color: i == index ? SafariTheme.wine : SafariTheme.muted,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _dot(int i) {
    final on = i <= index;
    final child = Container(
      width: 28,
      height: 28,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: on ? SafariTheme.wine : SafariTheme.sand,
        shape: BoxShape.circle,
        border: Border.all(color: on ? SafariTheme.wine : SafariTheme.cardBorder),
      ),
      child: Text(
        '${i + 1}',
        style: TextStyle(color: on ? Colors.white : SafariTheme.muted, fontSize: 12, fontWeight: FontWeight.w700),
      ),
    );
    if (onBack != null && i < index) {
      return InkWell(onTap: () => onBack!(i), customBorder: const CircleBorder(), child: child);
    }
    return child;
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
      child: Column(
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: SafariTheme.sand,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: SafariTheme.wine, size: 22),
          ),
          const SizedBox(height: 8),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
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
  return (raw['guest_label'] ??
          raw['alias'] ??
          (tourist is Map ? tourist['first_name'] : null) ??
          raw['first_name'] ??
          raw['name'] ??
          raw['guest'] ??
          'Guest')
      .toString();
}

int safariPassGuestNumber(Map row, [int fallback = 1]) {
  final n = row['guest_number'];
  if (n is num && n > 0) return n.toInt();
  for (final key in ['guest_label', 'alias', 'first_name', 'guest']) {
    final match = RegExp(r'Guest\s+(\d+)', caseSensitive: false).firstMatch('${row[key] ?? ''}');
    if (match != null) return int.parse(match.group(1)!);
  }
  final tourist = row['tourist'];
  if (tourist is Map) {
    final match = RegExp(r'Guest\s+(\d+)', caseSensitive: false).firstMatch('${tourist['first_name'] ?? ''}');
    if (match != null) return int.parse(match.group(1)!);
  }
  return fallback;
}

String safariPassGuestSign(Map row, [int fallback = 1]) => 'Guest ${safariPassGuestNumber(row, fallback)}';

List<int> safariPassGuestNumbers(List rows) {
  final nos = List<int>.filled(rows.length, 1);
  final byTrip = <String, List<int>>{};
  for (var i = 0; i < rows.length; i++) {
    final row = rows[i] as Map;
    final key = '${row['trip_label'] ?? row['trip_id'] ?? 'pass-$i'}';
    byTrip.putIfAbsent(key, () => []).add(i);
  }
  for (final indexes in byTrip.values) {
    indexes.sort((a, b) {
      final da = DateTime.tryParse('${(rows[a] as Map)['created_at'] ?? ''}');
      final db = DateTime.tryParse('${(rows[b] as Map)['created_at'] ?? ''}');
      if (da != null && db != null) return da.compareTo(db);
      return a.compareTo(b);
    });
    for (var n = 0; n < indexes.length; n++) {
      nos[indexes[n]] = safariPassGuestNumber(rows[indexes[n]] as Map, n + 1);
    }
  }
  return nos;
}

String? safariGuestPhone(dynamic raw) {
  if (raw is! Map) return null;
  final tourist = raw['tourist'];
  final value = raw['guest_whatsapp'] ??
      raw['whatsapp'] ??
      raw['phone'] ??
      (tourist is Map ? (tourist['phone'] ?? tourist['whatsapp']) : null);
  final text = value?.toString().trim() ?? '';
  return text.isEmpty ? null : text;
}

String? safariWhatsAppDigits(String raw) {
  var digits = raw.replaceAll(RegExp(r'\D'), '');
  if (digits.isEmpty) return null;
  if (digits.startsWith('00')) digits = digits.substring(2);
  if (digits.startsWith('0') && digits.length == 10) return '255${digits.substring(1)}';
  if (digits.length == 9 && (digits.startsWith('6') || digits.startsWith('7'))) return '255$digits';
  if (digits.length >= 9 && digits.length <= 15) return digits;
  return null;
}

Future<bool> safariOpenWhatsApp(String raw, String message) async {
  final n = safariWhatsAppDigits(raw);
  if (n == null) return false;
  final uri = Uri.parse('https://wa.me/$n?text=${Uri.encodeComponent(message)}');
  return launchUrl(uri, mode: LaunchMode.externalApplication);
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

String safariDateTime(dynamic v) {
  if (v == null || '$v'.isEmpty) return '';
  final dt = DateTime.tryParse(v.toString())?.toLocal();
  if (dt == null) return safariDate(v);
  final h = dt.hour.toString().padLeft(2, '0');
  final min = dt.minute.toString().padLeft(2, '0');
  return '${safariDate(v)} · $h:$min';
}

bool safariNotificationUnread(Map row) {
  final v = row['read_at'];
  return v == null || v.toString().trim().isEmpty || v.toString() == 'null';
}

String ledgerTypeLabel(dynamic type) {
  switch ('$type'.toUpperCase()) {
    case 'COMMISSION':
    case 'POINTS':
    case 'POINTS_WITHDRAWAL':
      return 'Points';
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
                Text(type, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
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
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: inbound ? const Color(0xFF1F6B3A) : SafariTheme.maroon,
            ),
          ),
        ],
      ),
    );
  }
}

enum SafariLogoVariant { wordmark, poster }

class SafariWordmark extends StatelessWidget {
  const SafariWordmark({super.key, this.light = true});
  final bool light;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SAFARI LAND',
          style: SafariTheme.display(
            size: 22,
            weight: FontWeight.w700,
            color: light ? Colors.white : SafariTheme.black,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'GO BEYOND THE SAFARI',
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.6,
            height: 1.2,
            color: light ? SafariTheme.goldSoft : SafariTheme.muted,
          ),
        ),
      ],
    );
  }
}

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
    return SizedBox(
      width: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              SafariBrand.posterAsset,
              fit: BoxFit.cover,
              alignment: Alignment.center,
              errorBuilder: (_, __, ___) => const ColoredBox(color: SafariTheme.darkEarth),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    SafariTheme.darkEarth.withValues(alpha: 0.55),
                    SafariTheme.wine.withValues(alpha: 0.88),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16, MediaQuery.paddingOf(context).top + 10, 16, 18),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const Expanded(child: SafariWordmark()),
                if (onNotify != null)
                  IconButton(
                    onPressed: onNotify,
                    icon: Badge(isLabelVisible: unread > 0, child: const Icon(Icons.notifications_outlined, color: Colors.white, size: 22)),
                  ),
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white.withValues(alpha: 0.18),
                  child: Text(initials.isEmpty ? 'G' : initials, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
                ),
              ]),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('Driver-Guide Partner', style: TextStyle(color: SafariTheme.goldSoft, fontSize: 11, letterSpacing: 0.8, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text('Karibu, $first', style: SafariTheme.display(color: Colors.white, size: 26)),
                  ]),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: SafariTheme.gold.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: SafariTheme.gold.withValues(alpha: 0.45)),
                  ),
                  child: Text(tier, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 11)),
                ),
              ]),
            ]),
          ),
        ],
      ),
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
    this.stats = const [],
  });
  final String label;
  final dynamic amount;
  final String? actionLabel;
  final VoidCallback? onAction;
  final List<(String, String)> stats;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SafariTheme.cardRadius),
        color: Colors.white,
        border: Border.all(color: SafariTheme.gold.withValues(alpha: 0.45)),
        boxShadow: SafariTheme.quietShadow,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(color: SafariTheme.muted, fontSize: 12, fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SafariCountUp(amount, moneyFormat: true, style: SafariTheme.display(size: 28, color: SafariTheme.wine, weight: FontWeight.w700)),
            ),
            if (actionLabel != null)
              SizedBox(
                height: 34,
                child: ElevatedButton(
                  onPressed: onAction,
                  style: ElevatedButton.styleFrom(minimumSize: const Size(0, 48), padding: const EdgeInsets.symmetric(horizontal: 16)),
                  child: Text(actionLabel!),
                ),
              ),
          ],
        ),
        if (stats.isNotEmpty) ...[
          const SizedBox(height: 12),
          Container(height: 1, color: SafariTheme.cardBorder),
          const SizedBox(height: 10),
          Row(
            children: [
              for (var i = 0; i < stats.length; i++) ...[
                if (i > 0) Container(width: 1, height: 28, color: SafariTheme.cardBorder),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Column(children: [
                      Text(stats[i].$2, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: SafariTheme.maroon)),
                      const SizedBox(height: 2),
                      Text(stats[i].$1, textAlign: TextAlign.center, style: const TextStyle(color: SafariTheme.muted, fontSize: 10)),
                    ]),
                  ),
                ),
              ],
            ],
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
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: SafariTheme.statFill, borderRadius: BorderRadius.circular(10)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SafariCountUp(
                  items[i].$2,
                  moneyFormat: items[i].money,
                  suffix: items[i].suffix,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: SafariTheme.maroon),
                ),
                const SizedBox(height: 2),
                Text(items[i].$1, style: const TextStyle(color: SafariTheme.muted, fontSize: 10)),
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
      childAspectRatio: 1.7,
      children: items
          .map((item) => SafariCard(
                onTap: item.$3,
                padding: const EdgeInsets.all(10),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(item.$1, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: SafariTheme.maroon)),
                  const SizedBox(height: 4),
                  Text(item.$2, style: const TextStyle(color: SafariTheme.muted, fontSize: 11)),
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
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: i == index ? SafariTheme.wine : SafariTheme.sand,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                tabs[i],
                style: TextStyle(color: i == index ? Colors.white : SafariTheme.maroon, fontWeight: FontWeight.w600, fontSize: 12),
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF3EAD9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: SafariTheme.gold, width: 1, strokeAlign: BorderSide.strokeAlignInside),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('MY NEXT CHAPTER', style: TextStyle(color: SafariTheme.muted, fontSize: 10, letterSpacing: 0.8, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 4),
        Text(body, style: const TextStyle(color: SafariTheme.muted, fontSize: 13)),
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
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(SafariTheme.cardRadius)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [SafariTheme.darkEarth, SafariTheme.wine.withValues(alpha: 0.92)],
        ),
      ),
      child: DefaultTextStyle.merge(style: const TextStyle(color: Colors.white), child: child),
    );
  }
}

class SafariPageBody extends StatelessWidget {
  const SafariPageBody({super.key, required this.child, this.padding});
  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: SafariTheme.contentMaxWidth),
        child: SingleChildScrollView(
          padding: padding ?? const EdgeInsets.fromLTRB(16, 12, 16, 88),
          child: child,
        ),
      ),
    );
  }
}

class SafariPhotoBanner extends StatelessWidget {
  const SafariPhotoBanner({super.key, required this.child, this.height = 168});
  final Widget child;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height + MediaQuery.paddingOf(context).top,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            SafariBrand.posterAsset,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const ColoredBox(color: SafariTheme.darkEarth),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  SafariTheme.darkEarth.withValues(alpha: 0.35),
                  SafariTheme.wine.withValues(alpha: 0.82),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16, MediaQuery.paddingOf(context).top + 8, 16, 16),
            child: child,
          ),
        ],
      ),
    );
  }
}

class SafariLoadingButton extends StatelessWidget {
  const SafariLoadingButton({
    super.key,
    required this.label,
    required this.loading,
    required this.onPressed,
  });

  final String label;
  final bool loading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: loading ? () {} : onPressed,
      child: loading
          ? const SizedBox(
              height: 22,
              width: 22,
              child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white),
            )
          : Text(label),
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
      style: ElevatedButton.styleFrom(backgroundColor: SafariTheme.gold, foregroundColor: SafariTheme.darkEarth, minimumSize: const Size(0, 48), textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      child: Text(label),
    );
  }
}

class SafariGoogleButton extends StatelessWidget {
  const SafariGoogleButton({super.key, required this.loading, required this.onPressed, this.label = 'Continue with Google'});
  final bool loading;
  final VoidCallback? onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: loading ? () {} : onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: SafariTheme.black,
        backgroundColor: Colors.white,
        side: const BorderSide(color: SafariTheme.cardBorder),
        minimumSize: const Size(0, 48),
      ),
      child: loading
          ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2.4, color: SafariTheme.wine))
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 18,
                  height: 18,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: const Color(0xFF4285F4), width: 1.4),
                  ),
                  child: const Text('G', style: TextStyle(color: Color(0xFF4285F4), fontWeight: FontWeight.w800, fontSize: 12, height: 1)),
                ),
                const SizedBox(width: 10),
                Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
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
      style: ElevatedButton.styleFrom(backgroundColor: SafariTheme.sand, foregroundColor: SafariTheme.wine, minimumSize: const Size(0, 48), textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
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
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: SafariTheme.statFill, borderRadius: BorderRadius.circular(10)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.w700, color: SafariTheme.maroon, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: SafariTheme.muted, fontSize: 10)),
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
      padding: const EdgeInsets.all(10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: SafariTheme.maroon)),
        const SizedBox(height: 3),
        Text(subtitle, style: const TextStyle(color: SafariTheme.muted, fontSize: 11)),
      ]),
    );
  }
}

Future<T?> safariSheet<T>(BuildContext context, Widget child) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    backgroundColor: SafariTheme.canvas,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
    builder: (ctx) => Padding(
      padding: EdgeInsets.fromLTRB(16, 14, 16, 16 + MediaQuery.viewInsetsOf(ctx).bottom),
      child: child,
    ),
  );
}
