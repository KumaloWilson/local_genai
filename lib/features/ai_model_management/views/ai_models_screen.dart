import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../models/ai_model.dart';

class AIModelScreen extends StatefulWidget {
  const AIModelScreen({super.key});

  @override
  State<AIModelScreen> createState() => _AIModelScreenState();
}

class _AIModelScreenState extends State<AIModelScreen> {
  final List<AIModel> models = List.generate(
    10,
        (i) => AIModel(
      name: "Model ${i + 1}",
      version: "1.${i}",
      size: "${(i + 1) * 100}MB",
      isDownloaded: i < 3,
    ),
  );

  bool _isSearching = false;
  String _searchQuery = "";
  String _sortBy = "name";
  bool _offlineOnly = false;

  void _showDownloadProgress(String modelName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            const SizedBox(width: 16),
            Text('Downloading $modelName...'),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildModelCard(AIModel model) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

    child: ListTile(
        leading: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.smart_toy,
              size: 40,
              color: model.isDownloaded ? Colors.blue : Colors.grey,
            ).animate(
              onPlay: (controller) => controller.repeat(),
            ).rotate(
              duration: 2.seconds,
              begin: 0,
              end: 0.1,
            ),
            if (model.downloadProgress != null)
              CircularProgressIndicator(
                value: model.downloadProgress,
                strokeWidth: 2,
              ),
          ],
        ),
        title: Text(
          model.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Version: ${model.version}"),
            Text("Size: ${model.size}"),
            Text(
              model.isDownloaded ? "Status: Downloaded" : "Status: Available",
              style: TextStyle(
                color: model.isDownloaded ? Colors.green : Colors.grey,
              ),
            ),
          ],
        ),
        trailing: model.isDownloaded
            ? PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) {
            // Handle actions
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'active',
              child: Text('Set as Active'),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Text('Delete'),
            ),
          ],
        )
            : IconButton(
          icon: const Icon(Icons.download),
          onPressed: () {
            _showDownloadProgress(model.name);
            // Implement download logic
          },
        ),
      ).animate()
        .fadeIn(duration: 400.ms)
        .slideX(begin: 0.2, end: 0)
        .then()
        .shimmer(duration: 1.seconds)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search models...',
            border: InputBorder.none,
          ),
          onChanged: (value) => setState(() => _searchQuery = value),
        )
            : const Text("AI Models"),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () => setState(() => _isSearching = !_isSearching),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              setState(() {
                if (value == 'offline') {
                  _offlineOnly = !_offlineOnly;
                } else {
                  _sortBy = value;
                }
              });
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
                    if (_offlineOnly) const Icon(Icons.check),
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
            child: ListView.builder(
              itemCount: models.length,
              itemBuilder: (context, index) => _buildModelCard(models[index]),
            ),
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
                onPressed: () {
                  // Implement file picker
                },
              ).animate()
                  .fadeIn(delay: 200.ms)
                  .slideY(begin: 0.2, end: 0),
            ),
          ),
        ],
      ),
    );
  }
}