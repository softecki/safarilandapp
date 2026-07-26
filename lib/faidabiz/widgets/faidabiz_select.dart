import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wicom/faidabiz/faidabiz_theme.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_chrome.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_neumorphic.dart';

/// Branded selectable field that opens a full-page picker (products / units / etc.).
class FaidaBizSelectField<T> extends StatelessWidget {
  const FaidaBizSelectField({
    super.key,
    required this.label,
    required this.valueLabel,
    required this.onTap,
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
    return FaidaBizNeuSelect(
      label: label,
      valueLabel: valueLabel,
      hint: hint,
      leading: leading,
      enabled: enabled,
      onTap: onTap,
    );
  }
}

/// Opens a searchable FaidaBiz product picker page. Returns selected product map or null.
Future<Map<String, dynamic>?> showFaidaBizProductPicker({
  required BuildContext context,
  required List products,
  int? selectedId,
}) {
  return Navigator.of(context).push<Map<String, dynamic>>(
    MaterialPageRoute(
      builder: (_) => _FaidaBizProductPickerPage(
        products: products,
        selectedId: selectedId,
      ),
    ),
  );
}

Future<T?> showFaidaBizOptionPicker<T>({
  required BuildContext context,
  required String title,
  required List<({T value, String label, String? subtitle})> options,
  T? selected,
}) {
  return Navigator.of(context).push<T>(
    MaterialPageRoute(
      builder: (_) => _FaidaBizOptionPickerPage<T>(
        title: title,
        options: options,
        selected: selected,
      ),
    ),
  );
}

class _FaidaBizProductPickerPage extends StatefulWidget {
  const _FaidaBizProductPickerPage({required this.products, this.selectedId});
  final List products;
  final int? selectedId;

  @override
  State<_FaidaBizProductPickerPage> createState() => _FaidaBizProductPickerPageState();
}

class _FaidaBizProductPickerPageState extends State<_FaidaBizProductPickerPage> {
  final search = TextEditingController();
  String query = '';

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  List get filtered {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return widget.products;
    return widget.products.where((raw) {
      final p = Map<String, dynamic>.from(raw as Map);
      return (p['name']?.toString() ?? '').toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final items = filtered;

    return FaidaBizNeuFormScaffold(
      appBar: faidaBizAppBar(title: 'form.select_product'.tr()),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: FaidaBizNeuField(
              controller: search,
              hint: 'form.search_product'.tr(),
              prefixIcon: Icons.search_rounded,
              autofocus: widget.products.length > 8,
              onChanged: (v) => setState(() => query = v),
              suffix: query.trim().isNotEmpty && items.isEmpty
                  ? IconButton(
                      tooltip: 'sales.create_product_from_search'.tr(),
                      onPressed: () => Navigator.pop(context, {
                        '_create_new': true,
                        'name': query.trim(),
                      }),
                      icon: const Icon(Icons.add_circle_outline, color: FaidaBizTheme.green),
                    )
                  : (query.trim().isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            search.clear();
                            setState(() => query = '');
                          },
                        )
                      : null),
            ),
          ),
          if (query.trim().isNotEmpty && items.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: FaidaBizNeuHint(
                icon: Icons.add_box_outlined,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'sales.product_not_found'.tr(args: [query.trim()]),
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'sales.create_product_hint'.tr(),
                      style: TextStyle(fontSize: 12.5, color: Colors.grey.shade700, height: 1.35),
                    ),
                    const SizedBox(height: 10),
                    NeuPrimaryButton(
                      label: 'sales.create_product_cta'.tr(args: [query.trim()]),
                      icon: Icons.add,
                      onPressed: () => Navigator.pop(context, {
                        '_create_new': true,
                        'name': query.trim(),
                      }),
                    ),
                  ],
                ),
              ),
            ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
                final p = Map<String, dynamic>.from(items[i] as Map);
                final id = int.tryParse('${p['id']}');
                final isSelected = id != null && id == widget.selectedId;
                return NeuPanel(
                  padding: EdgeInsets.zero,
                  child: ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    selected: isSelected,
                    selectedTileColor: FaidaBizTheme.green.withValues(alpha: 0.08),
                    leading: Icon(
                      Icons.inventory_2_outlined,
                      color: isSelected ? FaidaBizTheme.green : Colors.grey.shade600,
                    ),
                    title: Text(p['name']?.toString() ?? '', style: const TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: Text(
                      '${p['unit'] ?? ''} · ${'form.stock'.tr()}: ${p['stock_qty']} · ${FaidaBizTheme.money(p['sell_price'])}',
                    ),
                    trailing: isSelected ? const Icon(Icons.check_circle, color: FaidaBizTheme.green) : null,
                    onTap: () => Navigator.pop(context, p),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FaidaBizOptionPickerPage<T> extends StatelessWidget {
  const _FaidaBizOptionPickerPage({
    required this.title,
    required this.options,
    this.selected,
  });

  final String title;
  final List<({T value, String label, String? subtitle})> options;
  final T? selected;

  @override
  Widget build(BuildContext context) {
    return FaidaBizNeuFormScaffold(
      appBar: faidaBizAppBar(title: title),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        itemCount: options.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, i) {
          final o = options[i];
          final isSelected = o.value == selected;
          return NeuPanel(
            padding: EdgeInsets.zero,
            child: ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              selected: isSelected,
              selectedTileColor: FaidaBizTheme.green.withValues(alpha: 0.08),
              title: Text(o.label, style: const TextStyle(fontWeight: FontWeight.w700)),
              subtitle: o.subtitle != null ? Text(o.subtitle!) : null,
              trailing: isSelected ? const Icon(Icons.check_circle, color: FaidaBizTheme.green) : null,
              onTap: () => Navigator.pop(context, o.value),
            ),
          );
        },
      ),
    );
  }
}
