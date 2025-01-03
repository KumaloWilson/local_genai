// import '../../../global/global.dart';
//
// class DownloadTaskModel {
//   final String id;
//   final String url;
//   final String filename;
//   final String modelName;
//   double progress;
//   DownloadStatus status;
//   String? error;
//
//   DownloadTaskModel({
//     required this.id,
//     required this.url,
//     required this.filename,
//     required this.modelName,
//     this.progress = 0.0,
//     this.status = DownloadStatus.pending,
//     this.error,
//   });
//
//   // Convert to/from JSON for persistence
//   Map<String, dynamic> toJson() => {
//     'id': id,
//     'url': url,
//     'filename': filename,
//     'modelName': modelName,
//     'progress': progress,
//     'status': status.toString(),
//     'error': error,
//   };
//
//   factory DownloadTaskModel.fromJson(Map<String, dynamic> json) {
//     return DownloadTaskModel(
//       id: json['id'],
//       url: json['url'],
//       filename: json['filename'],
//       modelName: json['modelName'],
//       progress: json['progress'],
//       status: DownloadStatus.values.firstWhere(
//             (e) => e.toString() == json['status'],
//         orElse: () => DownloadStatus.failed,
//       ),
//       error: json['error'],
//     );
//   }
// }
