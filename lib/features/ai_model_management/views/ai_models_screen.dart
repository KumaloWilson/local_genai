import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:local_gen_ai/widgets/cards/model_card.dart';
import '../controllers/ai_model_controller.dart';

class AIModelScreen extends StatefulWidget {
  const AIModelScreen({super.key});

  @override
  State<AIModelScreen> createState() => _AIModelScreenState();
}

class _AIModelScreenState extends State<AIModelScreen> {
  final AIModelController _controller = Get.find<AIModelController>();

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.model_training,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No AI Models Found',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Import a local model or check your search filters',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ).animate()
          .fadeIn(duration: 600.ms)
          .slideY(begin: 0.2, end: 0),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[300],
          ),
          const SizedBox(height: 16),
          Text(
            'Something went wrong',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: (){

            },
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ).animate()
          .fadeIn(duration: 600.ms)
          .slideY(begin: 0.2, end: 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => _controller.searchQuery.isEmpty
            ? const Text(
          'AI Models',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16
          ),
        )
            : TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search models...',
            border: InputBorder.none,
          ),
          onChanged: _controller.setSearchQuery,
        )),
        actions: [
          IconButton(
            icon: Obx(() => Icon(
                _controller.searchQuery.isEmpty ? Icons.search : Icons.close)),
            onPressed: () {
              if (_controller.searchQuery.isNotEmpty) {
                _controller.setSearchQuery('');
              } else {
                _controller.setSearchQuery(' ');
              }
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'offline') {
                _controller.toggleOfflineOnly();
              } else {
                _controller.setSortBy(value);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'name',
                child: Text('Sort by Name'),
              ),
              const PopupMenuItem(
                value: 'size',
                child: Text('Sort by Size'),
              ),
              PopupMenuItem(
                value: 'offline',
                child: Row(
                  children: [
                    const Text('Offline Only'),
                    const Spacer(),
                    Obx(() => _controller.offlineOnly.value
                        ? const Icon(Icons.check)
                        : Container()),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (_controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final models = _controller.models;

              if (models == null) {
                return _buildErrorState();
              }

              if (models.isEmpty) {
                return _buildEmptyState();
              }

              return ListView.builder(
                itemCount: models.length,
                itemBuilder: (context, index) {
                  final model = models[index];
                  return AIModelCard(
                    model: model,
                  );
                },
              );
            }),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.upload_file),
                label: const Text("Import Local Model"),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () async {
                  // Implement file picker logic here
                },
              ).animate()
                  .fadeIn(delay: 200.ms)
                  .slideY(begin: 0.2, end: 0),
            ),
          )
        ],
      ),
    );
  }
}