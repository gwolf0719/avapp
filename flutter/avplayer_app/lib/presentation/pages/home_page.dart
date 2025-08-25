import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/video_list_provider.dart';
import '../widgets/video_item_card.dart';
import '../widgets/video_preview_dialog.dart';
import '../pages/player_page.dart';
import '../../data/models/video_list_item.dart';
import '../../core/utils/responsive_helper.dart';
import '../../core/utils/focus_helper.dart';
import '../../core/utils/navigation_manager.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final ScrollController _scrollController = ScrollController();
  int _focusedIndex = 0;
  GridFocusManager? _focusManager;
  final NavigationManager _navigationManager = NavigationManager();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    
    // Load initial videos when the page is first loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(videoListProvider.notifier).loadInitialVideos();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _focusManager?.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(videoListProvider.notifier).loadMoreVideos();
    }
  }

  void _updateFocusManager(int itemCount, int columnCount) {
    if (_focusManager?.focusNodes.length != itemCount) {
      _focusManager?.dispose();
      _focusManager = GridFocusManager(
        columnCount: columnCount,
        itemCount: itemCount,
      );
    }
  }

  void _onVideoTap(int index) {
    setState(() {
      _focusedIndex = index;
    });
    
    final videos = ref.read(videoListProvider.notifier).allVideos;
    if (index < videos.length) {
      final video = videos[index];
      _showVideoPreview(video);
    }
  }

  void _showVideoPreview(VideoListItem video) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => VideoPreviewDialog(
        video: video,
        onPlayPressed: () => _navigateToPlayer(video),
      ),
    );
  }

  void _navigateToPlayer(VideoListItem video) {
    // 添加導航記錄
    _navigationManager.addNavigation('/player');
    
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PlayerPage(video: video),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final videoListState = ref.watch(videoListProvider);
    final columnCount = ResponsiveHelper.getGridColumnCount(context);
    final padding = ResponsiveHelper.getGridPadding(context);
    final spacing = ResponsiveHelper.getGridSpacing(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 0, // 隱藏 AppBar
      ),
      body: videoListState.when(
        loading: () => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                '載入影片中...',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 80,
                  color: Colors.red[300],
                ),
                const SizedBox(height: 24),
                Text(
                  '載入失敗',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '無法載入影片列表，請檢查網路連線',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    ref.read(videoListProvider.notifier).refresh();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('重新載入'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
        data: (response) {
          if (response == null || response.videos.isEmpty) {
            return const Center(
              child: Text('無影片資料'),
            );
          }

          final videos = ref.watch(videoListProvider.notifier).allVideos;
          final hasMore = ref.watch(videoListProvider.notifier).hasNextPage;
          final isTV = ResponsiveHelper.isTV(context);

          // Update focus manager when video count changes
          _updateFocusManager(videos.length, columnCount);

          return RefreshIndicator(
            onRefresh: () async {
              await ref.read(videoListProvider.notifier).refresh();
            },
            child: Padding(
              padding: padding,
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.zero,
                itemCount: (videos.length / columnCount).ceil() + (hasMore ? 1 : 0),
                itemBuilder: (context, rowIndex) {
                  if (rowIndex == (videos.length / columnCount).ceil()) {
                    // Loading indicator for more items
                    return Container(
                      padding: const EdgeInsets.all(16.0),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 8.0),
                            Text(
                              '載入更多...',
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final startIndex = rowIndex * columnCount;
                  final endIndex = (startIndex + columnCount).clamp(0, videos.length);
                  final rowVideos = videos.sublist(startIndex, endIndex);

                  return Padding(
                    padding: EdgeInsets.only(bottom: spacing),
                    child: Row(
                      children: [
                        for (int i = 0; i < columnCount; i++)
                          Expanded(
                            child: i < rowVideos.length
                                ? Padding(
                                    padding: EdgeInsets.only(
                                      right: i < columnCount - 1 ? spacing : 0,
                                    ),
                                    child: VideoItemCard(
                                      video: rowVideos[i],
                                      isFocused: _focusedIndex == startIndex + i,
                                      focusNode: isTV ? _focusManager?.getFocusNode(startIndex + i) : null,
                                      autofocus: isTV && startIndex + i == 0,
                                      onTap: () => _onVideoTap(startIndex + i),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
