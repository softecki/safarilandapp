import 'package:flutter/material.dart';
import 'package:wicom/safari/safari_api.dart';
import 'package:wicom/safari/safari_nav.dart';
import 'package:wicom/safari/safari_theme.dart';
import 'package:wicom/safari/safari_ui.dart';

class SafariProfileEditScreen extends StatefulWidget {
  const SafariProfileEditScreen({super.key});

  @override
  State<SafariProfileEditScreen> createState() => _SafariProfileEditScreenState();
}

class _SafariProfileEditScreenState extends State<SafariProfileEditScreen> {
  late final name = TextEditingController(text: '${SafariApi.driver?['name'] ?? ''}');
  late final bio = TextEditingController(text: '${SafariApi.driver?['bio'] ?? ''}');
  late final company = TextEditingController(text: '${SafariApi.driver?['company'] ?? ''}');
  late final goals = TextEditingController(text: ((SafariApi.driver?['goals'] as List?) ?? []).join(', '));
  late final account = TextEditingController(text: '${SafariApi.driver?['payout_account'] ?? ''}');
  String method = '${SafariApi.driver?['payout_method'] ?? 'MPESA'}';
  bool loading = false;

  @override
  void dispose() {
    name.dispose();
    bio.dispose();
    company.dispose();
    goals.dispose();
    account.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => loading = true);
    try {
      final json = await SafariApi.post('/drivers/profile', {
        'name': name.text.trim(),
        'bio': bio.text.trim(),
        'company': company.text.trim(),
        'goals': goals.text.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList(),
        'payout_method': method,
        'payout_account': account.text.trim(),
      });
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
    return Scaffold(
      appBar: AppBar(title: const Text('Edit profile')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(controller: name, decoration: const InputDecoration(labelText: 'Full name')),
          const SizedBox(height: 12),
          TextField(controller: company, decoration: const InputDecoration(labelText: 'Company / operator')),
          const SizedBox(height: 12),
          TextField(controller: bio, maxLines: 4, decoration: const InputDecoration(labelText: 'Bio')),
          const SizedBox(height: 12),
          TextField(controller: goals, maxLines: 2, decoration: const InputDecoration(labelText: 'Goals (comma separated)')),
          const SizedBox(height: 12),
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
