import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wicom/faidabiz/faidabiz_api.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_chrome.dart';
import 'package:wicom/faidabiz/widgets/faidabiz_neumorphic.dart';

class FaidaBizAddStaffScreen extends StatefulWidget {
  const FaidaBizAddStaffScreen({super.key});

  @override
  State<FaidaBizAddStaffScreen> createState() => _FaidaBizAddStaffScreenState();
}

class _FaidaBizAddStaffScreenState extends State<FaidaBizAddStaffScreen> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _name.text.trim();
    final phone = _phone.text.trim();
    final password = _password.text;
    if (name.isEmpty || phone.isEmpty || password.isEmpty) {
      setState(() => _error = 'settings.team_fill_all'.tr());
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await FaidaBizApi.addStaff(name: name, phone: phone, password: password);
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
      appBar: faidaBizAppBar(title: 'settings.team_add'.tr()),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('settings.team_add_hint'.tr(), style: TextStyle(color: Colors.grey.shade700)),
          const SizedBox(height: 16),
          FaidaBizNeuField(
            controller: _name,
            label: 'auth.their_name'.tr(),
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 14),
          FaidaBizNeuField(
            controller: _phone,
            label: 'auth.phone'.tr(),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 14),
          FaidaBizNeuField(
            controller: _password,
            label: 'auth.password'.tr(),
            obscureText: true,
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(_error!, style: const TextStyle(color: Colors.red)),
          ],
          const SizedBox(height: 24),
          NeuPrimaryButton(
            label: 'settings.team_add_btn'.tr(),
            loading: _saving,
            onPressed: _saving ? null : _save,
          ),
        ],
      ),
    );
  }
}
