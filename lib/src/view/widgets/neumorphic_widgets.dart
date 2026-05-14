import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:wicom/core/app_color.dart';
import 'package:wicom/core/app_neumorphic.dart';

/// Full-screen canvas using the current neumorphic base color.
class NeuScreenCanvas extends StatelessWidget {
  const NeuScreenCanvas({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return NeumorphicBackground(
      backendColor: AppColor.neumorphicBase,
      child: child,
    );
  }
}

/// Raised primary action (brand green), full width.
class NeuPrimaryButton extends StatelessWidget {
  const NeuPrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.loading = false,
    this.icon,
    this.height = 52,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final IconData? icon;
  final double height;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !loading;
    return SizedBox(
      width: double.infinity,
      height: height,
      child: NeumorphicButton(
        onPressed: enabled ? onPressed : null,
        style: NeumorphicStyle(
          color: AppColor.primaryColor,
          depth: enabled ? 6 : 1,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(14)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: loading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: Colors.white, size: 22),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

/// Secondary / outline-style neumorphic button, full width.
class NeuSecondaryButton extends StatelessWidget {
  const NeuSecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.height = 50,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final double height;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    return SizedBox(
      width: double.infinity,
      height: height,
      child: NeumorphicButton(
        onPressed: onPressed,
        style: NeumorphicStyle(
          color: AppColor.neumorphicSurface,
          depth: enabled ? 3 : 1,
          border: NeumorphicBorder(
            color: AppColor.primaryColor.withValues(alpha: enabled ? 0.35 : 0.15),
            width: 0.8,
          ),
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(14)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: AppColor.primaryColor.withValues(alpha: enabled ? 1 : 0.45),
                size: 22,
              ),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: TextStyle(
                color: AppColor.primaryColor.withValues(alpha: enabled ? 1 : 0.45),
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Destructive full-width action (e.g. log out).
class NeuDangerButton extends StatelessWidget {
  const NeuDangerButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.height = 50,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final double height;

  @override
  Widget build(BuildContext context) {
    const red = Color(0xFFDC2626);
    return SizedBox(
      width: double.infinity,
      height: height,
      child: NeumorphicButton(
        onPressed: onPressed,
        style: NeumorphicStyle(
          color: red,
          depth: 5,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(14)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white, size: 22),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Inset text field with optional label.
class NeuTextField extends StatelessWidget {
  const NeuTextField({
    super.key,
    required this.controller,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffix,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
  });

  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final Widget? suffix;
  final bool obscureText;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null) ...[
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              labelText!,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: AppColor.textSecondary,
              ),
            ),
          ),
        ],
        Neumorphic(
          style: AppNeumorphic.insetField(context),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            onChanged: onChanged,
            style: const TextStyle(fontSize: 16, color: AppColor.textPrimary),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 15),
              prefixIcon: prefixIcon != null
                  ? Icon(prefixIcon, color: AppColor.primaryColor, size: 22)
                  : null,
              suffixIcon: suffix,
              border: InputBorder.none,
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}

/// Raised panel for list tiles or copy blocks.
class NeuPanel extends StatelessWidget {
  const NeuPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(4),
    this.margin = EdgeInsets.zero,
    this.depth = 4,
  });

  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final double depth;

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      margin: margin,
      padding: padding,
      style: AppNeumorphic.raisedSurface(context, depth: depth),
      child: child,
    );
  }
}
