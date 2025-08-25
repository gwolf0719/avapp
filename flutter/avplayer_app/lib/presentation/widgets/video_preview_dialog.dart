import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/models/video_list_item.dart';
import '../../data/models/video_detail.dart';
import '../providers/video_detail_provider.dart';
import '../../core/utils/responsive_helper.dart';

class VideoPreviewDialog extends ConsumerStatefulWidget {
  final VideoListItem video;
  final VoidCallback? onPlayPressed;

  const VideoPreviewDialog({
    super.key,
    required this.video,
    this.onPlayPressed,
  });

  @override
  ConsumerState<VideoPreviewDialog> createState() => _VideoPreviewDialogState();
}

class _VideoPreviewDialogState extends ConsumerState<VideoPreviewDialog> {
  @override
  void initState() {
    super.initState();
    // Pre-fetch video details when dialog opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cachedVideoDetailProvider(widget.video.videoId));
    });
  }

  @override
  Widget build(BuildContext context) {
    final isTV = ResponsiveHelper.isTV(context);
    final screenSize = MediaQuery.of(context).size;
    final dialogWidth = isTV ? screenSize.width * 0.7 : screenSize.width * 0.9;
    final dialogHeight = isTV ? screenSize.height * 0.8 : screenSize.height * 0.7;
    
    final videoDetailAsync = ref.watch(cachedVideoDetailProvider(widget.video.videoId));

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: dialogWidth,
        height: dialogHeight,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 20.0,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            // Large image preview
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16.0),
                ),
                child: CachedNetworkImage(
                  imageUrl: widget.video.imageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[800],
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[800],
                    child: const Icon(
                      Icons.error,
                      color: Colors.white,
                      size: 64.0,
                    ),
                  ),
                ),
              ),
            ),
            // Content area
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(isTV ? 24.0 : 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      widget.video.title,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8.0),
                    
                    // Video details
                    Expanded(
                      child: videoDetailAsync.when(
                        loading: () => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        error: (error, stack) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (widget.video.duration != null) ...[
                              _buildDetailRow(Icons.schedule, '時長: ${widget.video.duration}'),
                              const SizedBox(height: 4.0),
                            ],
                            Text(
                              '詳情載入失敗: ${error.toString()}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        data: (detail) => _buildDetailContent(detail),
                      ),
                    ),
                    
                    const SizedBox(height: 16.0),
                    
                    // Action buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('關閉'),
                        ),
                        const SizedBox(width: 12.0),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                            widget.onPlayPressed?.call();
                          },
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('開始播放'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailContent(VideoDetail detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (detail.description != null && detail.description!.isNotEmpty) ...[
          Text(
            detail.description!,
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8.0),
        ],
        if (detail.duration != null) ...[
          _buildDetailRow(Icons.schedule, '時長: ${detail.duration}'),
          const SizedBox(height: 4.0),
        ],
        if (detail.releaseDate != null) ...[
          _buildDetailRow(Icons.calendar_today, '發布: ${detail.releaseDate}'),
          const SizedBox(height: 4.0),
        ],
        if (detail.actor != null) ...[
          _buildDetailRow(Icons.person, '演員: ${detail.actor}'),
          const SizedBox(height: 4.0),
        ],
        if (detail.playUrl != null && detail.playUrl!.isNotEmpty) ...[
          _buildDetailRow(Icons.video_library, '已就緒'),
        ] else ...[
          _buildDetailRow(Icons.warning, '影片來源處理中...'),
        ],
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16.0,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
