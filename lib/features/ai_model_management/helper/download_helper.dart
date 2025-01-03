import 'dart:io';
import 'dart:math';

import 'package:path_provider/path_provider.dart';

class DownloadHelper {
  // Get the downloads directory
  static Future<String> get downloadPath async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/models';
    final dir = Directory(path);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return path;
  }

  // Sanitize filename to remove invalid characters
  static String sanitizeFilename(String filename) {
    // Remove any path separators and invalid filename characters
    return filename
        .replaceAll(RegExp(r'[/\\?%*:|"<>]'), '')
        .replaceAll(RegExp(r'\s+'), '_');
  }

}