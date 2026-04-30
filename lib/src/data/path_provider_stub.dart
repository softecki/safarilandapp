/// Stub file for path_provider on web platform
/// This file provides dummy functions to prevent compilation errors on web

import 'dart:io' if (dart.library.html) 'dart:html';

class Directory {
  final String path;
  Directory(this.path);
}

Future<Directory> getApplicationDocumentsDirectory() async {
  throw UnsupportedError('path_provider is not needed on web');
}

Future<Directory> getTemporaryDirectory() async {
  throw UnsupportedError('path_provider is not needed on web');
}

Future<Directory?> getExternalStorageDirectory() async {
  throw UnsupportedError('path_provider is not needed on web');
}
