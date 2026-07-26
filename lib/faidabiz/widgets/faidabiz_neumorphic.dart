import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:wicom/core/app_color.dart';
import 'package:wicom/core/app_neumorphic.dart';
import 'package:wicom/faidabiz/faidabiz_theme.dart';

export 'package:wicom/src/view/widgets/neumorphic_widgets.dart'
    show NeuPrimaryButton, NeuSecondaryButton, NeuDangerButton, NeuPanel, NeuScreenCanvas;

/// Soft neumorphic canvas color used by FaidaBiz forms.
const faidaBizNeuCanvas = AppColor.neumorphicBase;

/// Wraps a subtree with [NeumorphicTheme] so inset/raised surfaces render correctly.
class FaidaBizNeuScope extends StatelessWidget {
  const FaidaBizNeuScope({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return NeumorphicTheme(
      themeMode: ThemeMode.light,
      theme: AppNeumorphic.lightTheme,
      child: child,
    );
  }
}

/// Form page scaffold: neumorphic base background + optional app bar.
class FaidaBizNeuFormScaffold extends StatelessWidget {
  const FaidaBizNeuFormScaffold({
    super.key,
    required this.appBar,
    required this.body,
    this.floatingActionButton,
  });

  final PreferredSizeWidget appBar;
  final Widget body;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return FaidaBizNeuScope(
      child: Scaffold(
        backgroundColor: faidaBizNeuCanvas,
        appBar: appBar,
        floatingActionButton: floatingActionButton,
        body: NeumorphicBackground(
          backendColor: faidaBizNeuCanvas,
          child: body,
        ),
      ),
    );
  }
}

/// Inset neumorphic text field (label above, sunken input).
class FaidaBizNeuField extends StatelessWidget {
  const FaidaBizNeuField({
    super.key,
    required this.controller,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffix,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.onChanged,
    this.autofocus = false,
  });

  final TextEditingController controller;
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final IconData? prefixIcon;
  final Widget? suffix;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final int maxLines;
  final int? minLines;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final ValueChanged<String>? onChanged;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText!.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              label!,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: hasError ? Colors.red.shade700 : AppColor.textSecondary,
              ),
            ),
          ),
        ],
        Neumorphic(
          style: NeumorphicStyle(
            depth: enabled ? -4 : -1,
            intensity: 0.68,
            color: NeumorphicTheme.baseColor(context),
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(14)),
            border: hasError
                ? NeumorphicBorder(color: Colors.red.shade300, width: 1)
                : const NeumorphicBorder.none(),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            enabled: enabled,
            readOnly: readOnly,
            maxLines: obscureText ? 1 : maxLines,
            minLines: minLines,
            autofocus: autofocus,
            keyboardType: keyboardType,
            textCapitalization: textCapitalization,
            onChanged: onChanged,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: enabled ? AppColor.textPrimary : Colors.grey.shade500,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 15),
              prefixIcon: prefixIcon != null
                  ? Icon(prefixIcon, color: FaidaBizTheme.green, size: 22)
                  : null,
              suffixIcon: suffix,
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: maxLines > 1 ? 14 : 14,
              ),
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(errorText!, style: TextStyle(color: Colors.red.shade700, fontSize: 12.5)),
          ),
        ] else if (helperText != null && helperText!.isNotEmpty) ...[
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(helperText!, style: TextStyle(color: Colors.grey.shade600, fontSize: 12, height: 1.35)),
          ),
        ],
      ],
    );
  }
}

/// Neumorphic tappable select / dropdown field.
class FaidaBizNeuSelect extends StatelessWidget {
  const FaidaBizNeuSelect({
    super.key,
    required this.label,
    required this.onTap,
    this.valueLabel,
    this.hint,
    this.leading,
    this.enabled = true,
  });

  final String label;
  final String? valueLabel;
  final String? hint;
  final Widget? leading;
  final VoidCallback? onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final hasValue = valueLabel != null && valueLabel!.trim().isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColor.textSecondary),
          ),
        ),
        NeumorphicButton(
          onPressed: enabled ? onTap : null,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          style: NeumorphicStyle(
            depth: enabled ? -3 : -1,
            color: NeumorphicTheme.baseColor(context),
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(14)),
          ),
          child: Row(
            children: [
              if (leading != null) ...[
                leading!,
                const SizedBox(width: 10),
              ],
              Expanded(
                child: Text(
                  hasValue ? valueLabel! : (hint ?? label),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: hasValue ? FontWeight.w600 : FontWeight.w400,
                    color: hasValue ? AppColor.textPrimary : Colors.grey.shade500,
                  ),
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: enabled ? FaidaBizTheme.green : Colors.grey,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Soft raised info / hint panel on form pages.
class FaidaBizNeuHint extends StatelessWidget {
  const FaidaBizNeuHint({
    super.key,
    required this.child,
    this.color,
    this.icon,
  });

  final Widget child;
  final Color? color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final c = color ?? FaidaBizTheme.green;
    return Neumorphic(
      padding: const EdgeInsets.all(14),
      style: NeumorphicStyle(
        depth: 3,
        color: AppColor.neumorphicSurface,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(14)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, color: c, size: 20),
            const SizedBox(width: 10),
          ],
          Expanded(child: child),
        ],
      ),
    );
  }
}
