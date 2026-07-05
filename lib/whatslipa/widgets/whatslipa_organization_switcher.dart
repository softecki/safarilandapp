import 'package:flutter/material.dart';
import 'package:wicom/core/app_color.dart';
import 'package:wicom/core/whatslipa_api.dart';
import 'package:wicom/whatslipa/widgets/whatslipa_loading.dart';
import 'package:wicom/whatslipa/widgets/whatslipa_ui.dart';

class WhatsLipaOrganizationSwitcher extends StatelessWidget {
  const WhatsLipaOrganizationSwitcher({
    super.key,
    required this.organizations,
    required this.currentSlug,
    required this.isPlatformAdmin,
    required this.onSwitched,
    this.compact = false,
  });

  final List<Map<String, dynamic>> organizations;
  final String? currentSlug;
  final bool isPlatformAdmin;
  final VoidCallback onSwitched;
  final bool compact;

  String get _currentName {
    if (currentSlug == null || currentSlug!.isEmpty) {
      return 'Select organization';
    }
    for (final org in organizations) {
      if (org['slug']?.toString() == currentSlug) {
        return org['name']?.toString() ?? currentSlug!;
      }
    }
    return currentSlug!;
  }

  Future<void> _openSheet(BuildContext context) async {
    if (organizations.isEmpty) return;

    final selected = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  isPlatformAdmin ? 'Switch organization' : 'Change organization',
                  style: WhatsLipaUi.sectionTitle,
                ),
                if (isPlatformAdmin)
                  Padding(
                    padding: const EdgeInsets.only(top: 6, bottom: 12),
                    child: Text(
                      'Platform admin — all API data will load from the selected tenant database.',
                      style: WhatsLipaUi.subtitle.copyWith(fontSize: 13),
                    ),
                  )
                else
                  const SizedBox(height: 12),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: organizations.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (_, i) {
                      final org = organizations[i];
                      final slug = org['slug']?.toString() ?? '';
                      final name = org['name']?.toString() ?? slug;
                      final active = slug == currentSlug;
                      return Material(
                        color: active ? WhatsLipaUi.primary.withValues(alpha: 0.08) : const Color(0xFFF7FAF8),
                        borderRadius: BorderRadius.circular(16),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: active ? null : () => Navigator.pop(ctx, slug),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: active
                                        ? WhatsLipaUi.primary.withValues(alpha: 0.15)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    active ? Icons.check_circle_rounded : Icons.business_rounded,
                                    color: active ? WhatsLipaUi.primary : AppColor.textSecondary,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        style: TextStyle(
                                          fontWeight: active ? FontWeight.w800 : FontWeight.w600,
                                          color: AppColor.textPrimary,
                                        ),
                                      ),
                                      Text(slug, style: WhatsLipaUi.subtitle.copyWith(fontSize: 12)),
                                    ],
                                  ),
                                ),
                                if (active)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: WhatsLipaUi.primary,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Text(
                                      'Active',
                                      style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (selected == null || selected.isEmpty || !context.mounted) return;

    WhatsLipaLoading.show(context, message: 'Switching organization…');
    try {
      await WhatsLipaApi.switchOrganization(selected);
      if (!context.mounted) return;
      WhatsLipaLoading.hide();
      onSwitched();
      final name = organizations.firstWhere(
        (o) => o['slug']?.toString() == selected,
        orElse: () => {'name': selected},
      )['name']?.toString();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Now using ${name ?? selected}')),
      );
    } catch (e) {
      WhatsLipaLoading.hide();
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not switch organization: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (organizations.isEmpty) {
      return const SizedBox.shrink();
    }

    if (compact) {
      return InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _openSheet(context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: WhatsLipaUi.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.swap_horiz_rounded, size: 16, color: WhatsLipaUi.primary),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  _currentName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: WhatsLipaUi.primary),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _openSheet(context),
        child: Ink(
          decoration: WhatsLipaUi.glassCard(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: WhatsLipaUi.brandGradient(),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.business_rounded, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isPlatformAdmin ? 'ACTIVE ORGANIZATION' : 'ORGANIZATION',
                        style: WhatsLipaUi.badgeLabel,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _currentName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColor.textPrimary),
                      ),
                      if (currentSlug != null && currentSlug!.isNotEmpty)
                        Text(currentSlug!, style: WhatsLipaUi.subtitle.copyWith(fontSize: 12)),
                    ],
                  ),
                ),
                Icon(Icons.unfold_more_rounded, color: WhatsLipaUi.primary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
