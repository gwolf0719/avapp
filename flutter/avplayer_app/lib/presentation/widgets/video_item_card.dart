import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/models/video_list_item.dart';
import '../../core/utils/responsive_helper.dart';

class VideoItemCard extends StatefulWidget {
  final VideoListItem video;
  final VoidCallback onTap;
  final bool isFocused;
  final FocusNode? focusNode;
  final bool autofocus;

  const VideoItemCard({
    super.key,
    required this.video,
    required this.onTap,
    this.isFocused = false,
    this.focusNode,
    this.autofocus = false,
  });

  @override
  State<VideoItemCard> createState() => _VideoItemCardState();
}

class _VideoItemCardState extends State<VideoItemCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late FocusNode _internalFocusNode;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _internalFocusNode = widget.focusNode ?? FocusNode();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _internalFocusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (_internalFocusNode.hasFocus != _isHovered) {
      setState(() {
        _isHovered = _internalFocusNode.hasFocus;
      });
      if (_internalFocusNode.hasFocus) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _internalFocusNode.removeListener(_onFocusChange);
    if (widget.focusNode == null) {
      _internalFocusNode.dispose();
    }
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(VideoItemCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFocused != oldWidget.isFocused) {
      if (widget.isFocused) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTV = ResponsiveHelper.isTV(context);
    final isFocused = _isHovered || widget.isFocused;
    
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Focus(
            focusNode: _internalFocusNode,
            autofocus: widget.autofocus,
            onKeyEvent: (node, event) {
              if (event is KeyDownEvent) {
                if (event.logicalKey == LogicalKeyboardKey.select ||
                    event.logicalKey == LogicalKeyboardKey.enter ||
                    event.logicalKey == LogicalKeyboardKey.space) {
                  widget.onTap();
                  return KeyEventResult.handled;
                }
              }
              return KeyEventResult.ignored;
            },
            child: Card(
              elevation: isFocused ? 8.0 : 2.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                side: isFocused
                    ? BorderSide(color: Theme.of(context).primaryColor, width: 2.0)
                    : BorderSide.none,
              ),
              child: InkWell(
                onTap: widget.onTap,
                borderRadius: BorderRadius.circular(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 圖片區域：寬度適應 grid，高度根據圖片比例
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12.0),
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          // 使用 16:9 的標準影片比例
                          const double aspectRatio = 16 / 9;
                          final double imageHeight = constraints.maxWidth / aspectRatio;
                          
                          return SizedBox(
                            width: constraints.maxWidth,
                            height: imageHeight,
                            child: Stack(
                              children: [
                                CachedNetworkImage(
                                  imageUrl: widget.video.imageUrl,
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    color: Colors.grey[300],
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => Container(
                                    color: Colors.grey[300],
                                    child: const Icon(
                                      Icons.error,
                                      color: Colors.grey,
                                      size: 48.0,
                                    ),
                                  ),
                                ),
                                if (widget.video.duration != null)
                                  Positioned(
                                    bottom: 4.0,
                                    right: 4.0,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 4.0,
                                        vertical: 1.0,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withValues(alpha: 0.7),
                                        borderRadius: BorderRadius.circular(3.0),
                                      ),
                                      child: Text(
                                        widget.video.duration!,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    // 標題區域：高度由內容決定
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                      child: Text(
                        widget.video.title,
                        style: TextStyle(
                          fontSize: isTV ? 14.0 : 12.0,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}