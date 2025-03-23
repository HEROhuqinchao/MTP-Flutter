import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mtp/src/core/constants/app_info.dart';
import 'package:mtp/src/presentation/providers/settings/settings_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:window_manager_plus/window_manager_plus.dart';
import 'package:mtp/src/presentation/pages/settings_screen/settings_screen.dart';

class DesktopSidebar extends ConsumerStatefulWidget {
  const DesktopSidebar({super.key});

  @override
  ConsumerState<DesktopSidebar> createState() => _DesktopSidebarState();
}

class _DesktopSidebarState extends ConsumerState<DesktopSidebar> {
  final _overlayController = OverlayPortalController();

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);

    return Container(
      width: 60, // 固定宽度
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.only(top: 8, bottom: 8),
            alignment: Alignment.center,
            child: Text(
              appName,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 上部菜单项
                Column(
                  children: [
                    const SizedBox(height: 12),
                    // 添加头像
                    InkWell(
                      onTap: () {
                        // // 点击头像打开设置页面
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (context) => const SettingsScreen(),
                        //   ),
                        // );
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Stack(
                          children: [
                            // 头像
                            CircleAvatar(
                              radius: 18,
                              backgroundColor:
                                  Theme.of(
                                    context,
                                  ).colorScheme.primaryContainer,

                              child:
                                  settings?.userAvatar.isNotEmpty == true
                                      ? ClipOval(
                                        child:
                                            settings!.userAvatar.startsWith(
                                                  'assets/',
                                                )
                                                ? Image.asset(
                                                  settings.userAvatar,
                                                  width: 36,
                                                  height: 36,
                                                  fit: BoxFit.cover,
                                                )
                                                : Image.file(
                                                  File(settings.userAvatar),
                                                  width: 36,
                                                  height: 36,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) {
                                                    // 图片加载失败时显示用户名首字母
                                                    return Text(
                                                      settings
                                                              .username
                                                              .isNotEmpty
                                                          ? settings.username[0]
                                                              .toUpperCase()
                                                          : 'U',
                                                      style: TextStyle(
                                                        color:
                                                            Theme.of(context)
                                                                .colorScheme
                                                                .onPrimaryContainer,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    );
                                                  },
                                                ),
                                      )
                                      : Text(
                                        settings?.username.isNotEmpty == true
                                            ? settings!.username[0]
                                                .toUpperCase()
                                            : 'U',
                                        style: TextStyle(
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.onPrimaryContainer,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                            ),
                            // 在线状态指示器
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(
                                    255,
                                    90,
                                    230,
                                    95,
                                  ), // 在线状态为绿色
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    IconButton(
                      icon: Icon(Ionicons.chatbubble, size: 18), // 减小图标大小
                      selectedIcon: Icon(
                        Ionicons.chatbubble_ellipses,
                        size: 18,
                      ), // 保持一致的大小
                      isSelected: true,
                      onPressed: () => {},
                      style: ButtonStyle(
                        // 设置更小的内边距
                        padding: WidgetStateProperty.all(EdgeInsets.all(4)),
                        // 设置背景颜色 - 选中时显示
                        backgroundColor: WidgetStateProperty.resolveWith((
                          states,
                        ) {
                          if (states.contains(WidgetState.selected)) {
                            return Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.1);
                          }
                          return Colors.transparent; // 未选中时透明
                        }),
                        // 设置图标颜色
                        iconColor: WidgetStateProperty.resolveWith((states) {
                          if (states.contains(WidgetState.selected)) {
                            return Theme.of(
                              context,
                            ).colorScheme.onPrimaryContainer;
                          }
                          return Theme.of(context).colorScheme.onSurface;
                        }),
                        // 形状设置
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        // 设置按钮大小约束
                        minimumSize: WidgetStateProperty.all(Size(36, 36)),
                        maximumSize: WidgetStateProperty.all(Size(36, 36)),
                      ),
                    ),
                  ],
                ),

                // 底部菜单项
                Column(
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        shadowColor: WidgetStateProperty.all(
                          Colors.transparent,
                        ),
                        elevation: WidgetStateProperty.all(0),
                        backgroundColor: WidgetStateProperty.all(
                          Colors.transparent,
                        ),
                        overlayColor: WidgetStateProperty.all(
                          Colors.transparent,
                        ),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        padding: WidgetStateProperty.all(
                          EdgeInsets.zero,
                        ), // 移除内边距
                        minimumSize: WidgetStateProperty.all(
                          Size(36, 36),
                        ), // 固定大小
                      ),
                      onPressed: _overlayController.toggle,
                      child: OverlayPortal(
                        controller: _overlayController,
                        overlayChildBuilder: (BuildContext context) {
                          return Stack(
                            children: [
                              // 全屏透明层，用于捕获点击事件并关闭菜单
                              Positioned.fill(
                                child: GestureDetector(
                                  onTap: _overlayController.hide,
                                  behavior: HitTestBehavior.opaque,
                                  child: Container(color: Colors.transparent),
                                ),
                              ),

                              // 菜单内容 - 定位在侧边栏右侧
                              Positioned(
                                left: 64, // 侧边栏宽度
                                bottom: 16, // 定位在底部菜单项附近
                                child: AnimatedOpacity(
                                  opacity: 1.0,
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeOutCubic,
                                  child: TweenAnimationBuilder<double>(
                                    tween: Tween(begin: 0.8, end: 1.0),
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeOutCubic,
                                    builder: (context, scale, child) {
                                      return Transform.scale(
                                        scale: scale,
                                        alignment: Alignment.bottomLeft,
                                        child: child,
                                      );
                                    },
                                    child: Material(
                                      elevation: 2,
                                      borderRadius: BorderRadius.circular(8),
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.surfaceContainer,
                                      child: SizedBox(
                                        width: 200,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            _buildMenuItem(
                                              context: context,
                                              icon: Ionicons.cog,
                                              title: '设置',
                                              onTap: () async {
                                                _overlayController.hide();
                                                // 打开设置界面
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder:
                                                        (context) =>
                                                            const SettingsScreen(),
                                                  ),
                                                );
                                              },
                                            ),
                                            Divider(
                                              height: 1,
                                              thickness: 1,
                                              indent: 16,
                                              endIndent: 16,
                                            ),
                                            _buildMenuItem(
                                              context: context,
                                              icon: Ionicons.help_circle,
                                              title: '帮助与反馈',
                                              onTap: () async {
                                                _overlayController.hide();
                                                // 实现帮助功能 - 打开帮助网页
                                                final Uri helpUrl = Uri.parse(
                                                  appHelpUrl,
                                                );

                                                try {
                                                  // 根据平台选择不同的实现方式
                                                  if (Platform.isWindows) {
                                                    // Windows 平台使用系统命令打开
                                                    await Process.run(
                                                      'explorer.exe',
                                                      [helpUrl.toString()],
                                                    );
                                                  } else {
                                                    // 其他平台使用 url_launcher
                                                    if (!await launchUrl(
                                                      helpUrl,
                                                      mode:
                                                          LaunchMode
                                                              .externalApplication,
                                                    )) {
                                                      // 如果打开失败，显示错误消息
                                                      if (context.mounted) {
                                                        ScaffoldMessenger.of(
                                                          context,
                                                        ).showSnackBar(
                                                          const SnackBar(
                                                            content: Text(
                                                              '无法打开帮助页面，请稍后再试',
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    }
                                                  }
                                                } catch (e) {
                                                  // 捕获可能的异常并提供反馈
                                                  if (context.mounted) {
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          '打开帮助页面时出错: $e',
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                }
                                              },
                                            ),
                                            Divider(
                                              height: 1,
                                              thickness: 1,
                                              indent: 16,
                                              endIndent: 16,
                                            ),
                                            _buildMenuItem(
                                              context: context,
                                              icon: Ionicons.information_circle,
                                              title: '关于',
                                              onTap: () {
                                                _overlayController.hide();
                                                // 实现关于功能
                                                showAboutDialog(
                                                  context: context,
                                                  applicationName: appName,
                                                  applicationIcon: CircleAvatar(
                                                    radius: 25,
                                                    backgroundColor:
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .primaryContainer,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            2.0,
                                                          ),
                                                      child: ClipOval(
                                                        child: Image.asset(
                                                          'assets/logo.png',
                                                          width: 46,
                                                          height: 46,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  applicationVersion:
                                                      appVersion,
                                                  applicationLegalese:
                                                      ' © ${DateTime.now().year} MomoTalk Plus. 保留所有权利',
                                                );
                                              },
                                            ),
                                            Divider(
                                              height: 1,
                                              thickness: 1,
                                              indent: 16,
                                              endIndent: 16,
                                            ),
                                            _buildMenuItem(
                                              context: context,
                                              icon: Ionicons.log_out,
                                              title: '退出',
                                              onTap: () async {
                                                _overlayController.hide();
                                                await WindowManagerPlus.current
                                                    .close();
                                              },
                                              textColor: Colors.redAccent,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                        child: Center(child: Icon(Ionicons.options, size: 24)),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: textColor ?? Theme.of(context).colorScheme.onSurface,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: textColor ?? Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
