import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wicom/faidabiz/faidabiz_api.dart';
import 'package:wicom/faidabiz/faidabiz_theme.dart';

class FaidaBizAddBusinessScreen extends StatefulWidget {
  const FaidaBizAddBusinessScreen({super.key});

  @override
  State<FaidaBizAddBusinessScreen> createState() => _FaidaBizAddBusinessScreenState();
}

class _FaidaBizAddBusinessScreenState extends State<FaidaBizAddBusinessScreen> {
  final _name = TextEditingController();
  final _type = TextEditingController(text: 'Duka la rejareja');
  final _phone = TextEditingController();
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final p = FaidaBizApi.user?['phone']?.toString();
    if (p != null && p.isNotEmpty) _phone.text = p;
  }

  @override
  void dispose() {
    _name.dispose();
    _type.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _name.text.trim();
    if (name.isEmpty) {
      setState(() => _error = 'settings.business_name_required'.tr());
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await FaidaBizApi.createBusiness(
        name: name,
        businessType: _type.text.trim().isEmpty ? null : _type.text.trim(),
        phone: _phone.text.trim().isEmpty ? null : _phone.text.trim(),
      );
      if (!mounted) return;
      Navigator.pop(context, true);
    } on FaidaBizApiException catch (e) {
      setState(() {
        _error = e.message;
        _saving = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _saving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('settings.business_add'.tr())),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('settings.business_add_hint'.tr(), style: TextStyle(color: Colors.grey.shade700)),
          const SizedBox(height: 16),
          TextField(
            controller: _name,
            decoration: InputDecoration(labelText: 'auth.business_name'.tr(), border: const OutlineInputBorder()),
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _type,
            decoration: InputDecoration(labelText: 'auth.business_type'.tr(), border: const OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _phone,
            decoration: InputDecoration(labelText: 'auth.phone'.tr(), border: const OutlineInputBorder()),
            keyboardType: TextInputType.phone,
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(_error!, style: const TextStyle(color: Colors.red)),
          ],
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _saving ? null : _save,
            style: FilledButton.styleFrom(backgroundColor: FaidaBizTheme.green, minimumSize: const Size.fromHeight(48)),
            child: _saving
                ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : Text('settings.business_add_btn'.tr()),
          ),
        ],
      ),
    );
  }
}
