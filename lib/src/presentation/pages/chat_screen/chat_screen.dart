import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mtp/src/presentation/providers/chat/chat_provider.dart';
import 'package:mtp/src/presentation/pages/chat_screen/widgets/conversation_list.dart';
import 'package:mtp/src/presentation/pages/chat_screen/widgets/conversation_view.dart';

class ChatScreen extends ConsumerWidget {
  const ChatScreen({super.key});

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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage)));
        // 清除错误消息
        ref.read(chatStateProvider.notifier).clearErrorMessage();
      });
    }
    final conversationListWidth = (Platform.isAndroid || Platform.isIOS) ? 320.0 : 252.0;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Row(
        children: [
          // 左侧对话列表
          SizedBox(width: conversationListWidth, child: ConversationList()),

          // 右侧对话内容
          Expanded(child: ConversationView()),
        ],
      ),
    );
  }
}
