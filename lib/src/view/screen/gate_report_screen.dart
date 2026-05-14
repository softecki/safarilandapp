import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wicom/core/gate_access_api.dart';
import 'package:wicom/core/gate_access_session.dart';
import 'package:wicom/src/services/gate_sync_service.dart';
import 'package:wicom/src/view/widgets/neumorphic_widgets.dart';

class GateReportScreen extends StatefulWidget {
  const GateReportScreen({super.key});

  @override
  State<GateReportScreen> createState() => _GateReportScreenState();
}

class _GateReportScreenState extends State<GateReportScreen> {
  final _syncService = GateSyncService();
  DateTime _from = DateTime.now().subtract(const Duration(days: 1));
  DateTime _to = DateTime.now();
  bool _busy = false;
  String? _status;

  Future<void> _pickFrom() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDate: _from,
    );
    if (picked != null) setState(() => _from = picked);
  }

  Future<void> _pickTo() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDate: _to,
    );
    if (picked != null) setState(() => _to = picked);
  }

  String _ymd(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> _syncAndGeneratePdf() async {
    setState(() {
      _busy = true;
      _status = null;
    });
    try {
      final token = await GateAccessSession.scannerToken;
      if (token == null || token.isEmpty) {
        throw Exception('Gate session expired. Login again.');
      }

      final summary = await _syncService.syncPending();
      final pdfBytes = await GateAccessApi.downloadReportPdf(
        scannerToken: token,
        from: _ymd(_from),
        to: _ymd(_to),
      );

      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/gate-attendance-${_ymd(_from)}-${_ymd(_to)}.pdf');
      await file.writeAsBytes(pdfBytes, flush: true);
      await Share.shareXFiles([XFile(file.path)], text: 'Gate attendance report');

      setState(() {
        _status =
            'Sync complete. Total: ${summary.total}, Succeeded: ${summary.succeeded}, Failed: ${summary.failed}. PDF ready.';
      });
    } catch (e) {
      setState(() => _status = e.toString());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gate Reports')),
      body: NeuScreenCanvas(
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                NeuPanel(
                  child: ListTile(
                    title: const Text('From'),
                    subtitle: Text(_ymd(_from)),
                    trailing: const Icon(Icons.calendar_today_outlined),
                    onTap: _pickFrom,
                  ),
                ),
                const SizedBox(height: 12),
                NeuPanel(
                  child: ListTile(
                    title: const Text('To'),
                    subtitle: Text(_ymd(_to)),
                    trailing: const Icon(Icons.calendar_today_outlined),
                    onTap: _pickTo,
                  ),
                ),
                const SizedBox(height: 20),
                NeuPrimaryButton(
                  label: _busy ? 'Processing…' : 'Sync & Print PDF Report',
                  icon: Icons.picture_as_pdf_outlined,
                  loading: _busy,
                  onPressed: _busy ? null : _syncAndGeneratePdf,
                ),
                if (_status != null) ...[
                  const SizedBox(height: 16),
                  NeuPanel(
                    padding: const EdgeInsets.all(14),
                    depth: 2,
                    child: Text(_status!, style: const TextStyle(fontSize: 13)),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
