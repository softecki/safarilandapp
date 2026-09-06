import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wicom/safari/safari_api.dart';
import 'package:wicom/safari/safari_theme.dart';
import 'package:wicom/safari/safari_ui.dart';

class SafariPassportScreen extends StatefulWidget {
  const SafariPassportScreen({super.key});

  @override
  State<SafariPassportScreen> createState() => _SafariPassportScreenState();
}

class _SafariPassportScreenState extends State<SafariPassportScreen> {
  Map<String, dynamic>? data;
  bool loading = true;
  bool editing = false;
  bool saving = false;
  XFile? photo;
  XFile? passport;

  final name = TextEditingController();
  final bio = TextEditingController();
  final company = TextEditingController();
  final licence = TextEditingController();
  final languages = TextEditingController();
  final destinations = TextEditingController();
  final specialties = TextEditingController();
  final experience = TextEditingController();
  final goals = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

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
    goals.dispose();
    super.dispose();
  }

  Map<String, dynamic> get driver {
    final fromData = data?['driver'];
    if (fromData is Map) return Map<String, dynamic>.from(fromData);
    return Map<String, dynamic>.from(SafariApi.driver ?? {});
  }

  Future<void> _load() async {
    try {
      final json = await SafariApi.get('/passport');
      data = Map<String, dynamic>.from(SafariApi.data(json) as Map);
      _fill();
    } catch (e) {
      await safariError(context, e);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  void _fill() {
    final d = driver;
    name.text = '${d['name'] ?? ''}';
    bio.text = '${d['bio'] ?? ''}';
    company.text = '${d['company'] ?? ''}';
    licence.text = '${d['licence_ref'] ?? ''}';
    languages.text = safariCsv(d['languages']).join(', ');
    destinations.text = safariCsv(d['destinations']).join(', ');
    specialties.text = safariCsv(d['specialties']).join(', ');
    experience.text = '${d['experience_years'] ?? ''}';
    goals.text = safariCsv(data?['goals'] ?? d['goals']).join(', ');
  }

  Future<XFile?> _pickImage() async {
    final source = await safariSheet<ImageSource>(
      context,
      Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Choose photo', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.photo_camera_outlined), title: const Text('Camera'), onTap: () => Navigator.pop(context, ImageSource.camera)),
        ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.photo_library_outlined), title: const Text('Gallery'), onTap: () => Navigator.pop(context, ImageSource.gallery)),
      ]),
    );
    if (source == null) return null;
    return ImagePicker().pickImage(source: source, imageQuality: 82, maxWidth: 1800);
  }

  Future<void> _save() async {
    setState(() => saving = true);
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
      if (passport != null) {
        files.add(http.MultipartFile.fromBytes(
          'passport',
          await passport!.readAsBytes(),
          filename: passport!.name.isEmpty ? 'passport.jpg' : passport!.name,
          contentType: MediaType('image', 'jpeg'),
        ));
      }
      final json = await SafariApi.request(
        'POST',
        '/drivers/profile',
        fields: {
          'name': name.text.trim(),
          'bio': bio.text.trim(),
          'company': company.text.trim(),
          'licence_ref': licence.text.trim(),
          'languages': languages.text.trim(),
          'destinations': destinations.text.trim(),
          'specialties': specialties.text.trim(),
          if (experience.text.trim().isNotEmpty) 'experience_years': experience.text.trim(),
          'goals': goals.text.trim(),
        },
        files: files,
      );
      final updated = Map<String, dynamic>.from(SafariApi.data(json) as Map);
      SafariApi.driver = updated;
      final token = SafariApi.token;
      if (token != null) await SafariApi.saveAuth(token, updated);
      photo = null;
      passport = null;
      editing = false;
      await _load();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Guide Passport saved')));
    } catch (e) {
      await safariError(context, e);
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final d = driver;
    final goalList = safariCsv(data?['goals'] ?? d['goals']);
    final languageList = safariCsv(d['languages']);
    final destinationList = safariCsv(d['destinations']);
    final stories = (data?['stories'] as List?) ?? [];
    final photoUrl = d['photo_url']?.toString();
    final hasPassport = d['has_passport'] == true || (d['passport_url']?.toString().isNotEmpty ?? false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Guide Passport'),
        actions: [
          if (!loading)
            TextButton(
              onPressed: () => setState(() {
                editing = !editing;
                if (editing) _fill();
              }),
              child: Text(editing ? 'Cancel' : 'Edit'),
            ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
              children: [
                if (editing) ...[
                  SafariCard(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('Photo & passport', style: TextStyle(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 10),
                      Row(children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              final picked = await _pickImage();
                              if (picked != null) setState(() => photo = picked);
                            },
                            icon: const Icon(Icons.account_circle_outlined),
                            label: Text(photo != null ? 'Photo selected' : 'Guide photo'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              final picked = await _pickImage();
                              if (picked != null) setState(() => passport = picked);
                            },
                            icon: const Icon(Icons.badge_outlined),
                            label: Text(passport != null ? 'Passport selected' : 'Upload passport'),
                          ),
                        ),
                      ]),
                      const SizedBox(height: 6),
                      Text(
                        hasPassport && passport == null ? 'A passport image is already on file. Upload again to replace it.' : 'Take a clear photo of your passport bio page.',
                        style: const TextStyle(color: SafariTheme.muted, fontSize: 12),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 12),
                  TextField(controller: name, decoration: const InputDecoration(labelText: 'Full name')),
                  const SizedBox(height: 12),
                  TextField(controller: company, decoration: const InputDecoration(labelText: 'Company / operator')),
                  const SizedBox(height: 12),
                  TextField(controller: licence, decoration: const InputDecoration(labelText: 'Guide licence / TALA ref')),
                  const SizedBox(height: 12),
                  TextField(controller: experience, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Years of experience')),
                  const SizedBox(height: 12),
                  TextField(controller: languages, decoration: const InputDecoration(labelText: 'Languages', hintText: 'English, Swahili, French')),
                  const SizedBox(height: 12),
                  TextField(controller: destinations, decoration: const InputDecoration(labelText: 'Destinations', hintText: 'Serengeti, Ngorongoro')),
                  const SizedBox(height: 12),
                  TextField(controller: specialties, decoration: const InputDecoration(labelText: 'Specialties')),
                  const SizedBox(height: 12),
                  TextField(controller: bio, maxLines: 4, decoration: const InputDecoration(labelText: 'Bio')),
                  const SizedBox(height: 12),
                  TextField(controller: goals, maxLines: 2, decoration: const InputDecoration(labelText: 'Dreams & goals')),
                  const SizedBox(height: 16),
                  SafariLoadingButton(label: saving ? 'Saving…' : 'Save Guide Passport', loading: saving, onPressed: _save),
                ] else ...[
                  SafariCard(
                    child: Column(children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: SafariTheme.pillFill,
                        backgroundImage: photoUrl != null && photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null,
                        child: photoUrl == null || photoUrl.isEmpty
                            ? Text(safariInitials(d['name']), style: const TextStyle(color: SafariTheme.maroon, fontWeight: FontWeight.w700, fontSize: 16))
                            : null,
                      ),
                      const SizedBox(height: 8),
                      Text('${d['name'] ?? ''}', style: Theme.of(context).textTheme.titleMedium),
                      Text('${d['member_no'] ?? ''} · ${data?['verified_rating'] ?? '—'} / 5', style: const TextStyle(color: SafariTheme.gold, fontWeight: FontWeight.w600, fontSize: 12)),
                      Text('${data?['verified_review_count'] ?? 0} verified reviews', style: const TextStyle(color: SafariTheme.muted, fontSize: 12)),
                      const SizedBox(height: 8),
                      SafariStatusChip(hasPassport ? 'Passport uploaded' : 'Passport not uploaded', tone: hasPassport ? SafariChipTone.success : SafariChipTone.warn),
                      if (languageList.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Wrap(spacing: 6, children: languageList.map((l) => SafariStatusChip(l, tone: SafariChipTone.gold)).toList()),
                      ],
                      if ((d['bio'] ?? '').toString().isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Text('${d['bio']}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 13)),
                      ],
                    ]),
                  ),
                  if (goalList.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    SafariDreamCard(title: goalList.first, body: goalList.length > 1 ? goalList.skip(1).join(' · ') : 'The next chapter guests can celebrate with you.'),
                  ],
                  if (destinationList.isNotEmpty) ...[
                    const SafariSectionTitle('Destinations'),
                    SafariCard(child: Text(destinationList.join(' · '))),
                  ],
                  if ((d['licence_ref'] ?? '').toString().isNotEmpty || (d['company'] ?? '').toString().isNotEmpty) ...[
                    const SafariSectionTitle('Credentials'),
                    SafariCard(
                      child: Text(
                        [if ((d['company'] ?? '').toString().isNotEmpty) d['company'], if ((d['licence_ref'] ?? '').toString().isNotEmpty) 'Licence ${d['licence_ref']}', if (d['experience_years'] != null) '${d['experience_years']} years']
                            .join(' · '),
                      ),
                    ),
                  ],
                  if (stories.isNotEmpty) ...[
                    const SafariSectionTitle('Public stories'),
                    ...stories.take(4).map((raw) {
                      final story = Map<String, dynamic>.from(raw as Map);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: SafariCard(child: Text(story['title']?.toString() ?? 'Story', style: const TextStyle(fontWeight: FontWeight.w700))),
                      );
                    }),
                  ],
                  const SizedBox(height: 12),
                  OutlinedButton(onPressed: () => setState(() { editing = true; _fill(); }), child: const Text('Edit information')),
                  if ((d['permanent_qr_url'] ?? d['public_url']) != null) ...[
                    const SizedBox(height: 8),
                    ElevatedButton(onPressed: () => Share.share((d['permanent_qr_url'] ?? d['public_url']).toString()), child: const Text('Share profile')),
                  ],
                ],
              ],
            ),
    );
  }
}
