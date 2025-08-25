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
}
