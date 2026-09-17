import 'package:flutter/material.dart';
import 'package:wicom/pamoja/brand.dart';
import 'package:wicom/pamoja/ops_api.dart';
import 'package:wicom/pamoja/session.dart';
import 'package:wicom/pamoja/shell.dart';
import 'package:wicom/pamoja/widgets.dart';

class PamojaLoginScreen extends StatefulWidget {
  const PamojaLoginScreen({super.key});

  @override
  State<PamojaLoginScreen> createState() => _PamojaLoginScreenState();
}

class _PamojaLoginScreenState extends State<PamojaLoginScreen> {
  final phone = TextEditingController(text: '+254 754 000 184');
  final password = TextEditingController(text: 'Pamoja2027');

  @override
  void dispose() {
    phone.dispose();
    password.dispose();
    super.dispose();
  }

  Future<void> _goOtp() async {
    try {
      final data = await OpsApi.login(phone.text, password.text);
      if (!mounted) return;
      await pushPamoja(
        context,
        PamojaOtpScreen(phone: '${data['phone'] ?? phone.text}', fanId: '${data['fanId'] ?? ''}', next: const PamojaShell()),
      );
    } catch (e) {
      if (!mounted) return;
      pamojaToast(context, '$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
          children: [
            const Text('PAMOJA', style: TextStyle(color: PamojaBrand.lake, fontWeight: FontWeight.w800, fontSize: 22, letterSpacing: 1.2)),
            const Text('AFCON 2027 SUPER APP', style: TextStyle(color: PamojaBrand.muted, letterSpacing: 2, fontSize: 10, fontWeight: FontWeight.w600)),
            const SizedBox(height: 28),
            const Text('Welcome back', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: PamojaBrand.indigo, height: 1.1)),
            const SizedBox(height: 8),
            const Text('Log in with your Fan ID mobile number. Demo OTP is 481028.'),
            const SizedBox(height: 24),
            TextField(controller: phone, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Mobile number')),
            const SizedBox(height: 12),
            TextField(controller: password, obscureText: true, decoration: const InputDecoration(labelText: 'Password')),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _goOtp, child: const Text('Continue')),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () => pushPamoja(context, const PamojaRegisterScreen()),
              child: const Text('Create Fan ID'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  final challenge = await OpsApi.login('+254754000184', 'Pamoja2027');
                  final session = await OpsApi.otp(phone: '${challenge['phone']}', fanId: '${challenge['fanId']}', code: '481028');
                  PamojaSession.instance.applyFan(Map<String, dynamic>.from(session['fan'] as Map), '${session['token']}');
                  await PamojaSession.instance.login();
                } catch (_) {
                  await PamojaSession.instance.login();
                }
                if (!context.mounted) return;
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const PamojaShell()), (_) => false);
              },
              child: const Text('Enter demo as Amina'),
            ),
          ],
        ),
      ),
    );
  }
}

class PamojaRegisterScreen extends StatefulWidget {
  const PamojaRegisterScreen({super.key});

  @override
  State<PamojaRegisterScreen> createState() => _PamojaRegisterScreenState();
}

class _PamojaRegisterScreenState extends State<PamojaRegisterScreen> {
  int step = 0;
  final first = TextEditingController(text: 'Amina');
  final last = TextEditingController(text: 'Kassim');
  final phone = TextEditingController(text: '+254 754 000 184');
  final email = TextEditingController(text: 'amina.kassim@pamoja.demo');
  final password = TextEditingController(text: 'Pamoja2027');
  String country = 'Kenya';
  bool consent = true;

  @override
  void dispose() {
    first.dispose();
    last.dispose();
    phone.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final titles = ['Your names', 'Contact', 'Country', 'Secure account', 'Consent'];
    return Scaffold(
      body: Column(
        children: [
          const PamojaBackBar(title: 'Create Fan ID', subtitle: 'Global by default'),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Row(
              children: List.generate(
                5,
                (i) => Expanded(
                  child: Container(
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      color: i <= step ? PamojaBrand.lake : PamojaBrand.border,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text('Step ${step + 1} of 5 · ${titles[step]}', style: const TextStyle(color: PamojaBrand.muted, fontWeight: FontWeight.w600)),
                const SizedBox(height: 16),
                if (step == 0) ...[
                  TextField(controller: first, decoration: const InputDecoration(labelText: 'First name')),
                  const SizedBox(height: 12),
                  TextField(controller: last, decoration: const InputDecoration(labelText: 'Last name')),
                ],
                if (step == 1) ...[
                  TextField(controller: phone, decoration: const InputDecoration(labelText: 'Mobile number')),
                  const SizedBox(height: 12),
                  TextField(controller: email, decoration: const InputDecoration(labelText: 'Email')),
                ],
                if (step == 2)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Nationality'),
                    subtitle: Text(country),
                    trailing: const Icon(Icons.keyboard_arrow_up_rounded),
                    onTap: () => pamojaSheet(
                      context,
                      title: 'Select country',
                      child: Column(
                        children: ['Tanzania', 'Kenya', 'Uganda', 'Other']
                            .map(
                              (c) => ListTile(
                                title: Text(c),
                                trailing: country == c ? const Icon(Icons.check, color: PamojaBrand.lake) : null,
                                onTap: () {
                                  setState(() => country = c);
                                  Navigator.pop(context);
                                },
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                if (step == 3)
                  TextField(controller: password, obscureText: true, decoration: const InputDecoration(labelText: 'Create password')),
                if (step == 4)
                  CheckboxListTile(
                    value: consent,
                    onChanged: (v) => setState(() => consent = v ?? false),
                    title: const Text('I agree to Pamoja terms, privacy and Fan ID processing for AFCON 2027.'),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    if (step < 4) {
                      setState(() => step++);
                      return;
                    }
                    if (!consent) {
                      pamojaToast(context, 'Consent is required to issue a Fan ID.');
                      return;
                    }
                    try {
                      final data = await OpsApi.register({
                        'firstName': first.text,
                        'lastName': last.text,
                        'phone': phone.text,
                        'email': email.text,
                        'nationality': country,
                        'country': country,
                        'password': password.text,
                      });
                      final fan = Map<String, dynamic>.from(data['fan'] as Map);
                      PamojaSession.instance.applyFan(fan);
                      if (!context.mounted) return;
                      await pushPamoja(context, PamojaOtpScreen(phone: phone.text, fanId: '${fan['id']}', next: const PamojaShell(), issueFanId: true));
                    } catch (e) {
                      if (!context.mounted) return;
                      pamojaToast(context, '$e');
                    }
                  },
                  child: Text(step < 4 ? 'Continue' : 'Verify mobile'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PamojaOtpScreen extends StatefulWidget {
  const PamojaOtpScreen({super.key, required this.phone, required this.next, this.issueFanId = false, this.fanId = ''});
  final String phone;
  final Widget next;
  final bool issueFanId;
  final String fanId;

  @override
  State<PamojaOtpScreen> createState() => _PamojaOtpScreenState();
}

class _PamojaOtpScreenState extends State<PamojaOtpScreen> {
  final code = TextEditingController();

  @override
  void dispose() {
    code.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    try {
      final session = await OpsApi.otp(phone: widget.phone, fanId: widget.fanId.isEmpty ? null : widget.fanId, code: code.text.trim().isEmpty ? '481028' : code.text.trim(), issueFanId: widget.issueFanId);
      PamojaSession.instance.applyFan(Map<String, dynamic>.from(session['fan'] as Map), '${session['token']}');
      await PamojaSession.instance.login();
    } catch (e) {
      if (code.text.trim().isNotEmpty && code.text.trim() != '481028') {
        if (!mounted) return;
        pamojaToast(context, '$e');
        return;
      }
      await PamojaSession.instance.login();
    }
    if (!mounted) return;
    pamojaToast(context, widget.issueFanId ? 'Global Fan ID ${PamojaSession.instance.fanId} issued' : 'Signed in');
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => widget.next), (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const PamojaBackBar(title: 'Verify mobile', subtitle: 'WhatsApp / SMS'),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Code sent to ${widget.phone} via WhatsApp', style: const TextStyle(color: PamojaBrand.muted)),
                const SizedBox(height: 16),
                TextField(
                  controller: code,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: const InputDecoration(labelText: '6-digit code', hintText: '481028'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(onPressed: _verify, child: const Text('Verify')),
                TextButton(onPressed: _verify, child: const Text('Use demo code 481028')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
