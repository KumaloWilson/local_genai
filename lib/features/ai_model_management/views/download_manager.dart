import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../controllers/download_manager.dart';
import '../models/ai_model.dart';
class DownloadsManager extends StatefulWidget {

  const DownloadsManager({super.key});

  @override
  State<DownloadsManager> createState() => _DownloadsManagerState();
}

class _DownloadsManagerState extends State<DownloadsManager> {
  final DownloadController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Downloads',
              style: Theme.of(context).textTheme.headlineSmall,
            ).animate()
                .fadeIn(duration: 600.ms)
                .slideX(begin: -0.2, end: 0),
          ),
          if (_controller.downloads.isEmpty)
            _buildEmptyState()
          else
            _buildDownloadsList(),
        ],
      ),
    ));
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.download_done_rounded,
            size: 64,
            color: Colors.grey[400],
          ).animate()
              .scale(duration: 600.ms, curve: Curves.elasticOut)
              .fadeIn(),
          const SizedBox(height: 16),
          Text(
            'No active downloads',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ).animate()
              .fadeIn(delay: 200.ms)
              .slideY(begin: 0.2, end: 0),
        ],
      ),
    );
  }

  Widget _buildDownloadsList() {
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.all(8),
      itemCount: _controller.downloads.length,
      itemBuilder: (context, index) {
        final model = _controller.downloads[index];
        return _buildDownloadCard(model)
            .animate()
            .fadeIn(delay: (100 * index).ms)
            .slideX(begin: 0.2, end: 0);
      },
    );
  }

  Widget _buildDownloadCard(AIModel model) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      _buildDownloadInfo(model),
                    ],
                  ),
                ),
                _buildActionButtons(model),
              ],
            ),
            const SizedBox(height: 8),
            _buildProgressIndicator(model),
          ],
        ),
      ),
    );
  }

  Widget _buildDownloadInfo(AIModel model) {
    return Obx(() {
      final progress = _controller.downloadProgress[model.id] ?? 0.0;
      final speed = _controller.downloadSpeed[model.id];
      final timeRemaining = _controller.timeRemaining[model.id];

      return Row(
        children: [
          Text(
            '${(progress * 100).toStringAsFixed(1)}%',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          if (speed != null) ...[
            const SizedBox(width: 8),
            Text(
              '${(speed / 1024 / 1024).toStringAsFixed(1)} MB/s',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
          if (timeRemaining != null) ...[
            const SizedBox(width: 8),
            Text(
              '${timeRemaining.inMinutes}m remaining',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ],
      ).animate()
          .fadeIn()
          .slide();
    });
  }

  Widget _buildActionButtons(AIModel model) {
    return Obx(() {
      final isActive = _controller.activeDownloads[model.id] ?? false;

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isActive)
            IconButton(
              icon: const Icon(Icons.pause_rounded),
              onPressed: () => _controller.pauseDownload(model),
            ).animate()
                .scale(duration: 200.ms)
          else
            IconButton(
              icon: const Icon(Icons.play_arrow_rounded),
              onPressed: () => _controller.resumeDownload(model),
            ).animate()
                .scale(duration: 200.ms),
          IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () => _controller.cancelDownload(model.id),
          ).animate()
              .scale(duration: 200.ms),
        ],
      );
    });
  }

  Widget _buildProgressIndicator(AIModel model) {
    return Obx(() {
      final progress = _controller.downloadProgress[model.id] ?? 0.0;

      return Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              minHeight: 8,
            ),
          ).animate()
              .scale(
            duration: 600.ms,
            curve: Curves.elasticOut,
            alignment: Alignment.centerLeft,
          ),
          if (progress > 0)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  ),
                  minHeight: 8,
                ),
              ),
            ).animate(
              onPlay: (controller) => controller.repeat(),
            )
                .shimmer(
              duration: 1500.ms,
              color: Colors.white.withOpacity(0.5),
            ),
        ],
      );
    });
  }
}