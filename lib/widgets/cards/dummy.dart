// import 'dart:async';
// import 'dart:io';
// import 'package:background_downloader/background_downloader.dart';
//
// class DownloadService {
//   final FileDownloader _downloader = FileDownloader();
//
//   Future<void> initialize() async {
//     await _downloader.trackTasks();
//     _configureNotifications();
//   }
//
//   void _configureNotifications() {
//     _downloader.configureNotification(
//       running: TaskNotification(
//         'Downloading',
//         'File: {filename} - {progress}%',
//       ),
//       complete: TaskNotification(
//         'Download Complete',
//         'File: {filename}',
//       ),
//       error: TaskNotification(
//         'Download Failed',
//         'File: {filename} - {error}',
//       ),
//       paused: TaskNotification(
//         'Download Paused',
//         'File: {filename} - Tap to resume',
//       ),
//       progressBar: true,
//     );
//   }
//
//   Future<TaskStatus> downloadFile({
//     required String url,
//     required String filename,
//     required String directory,
//     Map<String, String>? headers,
//     bool requiresWiFi = true,
//     int retries = 3,
//     bool allowPause = true,
//     String? metadata,
//     Function(double)? onProgress,
//     Function(TaskStatus)? onStatus,
//   }) async {
//     final task = DownloadTask(
//       url: url,
//       filename: filename,
//       directory: directory,
//       baseDirectory: BaseDirectory.applicationDocuments,
//       headers: headers,
//       requiresWiFi: requiresWiFi,
//       retries: retries,
//       allowPause: allowPause,
//       metaData: metadata ?? '',
//       updates: Updates.statusAndProgress,
//     );
//
//     final result = await _downloader.download(
//       task,
//       onProgress: onProgress,
//       onStatus: (status) => onStatus?.call(status),
//     );
//
//     return result.status;
//   }
//
//   Future<bool> enqueueDownload(DownloadTask task) async {
//     return await _downloader.enqueue(task);
//   }
//
//   Future<void> pauseDownload(DownloadTask task) async {
//     await _downloader.pause(task);
//   }
//
//   Future<void> resumeDownload(DownloadTask task) async {
//     await _downloader.resume(task);
//   }
//
//   Future<void> cancelDownload(String taskId) async {
//     await _downloader.cancelTaskWithId(taskId);
//   }
//
//   Future<List<TaskRecord>> getAllDownloads() async {
//     return await _downloader.database.allRecords();
//   }
//
//   Future<TaskRecord?> getDownloadStatus(String taskId) async {
//     return await _downloader.database.recordForId(taskId);
//   }
//
//   Stream<TaskUpdate> get downloadUpdates => _downloader.updates;
//
// }