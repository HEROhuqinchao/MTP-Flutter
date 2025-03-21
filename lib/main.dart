import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';
import 'package:mtp/hive/hive_registrar.g.dart';
import 'package:window_manager/window_manager.dart';
import 'package:logging/logging.dart';
import 'src/app/app.dart';
import 'src/di/dependency_injection.dart';
import 'src/utils/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化日志系统
  AppLogger.init(level: Level.ALL); // 开发环境可以记录所有级别

  // Hive初始化
  Hive
    ..init(Directory.current.path)
    ..registerAdapters();
  print('Hive数据库初始化完成');

  // 初始化依赖注入
  await initDependencies();
  print('依赖注入初始化完成');

  // 确保每个角色都有默认会话
  await ensureDefaultSessions();

  // 必须在桌面平台上初始化window_manager
  await windowManager.ensureInitialized();

  // 窗口配置
  WindowOptions windowOptions = const WindowOptions(
    minimumSize: Size(960, 654),
    size: Size(960, 654),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden, // 隐藏标题栏
  );

  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(ProviderScope(child: const App()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MTP App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

// 临时HomePage，实际应用中应该导入真正的主页
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MTP App')),
      body: const Center(child: Text('Welcome to MTP App')),
    );
  }
}
