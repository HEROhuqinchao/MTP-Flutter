import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mtp/src/app/routes.dart';
import '../core/layouts/responsive_layout.dart';
import '../core/widgets/custom_window/window_title_bar.dart';
import '../features/settings/presentation/providers/settings_provider.dart';
import 'theme/app_theme.dart';
import 'dart:io' show Platform;

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 获取当前主题模式
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'MTP',
      debugShowCheckedModeBanner: false,
      // 设置主题
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
      builder: (context, child) => AppHome(child: child!),
    );
  }
}

class AppHome extends StatefulWidget {
  final Widget child;

  const AppHome({super.key, required this.child});

  @override
  State<AppHome> createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  @override
  void initState() {
    super.initState();
    // 不要在这里调用包含MediaQuery的方法
    _configureBasicSystemUI();

    // 使用post-frame回调安全地设置依赖于MediaQuery的设置
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _configureScreenDependentUI();
    });
  }

  // 基本UI配置，不依赖MediaQuery
  void _configureBasicSystemUI() {
    if (Platform.isAndroid || Platform.isIOS) {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      );
    }
  }

  // 依赖屏幕尺寸的配置
  void _configureScreenDependentUI() {
    if (Platform.isAndroid || Platform.isIOS) {
      final width = MediaQuery.of(context).size.width;
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        if (width >= ScreenBreakpoints.mobile) ...[
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ],
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 判断是否为桌面平台
    final bool isDesktopPlatform =
        Platform.isWindows || Platform.isMacOS || Platform.isLinux;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          widget.child,
          // // 内容区域
          // ResponsiveLayout(
          //   // Mobile layout is different based on physical device
          //   mobileLayout: const MobileLayout(),
          //   // On mobile devices, landscape should adapt
          //   mobileLandscapeLayout: isMobilePlatform ? null : null,
          //   // Tablet layout
          //   tabletLayout:
          //       isDesktopPlatform
          //           ? const DesktopLayout(child: ChatScreen())
          //           : const TabletLayout(),
          //   // Desktop layout
          //   desktopLayout: const DesktopLayout(child: ChatScreen()),
          // ),
          // 桌面平台使用自定义标题栏，放在Stack顶层
          if (isDesktopPlatform)
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: WindowTitleBar(),
            ),
        ],
      ),
    );
  }
}
