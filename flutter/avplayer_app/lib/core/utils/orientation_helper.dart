import 'package:flutter/material.dart';

class OrientationHelper {
  /// 檢測當前螢幕方向
  static bool isLandscape(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return size.width > size.height;
  }

  /// 檢測是否為直式螢幕
  static bool isPortrait(BuildContext context) {
    return !isLandscape(context);
  }

  /// 根據螢幕方向獲取觸控手勢映射
  /// 直式：上下控制音量，左右控制播放進度
  /// 橫式：左右控制音量，上下控制播放進度
  static GestureMapping getGestureMapping(BuildContext context) {
    final isLandscapeMode = isLandscape(context);
    
    if (isLandscapeMode) {
      // 橫式模式：左右控制音量，上下控制播放進度
      return GestureMapping(
        volumeControl: GestureDirection.horizontal,
        progressControl: GestureDirection.vertical,
      );
    } else {
      // 直式模式：上下控制音量，左右控制播放進度
      return GestureMapping(
        volumeControl: GestureDirection.vertical,
        progressControl: GestureDirection.horizontal,
      );
    }
  }

  /// 根據螢幕方向和滑動方向判斷應該執行的動作
  static GestureAction getGestureAction(
    BuildContext context,
    double deltaX,
    double deltaY,
  ) {
    final mapping = getGestureMapping(context);
    final absDeltaX = deltaX.abs();
    final absDeltaY = deltaY.abs();
    
    // 判斷主要滑動方向
    if (absDeltaX > absDeltaY) {
      // 水平滑動為主
      if (mapping.volumeControl == GestureDirection.horizontal) {
        // 水平滑動控制音量
        return deltaX > 0 
            ? GestureAction.increaseVolume 
            : GestureAction.decreaseVolume;
      } else {
        // 水平滑動控制播放進度
        return deltaX > 0 
            ? GestureAction.seekForward 
            : GestureAction.seekBackward;
      }
    } else {
      // 垂直滑動為主
      if (mapping.volumeControl == GestureDirection.vertical) {
        // 垂直滑動控制音量
        return deltaY < 0 
            ? GestureAction.increaseVolume 
            : GestureAction.decreaseVolume;
      } else {
        // 垂直滑動控制播放進度
        return deltaY < 0 
            ? GestureAction.seekForward 
            : GestureAction.seekBackward;
      }
    }
  }
}

/// 手勢方向枚舉
enum GestureDirection {
  horizontal,
  vertical,
}

/// 手勢動作枚舉
enum GestureAction {
  increaseVolume,
  decreaseVolume,
  seekForward,
  seekBackward,
}

/// 手勢映射配置
class GestureMapping {
  final GestureDirection volumeControl;
  final GestureDirection progressControl;

  const GestureMapping({
    required this.volumeControl,
    required this.progressControl,
  });

  @override
  String toString() {
    return 'GestureMapping(volumeControl: $volumeControl, progressControl: $progressControl)';
  }
}
