import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:wicom/safari/safari_api.dart';
import 'package:wicom/safari/safari_gate.dart';
import 'package:wicom/safari/safari_nav.dart';
import 'package:wicom/safari/safari_theme.dart';
import 'package:wicom/safari/safari_ui.dart';

class SafariRegisterScreen extends StatefulWidget {
  const SafariRegisterScreen({
    super.key,
    this.phone = '',
    this.registrationToken,
    this.googleRegistrationToken,
    this.email,
    this.googleName,
    this.isDriver = false,
  }) : assert(registrationToken != null || googleRegistrationToken != null);

  final String phone;
  final String? registrationToken;
  final String? googleRegistrationToken;
  final String? email;
  final String? googleName;
  final bool isDriver;

  @override
  State<SafariRegisterScreen> createState() => _SafariRegisterScreenState();
}

class _SafariRegisterScreenState extends State<SafariRegisterScreen> {
  late final name = TextEditingController(text: widget.googleName ?? '');
  final whatsapp = TextEditingController();
  late final email = TextEditingController(text: widget.email ?? '');
  late final phone = TextEditingController(text: widget.phone);
  final phoneTwo = TextEditingController();
  final company = TextEditingController();
  final licence = TextEditingController();
  final languages = TextEditingController(text: 'English, Swahili');
  final experience = TextEditingController();
  final password = TextEditingController();
  final confirm = TextEditingController();
  DateTime? birth;
  String gender = '';
  String marital = '';
  bool terms = false;
  bool loading = false;
  XFile? photo;

  @override
  void dispose() {
    name.dispose();
    whatsapp.dispose();
    email.dispose();
    phone.dispose();
    phoneTwo.dispose();
    company.dispose();
    licence.dispose();
    languages.dispose();
    experience.dispose();
    password.dispose();
    confirm.dispose();
    super.dispose();
  }

  String get _birthLabel {
    if (birth == null) return 'Date of birth *';
    final d = birth!.day.toString().padLeft(2, '0');
    final m = birth!.month.toString().padLeft(2, '0');
    return '$d/$m/${birth!.year}';
  }

  bool get _fromGoogle => (widget.googleRegistrationToken ?? '').isNotEmpty;

  Future<void> _pickBirth() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: birth ?? DateTime(now.year - 25),
      firstDate: DateTime(1940),
      lastDate: DateTime(now.year - 16),
    );
    if (picked != null) setState(() => birth = picked);
  }

  Future<void> _submit() async {
    if (name.text.trim().isEmpty) {
      await safariError(context, 'Enter your full name.');
      return;
    }
    if (email.text.trim().isEmpty) {
      await safariError(context, 'Email is required');
      return;
    }
    if (_fromGoogle && phone.text.trim().isEmpty) {
      await safariError(context, 'Enter your mobile number.');
      return;
    }
    if (!_fromGoogle && password.text.isEmpty) {
      await safariError(context, 'Enter a password.');
      return;
    }
    if (password.text.isNotEmpty && password.text != confirm.text) {
      await safariError(context, 'Passwords do not match.');
      return;
    }
    if (birth == null) {
      await safariError(context, 'Select your date of birth.');
      return;
    }
    if (gender.isEmpty) {
      await safariError(context, 'Select your gender.');
      return;
    }
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
        if (widget.registrationToken != null) 'registration_token': widget.registrationToken!,
        if (widget.googleRegistrationToken != null) 'google_registration_token': widget.googleRegistrationToken!,
        'name': name.text.trim(),
        'phone': phone.text.trim(),
        'whatsapp': whatsapp.text.trim().isEmpty ? phone.text.trim() : whatsapp.text.trim(),
        'email': email.text.trim(),
        'is_driver': widget.isDriver ? '1' : '0',
        if (password.text.isNotEmpty) 'password': password.text,
        if (password.text.isNotEmpty) 'password_confirmation': confirm.text,
        'date_of_birth': '${birth!.year}-${birth!.month.toString().padLeft(2, '0')}-${birth!.day.toString().padLeft(2, '0')}',
        'gender': gender,
        'marital_status': marital,
        'phone_two': phoneTwo.text.trim(),
        'company': company.text.trim(),
        'licence_ref': licence.text.trim(),
        'languages': languages.text.trim(),
        if (experience.text.trim().isNotEmpty) 'experience_years': experience.text.trim(),
        'terms_accepted': '1',
      }, files: files);
      final data = SafariApi.data(json) as Map<String, dynamic>;
      await SafariApi.saveAuth(data['token'].toString(), Map<String, dynamic>.from(data['driver'] as Map));
      if (!mounted) return;
      SafariNav.reset(context, SafariGate.home());
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
          Text(
            _fromGoogle
                ? 'Google verified ${widget.email ?? 'your email'}. Add your mobile number and member details.'
                : 'Number ${widget.phone} verified. Complete the same member details used on the portal.',
            style: const TextStyle(color: SafariTheme.muted),
          ),
          const SafariSectionTitle('Member details'),
          TextField(controller: name, textCapitalization: TextCapitalization.words, decoration: const InputDecoration(labelText: 'Full name *')),
          const SizedBox(height: 12),
          TextField(
            controller: email,
            readOnly: _fromGoogle,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(labelText: 'Email *', helperText: _fromGoogle ? 'Taken from your Google account' : null),
          ),
          if (_fromGoogle) ...[
            const SizedBox(height: 12),
            TextField(controller: phone, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Mobile number *', hintText: '07XXXXXXXX')),
          ],
          const SizedBox(height: 12),
          InkWell(
            onTap: _pickBirth,
            child: InputDecorator(
              decoration: const InputDecoration(labelText: 'Date of birth *'),
              child: Text(birth == null ? 'Select date' : _birthLabel, style: TextStyle(color: birth == null ? SafariTheme.muted : SafariTheme.ink)),
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: gender.isEmpty ? null : gender,
            decoration: const InputDecoration(labelText: 'Gender *'),
            items: const [
              DropdownMenuItem(value: 'male', child: Text('Male')),
              DropdownMenuItem(value: 'female', child: Text('Female')),
            ],
            onChanged: (v) => setState(() => gender = v ?? ''),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: marital.isEmpty ? null : marital,
            decoration: const InputDecoration(labelText: 'Marital status'),
            items: const [
              DropdownMenuItem(value: 'single', child: Text('Single')),
              DropdownMenuItem(value: 'married', child: Text('Married')),
              DropdownMenuItem(value: 'divorced', child: Text('Divorced')),
              DropdownMenuItem(value: 'widowed', child: Text('Widowed')),
            ],
            onChanged: (v) => setState(() => marital = v ?? ''),
          ),
          const SafariSectionTitle('Contact'),
          TextField(controller: phoneTwo, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Second phone', hintText: '07xx or +255…')),
          const SizedBox(height: 12),
          TextField(controller: whatsapp, keyboardType: TextInputType.phone, decoration: InputDecoration(labelText: 'WhatsApp', hintText: _fromGoogle ? 'Leave blank to use your mobile number' : 'Leave blank to use the verified number')),
          if (widget.isDriver) ...[
            const SafariSectionTitle('Guide details'),
            TextField(controller: company, decoration: const InputDecoration(labelText: 'Company / operator')),
            const SizedBox(height: 12),
            TextField(controller: licence, decoration: const InputDecoration(labelText: 'Guide licence / TALA ref')),
            const SizedBox(height: 12),
            TextField(controller: experience, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Years of experience')),
            const SizedBox(height: 12),
            TextField(controller: languages, decoration: const InputDecoration(labelText: 'Languages', hintText: 'English, Swahili, French')),
          ],
          SafariSectionTitle(_fromGoogle ? 'Password (optional) & photo' : 'Password & photo'),
          if (_fromGoogle)
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text('You can skip a password and keep using Google to sign in.', style: TextStyle(color: SafariTheme.muted, fontSize: 13)),
            ),
          SafariPasswordField(controller: password, label: _fromGoogle ? 'Password (optional)' : 'Password'),
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
