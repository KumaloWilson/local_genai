import 'dart:async';

import 'package:background_downloader/background_downloader.dart';
import 'package:get/get.dart';
import 'package:local_gen_ai/core/utils/logs.dart';
import 'package:local_gen_ai/features/offline_storage/services/sqflite_service.dart';
import 'package:local_gen_ai/widgets/snackbar/custom_snackbar.dart';
import '../models/ai_model.dart';
import '../services/download_service.dart';
import 'ai_model_controller.dart';

class DownloadController extends GetxController {
  final RxList<AIModel> downloads = <AIModel>[].obs;
  final _activeDownloads = <String, DownloadTask>{}.obs;
  final _downloadProgress = <String, double>{}.obs;
  final _downloadSpeed = <String, double>{}.obs;
  final _timeRemaining = <String, Duration>{}.obs;

  final Map<String, StreamSubscription<TaskUpdate>> _progressSubscriptions = {};

  bool isDownloading(AIModel model) => _activeDownloads.containsKey(model.id);
  double getProgress(String modelId) => _downloadProgress[modelId] ?? 0.0;
  double getDownloadSpeed(String modelId) => _downloadSpeed[modelId] ?? 0.0;
  Duration? getRemainingTime(String modelId) => _timeRemaining[modelId];


  @override
  void onInit() {
    super.onInit();
    _initializeDownloader();
    _setupDownloadListener();
  }

  Future<void> _initializeDownloader() async {
    await DownloadService.initializeNotifications();
  }

  void _setupDownloadListener() {
    DownloadService.downloadUpdates.listen((update) {
      if (update is TaskStatusUpdate) {
        _handleStatusUpdate(update);
      } else if (update is TaskProgressUpdate) {
        _handleProgressUpdate(update);
      }
    });
  }

  Future<void> startDownload(AIModel model) async {
    if (isDownloading(model)) return;

    try {
      final task = await DownloadService.createDownloadTask(model);
      _activeDownloads[model.id] = task;
      downloads.add(model);
      _downloadProgress[model.id] = 0.0;
      _downloadSpeed[model.id] = 0.0;
      model.progress.value = 0.0;


      await DownloadService.startDownload(
        task,
            (progress) {
          _downloadProgress[model.id] = progress;
          model.progress.value = progress;
        },
            () async {
          model.isDownloaded.value = true;
          model.progress.value = 1.0;
          _activeDownloads.remove(model.id);
          _downloadProgress.remove(model.id);

          DevLogs.logInfo('${model.name} has been downloaded successfully',);

          CustomSnackBar.showSuccessSnackbar(message: '${model.name} has been downloaded successfully',);

        },
            (error) {
          model.progress.value = 0.0;
          _activeDownloads.remove(model.id);
          _downloadProgress.remove(model.id);


          DevLogs.logError('Failed to download ${model.name}: $error',);
          CustomSnackBar.showErrorSnackbar(message: 'Failed to download ${model.name}: $error',);
        },
      );
    } catch (e) {

      DevLogs.logError('Failed to start download: ${e.toString()}',);
      CustomSnackBar.showErrorSnackbar(message: 'Failed to start download: ${e.toString()}',);
    }
  }

  Future<void> cancelDownload(String modelId) async {
    final task = _activeDownloads[modelId];
    if (task != null) {
      await DownloadService.cancelDownload(task);
      _activeDownloads.remove(modelId);
      _downloadProgress.remove(modelId);

      // Find and update the corresponding model
      final model = Get.find<AIModelController>()
          .models
          .firstWhere((m) => m.id == modelId);
      model.progress.value = 0.0;

      Get.snackbar(
        'Download Cancelled',
        'Download has been cancelled',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> deleteModel(AIModel model) async {
    try {
      await DownloadService.deleteModel(model);
      model.isDownloaded.value = false;
      model.progress.value = 0.0;
      Get.snackbar(
        'Model Deleted',
        '${model.name} has been deleted',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete model: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> checkDownloadedModels(List<AIModel> models) async {
    for (final model in models) {
      model.isDownloaded.value = await DownloadService.modelExists(model);
    }
  }

  void _handleProgressUpdate(TaskProgressUpdate update) {
    final modelId = update.task.taskId;
    _downloadProgress[modelId] = update.progress;

    if (update.networkSpeed > 0) {
      _downloadSpeed[modelId] = update.networkSpeed;
      _timeRemaining[modelId] = update.timeRemaining;
    }
  }

  Future<void> _handleStatusUpdate(TaskStatusUpdate update) async {
    final task = update.task;

    switch (update.status) {
      case TaskStatus.complete:
        await _handleComplete(task);
        break;
      case TaskStatus.failed:
        _handleError(task.taskId, update.exception!.description ?? 'Download failed');
        break;
      case TaskStatus.canceled:
        _cleanupDownload(task.taskId);
        break;
      case TaskStatus.paused:
        //_activeDownloads[task.taskId] = ;
        break;
      default:
        break;
    }
  }
  Future<void> _handleComplete(Task task) async {
    _activeDownloads.remove(task.taskId);
    _downloadProgress[task.taskId] = 1.0;

    final model = downloads.firstWhere(
          (m) => m.id == task.taskId,
    );

    try {
      await DatabaseService.saveModel(model);
      CustomSnackBar.showSuccessSnackbar(
          message: '${model.name} downloaded successfully');
    } catch (e) {
      DevLogs.logError('Error saving model to database: $e');
    }

  }

  void _cleanupDownload(String taskId) {
    _activeDownloads.remove(taskId);
    _downloadProgress.remove(taskId);
    _downloadSpeed.remove(taskId);
    _timeRemaining.remove(taskId);
  }

  void _handleError(String modelId, String error) {
    _activeDownloads.remove(modelId);
    _downloadProgress[modelId] = 0.0;

    DevLogs.logError('Download failed for $modelId: $error');
    CustomSnackBar.showErrorSnackbar(message: 'Failed to download: $error');

  }

  @override
  void onClose() {
    for (final subscription in _progressSubscriptions.values) {
      subscription.cancel();
    }
    _progressSubscriptions.clear();
    super.onClose();
  }
}
