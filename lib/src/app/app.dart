import 'package:flutter/material.dart';
import 'package:mtp/src/presentation/pages/chat_screen/chat_screen.dart';
import '../core/widgets/platform_aware/desktop_layout.dart';
import '../core/widgets/platform_aware/mobile_layout.dart';
import '../core/widgets/platform_aware/tablet_layout.dart';
import '../core/widgets/responsive_layout.dart';
import '../core/widgets/custom_window/window_title_bar.dart';
import 'dart:io' show Platform;

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MTP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        useMaterial3: true,
      ),
      home: const AppHome(),
    );
  }
}

class AppHome extends StatelessWidget {
  const AppHome({super.key});

  @override
  Widget build(BuildContext context) {
    // 判断是否为桌面平台
    final bool isDesktopPlatform =
        Platform.isWindows || Platform.isMacOS || Platform.isLinux;

    return Scaffold(
      // 在桌面平台上不使用AppBar，而使用自定义标题栏
      appBar:
          isDesktopPlatform
              ? null
              : AppBar(
                title: const Text('Responsive App'),
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              ),
      body: Stack(
        children: [
          // 内容区域
          ResponsiveLayout(
            mobileLayout: const MobileLayout(),
            tabletLayout:
                isDesktopPlatform
                    ? const DesktopLayout(child: ChatScreen())
                    : const TabletLayout(),
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
