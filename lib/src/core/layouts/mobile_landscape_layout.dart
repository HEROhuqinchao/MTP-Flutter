import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mtp/src/presentation/pages/chat_screen/widgets/chat_list.dart';
import 'package:mtp/src/presentation/providers/chat/chat_provider.dart';

class MobileLandscapeLayout extends ConsumerWidget {
  final Widget child;
  const MobileLandscapeLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 监视错误消息
    final errorMessage = ref.watch(
      chatStateProvider.select((s) => s.errorMessage),
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
        ref.read(chatStateProvider.notifier).clearErrorMessage();
      });
    }
    return SafeArea(
      child: Row(
        children: [
          SizedBox(width: 360, child: ChatList()),
          Expanded(child: child),
        ],
      ),
    );
  }
}
