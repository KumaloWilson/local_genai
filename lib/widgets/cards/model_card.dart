import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';

import '../../features/ai_model_management/controllers/download_manager.dart';
import '../../features/ai_model_management/models/ai_model.dart';
import '../custom_button/general_button.dart';
import '../stat_item/stat_item.dart';


class AIModelCard extends StatefulWidget {
  final AIModel model;
  final Function()? onSelect;

  const AIModelCard({
    super.key,
    required this.model,
    this.onSelect,
  });

  @override
  State<AIModelCard> createState() => _AIModelCardState();
}

class _AIModelCardState extends State<AIModelCard> {
  final DownloadController _downloadManager = Get.find<DownloadController>();

  void _handleDownloadTap() {
    if (_downloadManager.isDownloading(widget.model)) {
      _downloadManager.cancelDownload(widget.model.id);
    } else {
      _downloadManager.startDownload(widget.model);
    }
  }

  void _handleDeleteTap() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Model'),
        content: Text('Are you sure you want to delete ${widget.model.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {

            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildModelIcon() {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
          Icons.smart_toy,
          size: 32,
          color: widget.model.isDownloaded.value
              ? Theme.of(context).primaryColor
              : Colors.grey.shade400,
        ).animate(
          onPlay: (controller) => controller.repeat(),
        ).rotate(
          duration: 2000.ms,
          begin: 0,
          end: 0.1,
       ),
    );
  }

  Widget _buildModelInfo() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.model.name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'By ${widget.model.author}',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildModelStats() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          StatItem(
            title: 'Type',
            value: widget.model.type,
            icon: Icons.category_outlined,
          ),
          StatItem(
            title: 'Size',
            value: '${(widget.model.size / 1024 / 1024).toStringAsFixed(2)} MB',
            icon: Icons.data_usage_outlined,
          ),
          StatItem(
            title: 'Parameters',
            value: '${(widget.model.params / 1000000000).toStringAsFixed(1)}B',
            icon: Icons.memory_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Obx(() => widget.model.isDownloaded.value
        ? Row(
      children: [
        Expanded(
          child: GeneralButton(
              onTap: widget.onSelect,
              btnColor: Colors.transparent,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.install_mobile),
                  SizedBox(width: 8),
                  Text('Select')
                ],
              )
          ),
        ),
        Expanded(
          child: GeneralButton(
              onTap: _handleDeleteTap,
              btnColor: Colors.transparent,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.delete,
                    color: Colors.redAccent,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Delete',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              )
          ),
        )
      ],
    )
        : Column(
          children: [
            Obx(() {
              final progress = widget.model.progress.value;
              final speed = _downloadManager.getDownloadSpeed(widget.model.id);
              if (progress > 0 && progress < 1) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Expanded(
                          child: SimpleAnimationProgressBar(
                            height: 10,
                            width: Get.width * 0.8,
                            backgroundColor: Theme.of(context).canvasColor,
                            foregrondColor: Theme.of(context).primaryColor,
                            ratio: progress,
                            direction: Axis.horizontal,
                            curve: Curves.fastLinearToSlowEaseIn,
                            duration: const Duration(seconds: 3),
                            borderRadius: BorderRadius.circular(10),
                            gradientColor: LinearGradient(
                                colors: [Theme.of(context).primaryColor.withGreen(9), Theme.of(context).primaryColor]),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).primaryColor,
                                offset: const Offset(
                                  1.0,
                                  1.0,
                                ),
                                blurRadius: 2.0,
                                spreadRadius: 2.0,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          '${speed}M/s'
                        )
                      ],
                    )
                  ],
                );
              }
              return Container();
            }),

            Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
            GeneralButton(
                onTap: _handleDownloadTap,
                btnColor: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _downloadManager.isDownloading(widget.model)
                          ? Icons.stop
                          : Icons.download,
                      color: _downloadManager.isDownloading(widget.model)
                          ? Colors.redAccent
                          : Theme.of(context).primaryColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _downloadManager.isDownloading(widget.model)
                          ? 'Cancel'
                          : 'Download',
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                )
            )
                  ],
                ),
          ],
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: widget.model.isDownloaded.value ? widget.onSelect : null,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildModelIcon(),
                  const SizedBox(width: 16),
                  _buildModelInfo(),
                ],
              ),
              const SizedBox(height: 12),
              _buildModelStats(),
              const Divider(height: 24),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    ).animate()
        .fadeIn(duration: 400.ms)
        .slideX(begin: 0.2, end: 0)
        .then()
        .shimmer(duration: 1000.ms);
  }
}