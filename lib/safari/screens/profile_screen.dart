import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wicom/safari/safari_api.dart';
import 'package:wicom/safari/safari_nav.dart';
import 'package:wicom/safari/safari_theme.dart';
import 'package:wicom/safari/safari_ui.dart';
import 'package:wicom/safari/screens/login_screen.dart';
import 'package:wicom/safari/screens/passport_screen.dart';
import 'package:wicom/safari/screens/profile_edit_screen.dart';
import 'package:wicom/safari/screens/reviews_screen.dart';
import 'package:wicom/safari/screens/settings_screen.dart';

class SafariProfileScreen extends StatefulWidget {
  const SafariProfileScreen({super.key});

  @override
  State<SafariProfileScreen> createState() => _SafariProfileScreenState();
}

class _SafariProfileScreenState extends State<SafariProfileScreen> {
  bool uploading = false;
  int reviewCount = 0;
  double? reviewRating;

  Map<String, dynamic> get d => Map<String, dynamic>.from(SafariApi.driver ?? {});

  @override
  void initState() {
    super.initState();
    _syncReviews();
  }

  Future<void> _syncReviews() async {
    reviewCount = int.tryParse('${d['review_count'] ?? 0}') ?? 0;
    reviewRating = double.tryParse('${d['review_rating'] ?? ''}');
    try {
      final json = await SafariApi.get('/reviews');
      final rows = (SafariApi.data(json) as List?) ?? [];
      if (!mounted) return;
      var sum = 0;
      for (final raw in rows) {
        if (raw is! Map) continue;
        sum += int.tryParse('${raw['overall'] ?? 0}') ?? 0;
      }
      setState(() {
        reviewCount = rows.length;
        reviewRating = rows.isEmpty ? null : sum / rows.length;
      });
    } catch (_) {}
  }

  Future<void> _openEdit({String section = 'profile'}) async {
    await SafariNav.push(context, SafariProfileEditScreen(section: section));
    if (mounted) setState(() {});
  }

  Future<XFile?> _pickPhoto() async {
    final source = await safariSheet<ImageSource>(
      context,
      Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Profile photo', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.photo_camera_outlined), title: const Text('Camera'), onTap: () => Navigator.pop(context, ImageSource.camera)),
        ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.photo_library_outlined), title: const Text('Gallery'), onTap: () => Navigator.pop(context, ImageSource.gallery)),
      ]),
    );
    if (source == null) return null;
    return ImagePicker().pickImage(source: source, imageQuality: 82, maxWidth: 1400);
  }

  Future<void> _uploadPhoto() async {
    final picked = await _pickPhoto();
    if (picked == null) return;
    setState(() => uploading = true);
    try {
      final json = await SafariApi.request(
        'POST',
        '/drivers/profile',
        files: [
          http.MultipartFile.fromBytes(
            'photo',
            await picked.readAsBytes(),
            filename: picked.name.isEmpty ? 'photo.jpg' : picked.name,
            contentType: MediaType('image', 'jpeg'),
          ),
        ],
      );
      final updated = Map<String, dynamic>.from(SafariApi.data(json) as Map);
      SafariApi.driver = updated;
      final token = SafariApi.token;
      if (token != null) await SafariApi.saveAuth(token, updated);
      if (mounted) {
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile photo updated')));
      }
    } catch (e) {
      await safariError(context, e);
    } finally {
      if (mounted) setState(() => uploading = false);
    }
  }

  String? _publicUrl() {
    final qr = d['permanent_qr_url']?.toString();
    if (qr != null && qr.isNotEmpty) return qr;
    final url = d['public_url']?.toString();
    return (url != null && url.isNotEmpty) ? url : null;
  }

  Future<void> _preview() async {
    final url = _publicUrl();
    if (url == null || url.isEmpty) {
      await safariError(context, 'Public profile is not ready yet.');
      return;
    }
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      await safariError(context, 'Could not open profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = d['name']?.toString() ?? 'Guide';
    final languages = safariCsv(d['languages']);
    final destinations = safariCsv(d['destinations']);
    final specialties = safariCsv(d['specialties']);
    final bio = d['bio']?.toString() ?? '';
    final photoUrl = d['photo_url']?.toString() ?? '';
    final ratingText = reviewRating == null ? '—' : reviewRating!.toStringAsFixed(1);

    return Scaffold(
      appBar: Navigator.canPop(context) ? AppBar(title: const Text('Profile')) : null,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 88),
        children: [
          if (!Navigator.canPop(context))
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text('Guide Passport', style: SafariTheme.display(size: 28)),
            ),
          SafariCard(
            child: Column(children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 44,
                    backgroundColor: SafariTheme.pillFill,
                    backgroundImage: photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null,
                    child: photoUrl.isNotEmpty
                        ? null
                        : Text(safariInitials(name), style: const TextStyle(fontWeight: FontWeight.w700, color: SafariTheme.maroon, fontSize: 22)),
                  ),
                  Material(
                    color: SafariTheme.maroon,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: uploading ? null : _uploadPhoto,
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: uploading
                            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : const Icon(Icons.camera_alt_outlined, size: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(name, style: SafariTheme.display(size: 26)),
              const SizedBox(height: 2),
              Text(d['member_no']?.toString() ?? 'Pending ID', style: const TextStyle(color: SafariTheme.gold, fontWeight: FontWeight.w600, fontSize: 12)),
              if (d['company'] != null) Text('${d['company']}', style: const TextStyle(color: SafariTheme.muted, fontSize: 13)),
              if ((d['licence_ref'] ?? '').toString().isNotEmpty)
                Text('Licence ${d['licence_ref']}', style: const TextStyle(color: SafariTheme.muted, fontSize: 12)),
              const SizedBox(height: 10),
              Text('$ratingText · $reviewCount review${reviewCount == 1 ? '' : 's'}', style: const TextStyle(color: SafariTheme.muted, fontSize: 12, fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                alignment: WrapAlignment.center,
                children: [
                  if (d['experience_years'] != null) SafariStatusChip('${d['experience_years']} yrs', tone: SafariChipTone.gold),
                  ...languages.map((l) => SafariStatusChip(l)),
                ],
              ),
              const SizedBox(height: 12),
              OutlinedButton(onPressed: () => _openEdit(), child: const Text('Edit profile')),
            ]),
          ),
          const SafariSectionTitle('Portfolio'),
          SafariCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              if (bio.isNotEmpty) ...[
                const Text('About', style: TextStyle(color: SafariTheme.muted, fontSize: 12, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(bio),
                const SizedBox(height: 12),
              ],
              const Text('Destinations', style: TextStyle(color: SafariTheme.muted, fontSize: 12, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Text(destinations.isEmpty ? 'Add the parks and places you guide.' : destinations.join(' · ')),
              const SizedBox(height: 12),
              const Text('Specialties', style: TextStyle(color: SafariTheme.muted, fontSize: 12, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Text(specialties.isEmpty ? 'Add the experiences you are known for.' : specialties.join(' · ')),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(onPressed: () => _openEdit(section: 'portfolio'), child: const Text('Edit portfolio')),
              ),
            ]),
          ),
          const SafariSectionTitle('Account'),
          _row(Icons.edit_outlined, 'Edit profile', () => _openEdit()),
          _row(Icons.work_outline, 'Edit portfolio', () => _openEdit(section: 'portfolio')),
          _row(Icons.menu_book_outlined, 'Guide Passport', () => SafariNav.push(context, const SafariPassportScreen()).then((_) { if (mounted) setState(() {}); })),
          _row(Icons.star_outline, 'Reviews', () => SafariNav.push(context, const SafariReviewsScreen()).then((_) => _syncReviews())),
          _row(Icons.visibility_outlined, 'Preview public profile', _preview),
          _row(Icons.ios_share, 'Share profile', () {
            final url = _publicUrl();
            if (url != null) Share.share(url);
          }),
          _row(Icons.settings_outlined, 'Settings', () => SafariNav.push(context, const SafariSettingsScreen())),
          _row(Icons.logout, 'Sign out', () async {
            try {
              await SafariApi.post('/auth/logout');
            } catch (_) {}
            await SafariApi.clear();
            if (!context.mounted) return;
            SafariNav.reset(context, const SafariLoginScreen());
          }),
        ],
      ),
    );
  }

  Widget _row(IconData icon, String label, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SafariCard(
        onTap: onTap,
        child: Row(children: [
          Icon(icon, color: SafariTheme.maroon),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
          const Icon(Icons.chevron_right, color: SafariTheme.muted),
        ]),
      ),
    );
  }
}
