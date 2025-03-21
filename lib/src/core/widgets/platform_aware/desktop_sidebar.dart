import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class DesktopSidebar extends StatefulWidget {
  const DesktopSidebar({super.key});

  @override
  State<DesktopSidebar> createState() => _DesktopSidebarState();
}

class _DesktopSidebarState extends State<DesktopSidebar> {
  final _overlayController = OverlayPortalController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60, // 固定宽度
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.only(top: 8, bottom: 8),
            alignment: Alignment.center,
            child: Text("MTP", style: Theme.of(context).textTheme.titleMedium),
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
                        // 点击头像的处理逻辑
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
                              // TODO: 如果有图片，可以使用下面的方式
                              // backgroundImage: NetworkImage('https://example.com/avatar.jpg'),
                              child: Text(
                                'U', // 用户名首字母，或者用Icon替代
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
                      icon: Icon(
                        Icons.comment_bank_outlined,
                        size: 18,
                      ), // 减小图标大小
                      selectedIcon: Icon(Icons.comment, size: 18), // 保持一致的大小
                      isSelected: true,
                      onPressed: () => {},
                      style: ButtonStyle(
                        // 设置更小的内边距
                        padding: MaterialStateProperty.all(EdgeInsets.all(4)),
                        // 设置背景颜色 - 选中时显示
                        backgroundColor: MaterialStateProperty.resolveWith((
                          states,
                        ) {
                          if (states.contains(MaterialState.selected)) {
                            return Theme.of(
                              context,
                            ).colorScheme.primaryContainer.withOpacity(0.8);
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
                                              icon: Icons.settings_outlined,
                                              title: '设置',
                                              onTap: () {
                                                _overlayController.hide();
                                                // 实现设置功能
                                                print('打开设置');
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
                                              icon: Icons.help_outline,
                                              title: '帮助与反馈',
                                              onTap: () {
                                                _overlayController.hide();
                                                // 实现帮助功能
                                                print('打开帮助');
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
                                              icon: Icons.info_outline,
                                              title: '关于',
                                              onTap: () {
                                                _overlayController.hide();
                                                // 实现关于功能
                                                print('打开关于');
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
                                              icon: Icons.logout,
                                              title: '退出',
                                              onTap: () async {
                                                _overlayController.hide();
                                                await windowManager.close();
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
                        child: Center(child: Icon(Icons.menu, size: 24)),
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
