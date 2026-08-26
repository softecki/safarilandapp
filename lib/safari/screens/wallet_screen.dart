import 'package:flutter/material.dart';
import 'package:wicom/safari/safari_api.dart';
import 'package:wicom/safari/safari_ui.dart';
import 'package:wicom/safari/screens/withdraw_screen.dart';

class SafariWalletScreen extends StatefulWidget {
  const SafariWalletScreen({super.key});

  @override
  State<SafariWalletScreen> createState() => _SafariWalletScreenState();
}

class _SafariWalletScreenState extends State<SafariWalletScreen> {
  Map<String, dynamic>? data;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final json = await SafariApi.get('/wallet');
      data = Map<String, dynamic>.from(SafariApi.data(json) as Map);
    } catch (e) {
      await safariError(context, e);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final b = data?['balances'] as Map? ?? {};
    final ledger = (data?['ledger'] as List?) ?? [];
    return Scaffold(
      appBar: AppBar(title: const Text('Wallet')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                SafariHero(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('Available commission'),
                    Text(money(b['available']), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
                    Text('Pending ${money(b['pending'])} · Lifetime ${money(b['lifetime'])}'),
                    Text('Gratuity ${money(b['gratuity_available'])}'),
                  ]),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () async {
                    await Navigator.push(context, MaterialPageRoute(builder: (_) => SafariWithdrawScreen(available: b['available'] ?? 0)));
                    _load();
                  },
                  child: const Text('Request withdrawal'),
                ),
                const SizedBox(height: 12),
                ...ledger.map((row) => ListTile(
                      title: Text('${row['ledger_type']} ${row['direction']}'),
                      trailing: Text(money(row['amount'])),
                      subtitle: Text(row['note']?.toString() ?? row['reference']?.toString() ?? ''),
                    )),
              ],
            ),
    );
  }
}
