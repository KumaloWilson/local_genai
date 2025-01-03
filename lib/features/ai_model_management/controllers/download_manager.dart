import 'dart:async';
import 'dart:io';
import 'package:background_downloader/background_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import '../../../core/utils/logs.dart';
import '../../../widgets/snackbar/custom_snackbar.dart';
import '../../offline_storage/services/sqflite_service.dart';
import '../models/ai_model.dart';
import '../services/download_service.dart';

class DownloadController extends GetxController {
  final DownloadService _downloadService;
  final DatabaseService _dbService;

  // Observable collections
  final RxMap<String, bool> activeDownloads = <String, bool>{}.obs;
  final RxList<AIModel> downloads = <AIModel>[].obs;
  final RxMap<String, double> downloadProgress = <String, double>{}.obs;
  final RxMap<String, double> downloadSpeed = <String, double>{}.obs;
  final RxMap<String, Duration> timeRemaining = <String, Duration>{}.obs;

  static const int maxConcurrentDownloads = 3;
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  final Map<String, StreamSubscription<TaskUpdate>> _progressSubscriptions = {};

  DownloadController(this._downloadService, this._dbService);

  @override
  void onInit() {
    super.onInit();
    _initializeDownloader();
    _setupDownloadListener();
    _initializeNotifications();
  }

  Future<void> _initializeDownloader() async {
    await _downloadService.initialize();
    await _loadExistingDownloads();
  }

  Future<void> _loadExistingDownloads() async {
    final records = await _downloadService.getAllDownloads();
    for (final record in records) {
      if (record.status == TaskStatus.running || record.status == TaskStatus.paused) {
        activeDownloads[record.taskId] = true;
        downloadProgress[record.taskId] = record.progress;
      }
    }
  }

  void _setupDownloadListener() {
    _downloadService.downloadUpdates.listen((update) {
      if (update is TaskStatusUpdate) {
        _handleStatusUpdate(update);
      } else if (update is TaskProgressUpdate) {
        _handleProgressUpdate(update);
      }
    });
  }

  Future<void> startDownload(AIModel model) async {
    if (activeDownloads[model.id] == true) {
      CustomSnackBar.showLoadingSnackbar(message: 'Download already in progress');
      return;
    }

    if (_getCurrentActiveDownloads() >= maxConcurrentDownloads) {
      _addToQueue(model);
      return;
    }

    activeDownloads[model.id] = true;
    downloads.add(model);

    try {
      final downloadTask = DownloadTask(
        url: model.downloadUrl.value,
        filename: model.filename,
        directory: 'models/${model.type}',
        baseDirectory: BaseDirectory.applicationDocuments,
        updates: Updates.statusAndProgress,
        allowPause: true,
        requiresWiFi: true,
        retries: 3,
        metaData: model.toJson().toString(),
      );

      final success = await _downloadService.enqueueDownload(downloadTask);

      if (!success) {
        throw Exception('Failed to enqueue download');
      }

      _showNotification('Download Started', 'Downloading ${model.name}');
    } catch (e) {
      _handleError(model.id, e.toString());
    }
  }

  bool isDownloading(AIModel model) {
    return downloads.contains(model);
  }

  Future<void> pauseDownload(AIModel model) async {
    if (activeDownloads[model.id] != true) return;
    await _downloadService.pauseDownload(
      DownloadTask(
        taskId: model.id,
        url: model.downloadUrl.value,
        allowPause: true,
        displayName: model.name,
        filename: model.name,
        retries: 5,
      ),
    );
  }

  Future<void> resumeDownload(AIModel model) async {
    if (activeDownloads[model.id] != true) return;
    await _downloadService.resumeDownload(
      DownloadTask(
        taskId: model.id,
        url: model.downloadUrl.value,
        allowPause: true,
        displayName: model.name,
        filename: model.name,
        retries: 5,
      ),
    );
  }

  Future<void> cancelDownload(String modelId) async {
    if (activeDownloads[modelId] != true) return;

    try {
      await _downloadService.cancelDownload(modelId);
      activeDownloads.remove(modelId);
      downloadProgress.remove(modelId);

      CustomSnackBar.showInfoSnackbar(message: 'Download cancelled');
    } catch (e) {
      DevLogs.logError('Error canceling download: $e');
    }
  }

  void _handleStatusUpdate(TaskStatusUpdate update) async {
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
        activeDownloads[task.taskId] = false;
        break;
      default:
        break;
    }
  }

  void _handleProgressUpdate(TaskProgressUpdate update) {
    final modelId = update.task.taskId;
    downloadProgress[modelId] = update.progress;

    if (update.networkSpeed > 0) {
      downloadSpeed[modelId] = update.networkSpeed;
      timeRemaining[modelId] = update.timeRemaining;
    }
  }

  Future<void> _handleComplete(Task task) async {
    activeDownloads.remove(task.taskId);
    downloadProgress[task.taskId] = 1.0;

    final model = downloads.firstWhere(
          (m) => m.id == task.taskId,
    );

    try {
      await _dbService.saveModel(model);
      CustomSnackBar.showSuccessSnackbar(
          message: '${model.name} downloaded successfully');
      _showNotification('Download Complete', '${model.name} downloaded');
    } catch (e) {
      DevLogs.logError('Error saving model to database: $e');
    }

    _processQueue();
  }


  void _handleError(String modelId, String error) {
    activeDownloads.remove(modelId);
    downloadProgress[modelId] = 0.0;

    DevLogs.logError('Download failed for $modelId: $error');
    CustomSnackBar.showErrorSnackbar(message: 'Failed to download: $error');
    _showNotification('Download Failed', 'Failed to download: $error');

    _processQueue();
  }

  int _getCurrentActiveDownloads() =>
      activeDownloads.values.where((active) => active).length;

  void _addToQueue(AIModel model) {
    downloads.add(model);
    CustomSnackBar.showLoadingSnackbar(
      message: '${model.name} queued - will start when other downloads complete',
    );
    _showNotification('Download Queued', '${model.name} queued');
  }

  void _processQueue() {
    if (_getCurrentActiveDownloads() < maxConcurrentDownloads) {
      final pendingDownload = downloads.firstWhereOrNull(
              (model) => !activeDownloads.containsKey(model.id));

      if (pendingDownload != null) {
        startDownload(pendingDownload);
      }
    }
  }

  Future<void> _initializeNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await _notifications.initialize(initSettings);
  }

  Future<void> _showNotification(String title, String body) async {
    const androidDetails = AndroidNotificationDetails(
      'downloads_channel',
      'Downloads',
      channelDescription: 'Download notifications',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );

    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      details,
    );
  }

  void _cleanupDownload(String taskId) {
    activeDownloads.remove(taskId);
    downloadProgress.remove(taskId);
    downloadSpeed.remove(taskId);
    timeRemaining.remove(taskId);
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
