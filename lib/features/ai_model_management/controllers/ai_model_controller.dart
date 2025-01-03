import 'package:get/get.dart';
import 'package:local_gen_ai/core/utils/logs.dart';
import '../../../widgets/snackbar/custom_snackbar.dart';
import '../../offline_storage/services/sqflite_service.dart';
import '../models/ai_model.dart';

class AIModelController extends GetxController {
  final DatabaseService _dbService;

  RxList<AIModel> models = <AIModel>[].obs;
  RxBool isLoading = false.obs;
  RxString searchQuery = ''.obs;
  RxString sortBy = 'name'.obs;
  RxBool offlineOnly = false.obs;

  AIModelController(this._dbService,);

  @override
  Future<void> onInit() async {
    super.onInit();
    isLoading.value = true;

    // Check if the models are initialized
    final isInitialized = await _dbService.isModelsInitialized();
    if (!isInitialized) {
      // If not initialized, load the default models into the database
      await _dbService.init();  // This will populate the models
    }

    await loadModels();
  }

  Future<void> loadModels() async {
    try {
      isLoading.value = true;

      // Load stored models from the database
      final storedModels = await _dbService.getAllModels();

      models.value = storedModels;

    } catch (e) {
      DevLogs.logError('Error Failed to load models: $e');
      CustomSnackBar.showErrorSnackbar(message:  'Failed to load models: $e');
    } finally {
      isLoading.value = false;
    }
  }

  List<AIModel> get filteredModels {
    return models.where((model) {
      if (offlineOnly.value && !model.isDownloaded!.value) return false;
      if (searchQuery.isEmpty) return true;
      return model.name!.toLowerCase().contains(searchQuery.toLowerCase()) ||
          model.description!.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList()
      ..sort((a, b) {
        switch (sortBy.value) {
          case 'name':
            return a.name!.compareTo(b.name!);
          case 'size':
            return a.size!.compareTo(b.size!);
          case 'type':
            return a.type!.compareTo(b.type!);
          default:
            return 0;
        }
      });
  }
  //
  // Future<void> downloadModel(AIModel model) async {
  //   try {
  //     await _downloadService.downloadModel(
  //       url: model.downloadUrl!.value,
  //       filename: model.filename!,
  //       onProgress: (progress) {
  //         model.progress!.value = progress;
  //       },
  //       onComplete: (path) async {
  //         model.isDownloaded!.value = true;
  //         model.progress!.value = 1.0;
  //         await _dbService.saveModel(model);
  //         CustomSnackBar.showSuccessSnackbar(message: '${model.name} downloaded successfully');
  //       },
  //       onError: (error) {
  //         DevLogs.logError('Error Failed to download ${model.name}: $error');
  //         CustomSnackBar.showErrorSnackbar(message: 'Failed to download ${model.name}: $error');
  //       },
  //     );
  //   } catch (e) {
  //     DevLogs.logError('Error Failed to initiate download: $e');
  //     CustomSnackBar.showErrorSnackbar(message: 'Failed to initiate download: $e');
  //   }
  // }
  //
  // Future<void> deleteModel(AIModel model) async {
  //   try {
  //     // Delete the model's file if it exists
  //     final path = await _downloadService.getDownloadPath(model.filename!);
  //     final file = File(path);
  //     if (await file.exists()) {
  //       await file.delete();
  //     }
  //
  //     // Delete the model's record from the database
  //     await _dbService.deleteModel(model);
  //
  //     // Update the model state to reflect the deletion
  //     model.isDownloaded!.value = false;
  //     model.progress!.value = 0.0;
  //
  //     // Optionally, reload the models from the database to update the UI
  //     await loadModels();
  //
  //     CustomSnackBar.showSuccessSnackbar(message: '${model.name} deleted successfully');
  //   } catch (e) {
  //     DevLogs.logError('Error Failed to delete ${model.name}: $e');
  //     CustomSnackBar.showErrorSnackbar(message: 'Failed to delete ${model.name}: $e');
  //   }
  // }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  void setSortBy(String sort) {
    sortBy.value = sort;
  }

  void toggleOfflineOnly() {
    offlineOnly.value = !offlineOnly.value;
  }
}
