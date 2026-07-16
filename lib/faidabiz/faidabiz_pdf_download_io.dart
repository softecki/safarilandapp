import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

/// Mobile / desktop: share sheet (works as download + share).
Future<void> downloadPdfBytes(Uint8List bytes, String filename) async {
  try {
    await Printing.sharePdf(bytes: bytes, filename: filename);
  } catch (_) {
    // Fallback when printing channel is missing (e.g. some desktop builds).
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes, flush: true);
    await Share.shareXFiles(
      [XFile(file.path, mimeType: 'application/pdf', name: filename)],
      subject: filename,
    );
  }
}
