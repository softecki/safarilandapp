import 'dart:typed_data';

/// Platform download helper — implemented in `_web` / `_io`.
Future<void> downloadPdfBytes(Uint8List bytes, String filename) =>
    throw UnsupportedError('PDF download is not supported on this platform');
