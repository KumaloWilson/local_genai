import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DownloadService {
  static const int maxRetries = 3;
  static const int timeoutSeconds = 30;

  Future<String> getDownloadPath(String filename) async {
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, 'models');
    await Directory(path).create(recursive: true);
    return join(path, filename);
  }

  Future<void> downloadModel({
    required String url,
    required String filename,
    required Function(double) onProgress,
    required Function(String) onComplete,
    required Function(String) onError,
  }) async {
    int attempts = 0;
    while (attempts < maxRetries) {
      try {
        final client = http.Client();
        final response = await client.head(Uri.parse(url)).timeout(const Duration(seconds: timeoutSeconds));

        final totalSize = int.parse(response.headers['content-length'] ?? '0');
        if (totalSize == 0) throw Exception('Invalid file size');

        final downloadPath = await getDownloadPath(filename);
        final file = File(downloadPath);
        final sink = file.openWrite();

        final streamedResponse = await client
            .send(http.Request('GET', Uri.parse(url)))
            .timeout(const Duration(seconds: timeoutSeconds));

        int received = 0;
        await streamedResponse.stream.listen(
              (chunk) {
            sink.add(chunk);
            received += chunk.length;
            onProgress(received / totalSize);
          },
          onDone: () async {
            await sink.close();
            onComplete(downloadPath);
          },
          onError: (error) async {
            await sink.close();
            throw Exception('Stream error: $error');
          },
          cancelOnError: true,
        ).asFuture();

        client.close();
        return;
      } catch (e) {
        attempts++;
        if (attempts >= maxRetries) {
          onError('Download failed after $maxRetries attempts: $e');
        }
        await Future.delayed(Duration(seconds: attempts * 2)); // Exponential backoff
      }
    }
  }
}
