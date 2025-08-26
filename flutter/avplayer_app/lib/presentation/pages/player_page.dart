import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import '../../data/models/video_list_item.dart';
import '../../data/models/video_detail.dart';
import '../providers/video_detail_provider.dart';
import '../providers/actor_videos_provider.dart';
import '../../core/utils/responsive_helper.dart';
import '../../core/utils/orientation_helper.dart';
import '../widgets/video_preview_dialog.dart';
import '../../core/utils/navigation_manager.dart';

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
  bool _showPauseControls = false; // 控制是否顯示暫停按鈕
  bool _userPaused = false; // 用戶主動暫停標記
  
  // 音量控制
  double _volume = 1.0;
  static const double _volumeStep = 0.1;
  
  // 快進/快退控制
  static const Duration _seekStep = Duration(seconds: 10);
  static const Duration _fastSeekStep = Duration(seconds: 30);
  
  // 推薦影片選擇
  int _selectedRecommendationIndex = 0;
  List<VideoListItem> _recommendations = [];
  final NavigationManager _navigationManager = NavigationManager();
  
  // 方向控制提示
  Timer? _orientationHintTimer;

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
    _orientationHintTimer?.cancel();
    super.dispose();
  }

  // TV 遙控器播放控制方法
  void _togglePlayPause() {
    if (_videoPlayerController != null) {
      if (_videoPlayerController!.value.isPlaying) {
        _videoPlayerController!.pause();
        setState(() {
          _isPaused = true;
          _userPaused = true; // 標記為用戶主動暫停
          _showPauseControls = true; // 顯示暫停按鈕
        });
      } else {
        _videoPlayerController!.play();
        setState(() {
          _isPaused = false;
          _userPaused = false; // 清除用戶暫停標記
          _showPauseControls = false; // 隱藏暫停按鈕
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
      _triggerOrientationHint();
    }
  }

  void _decreaseVolume() {
    if (_videoPlayerController != null) {
      _volume = (_volume - _volumeStep).clamp(0.0, 1.0);
      _videoPlayerController!.setVolume(_volume);
      setState(() {});
      _triggerOrientationHint();
    }
  }

  // 快進/快退控制
  void _seekForward() {
    if (_videoPlayerController != null) {
      final currentPosition = _videoPlayerController!.value.position;
      final newPosition = currentPosition + _seekStep;
      _videoPlayerController!.seekTo(newPosition);
      _triggerOrientationHint();
    }
  }

  void _seekBackward() {
    if (_videoPlayerController != null) {
      final currentPosition = _videoPlayerController!.value.position;
      final newPosition = currentPosition - _seekStep;
      _videoPlayerController!.seekTo(newPosition);
      _triggerOrientationHint();
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

  // 顯示方向控制提示
  void _triggerOrientationHint() {
    // 暫時只是取消之前的計時器，稍後可以加入視覺提示
    _orientationHintTimer?.cancel();
    _orientationHintTimer = Timer(const Duration(seconds: 2), () {
      // 可以在這裡加入隱藏提示的邏輯
    });
  }

  // 選擇推薦影片
  void _selectRecommendation() {
    if (_isPaused && _recommendations.isNotEmpty && _selectedRecommendationIndex < _recommendations.length) {
      final selectedVideo = _recommendations[_selectedRecommendationIndex];
      _showVideoPreviewDialog(selectedVideo);
    }
  }

  // 顯示影片預覽對話框
  void _showVideoPreviewDialog(VideoListItem video) {
    // 添加導航記錄（推薦影片選擇）
    _navigationManager.addNavigation('/player/recommendation');
    
    showDialog(
      context: context,
      builder: (context) => VideoPreviewDialog(
        video: video,
        onPlayPressed: () {
          Navigator.of(context).pop(); // 關閉對話框
          // 移除推薦影片導航記錄，因為要替換當前播放器
          _navigationManager.removeLastNavigation();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => PlayerPage(video: video),
            ),
          );
        },
      ),
    );
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
              // 只有在用戶主動暫停時才顯示控制項
              if (!_userPaused && _isPaused) {
                _showPauseControls = false;
              }
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
          showControlsOnInitialize: false, // 不顯示預設控制項
          showOptions: false, // 隱藏選項按鈕
          showControls: false, // 隱藏預設控制項
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
      body: SizedBox.expand(
        child: Focus(
          autofocus: true,
          onKeyEvent: (node, event) {
            if (event is KeyDownEvent) {
              switch (event.logicalKey) {
                // 導航控制
                case LogicalKeyboardKey.goBack:
                case LogicalKeyboardKey.escape:
                  // 移除當前頁面的導航記錄
                  _navigationManager.removeLastNavigation();
                  Navigator.of(context).pop();
                  return KeyEventResult.handled;
                
                // 播放/暫停控制（與點擊畫面共通）
                case LogicalKeyboardKey.select:
                case LogicalKeyboardKey.enter:
                case LogicalKeyboardKey.space:
                case LogicalKeyboardKey.mediaPlay:
                case LogicalKeyboardKey.mediaPlayPause:
                  if (_isPaused && _recommendations.isNotEmpty) {
                    _selectRecommendation();
                  } else {
                    _togglePlayPause();
                  }
                  return KeyEventResult.handled;
                
                // 音量控制
                case LogicalKeyboardKey.arrowUp:
                  _increaseVolume();
                  return KeyEventResult.handled;
                case LogicalKeyboardKey.arrowDown:
                  _decreaseVolume();
                  return KeyEventResult.handled;
                
                // 快進/快退控制（播放時）或推薦影片選擇（暫停時）
                case LogicalKeyboardKey.arrowRight:
                  if (_isPaused && _recommendations.isNotEmpty) {
                    // 只更新選擇索引，不觸發暫停狀態
                    setState(() {
                      _selectedRecommendationIndex = (_selectedRecommendationIndex + 1) % _recommendations.length;
                    });
                  } else {
                    _seekForward();
                  }
                  return KeyEventResult.handled;
                case LogicalKeyboardKey.arrowLeft:
                  if (_isPaused && _recommendations.isNotEmpty) {
                    // 只更新選擇索引，不觸發暫停狀態
                    setState(() {
                      _selectedRecommendationIndex = (_selectedRecommendationIndex - 1 + _recommendations.length) % _recommendations.length;
                    });
                  } else {
                    _seekBackward();
                  }
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
                              ? GestureDetector(
                                  onTap: () {
                                    // 直接進入暫停狀態並顯示推薦影片
                                    if (!_isPaused) {
                                      _videoPlayerController!.pause();
                                      setState(() {
                                        _isPaused = true;
                                        _userPaused = true; // 標記為用戶主動暫停
                                        _showPauseControls = true; // 顯示暫停按鈕
                                      });
                                    }
                                  },
                                  onPanUpdate: (details) {
                                    // 智能方向控制：根據螢幕方向適配手勢
                                    final action = OrientationHelper.getGestureAction(
                                      context,
                                      details.delta.dx,
                                      details.delta.dy,
                                    );
                                    
                                    // 執行對應的動作
                                    switch (action) {
                                      case GestureAction.increaseVolume:
                                        _increaseVolume();
                                        break;
                                      case GestureAction.decreaseVolume:
                                        _decreaseVolume();
                                        break;
                                      case GestureAction.seekForward:
                                        _seekForward();
                                        break;
                                      case GestureAction.seekBackward:
                                        _seekBackward();
                                        break;
                                    }
                                  },
                                  child: Chewie(controller: _chewieController!),
                                )
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
                        

                        
                        // 暫停時的控制介面
                        if (_isPaused && _showPauseControls)
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
                        if (_isPaused && _userPaused && _videoDetail != null)
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
                                    child: _videoDetail?.actorUrl != null
                                        ? _ActorRecommendations(
                                            actorUrl: _videoDetail!.actorUrl!,
                                            currentVideoId: widget.video.videoId,
                                            selectedIndex: _selectedRecommendationIndex,
                                            onRecommendationsLoaded: (recommendations) {
                                              _recommendations = recommendations;
                                            },
                                            onVideoSelected: _showVideoPreviewDialog,
                                          )
                                        : const Center(
                                            child: Text(
                                              '載入推薦影片中...',
                                              style: TextStyle(color: Colors.white70),
                                            ),
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

class _ActorRecommendations extends ConsumerStatefulWidget {
  final String actorUrl;
  final String currentVideoId;
  final int selectedIndex;
  final Function(List<VideoListItem>) onRecommendationsLoaded;
  final Function(VideoListItem) onVideoSelected;

  const _ActorRecommendations({
    required this.actorUrl,
    required this.currentVideoId,
    required this.selectedIndex,
    required this.onRecommendationsLoaded,
    required this.onVideoSelected,
  });

  @override
  ConsumerState<_ActorRecommendations> createState() => _ActorRecommendationsState();
}

class _ActorRecommendationsState extends ConsumerState<_ActorRecommendations> {
  final ScrollController _scrollController = ScrollController();
  List<VideoListItem> _videos = [];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // 自動滾動到選中的項目
  void _scrollToSelectedItem() {
    if (_videos.isEmpty || !_scrollController.hasClients) return;
    
    final itemWidth = 120.0 + 12.0; // 項目寬度 + 右邊距
    final containerWidth = _scrollController.position.viewportDimension;
    
    // 計算選中項目的位置
    final selectedItemOffset = widget.selectedIndex * itemWidth;
    
    // 計算目標滾動位置，讓選中項目居中
    final targetOffset = selectedItemOffset - (containerWidth / 2) + (itemWidth / 2);
    
    // 確保滾動位置在有效範圍內
    final maxOffset = _scrollController.position.maxScrollExtent;
    final clampedOffset = targetOffset.clamp(0.0, maxOffset);
    
    // 執行滾動動畫
    _scrollController.animateTo(
      clampedOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final actorVideosState = ref.watch(actorVideosProvider(widget.actorUrl));

    return actorVideosState.when(
      data: (actorVideos) {
        final filteredVideos = actorVideos.videos
            .where((video) => video.videoId != widget.currentVideoId)
            .take(10)
            .toList();

        // 更新本地影片列表
        if (_videos != filteredVideos) {
          _videos = filteredVideos;
          // 通知父組件推薦影片列表已載入
          WidgetsBinding.instance.addPostFrameCallback((_) {
            widget.onRecommendationsLoaded(filteredVideos);
          });
        }

        // 當選中索引改變時，自動滾動到選中項目
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_videos.isNotEmpty && widget.selectedIndex < _videos.length) {
            _scrollToSelectedItem();
          }
        });

        if (filteredVideos.isEmpty) {
          return const Center(
            child: Text(
              '暫無其他作品',
              style: TextStyle(color: Colors.white70),
            ),
          );
        }

        return ListView.builder(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: filteredVideos.length,
          itemBuilder: (context, index) {
            final video = filteredVideos[index];
            final isSelected = index == widget.selectedIndex;
            
            return Container(
              width: 120,
              margin: const EdgeInsets.only(right: 12),
              child: GestureDetector(
                onTap: () {
                  widget.onVideoSelected(video);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: isSelected 
                          ? Border.all(color: Colors.blue, width: 3)
                          : null,
                      ),
                      child: ClipRRect(
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
