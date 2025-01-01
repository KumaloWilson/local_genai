import 'dart:async';
import 'dart:io';
import 'package:get/get.dart';
import '../../../core/utils/logs.dart';
import '../../../widgets/snackbar/custom_snackbar.dart';
import '../../offline_storage/services/sqflite_service.dart';
import '../models/ai_model.dart';
import '../services/download_service.dart';

class DownloadManager extends GetxController {
  final DownloadService _downloadService;
  final DatabaseService _dbService;

  // Track active downloads
  final RxMap<String, bool> activeDownloads = <String, bool>{}.obs;

  DownloadManager(this._downloadService, this._dbService);

  Future<void> startDownload(AIModel model) async {
    if (activeDownloads[model.id] == true) {
      CustomSnackBar.showLoadingSnackbar(message: 'Download already in progress');
      return;
    }

    activeDownloads[model.id] = true;

    try {
      await _downloadService.downloadModel(
        url: model.downloadUrl.value,
        filename: model.filename,
        onProgress: (progress) {
          model.progress.value = progress;
        },
        onComplete: (path) async {
          model.isDownloaded.value = true;
          model.progress.value = 1.0;
          await _dbService.saveModel(model);
          activeDownloads.remove(model.id);
          CustomSnackBar.showSuccessSnackbar(message: '${model.name} downloaded successfully');
        },
        onError: (error) {
          model.progress.value = 0.0;
          activeDownloads.remove(model.id);
          DevLogs.logError('Download failed for ${model.name}: $error');
          CustomSnackBar.showErrorSnackbar(message: 'Failed to download ${model.name}: $error');
        },
      );
    } catch (e) {
      activeDownloads.remove(model.id);
      DevLogs.logError('Error initiating download: $e');
      CustomSnackBar.showErrorSnackbar(message: 'Failed to start download: $e');
    }
  }

  Future<void> cancelDownload(AIModel model) async {
    if (activeDownloads[model.id] != true) return;

    activeDownloads.remove(model.id);
    model.progress.value = 0.0;

    final path = await _downloadService.getDownloadPath(model.filename);
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }

    CustomSnackBar.showInfoSnackbar(message: '${model.name} download cancelled');
  }

  bool isDownloading(String modelId) => activeDownloads[modelId] == true;
}