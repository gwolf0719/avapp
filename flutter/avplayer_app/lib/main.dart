import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'presentation/pages/home_page.dart';
import 'core/utils/navigation_manager.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AV Player',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const AppWrapper(),
    );
  }
}

class AppWrapper extends StatefulWidget {
  const AppWrapper({super.key});

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  final NavigationManager _navigationManager = NavigationManager();

  @override
  void initState() {
    super.initState();
    // 初始化導航管理器
    _navigationManager.resetNavigation();
    _navigationManager.addNavigation('/');
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          // 處理 back 鍵事件
          await _navigationManager.handleBackKey(context);
        }
      },
      child: Focus(
        autofocus: true,
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent) {
            switch (event.logicalKey) {
              case LogicalKeyboardKey.goBack:
              case LogicalKeyboardKey.escape:
                _navigationManager.handleBackKey(context);
                return KeyEventResult.handled;
            }
          }
          return KeyEventResult.ignored;
        },
        child: const HomePage(),
      ),
    );
  }
}