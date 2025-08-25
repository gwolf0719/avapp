import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/video_list_provider.dart';
import '../widgets/video_item_card.dart';
import '../widgets/video_preview_dialog.dart';
import '../pages/player_page.dart';
import '../../data/models/video_list_item.dart';
import '../../core/utils/responsive_helper.dart';
import '../../core/utils/focus_helper.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final ScrollController _scrollController = ScrollController();
  int _focusedIndex = 0;
  GridFocusManager? _focusManager;

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
        title: const Text('影片列表'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(videoListProvider.notifier).refresh();
            },
          ),
        ],
      ),
      body: videoListState.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error,
                size: 64,
                color: Colors.red[300],
              ),
              const SizedBox(height: 16),
              Text(
                '載入失敗',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.read(videoListProvider.notifier).refresh();
                },
                child: const Text('重試'),
              ),
            ],
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
              child: GridView.builder(
                controller: _scrollController,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columnCount,
                  crossAxisSpacing: spacing,
                  mainAxisSpacing: spacing,
                  childAspectRatio: ResponsiveHelper.getGridItemAspectRatio(context),
                ),
                itemCount: videos.length + (hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == videos.length) {
                    // Loading indicator for more items
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final video = videos[index];
                  return VideoItemCard(
                    video: video,
                    isFocused: _focusedIndex == index,
                    focusNode: isTV ? _focusManager?.getFocusNode(index) : null,
                    autofocus: isTV && index == 0,
                    onTap: () => _onVideoTap(index),
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
