import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:local_gen_ai/features/ai_model_management/controllers/ai_model_controller.dart';
import 'package:local_gen_ai/features/ai_model_management/models/ai_model.dart';
import 'package:local_gen_ai/widgets/custom_button/general_button.dart';

import '../../features/ai_model_management/controllers/download_manager.dart';

class AIModelCard extends StatefulWidget {
  final AIModel model;
  const AIModelCard({super.key, required this.model,});

  @override
  State<AIModelCard> createState() => _AIModelCardState();
}

class _AIModelCardState extends State<AIModelCard> {
  final DownloadManager _downloadManager = Get.find<DownloadManager>();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {}, // Add your onTap handler here
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Model Icon with Animation
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Obx(() {
                          if (widget.model.progress.value > 0 && widget.model.progress.value < 1) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${(widget.model.progress.value * 100).toInt()}%',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                CircularProgressIndicator(
                                  value: widget.model.progress.value,
                                  strokeWidth: 2,
                                  backgroundColor: Colors.grey.shade200,
                                ),
                              ],
                            );
                          }
                          return Icon(
                            Icons.smart_toy,
                            size: 32,
                            color: widget.model.isDownloaded.value ? Colors.blue : Colors.grey.shade400,
                          ).animate(
                            onPlay: (controller) => controller.repeat(),
                          ).rotate(
                            duration: 2000.ms,
                            begin: 0,
                            end: 0.1,
                          );
                        }),
                      ],
                    )
                  ),
                  const SizedBox(width: 16),
                  // Model Info
                  Expanded(
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
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Model Stats
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStat(
                      'Type',
                      widget.model.type,
                      Icons.category_outlined,
                    ),
                    _buildStat(
                      'Size',
                      '${(widget.model.size / 1024 / 1024).toStringAsFixed(2)} MB',
                      Icons.data_usage_outlined,
                    ),
                    _buildStat(
                      'Parameters',
                      '${(widget.model.params / 1000000000).toStringAsFixed(1)}B',
                      Icons.memory_outlined,
                    ),
                  ],
                ),
              ),
              const Divider(),
              Obx(() => widget.model.isDownloaded.value
                  ? const Row(
                children: [
                  Expanded(
                    child: GeneralButton(
                      btnColor: Colors.transparent,
                      child: Row(
                        children: [
                          Icon(
                              Icons.install_mobile
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                              'Select'
                          )
                        ],
                      )
                    ),
                  ),

                  Expanded(
                    child: GeneralButton(
                        btnColor: Colors.transparent,
                        child: Row(
                          children: [
                            Icon(
                                Icons.delete,
                              color: Colors.redAccent,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                                'Delete',
                              style: TextStyle(
                                color: Colors.redAccent
                              ),
                            )
                          ],
                        )
                    ),
                  )
                ],
              )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GeneralButton(
                          onTap: (){
                            if (_downloadManager.isDownloading(widget.model.id)) {
                              _downloadManager.cancelDownload(widget.model);
                            } else {
                              _downloadManager.startDownload(widget.model);
                            }
                          },
                          btnColor: Colors.transparent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _downloadManager.isDownloading(widget.model.id)
                                    ? Icons.stop
                                    : Icons.download,
                                color: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _downloadManager.isDownloading(widget.model.id)
                                    ? 'Cancel'
                                    : 'Download',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor
                                ),
                              )
                            ],
                          )
                      )
                    ],
                  ),
              ),
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

  Widget _buildStat(String label, String value, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade600),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}