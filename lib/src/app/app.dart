import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mtp/src/presentation/pages/chat_screen/chat_screen.dart';
import '../core/widgets/platform_aware/desktop_layout.dart';
import '../core/widgets/platform_aware/mobile_layout.dart';
import '../core/widgets/platform_aware/tablet_layout.dart';
import '../core/widgets/responsive_layout.dart';
import '../core/widgets/custom_window/window_title_bar.dart';
import '../presentation/providers/settings/settings_provider.dart';
import 'theme/app_theme.dart';
import 'dart:io' show Platform;

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 获取当前主题模式
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'MTP',
      debugShowCheckedModeBanner: false,
      // 设置主题
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: const AppHome(),
    );
  }
}

class AppHome extends StatefulWidget {
  const AppHome({super.key});

  @override
  State<AppHome> createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  @override
  void initState() {
    super.initState();
    _configureSystemUI();
  }

  // Configure system UI based on platform
  void _configureSystemUI() {
    if (Platform.isAndroid || Platform.isIOS) {
      // Mobile-specific UI configuration
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);

      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // 判断是否为桌面平台
    final bool isDesktopPlatform =
        Platform.isWindows || Platform.isMacOS || Platform.isLinux;
    final bool isMobilePlatform = Platform.isAndroid || Platform.isIOS;

    return Scaffold(
      // 在桌面平台上不使用AppBar，而使用自定义标题栏
      appBar: null,
      // isDesktopPlatform
      //     ? null
      //     : AppBar(
      //       title: const Text('MomoTalk Plus'),
      //       backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      //     ),
      body: Stack(
        children: [
          // 内容区域
          ResponsiveLayout(
            // Mobile layout is different based on physical device
            mobileLayout: const MobileLayout(),
            // On mobile devices, landscape should adapt
            mobileLandscapeLayout: isMobilePlatform ? null : null,
            // Tablet layout
            tabletLayout:
                isDesktopPlatform
                    ? const DesktopLayout(child: ChatScreen())
                    : const TabletLayout(),
            // Desktop layout
            desktopLayout: const DesktopLayout(child: ChatScreen()),
          ),
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
