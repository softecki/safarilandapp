import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:wicom/safari/safari_api.dart';
import 'package:wicom/safari/safari_nav.dart';
import 'package:wicom/safari/safari_theme.dart';
import 'package:wicom/safari/safari_ui.dart';
import 'package:wicom/safari/screens/pending_screen.dart';

class SafariRegisterScreen extends StatefulWidget {
  const SafariRegisterScreen({super.key, required this.phone, required this.registrationToken, this.email});
  final String phone;
  final String registrationToken;
  final String? email;

  @override
  State<SafariRegisterScreen> createState() => _SafariRegisterScreenState();
}

class _SafariRegisterScreenState extends State<SafariRegisterScreen> {
  final name = TextEditingController();
  final whatsapp = TextEditingController();
  late final email = TextEditingController(text: widget.email ?? '');
  final password = TextEditingController();
  final confirm = TextEditingController();
  bool terms = false;
  bool loading = false;
  XFile? photo;

  @override
  void dispose() {
    name.dispose();
    whatsapp.dispose();
    email.dispose();
    password.dispose();
    confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!terms) {
      await safariError(context, 'Please accept the terms');
      return;
    }
    setState(() => loading = true);
    try {
      final files = <http.MultipartFile>[];
      if (photo != null) {
        files.add(await http.MultipartFile.fromPath('photo', photo!.path));
      }
      final json = await SafariApi.request('POST', '/auth/register', fields: {
        'registration_token': widget.registrationToken,
        'name': name.text.trim(),
        'whatsapp': whatsapp.text.trim().isEmpty ? widget.phone : whatsapp.text.trim(),
        'email': email.text.trim(),
        'password': password.text,
        'password_confirmation': confirm.text,
        'terms_accepted': '1',
      }, files: files);
      final data = SafariApi.data(json) as Map<String, dynamic>;
      await SafariApi.saveAuth(data['token'].toString(), Map<String, dynamic>.from(data['driver'] as Map));
      if (!mounted) return;
      SafariNav.reset(context, const SafariPendingScreen());
    } catch (e) {
      await safariError(context, e);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create profile')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text('Number ${widget.phone} verified. Set a password — later you will sign in with phone and password only.', style: const TextStyle(color: SafariTheme.muted)),
          const SizedBox(height: 16),
          TextField(controller: name, decoration: const InputDecoration(labelText: 'Full name')),
          const SizedBox(height: 12),
          TextField(controller: email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email')),
          const SizedBox(height: 12),
          TextField(controller: whatsapp, decoration: const InputDecoration(labelText: 'WhatsApp (optional)')),
          const SizedBox(height: 12),
          SafariPasswordField(controller: password),
          const SizedBox(height: 12),
          SafariPasswordField(controller: confirm, label: 'Confirm password'),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () async {
              final p = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 70);
              if (p != null) setState(() => photo = p);
            },
            icon: const Icon(Icons.photo),
            label: Text(photo == null ? 'Profile photo' : 'Photo selected'),
          ),
          const SizedBox(height: 8),
          CheckboxListTile(
            value: terms,
            contentPadding: EdgeInsets.zero,
            onChanged: (v) => setState(() => terms = v ?? false),
            title: const Text('I accept Safari Land Tanzania partner terms'),
          ),
          SafariLoadingButton(label: 'Submit for verification', loading: loading, onPressed: _submit),
        ],
      ),
    );
  }
}
