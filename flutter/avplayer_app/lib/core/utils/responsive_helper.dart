import 'package:flutter/material.dart';

class ResponsiveHelper {
  static bool isTV(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return size.width > 1000;
  }

  static bool isTablet(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return size.width > 600 && size.width <= 1000;
  }

  static bool isMobile(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return size.width <= 600;
  }

  static int getGridColumnCount(BuildContext context) {
    if (isTV(context)) {
      return 6; // TV: 6 columns
    } else if (isTablet(context)) {
      return 4; // Tablet: 4 columns
    } else {
      return 2; // Mobile: 2 columns
    }
  }

  static double getGridItemAspectRatio(BuildContext context) {
    // 調整寬高比，讓圖片區域更大，文字區域更小
    if (isTV(context)) {
      return 0.7; // TV: 較高的比例
    } else if (isTablet(context)) {
      return 0.65; // Tablet: 中等比例
    } else {
      return 0.6; // Mobile: 調整比例，減少間距
    }
  }

  static EdgeInsets getGridPadding(BuildContext context) {
    if (isTV(context)) {
      return const EdgeInsets.all(24.0);
    } else if (isTablet(context)) {
      return const EdgeInsets.all(16.0);
    } else {
      return const EdgeInsets.all(12.0);
    }
  }

  static double getGridSpacing(BuildContext context) {
    if (isTV(context)) {
      return 16.0;
    } else if (isTablet(context)) {
      return 12.0;
    } else {
      return 8.0;
    }
  }
}
