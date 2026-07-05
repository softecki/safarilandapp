import 'package:flutter/material.dart';
import 'package:wicom/core/whatslipa_api.dart';
import 'package:wicom/core/whatslipa_session.dart';
import 'package:wicom/whatslipa/screens/whatslipa_home_screen.dart';
import 'package:wicom/whatslipa/widgets/whatslipa_loading.dart';
import 'package:wicom/whatslipa/widgets/whatslipa_theme.dart';
import 'package:wicom/whatslipa/widgets/whatslipa_ui.dart';

class WhatsLipaOrganizationPickerScreen extends StatefulWidget {
  const WhatsLipaOrganizationPickerScreen({
    super.key,
    required this.organizations,
    this.token,
  });

  final List<Map<String, dynamic>> organizations;
  final String? token;

  @override
  State<WhatsLipaOrganizationPickerScreen> createState() =>
      _WhatsLipaOrganizationPickerScreenState();
}

class _WhatsLipaOrganizationPickerScreenState extends State<WhatsLipaOrganizationPickerScreen> {
  String? _selectedSlug;
  bool _loading = false;
  String? _error;

  Future<void> _continue() async {
    final slug = _selectedSlug;
    if (slug == null || slug.isEmpty) {
      setState(() => _error = 'Select an organization to continue.');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });
    WhatsLipaLoading.show(context, message: 'Connecting…');

    try {
      final res = await WhatsLipaApi.selectOrganization(slug);
      final data = res['data'];
      if (data is! Map) {
        throw Exception('Invalid server response.');
      }
      await WhatsLipaSession.saveFromAuthPayload(
        Map<String, dynamic>.from(data),
        token: widget.token,
      );

      if (!mounted) return;
      WhatsLipaLoading.hide();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute<void>(builder: (_) => const WhatsLipaHomeScreen()),
        (_) => false,
      );
    } catch (e) {
      WhatsLipaLoading.hide();
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WhatsLipaTheme.appBar(title: 'Choose organization'),
      body: WhatsLipaScreenBackground(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            WhatsLipaGlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Select your workspace', style: WhatsLipaUi.sectionTitle),
                  const SizedBox(height: 8),
                  Text(
                    'Your account belongs to more than one organization. Pick which one to use in the app.',
                    style: WhatsLipaUi.subtitle,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ...widget.organizations.map((org) {
              final slug = org['slug']?.toString() ?? '';
              final name = org['name']?.toString() ?? slug;
              final selected = _selectedSlug == slug;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Material(
                  color: selected ? WhatsLipaUi.primary.withValues(alpha: 0.08) : Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  elevation: selected ? 0 : 0,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: _loading
                        ? null
                        : () => setState(() {
                              _selectedSlug = slug;
                              _error = null;
                            }),
                    child: Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: selected
                              ? WhatsLipaUi.primary.withValues(alpha: 0.45)
                              : WhatsLipaUi.primary.withValues(alpha: 0.08),
                          width: selected ? 1.5 : 1,
                        ),
                        boxShadow: selected ? WhatsLipaUi.cardShadow(blur: 12, y: 4) : null,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: WhatsLipaUi.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(Icons.domain_rounded, color: WhatsLipaUi.primary),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                                  Text(slug, style: WhatsLipaUi.subtitle.copyWith(fontSize: 12)),
                                ],
                              ),
                            ),
                            Icon(
                              selected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                              color: selected ? WhatsLipaUi.primary : Colors.grey.shade400,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!, style: TextStyle(color: Colors.red.shade800)),
            ],
            const SizedBox(height: 20),
            WhatsLipaPrimaryButton(
              label: _loading ? 'Connecting…' : 'Continue',
              loading: _loading,
              onPressed: _loading ? null : _continue,
            ),
          ],
        ),
      ),
    );
  }
}
