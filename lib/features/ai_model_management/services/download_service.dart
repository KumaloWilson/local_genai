import 'dart:async';
import 'dart:io';

import 'package:background_downloader/background_downloader.dart';
import 'package:local_gen_ai/features/ai_model_management/helper/download_helper.dart';
import 'package:path/path.dart' as path;

import '../models/ai_model.dart';

class DownloadService {
  static final FileDownloader _downloader = FileDownloader();

  static Stream<TaskUpdate> get downloadUpdates => _downloader.updates;


  // Initialize download notifications
  // Initialize download notifications
  static Future<void> initializeNotifications() async {
    await _downloader.trackTasks();

    _downloader.configureNotification(
      running: const TaskNotification(
        'Downloading AI Model',
        '{filename}',
      ),
      complete: const TaskNotification(
          'Download Complete',
          '{filename}'
      ),
      error: const TaskNotification(
          'Download Failed',
          'There was an error downloading the model'
      ),
      paused: const TaskNotification(
          'Download Paused',
          '{filename}'
      ),
      progressBar: true,
    );
  }


  // Create download task for a model
  static Future<DownloadTask> createDownloadTask(AIModel model) async {
    final downloadPath = await DownloadHelper.downloadPath;
    // Sanitize the filename and ensure it has the correct extension
    final filename = DownloadHelper.sanitizeFilename(model.name);

    // Create the task with sanitized filename
    return DownloadTask(
        url: model.downloadUrl.value,
        filename: filename,
        directory: downloadPath,
        baseDirectory: BaseDirectory.applicationDocuments,
        updates: Updates.statusAndProgress,
        allowPause: true,
        retries: 3,
        metaData: model.toJson().toString()
    );
  }

  // Start a download
  static Future<void> startDownload(
      DownloadTask task,
      Function(double) onProgress,
      Function() onComplete,
      Function(String) onError,
      ) async {
    try {
      await _downloader.download(
        task,
        onProgress: (progress) => onProgress(progress),
        onStatus: (status) {
          if (status == TaskStatus.complete) {
            onComplete();
          } else if (status == TaskStatus.failed) {
            onError('Download failed');
          }
        },
      );
    } catch (e) {
      onError(e.toString());
    }
  }

  // Cancel a download
  static Future<void> cancelDownload(DownloadTask task) async {
    await _downloader.cancelTaskWithId(task.taskId);
  }

  static Future<void> pauseDownload(DownloadTask task) async {
    await _downloader.pause(task);
  }

  static Future<void> resumeDownload(DownloadTask task) async {
    await _downloader.resume(task);
  }


  Future<List<TaskRecord>> getAllDownloads() async {
    return await _downloader.database.allRecords();
  }

  Future<TaskRecord?> getDownloadStatus(String taskId) async {
    return await _downloader.database.recordForId(taskId);
  }

  // Check if a model file exists
  static Future<bool> modelExists(AIModel model) async {
    final downloadPath = await DownloadHelper.downloadPath;
    final filename = DownloadHelper.sanitizeFilename(model.name);
    final file = File(path.join(downloadPath, filename));
    return file.exists();
  }

  // Delete a downloaded model
  static Future<void> deleteModel(AIModel model) async {
    final downloadPath = await DownloadHelper.downloadPath;
    final filename = DownloadHelper.sanitizeFilename(model.name);
    final file = File(path.join(downloadPath, filename));
    if (await file.exists()) {
      await file.delete();
    }
  }

  // Get the file path for a model
  static Future<String> getModelPath(AIModel model) async {
    final downloadPath = await DownloadHelper.downloadPath;
    final filename = DownloadHelper.sanitizeFilename(model.name);
    return path.join(downloadPath, filename);
  }
}


