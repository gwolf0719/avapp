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
    // 調整寬高比，讓卡片更緊湊，減少空白間距
    if (isTV(context)) {
      return 0.8; // TV: 更緊湊的比例
    } else if (isTablet(context)) {
      return 0.75; // Tablet: 更緊湊的比例
    } else {
      return 0.7; // Mobile: 更緊湊的比例，減少間距
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

  static double getGridItemMaxWidth(BuildContext context) {
    if (isTV(context)) {
      return 200.0; // TV: 較大的卡片
    } else if (isTablet(context)) {
      return 180.0; // Tablet: 中等卡片
    } else {
      return 160.0; // Mobile: 較小的卡片
    }
  }
}
