import 'package:flutter/material.dart';
import 'package:wicom/safari/safari_api.dart';
import 'package:wicom/safari/screens/login_screen.dart';

class SafariSettingsScreen extends StatefulWidget {
  const SafariSettingsScreen({super.key});

  @override
  State<SafariSettingsScreen> createState() => _SafariSettingsScreenState();
}

class _SafariSettingsScreenState extends State<SafariSettingsScreen> {
  late final url = TextEditingController(text: SafariApi.baseUrl);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          TextField(controller: url, decoration: const InputDecoration(labelText: 'API base URL')),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () async {
              await SafariApi.setBaseUrl(url.text.trim());
              if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved')));
            },
            child: const Text('Save'),
          ),
          if (SafariApi.isLoggedIn)
            TextButton(
              onPressed: () async {
                try { await SafariApi.post('/auth/logout'); } catch (_) {}
                await SafariApi.clear();
                if (!context.mounted) return;
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const SafariLoginScreen()), (_) => false);
              },
              child: const Text('Sign out'),
            ),
        ],
      ),
    );
  }
}
