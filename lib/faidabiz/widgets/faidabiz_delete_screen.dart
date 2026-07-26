import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_chrome.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_loader.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_neumorphic.dart';

/// Full-page soft-delete confirmation (reason + password). Returns true if deleted.
class FaidaBizDeleteScreen extends StatefulWidget {
  const FaidaBizDeleteScreen({
    super.key,
    required this.title,
    this.itemLabel,
    required this.onConfirm,
  });

  final String title;
  final String? itemLabel;
  final Future<void> Function(String reason, String password) onConfirm;

  @override
  State<FaidaBizDeleteScreen> createState() => _FaidaBizDeleteScreenState();
}

class _FaidaBizDeleteScreenState extends State<FaidaBizDeleteScreen> {
  final reason = TextEditingController();
  final password = TextEditingController();
  bool loading = false;
  String? error;

  @override
  void dispose() {
    reason.dispose();
    password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (reason.text.trim().length < 3) {
      setState(() => error = 'delete.reason_required'.tr());
      return;
    }
    if (password.text.isEmpty) {
      setState(() => error = 'delete.password_required'.tr());
      return;
    }
    setState(() {
      loading = true;
      error = null;
    });
    try {
      await widget.onConfirm(reason.text.trim(), password.text);
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        setState(() {
          loading = false;
          error = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FaidaBizNeuFormScaffold(
      appBar: faidaBizAppBar(
        title: widget.title,
        backgroundColor: Colors.red.shade700,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
        children: [
          FaidaBizNeuHint(
            color: Colors.red.shade700,
            icon: Icons.warning_amber_rounded,
            child: Text(
              'delete.soft_hint'.tr(),
              style: TextStyle(color: Colors.red.shade900, height: 1.4, fontSize: 13.5),
            ),
          ),
          if (widget.itemLabel != null && widget.itemLabel!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text('delete.item'.tr(), style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
            const SizedBox(height: 4),
            Text(widget.itemLabel!, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
          ],
          const SizedBox(height: 20),
          FaidaBizNeuField(
            controller: reason,
            label: 'delete.reason'.tr(),
            maxLines: 3,
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 14),
          FaidaBizNeuField(
            controller: password,
            label: 'delete.password'.tr(),
            obscureText: true,
          ),
          if (error != null) ...[
            const SizedBox(height: 12),
            Text(error!, style: TextStyle(color: Colors.red.shade700)),
          ],
          const SizedBox(height: 28),
          IgnorePointer(
            ignoring: loading,
            child: Opacity(
              opacity: loading ? 0.7 : 1,
              child: NeuDangerButton(
                label: 'delete.confirm'.tr(),
                icon: Icons.delete_outline,
                onPressed: _submit,
              ),
            ),
          ),
          if (loading) ...[
            const SizedBox(height: 8),
            Center(child: FaidaBizLoader.button()),
          ],
          const SizedBox(height: 10),
          TextButton(
            onPressed: loading ? null : () => Navigator.pop(context, false),
            child: Text('delete.cancel'.tr()),
          ),
        ],
      ),
    );
  }
}

/// Opens the delete page and runs [onConfirm] when the user confirms.
Future<bool> confirmAndSoftDelete({
  required BuildContext context,
  required String title,
  String? itemLabel,
  required Future<void> Function(String reason, String password) onConfirm,
}) async {
  final ok = await Navigator.push<bool>(
    context,
    MaterialPageRoute(
      builder: (_) => FaidaBizDeleteScreen(
        title: title,
        itemLabel: itemLabel,
        onConfirm: onConfirm,
      ),
    ),
  );
  return ok == true;
}

Color get faidaBizDeleteColor => Colors.red.shade700;
