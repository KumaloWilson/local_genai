class AIModel {
  final String name;
  final String version;
  final String size;
  final bool isDownloaded;
  final double? downloadProgress;

  AIModel({
    required this.name,
    required this.version,
    required this.size,
    this.isDownloaded = false,
    this.downloadProgress,
  });
}