import 'dart:async';
import 'dart:io';

import 'package:background_downloader/background_downloader.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:local_gen_ai/core/utils/logs.dart';
import 'package:local_gen_ai/features/ai_model_management/helper/download_helper.dart';
import 'package:path/path.dart' as path;

import '../models/ai_model.dart';

class DownloadService {
  static final FileDownloader _downloader = FileDownloader();
  static final StreamController<TaskUpdate> _updatesController = StreamController.broadcast();

  static Stream<TaskUpdate> get downloadUpdates => _updatesController.stream;

  static const int maxConcurrentDownloads = 3;
  static int activeDownloads = 0;

  static Future<void> initialize() async {
    await _downloader.trackTasks();

    _downloader.configureNotification(
      running: const TaskNotification('Downloading {progress}', '{filename}'),
      complete: const TaskNotification('Download Complete', '{filename}'),
      error: const TaskNotification('Download Failed', '{filename}'),
      paused: const TaskNotification('Download Paused', '{filename}'),
      progressBar: true,
    );

    _downloader.updates.listen(_updatesController.add);
  }



  static Future<void> startDownload({
    required DownloadTask task,
    required Function(double) onProgress,
    required Function() onComplete,
    required Function(String) onError,
  }) async {
    if (activeDownloads >= maxConcurrentDownloads) {
      onError('Max concurrent downloads reached.');
      return;
    }

    if (!await DownloadHelper.hasNetworkConnectivity()) {
      onError('No network connectivity.');
      return;
    }

    activeDownloads++;

    try {
      await _downloader.download(
        task,
        onProgress: (progress) => onProgress(progress),
        onStatus: (status) {
          switch (status) {
            case TaskStatus.complete:
              onComplete();
              break;
            case TaskStatus.failed:
              onError('Download failed');
              break;
            default:
              break;
          }
        },
      );
    } catch (e) {
      onError(e.toString());
    } finally {
      activeDownloads--;
    }
  }

  static Future<void> pauseDownload(DownloadTask task) async {
    try {
      await _downloader.pause(task);
      DevLogs.logInfo('Paused download: ${task.filename}');
    } catch (e) {
      DevLogs.logError('Failed to pause download: ${task.filename}', );
    }
  }

  static Future<void> resumeDownload(DownloadTask task) async {
    if (!await DownloadHelper.hasNetworkConnectivity()) {
      DevLogs.logError('Network unavailable. Cannot resume download.');
      return;
    }

    try {
      await _downloader.resume(task);
      DevLogs.logInfo('Resumed download: ${task.filename}');
    } catch (e) {
      DevLogs.logError('Failed to resume download: ${task.filename}', );
    }
  }

  static Future<void> cancelDownload(DownloadTask task) async {
    try {
      await _downloader.cancelTaskWithId(task.taskId);
      await _downloader.database.deleteRecordWithId(task.taskId);
      DevLogs.logInfo('Cancelled download: ${task.filename}');
    } catch (e) {
      DevLogs.logError('Failed to cancel download: ${task.filename}', );
    }
  }

  static Future<void> retryDownload(
      DownloadTask task,
      Function(String) onError,
      ) async {
    const maxRetries = 3;
    for (var attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        await _downloader.cancelTaskWithId(task.taskId);
        await _downloader.database.deleteRecordWithId(task.taskId);
        await _downloader.download(task);
        return;
      } catch (e) {
        if (attempt == maxRetries) {
          onError('Max retry attempts reached. Error: $e');
          DevLogs.logError('Failed to retry download: ${task.filename}', );
        } else {
          await Future.delayed(Duration(seconds: attempt * 2));
        }
      }
    }
  }

  static Future<List<TaskRecord>> getAllActiveDownloads() async {
    return (await _downloader.database.allRecords())
        .where((task) => task.status == TaskStatus.running)
        .toList();
  }

  static Future<void> autoResumePausedDownloads() async {
    if (!await DownloadHelper.hasNetworkConnectivity()) {
      return;
    }

    final pausedTasks = (await _downloader.database.allRecords())
        .where((task) => task.status == TaskStatus.paused)
        .toList();

    for (final task in pausedTasks) {
      await resumeDownload(
        DownloadTask(
          url: task.task.url,
          taskId: task.taskId,
          filename: task.task.filename,
          allowPause: true,
        ),
      );
    }
  }

  static Future<void> cleanUpOldDownloads(Duration ageLimit) async {
    final records = await _downloader.database.allRecords();
    final now = DateTime.now();

    for (final record in records) {
      if (record.status == TaskStatus.complete &&
          now.difference(record.task.creationTime) > ageLimit) {
        final file = File(record.task.filename);
        if (await file.exists()) {
          await file.delete();
        }
        await _downloader.database.deleteRecordWithId(record.taskId);
        DevLogs.logInfo('Deleted old download: ${record.task.filename}');
      }
    }
  }
}
