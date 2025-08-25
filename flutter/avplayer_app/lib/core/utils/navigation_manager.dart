import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NavigationManager {
  static final NavigationManager _instance = NavigationManager._internal();
  factory NavigationManager() => _instance;
  NavigationManager._internal();

  // 導航歷史記錄
  final List<String> _navigationHistory = [];
  
  // 是否已經顯示過退出確認對話框
  bool _hasShownExitDialog = false;

  // 添加導航記錄
  void addNavigation(String routeName) {
    _navigationHistory.add(routeName);
  }

  // 移除最後一個導航記錄
  void removeLastNavigation() {
    if (_navigationHistory.isNotEmpty) {
      _navigationHistory.removeLast();
    }
  }

  // 獲取當前導航層級
  int get navigationLevel => _navigationHistory.length;

  // 檢查是否在首頁（列表頁）
  bool get isAtHomePage => _navigationHistory.isEmpty || 
                          (_navigationHistory.length == 1 && 
                           _navigationHistory.first == '/');

  // 處理 back 鍵事件
  Future<bool> handleBackKey(BuildContext context) async {
    if (_navigationHistory.isEmpty) {
      // 如果沒有導航歷史，顯示退出確認
      return await _showExitConfirmation(context);
    } else {
      // 有導航歷史，執行正常的返回操作
      removeLastNavigation();
      return true; // 允許返回
    }
  }

  // 顯示退出確認對話框
  Future<bool> _showExitConfirmation(BuildContext context) async {
    // 如果已經顯示過對話框，再次顯示
    if (_hasShownExitDialog) {
      return await _showExitDialog(context);
    }

    _hasShownExitDialog = true;
    
    return await _showExitDialog(context);
  }

  // 顯示退出對話框
  Future<bool> _showExitDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('確定要關閉程式？'),
          content: const Text('您確定要退出應用程式嗎？'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('確定'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      // 用戶確認退出，關閉所有相關進程
      await _closeApplication();
      return true;
    }
    
    return false;
  }

  // 關閉應用程式
  Future<void> _closeApplication() async {
    try {
      // 關閉所有相關進程
      await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    } catch (e) {
      // 如果 SystemNavigator.pop 失敗，使用 exit
      SystemNavigator.pop();
    }
  }

  // 重置導航歷史（用於重新開始）
  void resetNavigation() {
    _navigationHistory.clear();
    _hasShownExitDialog = false;
  }

  // 清空導航歷史但保持退出對話框狀態
  void clearNavigationHistory() {
    _navigationHistory.clear();
  }
}
