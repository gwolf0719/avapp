import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FocusHelper {
  static bool isTVMode(BuildContext context) {
    return MediaQuery.of(context).size.width > 1000;
  }

  static void requestFocus(FocusNode focusNode) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });
  }

  static Widget buildFocusableItem({
    required Widget child,
    required FocusNode focusNode,
    required VoidCallback onTap,
    VoidCallback? onEnter,
    bool autofocus = false,
  }) {
    return Focus(
      focusNode: focusNode,
      autofocus: autofocus,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.select ||
              event.logicalKey == LogicalKeyboardKey.enter ||
              event.logicalKey == LogicalKeyboardKey.space) {
            if (onEnter != null) {
              onEnter();
            } else {
              onTap();
            }
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: GestureDetector(
        onTap: onTap,
        child: child,
      ),
    );
  }

  // TV 遙控器按鍵支援
  static Widget buildTVRemoteControl({
    required Widget child,
    required FocusNode focusNode,
    required VoidCallback onSelect,
    VoidCallback? onBack,
    VoidCallback? onUp,
    VoidCallback? onDown,
    VoidCallback? onLeft,
    VoidCallback? onRight,
    VoidCallback? onPlayPause,
    VoidCallback? onStop,
    VoidCallback? onFastForward,
    VoidCallback? onRewind,
    bool autofocus = false,
  }) {
    return Focus(
      focusNode: focusNode,
      autofocus: autofocus,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          switch (event.logicalKey) {
            case LogicalKeyboardKey.select:
            case LogicalKeyboardKey.enter:
            case LogicalKeyboardKey.space:
              onSelect();
              return KeyEventResult.handled;
            case LogicalKeyboardKey.goBack:
            case LogicalKeyboardKey.escape:
              onBack?.call();
              return KeyEventResult.handled;
            case LogicalKeyboardKey.arrowUp:
              onUp?.call();
              return KeyEventResult.handled;
            case LogicalKeyboardKey.arrowDown:
              onDown?.call();
              return KeyEventResult.handled;
            case LogicalKeyboardKey.arrowLeft:
              onLeft?.call();
              return KeyEventResult.handled;
            case LogicalKeyboardKey.arrowRight:
              onRight?.call();
              return KeyEventResult.handled;
            case LogicalKeyboardKey.mediaPlay:
            case LogicalKeyboardKey.mediaPlayPause:
              onPlayPause?.call();
              return KeyEventResult.handled;
            case LogicalKeyboardKey.mediaStop:
              onStop?.call();
              return KeyEventResult.handled;
            case LogicalKeyboardKey.mediaFastForward:
              onFastForward?.call();
              return KeyEventResult.handled;
            case LogicalKeyboardKey.mediaRewind:
              onRewind?.call();
              return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: child,
    );
  }
}

class GridFocusManager {
  final int columnCount;
  final List<FocusNode> focusNodes;
  
  GridFocusManager({required this.columnCount, required int itemCount})
      : focusNodes = List.generate(itemCount, (index) => FocusNode());

  void dispose() {
    for (final node in focusNodes) {
      node.dispose();
    }
  }

  FocusNode getFocusNode(int index) {
    if (index >= 0 && index < focusNodes.length) {
      return focusNodes[index];
    }
    return FocusNode(); // Fallback
  }

  void focusAt(int index) {
    if (index >= 0 && index < focusNodes.length) {
      FocusHelper.requestFocus(focusNodes[index]);
    }
  }

  int? getUpIndex(int currentIndex) {
    final upIndex = currentIndex - columnCount;
    return upIndex >= 0 ? upIndex : null;
  }

  int? getDownIndex(int currentIndex, int totalItems) {
    final downIndex = currentIndex + columnCount;
    return downIndex < totalItems ? downIndex : null;
  }

  int? getLeftIndex(int currentIndex) {
    if (currentIndex % columnCount == 0) return null;
    return currentIndex - 1;
  }

  int? getRightIndex(int currentIndex, int totalItems) {
    if ((currentIndex + 1) % columnCount == 0) return null;
    final rightIndex = currentIndex + 1;
    return rightIndex < totalItems ? rightIndex : null;
  }

  // 處理 TV 遙控器方向鍵導航
  int? navigateWithTVRemote(int currentIndex, int totalItems, LogicalKeyboardKey key) {
    switch (key) {
      case LogicalKeyboardKey.arrowUp:
        return getUpIndex(currentIndex);
      case LogicalKeyboardKey.arrowDown:
        return getDownIndex(currentIndex, totalItems);
      case LogicalKeyboardKey.arrowLeft:
        return getLeftIndex(currentIndex);
      case LogicalKeyboardKey.arrowRight:
        return getRightIndex(currentIndex, totalItems);
      default:
        return null;
    }
  }
}
