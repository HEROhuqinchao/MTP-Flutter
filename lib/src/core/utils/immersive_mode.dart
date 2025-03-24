import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 沉浸式状态栏工具类
class ImmersiveMode {
  /// 设置沉浸式状态栏
  ///
  /// [statusBarColor] 状态栏颜色，默认透明
  /// [isDark] 状态栏图标是否为深色模式 (true=深色图标，适合浅色背景；false=浅色图标，适合深色背景)
  static void set({Color? statusBarColor, bool? isDark}) {
    if (!Platform.isAndroid && !Platform.isIOS) return;

    // 状态栏图标颜色 - isDark为true时应使用黑色图标(Brightness.dark)
    final statusBarIconBrightness =
        isDark == true ? Brightness.dark : Brightness.light;

    // iOS状态栏样式 - 与Android相反
    final statusBarBrightness =
        isDark == true ? Brightness.light : Brightness.dark;

    final style = SystemUiOverlayStyle(
      // 一定要显式设置颜色，否则在某些设备上可能不生效
      statusBarColor: statusBarColor,
      // 确保设置正确的亮度值
      statusBarIconBrightness: statusBarIconBrightness,
      statusBarBrightness: statusBarBrightness,
    );

    // 直接应用样式而不是通过SystemChrome
    SystemChrome.setSystemUIOverlayStyle(style);

    // 允许内容延伸到状态栏和底部导航栏
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  /// 获取状态栏高度
  static double getStatusBarHeight(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  /// 获取底部安全区域高度
  static double getBottomSafeAreaHeight(BuildContext context) {
    return MediaQuery.of(context).padding.bottom;
  }
}
