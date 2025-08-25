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
  bool _isPaused = false;
  
  // 音量控制
  double _volume = 1.0;
  static const double _volumeStep = 0.1;
  
  // 快進/快退控制
  static const Duration _seekStep = Duration(seconds: 10);
  static const Duration _fastSeekStep = Duration(seconds: 30);

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
        setState(() {
          _isPaused = true;
        });
      } else {
        _videoPlayerController!.play();
        setState(() {
          _isPaused = false;
        });
      }
    }
  }

  void _stopVideo() {
    if (_videoPlayerController != null) {
      _videoPlayerController!.pause();
      _videoPlayerController!.seekTo(Duration.zero);
    }
  }

  // 音量控制
  void _increaseVolume() {
    if (_videoPlayerController != null) {
      _volume = (_volume + _volumeStep).clamp(0.0, 1.0);
      _videoPlayerController!.setVolume(_volume);
      setState(() {});
    }
  }

  void _decreaseVolume() {
    if (_videoPlayerController != null) {
      _volume = (_volume - _volumeStep).clamp(0.0, 1.0);
      _videoPlayerController!.setVolume(_volume);
      setState(() {});
    }
  }

  // 快進/快退控制
  void _seekForward() {
    if (_videoPlayerController != null) {
      final currentPosition = _videoPlayerController!.value.position;
      final newPosition = currentPosition + _seekStep;
      _videoPlayerController!.seekTo(newPosition);
    }
  }

  void _seekBackward() {
    if (_videoPlayerController != null) {
      final currentPosition = _videoPlayerController!.value.position;
      final newPosition = currentPosition - _seekStep;
      _videoPlayerController!.seekTo(newPosition);
    }
  }

  // 快速快進/快退（長按）
  void _fastSeekForward() {
    if (_videoPlayerController != null) {
      final currentPosition = _videoPlayerController!.value.position;
      final newPosition = currentPosition + _fastSeekStep;
      _videoPlayerController!.seekTo(newPosition);
    }
  }

  void _fastSeekBackward() {
    if (_videoPlayerController != null) {
      final currentPosition = _videoPlayerController!.value.position;
      final newPosition = currentPosition - _fastSeekStep;
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

        // 添加播放狀態監聽
        _videoPlayerController!.addListener(() {
          if (mounted) {
            setState(() {
              _isPaused = !_videoPlayerController!.value.isPlaying;
            });
          }
        });

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
                // 導航控制
                case LogicalKeyboardKey.goBack:
                case LogicalKeyboardKey.escape:
                  Navigator.of(context).pop();
                  return KeyEventResult.handled;
                
                // 播放/暫停控制
                case LogicalKeyboardKey.select:
                case LogicalKeyboardKey.enter:
                case LogicalKeyboardKey.space:
                case LogicalKeyboardKey.mediaPlay:
                case LogicalKeyboardKey.mediaPlayPause:
                  _togglePlayPause();
                  return KeyEventResult.handled;
                
                // 音量控制
                case LogicalKeyboardKey.arrowUp:
                  _decreaseVolume();
                  return KeyEventResult.handled;
                case LogicalKeyboardKey.arrowDown:
                  _increaseVolume();
                  return KeyEventResult.handled;
                
                // 快進/快退控制
                case LogicalKeyboardKey.arrowRight:
                  _seekBackward();
                  return KeyEventResult.handled;
                case LogicalKeyboardKey.arrowLeft:
                  _seekForward();
                  return KeyEventResult.handled;
                
                // 其他媒體控制
                case LogicalKeyboardKey.mediaStop:
                  _stopVideo();
                  return KeyEventResult.handled;
                case LogicalKeyboardKey.mediaFastForward:
                  _fastSeekForward();
                  return KeyEventResult.handled;
                case LogicalKeyboardKey.mediaRewind:
                  _fastSeekBackward();
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
                        // Video player - 滿版顯示
                        SizedBox.expand(
                          child: _chewieController != null
                              ? Chewie(controller: _chewieController!)
                              : const Center(child: CircularProgressIndicator()),
                        ),
                        
                        // 返回按鈕
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
                        
                        // 音量指示器
                        Positioned(
                          top: 16,
                          right: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.7),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _volume == 0 ? Icons.volume_off : 
                                  _volume < 0.5 ? Icons.volume_down : Icons.volume_up,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${(_volume * 100).round()}%',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        // 暫停時的控制介面
                        if (_isPaused)
                          Positioned.fill(
                            child: Container(
                              color: Colors.black.withValues(alpha: 0.3),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // 播放按鈕
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.9),
                                        shape: BoxShape.circle,
                                      ),
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.play_arrow,
                                          size: 40,
                                          color: Colors.black,
                                        ),
                                        onPressed: _togglePlayPause,
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    // 控制提示
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withValues(alpha: 0.7),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: const Text(
                                        '按 OK 鍵繼續播放',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
