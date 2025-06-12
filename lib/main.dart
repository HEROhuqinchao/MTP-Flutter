import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';
import 'package:mtp/hive/hive_registrar.g.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:window_manager/window_manager.dart';
import 'src/app/app.dart';
import 'src/di/dependency_injection.dart';
import 'src/utils/logger.dart';
import 'package:mtp/src/core/utils/immersive_mode.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  // 设置沉浸式状态栏 - 初始为透明，视觉效果更好
  ImmersiveMode.set(statusBarColor: Colors.transparent);

  // 主窗口的初始化逻辑
  // 初始化日志系统
  AppLogger.init(level: Level.ALL); // 开发环境可以记录所有级别

  // 根据平台选择合适的存储路径
  String hivePath;
  if (Platform.isAndroid || Platform.isIOS) {
    // 在移动平台上使用应用文档目录
    final directory = await getApplicationDocumentsDirectory();
    hivePath = directory.path;
    localLogger.info('移动平台，Hive将使用路径: $hivePath');
  } else {
    // 在桌面平台上使用当前目录
    hivePath = Directory.current.path;
    localLogger.info('桌面平台，Hive将使用路径: $hivePath');
  }

  // Hive初始化
  Hive
    ..init(hivePath)
    ..registerAdapters();
  localLogger.info('Hive数据库初始化完成');

  // 初始化依赖注入
  await initDependencies();
  localLogger.info('依赖注入初始化完成');

  // 确保每个角色都有默认会话
  await ensureDefaultSessions();

  if (!(Platform.isAndroid || Platform.isIOS)) {
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
  }

  runApp(ProviderScope(child: const App()));
}
