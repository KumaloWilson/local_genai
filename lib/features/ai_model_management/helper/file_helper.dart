import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class FileHelper {
  static Future<String> getModelDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final modelDir = Directory(path.join(appDir.path, 'models'));
    if (!await modelDir.exists()) {
      await modelDir.create(recursive: true);
    }
    return modelDir.path;
  }

  static Future<bool> checkModelExists(String filename) async {
    final modelDir = await getModelDirectory();
    final file = File(path.join(modelDir, filename));
    return await file.exists();
  }

  static Future<int> getAvailableStorage() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final stat = await appDir.stat();
      return stat.size;
    } catch (e) {
      return 0;
    }
  }
}