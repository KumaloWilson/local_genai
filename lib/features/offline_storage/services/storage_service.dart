import 'dart:io';

import '../../../core/constants/model_constants.dart';
import '../../ai_model_management/helper/file_helper.dart';

class StorageService {
  static Future<bool> hasEnoughStorage(int requiredBytes) async {
    final available = await FileHelper.getAvailableStorage();
    return available >= requiredBytes + ModelConstants.MIN_STORAGE_REQUIRED;
  }

  static Future<void> cleanupOldModels() async {
    final modelDir = await FileHelper.getModelDirectory();
    final dir = Directory(modelDir);

    if (!await dir.exists()) {
      return;
    }

    final files = await dir.list().toList();
    if (files.length <= 5) return; // Keep at least 5 most recent models

    // Sort by last modified time
    files.sort((a, b) {
      return File(a.path).lastModifiedSync()
          .compareTo(File(b.path).lastModifiedSync());
    });

    // Delete oldest files
    for (var i = 0; i < files.length - 5; i++) {
      await File(files[i].path).delete();
    }
  }
}