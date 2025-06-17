import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
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
