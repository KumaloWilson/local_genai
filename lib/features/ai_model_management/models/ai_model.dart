import 'dart:convert';
import 'package:get/get.dart';
import 'package:local_gen_ai/features/ai_model_management/models/chat_template_config.dart';
import 'model_file.dart';

class AIModel {
  final String id;
  final String author;
  final String name;
  final String type;
  final String description;
  final int size;
  final int params;
  RxBool isDownloaded;
  RxString downloadUrl;
  final String hfUrl;
  RxDouble progress;
  final String filename;
  final bool isLocal;
  final String origin;
  final ChatTemplate defaultChatTemplate;
  final ChatTemplate chatTemplate;
  final Map<String, dynamic> defaultCompletionSettings;
  final Map<String, dynamic> completionSettings;
  final HFModelFile hfModelFile;

  AIModel({
    required this.id,
    required this.author,
    required this.name,
    required this.type,
    required this.description,
    required this.size,
    required this.params,
    required this.isDownloaded,
    required this.downloadUrl,
    required this.hfUrl,
    required this.progress,
    required this.filename,
    required this.isLocal,
    required this.origin,
    required this.defaultChatTemplate,
    required this.chatTemplate,
    required this.defaultCompletionSettings,
    required this.completionSettings,
    required this.hfModelFile,
  });

  // Convert a Model instance to a Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author': author,
      'name': name,
      'type': type,
      'description': description,
      'size': size,
      'params': params,
      'isDownloaded': isDownloaded.value,  // Use .value to get the actual value of RxBool
      'downloadUrl': downloadUrl.value,  // Use .value to get the actual value of RxString
      'hfUrl': hfUrl,
      'progress': progress.value,  // Use .value to get the actual value of RxDouble
      'filename': filename,
      'isLocal': isLocal,
      'origin': origin,
      'defaultChatTemplate': defaultChatTemplate.toMap(),
      'chatTemplate': chatTemplate.toMap(),
      'defaultCompletionSettings': defaultCompletionSettings,
      'completionSettings': completionSettings,
      'hfModelFile': hfModelFile.toJson(),
    };
  }

  // Create a Model instance from a Map
  factory AIModel.fromJson(Map<String, dynamic> json) {
    return AIModel(
      id: json['id'],
      author: json['author'],
      name: json['name'],
      type: json['type'],
      description: json['description'],
      size: json['size'],
      params: json['params'],
      isDownloaded: RxBool(json['isDownloaded']),  // Wrap in RxBool
      downloadUrl: RxString(json['downloadUrl']),  // Wrap in RxString
      hfUrl: json['hfUrl'],
      progress: RxDouble(json['progress'].toDouble()),  // Wrap in RxDouble
      filename: json['filename'],
      isLocal: json['isLocal'],
      origin: json['origin'],
      defaultChatTemplate: ChatTemplate.fromMap(json['defaultChatTemplate']),
      chatTemplate: ChatTemplate.fromMap(json['chatTemplate']),
      defaultCompletionSettings: Map<String, dynamic>.from(json['defaultCompletionSettings']),
      completionSettings: Map<String, dynamic>.from(json['completionSettings']),
      hfModelFile: HFModelFile.fromJson(json['hfModelFile']),
    );
  }
}
