import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import '../../data/models/video_list_item.dart';
import '../../data/models/video_detail.dart';
import '../providers/video_detail_provider.dart';
import '../providers/actor_videos_provider.dart';
import '../../core/utils/responsive_helper.dart';

class PlayerPage extends ConsumerStatefulWidget {
  final VideoListItem video;

  const PlayerPage({
    super.key,
    required this.video,
  });

  @override
  ConsumerState<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends ConsumerState<PlayerPage> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _isLoading = true;
  String? _errorMessage;
  VideoDetail? _videoDetail;
  final bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializePlayer();
    });
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  // TV 遙控器播放控制方法
  void _togglePlayPause() {
    if (_videoPlayerController != null) {
      if (_videoPlayerController!.value.isPlaying) {
        _videoPlayerController!.pause();
      } else {
        _videoPlayerController!.play();
      }
    }
  }

  void _stopVideo() {
    if (_videoPlayerController != null) {
      _videoPlayerController!.pause();
      _videoPlayerController!.seekTo(Duration.zero);
    }
  }

  void _fastForward() {
    if (_videoPlayerController != null) {
      final currentPosition = _videoPlayerController!.value.position;
      final newPosition = currentPosition + const Duration(seconds: 10);
      _videoPlayerController!.seekTo(newPosition);
    }
  }

  void _rewind() {
    if (_videoPlayerController != null) {
      final currentPosition = _videoPlayerController!.value.position;
      final newPosition = currentPosition - const Duration(seconds: 10);
      _videoPlayerController!.seekTo(newPosition);
    }
  }

  Future<void> _initializePlayer() async {
    try {
      // 獲取影片詳情和播放 URL
      final videoDetail = await ref.read(cachedVideoDetailProvider(widget.video.videoId).future);
      _videoDetail = videoDetail;
      
      if (videoDetail.playUrl != null && videoDetail.playUrl!.isNotEmpty) {
        _videoPlayerController = VideoPlayerController.networkUrl(
          Uri.parse(videoDetail.playUrl!),
        );

        await _videoPlayerController!.initialize();

        _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController!,
          autoPlay: true,
          looping: false,
          allowFullScreen: true,
          allowMuting: true,
          allowPlaybackSpeedChanging: true,
          showControlsOnInitialize: true,
          showOptions: false, // 隱藏選項按鈕
          showControls: true,
          errorBuilder: (context, errorMessage) {
            return Center(
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
                    '播放錯誤',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    errorMessage,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('返回'),
                  ),
                ],
              ),
            );
          },
        );

        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        throw Exception('無法獲取播放連結');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTV = ResponsiveHelper.isTV(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Focus(
          autofocus: true,
          onKeyEvent: (node, event) {
            if (event is KeyDownEvent) {
              switch (event.logicalKey) {
                case LogicalKeyboardKey.goBack:
                case LogicalKeyboardKey.escape:
                  Navigator.of(context).pop();
                  return KeyEventResult.handled;
                case LogicalKeyboardKey.mediaPlay:
                case LogicalKeyboardKey.mediaPlayPause:
                  _togglePlayPause();
                  return KeyEventResult.handled;
                case LogicalKeyboardKey.mediaStop:
                  _stopVideo();
                  return KeyEventResult.handled;
                case LogicalKeyboardKey.mediaFastForward:
                  _fastForward();
                  return KeyEventResult.handled;
                case LogicalKeyboardKey.mediaRewind:
                  _rewind();
                  return KeyEventResult.handled;
              }
            }
            return KeyEventResult.ignored;
          },
          child: _isLoading
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Colors.white),
                      SizedBox(height: 16),
                      Text(
                        '載入中...',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                )
              : _errorMessage != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error,
                            size: 64,
                            color: Colors.red[300],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            '播放失敗',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _errorMessage!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('返回'),
                          ),
                        ],
                      ),
                    )
                  : Stack(
                      children: [
                        // Video player
                        Center(
                          child: _chewieController != null
                              ? Chewie(controller: _chewieController!)
                              : const CircularProgressIndicator(),
                        ),
                        
                        // Custom controls overlay (if needed)
                        if (isTV)
                          Positioned(
                            top: 16,
                            left: 16,
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: 32,
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ),
                        
                        // 暫停時的推薦影片列表
                        if (_isPaused && _videoDetail?.actorUrl != null)
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 200,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withValues(alpha: 0.8),
                                    Colors.black.withValues(alpha: 0.9),
                                  ],
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      '${_videoDetail?.actor ?? '演員'} 的其他作品',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: _ActorRecommendations(
                                      actorUrl: _videoDetail!.actorUrl!,
                                      currentVideoId: widget.video.videoId,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
        ),
      ),
    );
  }
}

class _ActorRecommendations extends ConsumerWidget {
  final String actorUrl;
  final String currentVideoId;

  const _ActorRecommendations({
    required this.actorUrl,
    required this.currentVideoId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actorVideosState = ref.watch(actorVideosProvider(actorUrl));

    return actorVideosState.when(
      data: (actorVideos) {
        final filteredVideos = actorVideos.videos
            .where((video) => video.videoId != currentVideoId)
            .take(10)
            .toList();

        if (filteredVideos.isEmpty) {
          return const Center(
            child: Text(
              '暫無其他作品',
              style: TextStyle(color: Colors.white70),
            ),
          );
        }

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: filteredVideos.length,
          itemBuilder: (context, index) {
            final video = filteredVideos[index];
            return Container(
              width: 120,
              margin: const EdgeInsets.only(right: 12),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => PlayerPage(video: video),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Image.network(
                          video.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[800],
                              child: const Icon(
                                Icons.error,
                                color: Colors.white,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      video.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
      error: (error, stackTrace) => Center(
        child: Text(
          '載入失敗',
          style: TextStyle(color: Colors.red[300]),
        ),
      ),
    );
  }
}
