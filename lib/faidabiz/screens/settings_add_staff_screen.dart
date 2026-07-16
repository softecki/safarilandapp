import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wicom/faidabiz/faidabiz_api.dart';
import 'package:wicom/faidabiz/faidabiz_theme.dart';

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
    return Scaffold(
      appBar: AppBar(title: Text('settings.team_add'.tr())),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('settings.team_add_hint'.tr(), style: TextStyle(color: Colors.grey.shade700)),
          const SizedBox(height: 16),
          TextField(
            controller: _name,
            decoration: InputDecoration(labelText: 'auth.name'.tr(), border: const OutlineInputBorder()),
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _phone,
            decoration: InputDecoration(labelText: 'auth.phone'.tr(), border: const OutlineInputBorder()),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _password,
            decoration: InputDecoration(labelText: 'auth.password'.tr(), border: const OutlineInputBorder()),
            obscureText: true,
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
                : Text('settings.team_add_btn'.tr()),
          ),
        ],
      ),
    );
  }
}
