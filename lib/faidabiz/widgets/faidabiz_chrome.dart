import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wicom/faidabiz/faidabiz_theme.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_neumorphic.dart';

/// Explicit back + title AppBar used across FaidaBiz screens.
PreferredSizeWidget faidaBizAppBar({
  required String title,
  Color? backgroundColor,
  Color foregroundColor = Colors.white,
  List<Widget>? actions,
  VoidCallback? onBack,
}) {
  return AppBar(
    title: Text(title),
    backgroundColor: backgroundColor ?? FaidaBizTheme.green,
    foregroundColor: foregroundColor,
    elevation: 0,
    leading: Builder(
      builder: (context) => IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
        onPressed: onBack ?? () => Navigator.maybePop(context),
      ),
    ),
    actions: actions,
  );
}

/// Presentable Edit / Delete action row for detail pages.
class FaidaBizDetailActions extends StatelessWidget {
  const FaidaBizDetailActions({
    super.key,
    this.onEdit,
    this.onDelete,
    this.editLabel,
    this.deleteLabel,
    this.accentColor,
  });

  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final String? editLabel;
  final String? deleteLabel;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (onEdit != null)
          Expanded(
            child: NeuPrimaryButton(
              label: editLabel ?? 'common.edit'.tr(),
              icon: Icons.edit_outlined,
              onPressed: onEdit,
            ),
          ),
        if (onEdit != null && onDelete != null) const SizedBox(width: 10),
        if (onDelete != null)
          Expanded(
            child: NeuDangerButton(
              label: deleteLabel ?? 'delete.confirm'.tr(),
              icon: Icons.delete_outline,
              onPressed: onDelete!,
            ),
          ),
      ],
    );
  }
}
