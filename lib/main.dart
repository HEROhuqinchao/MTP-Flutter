import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';
import 'package:mtp/hive/hive_registrar.g.dart';
import 'package:logging/logging.dart';
import 'package:window_manager_plus/window_manager_plus.dart';
import 'src/app/app.dart';
import 'src/di/dependency_injection.dart';
import 'src/utils/logger.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  // 主窗口的初始化逻辑
  // 初始化日志系统
  AppLogger.init(level: Level.ALL); // 开发环境可以记录所有级别

  final windowId = args.isEmpty ? 0 : int.tryParse(args[0]) ?? 0;

  // 必须在桌面平台上初始化window_manager
  await WindowManagerPlus.ensureInitialized(windowId);
  // Hive初始化
  Hive
    ..init(Directory.current.path)
    ..registerAdapters();
  localLogger.info('Hive数据库初始化完成');

  // 初始化依赖注入
  await initDependencies();
  localLogger.info('依赖注入初始化完成');

  // 确保每个角色都有默认会话
  await ensureDefaultSessions();

  // 窗口配置
  WindowOptions windowOptions = const WindowOptions(
    minimumSize: Size(960, 654),
    size: Size(960, 654),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden, // 隐藏标题栏
  );
  await WindowManagerPlus.current.waitUntilReadyToShow(windowOptions, () async {
    await WindowManagerPlus.current.show();
    await WindowManagerPlus.current.focus();
  });

  runApp(ProviderScope(child: const App()));
}
