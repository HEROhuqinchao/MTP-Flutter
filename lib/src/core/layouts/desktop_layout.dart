import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mtp/src/core/widgets/platform_aware/desktop_sidebar.dart';
import 'package:mtp/src/features/chat/presentation/widgets/chat_list.dart';
import 'package:mtp/src/features/chat/presentation/providers/chat_provider.dart';

class DesktopLayout extends ConsumerWidget {
  final Widget child;
  final bool showDivider;
  final bool showChatList;
  final Color? backgroundColor;

  const DesktopLayout({
    super.key,
    required this.child,
    this.showDivider = true,
    this.showChatList = false,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    // 监视错误消息
    final errorMessage = ref.watch(
      sessionStateProvider.select((s) => s.errorMessage),
    );

    // 如果有错误消息，显示提示
    if (errorMessage != null) {
      // 使用WidgetsBinding.instance.addPostFrameCallback以避免在构建过程中显示SnackBar
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ElegantNotification(
          title: Text('发生错误'),
          description: Text(errorMessage),
          icon: Icon(Ionicons.warning),
          width: 360,
          progressIndicatorColor: Colors.orange,
          position: Alignment.bottomRight,
        ).show(context);
        // 清除错误消息
        ref.read(sessionStateProvider.notifier).clearErrorMessage();
      });
    }

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: backgroundColor ?? theme.scaffoldBackgroundColor,
        body: Row(
          children: [
            // 固定宽度的侧边栏
            const DesktopSidebar(),

            // 可选的分隔线
            if (showDivider)
              VerticalDivider(
                width: 1,
                thickness: 1,
                color: theme.dividerColor.withValues(alpha: 0.1),
              ),
            // 左侧对话列表
            if (showChatList) SizedBox(width: 252, child: ChatList()),

            // 右侧对话内容
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}
