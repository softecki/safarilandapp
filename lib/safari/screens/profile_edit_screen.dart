import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wicom/safari/safari_api.dart';
import 'package:wicom/safari/safari_theme.dart';
import 'package:wicom/safari/safari_ui.dart';

class SafariProfileEditScreen extends StatefulWidget {
  const SafariProfileEditScreen({super.key, this.section = 'profile'});
  final String section;

  @override
  State<SafariProfileEditScreen> createState() => _SafariProfileEditScreenState();
}

class _SafariProfileEditScreenState extends State<SafariProfileEditScreen> {
  late final name = TextEditingController(text: '${SafariApi.driver?['name'] ?? ''}');
  late final bio = TextEditingController(text: '${SafariApi.driver?['bio'] ?? ''}');
  late final company = TextEditingController(text: '${SafariApi.driver?['company'] ?? ''}');
  late final licence = TextEditingController(text: '${SafariApi.driver?['licence_ref'] ?? ''}');
  late final languages = TextEditingController(text: safariCsv(SafariApi.driver?['languages']).join(', '));
  late final destinations = TextEditingController(text: safariCsv(SafariApi.driver?['destinations']).join(', '));
  late final specialties = TextEditingController(text: safariCsv(SafariApi.driver?['specialties']).join(', '));
  late final experience = TextEditingController(text: '${SafariApi.driver?['experience_years'] ?? ''}');
  late final account = TextEditingController(text: '${SafariApi.driver?['payout_account'] ?? ''}');
  String method = '${SafariApi.driver?['payout_method'] ?? 'MPESA'}';
  XFile? photo;
  bool loading = false;

  @override
  void dispose() {
    name.dispose();
    bio.dispose();
    company.dispose();
    licence.dispose();
    languages.dispose();
    destinations.dispose();
    specialties.dispose();
    experience.dispose();
    account.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final source = await safariSheet<ImageSource>(
      context,
      Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Profile photo', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.photo_camera_outlined), title: const Text('Camera'), onTap: () => Navigator.pop(context, ImageSource.camera)),
        ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.photo_library_outlined), title: const Text('Gallery'), onTap: () => Navigator.pop(context, ImageSource.gallery)),
      ]),
    );
    if (source == null) return;
    final picked = await ImagePicker().pickImage(source: source, imageQuality: 82, maxWidth: 1400);
    if (picked != null) setState(() => photo = picked);
  }

  Future<void> _save() async {
    setState(() => loading = true);
    try {
      final files = <http.MultipartFile>[];
      if (photo != null) {
        files.add(http.MultipartFile.fromBytes(
          'photo',
          await photo!.readAsBytes(),
          filename: photo!.name.isEmpty ? 'photo.jpg' : photo!.name,
          contentType: MediaType('image', 'jpeg'),
        ));
      }
      final fields = {
        'name': name.text.trim(),
        'bio': bio.text.trim(),
        'company': company.text.trim(),
        'licence_ref': licence.text.trim(),
        'languages': languages.text.trim(),
        'destinations': destinations.text.trim(),
        'specialties': specialties.text.trim(),
        if (experience.text.trim().isNotEmpty) 'experience_years': experience.text.trim(),
        'payout_method': method,
        'payout_account': account.text.trim(),
      };
      final json = files.isEmpty
          ? await SafariApi.post('/drivers/profile', {
              'name': fields['name'],
              'bio': fields['bio'],
              'company': fields['company'],
              'licence_ref': fields['licence_ref'],
              'languages': safariCsv(languages.text),
              'destinations': safariCsv(destinations.text),
              'specialties': safariCsv(specialties.text),
              'experience_years': int.tryParse(experience.text.trim()),
              'payout_method': method,
              'payout_account': account.text.trim(),
            })
          : await SafariApi.request('POST', '/drivers/profile', fields: fields, files: files);
      SafariApi.driver = Map<String, dynamic>.from(SafariApi.data(json) as Map);
      final token = SafariApi.token;
      if (token != null) {
        await SafariApi.saveAuth(token, SafariApi.driver!);
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile saved')));
      Navigator.pop(context);
    } catch (e) {
      await safariError(context, e);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentPhoto = SafariApi.driver?['photo_url']?.toString() ?? '';
    final portfolioFirst = widget.section == 'portfolio';
    return Scaffold(
      appBar: AppBar(title: Text(portfolioFirst ? 'Edit portfolio' : 'Edit profile')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: GestureDetector(
              onTap: _pickPhoto,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: SafariTheme.pillFill,
                    backgroundImage: photo == null && currentPhoto.isNotEmpty ? NetworkImage(currentPhoto) : null,
                    child: photo != null
                        ? const Icon(Icons.check, color: SafariTheme.maroon, size: 28)
                        : (currentPhoto.isEmpty
                            ? Text(safariInitials(name.text), style: const TextStyle(fontWeight: FontWeight.w700, color: SafariTheme.maroon, fontSize: 22))
                            : null),
                  ),
                  const CircleAvatar(
                    radius: 14,
                    backgroundColor: SafariTheme.maroon,
                    child: Icon(Icons.camera_alt_outlined, size: 14, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(photo != null ? 'New photo selected' : 'Tap the photo to change it', textAlign: TextAlign.center, style: const TextStyle(color: SafariTheme.muted, fontSize: 12)),
          if (!portfolioFirst) ...[
            const SafariSectionTitle('Profile'),
            TextField(controller: name, decoration: const InputDecoration(labelText: 'Full name')),
            const SizedBox(height: 12),
            TextField(controller: company, decoration: const InputDecoration(labelText: 'Company / operator')),
            const SizedBox(height: 12),
            TextField(controller: licence, decoration: const InputDecoration(labelText: 'Guide licence / TALA ref')),
            const SizedBox(height: 12),
            TextField(controller: experience, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Years of experience')),
            const SizedBox(height: 12),
            TextField(controller: languages, decoration: const InputDecoration(labelText: 'Languages', hintText: 'English, Swahili, French')),
          ],
          const SafariSectionTitle('Portfolio'),
          TextField(controller: destinations, decoration: const InputDecoration(labelText: 'Destinations', hintText: 'Serengeti, Ngorongoro, Tarangire')),
          const SizedBox(height: 12),
          TextField(controller: specialties, decoration: const InputDecoration(labelText: 'Specialties', hintText: 'Birding, photography, family groups')),
          const SizedBox(height: 12),
          TextField(controller: bio, maxLines: 4, decoration: const InputDecoration(labelText: 'About / bio')),
          if (portfolioFirst) ...[
            const SafariSectionTitle('Profile'),
            TextField(controller: name, decoration: const InputDecoration(labelText: 'Full name')),
            const SizedBox(height: 12),
            TextField(controller: company, decoration: const InputDecoration(labelText: 'Company / operator')),
            const SizedBox(height: 12),
            TextField(controller: licence, decoration: const InputDecoration(labelText: 'Guide licence / TALA ref')),
            const SizedBox(height: 12),
            TextField(controller: experience, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Years of experience')),
            const SizedBox(height: 12),
            TextField(controller: languages, decoration: const InputDecoration(labelText: 'Languages', hintText: 'English, Swahili, French')),
          ],
          const SafariSectionTitle('Payout'),
          DropdownButtonFormField<String>(
            value: ['MPESA', 'TIGOPESA', 'AIRTEL', 'BANK'].contains(method) ? method : 'MPESA',
            decoration: const InputDecoration(labelText: 'Default payout method'),
            items: const [
              DropdownMenuItem(value: 'MPESA', child: Text('M-Pesa')),
              DropdownMenuItem(value: 'TIGOPESA', child: Text('Tigo Pesa')),
              DropdownMenuItem(value: 'AIRTEL', child: Text('Airtel Money')),
              DropdownMenuItem(value: 'BANK', child: Text('Bank transfer')),
            ],
            onChanged: (v) => setState(() => method = v ?? 'MPESA'),
          ),
          const SizedBox(height: 12),
          TextField(controller: account, decoration: const InputDecoration(labelText: 'Payout account / phone')),
          const SizedBox(height: 8),
          const Text('Payout details are used when you request a withdrawal. Money is not sent from this screen.', style: TextStyle(color: SafariTheme.muted, fontSize: 12)),
          const SizedBox(height: 20),
          SafariLoadingButton(label: 'Save', loading: loading, onPressed: _save),
        ],
      ),
    );
  }
}
