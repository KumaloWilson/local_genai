import 'dart:io';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:disk_space_update/disk_space_update.dart';
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

  static Future<bool> hasNetworkConnectivity() async {
    final connectivity = await Connectivity().checkConnectivity();

    if(connectivity.last == ConnectivityResult.none) {
      return false;
    }else{
      return true;
    }
  }

  static Future<bool> hasSufficientStorage(int requiredSpace) async {
    final freeSpace = await getAvailableSpace() ?? 0;
    return freeSpace.toInt() >= requiredSpace;
  }


  static Future<int> getAvailableSpace() async {
    if (Platform.isAndroid) {
      final space = await DiskSpace.getFreeDiskSpace;
      return (space ?? 0 * 1024 * 1024).toInt(); // Convert MB to bytes
    } else if (Platform.isIOS) {
      final directory = await getApplicationDocumentsDirectory();
      final stat = await directory.stat();
      return stat.size;
    }
    return 0;
  }
}