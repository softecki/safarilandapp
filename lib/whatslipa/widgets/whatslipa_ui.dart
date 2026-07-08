import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wicom/core/app_color.dart';
import 'package:wicom/core/whatslipa_brand.dart';
class WhatsLipaUi {
  WhatsLipaUi._();

  static Color get primary => WhatsLipaBrand.primary;
  static Color get secondary => WhatsLipaBrand.secondary;

  static LinearGradient brandGradient({Alignment begin = Alignment.topLeft, Alignment end = Alignment.bottomRight}) {
    return LinearGradient(
      begin: begin,
      end: end,
      colors: [primary, secondary],
    );
  }

  static LinearGradient softBackgroundGradient() {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        primary.withValues(alpha: 0.08),
        AppColor.neumorphicBase,
        const Color(0xFFF7FBF8),
      ],
      stops: const [0, 0.35, 1],
    );
  }

  static List<BoxShadow> cardShadow({Color? tint, double blur = 18, double y = 8}) {
    final c = tint ?? primary;
    return [
      BoxShadow(
        color: c.withValues(alpha: 0.12),
        blurRadius: blur,
        offset: Offset(0, y),
      ),
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.04),
        blurRadius: 6,
        offset: const Offset(0, 2),
      ),
    ];
  }

  static BoxDecoration glassCard({Color? borderTint}) {
    return BoxDecoration(
      color: Colors.white.withValues(alpha: 0.96),
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: (borderTint ?? primary).withValues(alpha: 0.08)),
      boxShadow: cardShadow(tint: borderTint),
    );
  }

  static TextStyle get headline => TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w800,
        color: primary,
        letterSpacing: -0.5,
        height: 1.15,
      );

  static TextStyle get sectionTitle => const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColor.textPrimary,
        letterSpacing: -0.2,
      );

  static TextStyle get subtitle => const TextStyle(
        fontSize: 14,
        color: AppColor.textSecondary,
        height: 1.45,
      );

  static TextStyle get badgeLabel => TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: primary,
        letterSpacing: 0.6,
      );
}

class WhatsLipaScreenBackground extends StatelessWidget {
  const WhatsLipaScreenBackground({super.key, required this.child, this.withGradient = true});

  final Widget child;
  final bool withGradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: withGradient ? WhatsLipaUi.softBackgroundGradient() : null,
        color: withGradient ? null : AppColor.neumorphicBase,
      ),
      child: child,
    );
  }
}

class WhatsLipaBrandLogo extends StatelessWidget {
  const WhatsLipaBrandLogo({super.key, this.size = 88, this.icon = Icons.storefront_rounded});

  final double size;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final asset = WhatsLipaBrand.logoAsset;
    if (asset != null) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: WhatsLipaBrand.lotiGasYellow,
          borderRadius: BorderRadius.circular(size * 0.08),
          border: Border.all(color: WhatsLipaBrand.lotiGasBlack.withValues(alpha: 0.08)),
          boxShadow: [
            BoxShadow(
              color: WhatsLipaBrand.lotiGasBlack.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: EdgeInsets.all(size * 0.06),
        child: Image.asset(
          asset,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
          errorBuilder: (_, __, ___) => Icon(
            Icons.propane_tank_outlined,
            color: WhatsLipaBrand.lotiGasBlack,
            size: size * 0.5,
          ),
        ),
      );
    }

    final p = WhatsLipaUi.primary;
    final onP = WhatsLipaBrand.onPrimary;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: WhatsLipaUi.brandGradient(),
        boxShadow: [
          BoxShadow(color: p.withValues(alpha: 0.35), blurRadius: 24, offset: const Offset(0, 10)),
        ],
      ),
      child: Icon(icon, color: onP, size: size * 0.44),
    );
  }
}

class WhatsLipaPrimaryButton extends StatelessWidget {
  const WhatsLipaPrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.loading = false,
    this.icon,
    this.height = 54,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final IconData? icon;
  final double height;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !loading;
    final onBtn = WhatsLipaBrand.onPrimary;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onPressed : null,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: enabled
                ? WhatsLipaUi.brandGradient()
                : LinearGradient(colors: [Colors.grey.shade400, Colors.grey.shade500]),
            boxShadow: enabled ? WhatsLipaUi.cardShadow(blur: 14, y: 6) : null,
          ),
          child: Center(
            child: loading
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2.5, color: onBtn),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[Icon(icon, color: onBtn, size: 22), const SizedBox(width: 10)],
                      Text(
                        label,
                        style: TextStyle(color: onBtn, fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class WhatsLipaGlassCard extends StatelessWidget {
  const WhatsLipaGlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(22),
    this.margin = EdgeInsets.zero,
  });

  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: WhatsLipaUi.glassCard(),
      child: child,
    );
  }
}

class WhatsLipaGradientHeader extends StatelessWidget {
  const WhatsLipaGradientHeader({
    super.key,
    required this.child,
    this.bottomRadius = 28,
    this.padding = const EdgeInsets.fromLTRB(20, 12, 12, 24),
  });

  final Widget child;
  final double bottomRadius;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final onHeader = WhatsLipaBrand.onPrimary;
    final isLotiGas = WhatsLipaBrand.isLotiGas;

    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: isLotiGas ? WhatsLipaBrand.lotiGasYellow : null,
        gradient: isLotiGas
            ? null
            : WhatsLipaUi.brandGradient(begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(bottomRadius),
          bottomRight: Radius.circular(bottomRadius),
        ),
        boxShadow: [
          BoxShadow(
            color: (isLotiGas ? WhatsLipaBrand.lotiGasBlack : WhatsLipaUi.primary).withValues(alpha: 0.18),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: DefaultTextStyle(
        style: TextStyle(color: onHeader),
        child: IconTheme(
          data: IconThemeData(color: onHeader),
          child: child,
        ),
      ),
    );
  }
}

class WhatsLipaHeaderIconButton extends StatelessWidget {
  const WhatsLipaHeaderIconButton({super.key, required this.icon, required this.onPressed, this.tooltip});

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final onHeader = WhatsLipaBrand.onPrimary;
    return Material(
      color: onHeader == Colors.white
          ? Colors.white.withValues(alpha: 0.18)
          : Colors.black.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, color: onHeader, size: 22),
        ),
      ),
    );
  }
}

class WhatsLipaModuleTile extends StatelessWidget {
  const WhatsLipaModuleTile({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
    this.useWhatsAppBrand = false,
  });

  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool useWhatsAppBrand;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: color.withValues(alpha: 0.12)),
            boxShadow: WhatsLipaUi.cardShadow(tint: color, blur: 16, y: 6),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [color.withValues(alpha: 0.18), color.withValues(alpha: 0.06)],
                    ),
                  ),
                  child: Center(
                    child: useWhatsAppBrand
                        ? const FaIcon(FontAwesomeIcons.whatsapp, color: Color(0xFF25D366), size: 28)
                        : Icon(icon, color: color, size: 28),
                  ),
                ),
                const Spacer(),
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    color: AppColor.textPrimary,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text('Open', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
                    const SizedBox(width: 4),
                    Icon(Icons.arrow_forward_rounded, size: 14, color: color),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WhatsLipaStyledAppBar extends StatelessWidget implements PreferredSizeWidget {
  const WhatsLipaStyledAppBar({
    super.key,
    this.title = '',
    this.titleWidget,
    this.actions,
    this.leading,
    this.accentColor,
  });

  final String title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final Color? accentColor;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final accent = accentColor ?? WhatsLipaUi.primary;
    final onPrimary = WhatsLipaBrand.onPrimary;
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: WhatsLipaBrand.isLotiGas
                ? [accent, accent]
                : [accent, Color.lerp(accent, WhatsLipaUi.secondary, 0.45)!],
          ),
        ),
      ),
      foregroundColor: onPrimary,
      iconTheme: IconThemeData(color: onPrimary),
      title: titleWidget ??
          (title.isNotEmpty
              ? Text(title, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: onPrimary))
              : null),
      leading: leading,
      actions: actions,
    );
  }
}

class WhatsLipaEmptyState extends StatelessWidget {
  const WhatsLipaEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: WhatsLipaUi.primary.withValues(alpha: 0.08),
            ),
            child: Icon(icon, size: 52, color: WhatsLipaUi.primary.withValues(alpha: 0.45)),
          ),
          const SizedBox(height: 20),
          Text(title, textAlign: TextAlign.center, style: WhatsLipaUi.sectionTitle),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center, style: WhatsLipaUi.subtitle),
        ],
      ),
    );
  }
}

class WhatsLipaInputField extends StatelessWidget {
  const WhatsLipaInputField({
    super.key,
    required this.controller,
    this.label,
    this.hint,
    this.prefixIcon,
    this.suffix,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
  });

  final TextEditingController controller;
  final String? label;
  final String? hint;
  final IconData? prefixIcon;
  final Widget? suffix;
  final bool obscureText;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!, style: WhatsLipaUi.badgeLabel),
          const SizedBox(height: 8),
        ],
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: const Color(0xFFF4F8F5),
            prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: WhatsLipaUi.primary) : null,
            suffixIcon: suffix,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: WhatsLipaUi.primary.withValues(alpha: 0.08)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: WhatsLipaUi.primary.withValues(alpha: 0.45), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
