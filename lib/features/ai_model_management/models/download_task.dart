class DownloadTask {
  final String url;
  final String filename;
  final Function(double) onProgress;
  final Function(String) onComplete;
  final Function(String) onError;

  DownloadTask({
    required this.url,
    required this.filename,
    required this.onProgress,
    required this.onComplete,
    required this.onError,
  });
}