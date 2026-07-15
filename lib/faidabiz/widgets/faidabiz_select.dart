import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wicom/faidabiz/faidabiz_theme.dart';

/// Branded selectable field that opens a bottom-sheet picker (products / units / etc.).
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
    final hasValue = valueLabel != null && valueLabel!.trim().isNotEmpty;
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(14),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: FaidaBizTheme.green, width: 2),
          ),
          suffixIcon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: enabled ? FaidaBizTheme.green : Colors.grey,
          ),
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
                  color: hasValue ? FaidaBizTheme.black : Colors.grey.shade500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Opens a searchable FaidaBiz product picker sheet. Returns selected product map or null.
Future<Map<String, dynamic>?> showFaidaBizProductPicker({
  required BuildContext context,
  required List products,
  int? selectedId,
}) {
  return showModalBottomSheet<Map<String, dynamic>>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _FaidaBizProductPickerSheet(
      products: products.cast<dynamic>().map((e) => Map<String, dynamic>.from(e as Map)).toList(),
      selectedId: selectedId,
    ),
  );
}

/// Opens a simple option picker. Returns selected value or null.
Future<T?> showFaidaBizOptionPicker<T>({
  required BuildContext context,
  required String title,
  required List<({T value, String label, String? subtitle})> options,
  T? selected,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _FaidaBizOptionPickerSheet<T>(
      title: title,
      options: options,
      selected: selected,
    ),
  );
}

class _FaidaBizProductPickerSheet extends StatefulWidget {
  const _FaidaBizProductPickerSheet({
    required this.products,
    this.selectedId,
  });

  final List<Map<String, dynamic>> products;
  final int? selectedId;

  @override
  State<_FaidaBizProductPickerSheet> createState() => _FaidaBizProductPickerSheetState();
}

class _FaidaBizProductPickerSheetState extends State<_FaidaBizProductPickerSheet> {
  final search = TextEditingController();
  String query = '';

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filtered {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return widget.products;
    return widget.products.where((p) {
      final name = '${p['name']}'.toLowerCase();
      final unit = '${p['unit']}'.toLowerCase();
      return name.contains(q) || unit.contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    final items = filtered;

    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: Container(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.78),
        decoration: const BoxDecoration(
          color: FaidaBizTheme.canvas,
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'form.select_product'.tr(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: FaidaBizTheme.black,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: search,
                autofocus: widget.products.length > 8,
                onChanged: (v) => setState(() => query = v),
                decoration: InputDecoration(
                  hintText: 'form.search_product'.tr(),
                  prefixIcon: const Icon(Icons.search_rounded, color: FaidaBizTheme.green),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: FaidaBizTheme.green, width: 2),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: items.isEmpty
                  ? Center(
                      child: Text(
                        'form.no_products'.tr(),
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, i) {
                        final p = items[i];
                        final id = int.tryParse('${p['id']}');
                        final selected = id != null && id == widget.selectedId;
                        final stock = FaidaBizTheme.asDouble(p['stock_qty']);
                        final sell = FaidaBizTheme.money(p['sell_price']);
                        final unit = '${p['unit'] ?? 'pcs'}';

                        return Material(
                          color: selected ? FaidaBizTheme.green.withValues(alpha: 0.08) : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: () => Navigator.pop(context, p),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: selected ? FaidaBizTheme.green : Colors.grey.shade200,
                                  width: selected ? 1.6 : 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 42,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      color: FaidaBizTheme.green.withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(Icons.inventory_2_outlined, color: FaidaBizTheme.green),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${p['name']}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15,
                                            color: FaidaBizTheme.black,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          '$unit · ${'form.stock'.tr()}: ${stock.toStringAsFixed(stock == stock.roundToDouble() ? 0 : 1)} · $sell',
                                          style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (selected)
                                    const Icon(Icons.check_circle_rounded, color: FaidaBizTheme.green),
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
  }
}

class _FaidaBizOptionPickerSheet<T> extends StatelessWidget {
  const _FaidaBizOptionPickerSheet({
    required this.title,
    required this.options,
    this.selected,
  });

  final String title;
  final List<({T value, String label, String? subtitle})> options;
  final T? selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
      decoration: const BoxDecoration(
        color: FaidaBizTheme.canvas,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(4)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: FaidaBizTheme.black),
                  ),
                ),
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close_rounded)),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
              itemCount: options.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
                final o = options[i];
                final isSelected = o.value == selected;
                return Material(
                  color: isSelected ? FaidaBizTheme.green.withValues(alpha: 0.08) : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => Navigator.pop(context, o.value),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected ? FaidaBizTheme.green : Colors.grey.shade200,
                          width: isSelected ? 1.6 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(o.label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                                if (o.subtitle != null)
                                  Text(o.subtitle!, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                              ],
                            ),
                          ),
                          if (isSelected) const Icon(Icons.check_circle_rounded, color: FaidaBizTheme.green),
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
    );
  }
}
