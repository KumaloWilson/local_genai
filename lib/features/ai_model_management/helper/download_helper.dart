import 'dart:math';

class DownloadHelper {
  static String getFileSize(int bytes) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB"];
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(2)} ${suffixes[i]}';
  }

  static String getDownloadSpeed(double bytesPerSecond) {
    return '${getFileSize(bytesPerSecond.toInt())}/s';
  }
}