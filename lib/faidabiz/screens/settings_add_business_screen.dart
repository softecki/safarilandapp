import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wicom/faidabiz/faidabiz_api.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_chrome.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_neumorphic.dart';

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
    return FaidaBizNeuFormScaffold(
      appBar: faidaBizAppBar(title: 'settings.business_add'.tr()),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('settings.business_add_hint'.tr(), style: TextStyle(color: Colors.grey.shade700)),
          const SizedBox(height: 16),
          FaidaBizNeuField(
            controller: _name,
            label: 'auth.business_name'.tr(),
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 14),
          FaidaBizNeuField(
            controller: _type,
            label: 'auth.business_type'.tr(),
          ),
          const SizedBox(height: 14),
          FaidaBizNeuField(
            controller: _phone,
            label: 'auth.phone'.tr(),
            keyboardType: TextInputType.phone,
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(_error!, style: const TextStyle(color: Colors.red)),
          ],
          const SizedBox(height: 24),
          NeuPrimaryButton(
            label: 'settings.business_add_btn'.tr(),
            loading: _saving,
            onPressed: _saving ? null : _save,
          ),
        ],
      ),
    );
  }
}
