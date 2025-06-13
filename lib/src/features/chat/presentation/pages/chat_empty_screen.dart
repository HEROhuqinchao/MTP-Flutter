import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class ChatEmptyscreen extends StatelessWidget {
  const ChatEmptyscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Ionicons.chatbubble,
            size: 80,
            color: Colors.grey.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            '没有消息',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '发送一条消息开始对话',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
