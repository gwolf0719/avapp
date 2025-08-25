import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/models/video_list_item.dart';
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
    final isLandscape = screenSize.width > screenSize.height;
    
    // 自適應對話框尺寸
    final dialogWidth = isTV 
        ? screenSize.width * 0.6 
        : (isLandscape ? screenSize.width * 0.7 : screenSize.width * 0.85);
    final maxDialogHeight = screenSize.height * 0.8; // 減少最大高度
    
    final videoDetailAsync = ref.watch(cachedVideoDetailProvider(widget.video.videoId));

    return Dialog(
      backgroundColor: Colors.transparent,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: dialogWidth,
          maxHeight: maxDialogHeight,
        ),
        child: Container(
          width: dialogWidth,
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
            mainAxisSize: MainAxisSize.min,
            children: [
              // 圖片區域
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
              
              // 標題和按鈕區域
              Container(
                padding: EdgeInsets.all(isTV ? 20.0 : 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 標題
                    Text(
                      widget.video.title,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 12.0),
                    
                    // 按鈕區域
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('關閉'),
                        ),
                        const SizedBox(width: 12.0),
                        
                        // 播放按鈕 - 根據載入狀態顯示不同內容
                        videoDetailAsync.when(
                          loading: () => ElevatedButton.icon(
                            onPressed: null, // 載入中不可點擊
                            icon: const SizedBox(
                              width: 16.0,
                              height: 16.0,
                              child: CircularProgressIndicator(strokeWidth: 2.0),
                            ),
                            label: const Text('載入中...'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                              foregroundColor: Colors.white,
                            ),
                          ),
                          error: (error, stack) => ElevatedButton.icon(
                            onPressed: null, // 錯誤時不可點擊
                            icon: const Icon(Icons.error),
                            label: const Text('載入失敗'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                          ),
                          data: (detail) => ElevatedButton.icon(
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
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
