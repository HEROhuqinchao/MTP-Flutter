import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mtp/src/domain/entities/message_entity.dart';
import 'package:mtp/src/presentation/providers/settings/settings_provider.dart';
import 'dart:io';

class MessageBubble extends ConsumerWidget {
  final MessageEntity message;
  final bool isMe;
  final double? maxWidth;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final settings = ref.watch(settingsProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) _buildAvatar(context, settings),

          const SizedBox(width: 8),

          // 消息气泡
          Flexible(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  constraints: BoxConstraints(
                    maxWidth:
                        maxWidth ?? MediaQuery.of(context).size.width * 0.5,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isMe
                            ? theme.colorScheme.primary.withOpacity(0.9)
                            : theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12).copyWith(
                      bottomRight: isMe ? const Radius.circular(4) : null,
                      bottomLeft: !isMe ? const Radius.circular(4) : null,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 消息内容
                      SelectableText(
                        message.content,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color:
                              isMe
                                  ? theme.colorScheme.onPrimary
                                  : theme.colorScheme.onSurfaceVariant,
                        ),
                      ),

                      const SizedBox(height: 4),

                      // 时间戳
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            _formatTime(message.timestamp),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color:
                                  isMe
                                      ? theme.colorScheme.onPrimary.withOpacity(
                                        0.7,
                                      )
                                      : theme.colorScheme.onSurfaceVariant
                                          .withOpacity(0.7),
                              fontSize: 10,
                            ),
                          ),
                          if (message.isRead) ...[
                            const SizedBox(width: 4),
                            Icon(
                              Ionicons.checkmark_done,
                              size: 14,
                              color:
                                  message.isRead
                                      ? Colors.blue
                                      : theme.colorScheme.onPrimary.withOpacity(
                                        0.7,
                                      ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(width: 8),

          if (isMe) _buildAvatar(context, settings),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, settings) {
    // 如果是当前用户发送的消息，优先使用设置中的头像
    String? avatarPath;
    if (isMe && settings != null && settings.userAvatar.isNotEmpty) {
      avatarPath = settings.userAvatar;
    } else if (message.senderAvatar != null) {
      avatarPath = message.senderAvatar;
    }

    // 如果没有头像，且不是当前用户的消息，显示空白
    if (avatarPath == null && !isMe) {
      return const SizedBox(width: 32, height: 32);
    }

    // 创建图像小部件
    Widget? imageWidget;
    if (avatarPath != null) {
      if (avatarPath == '') {
        imageWidget = null;
      } else if (avatarPath.startsWith('assets/')) {
        // 使用资源图像
        imageWidget = Image.asset(
          avatarPath,
          fit: BoxFit.cover,
          width: 36,
          height: 36,
          errorBuilder:
              (context, error, stackTrace) =>
                  _buildPlaceholderAvatar(context, settings),
        );
      } else if (avatarPath.startsWith('http')) {
        imageWidget = Image.network(
          avatarPath,
          fit: BoxFit.cover,
          width: 36,
          height: 36,
          errorBuilder:
              (context, error, stackTrace) =>
                  _buildPlaceholderAvatar(context, settings),
        );
      } else {
        // 使用本地文件
        imageWidget = Image.file(
          File(avatarPath),
          fit: BoxFit.cover,
          width: 36,
          height: 36,
          errorBuilder:
              (context, error, stackTrace) =>
                  _buildPlaceholderAvatar(context, settings),
        );
      }
    }

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      clipBehavior: Clip.antiAlias,
      child: imageWidget ?? _buildPlaceholderAvatar(context, settings),
    );
  }

  // 创建占位符头像
  Widget _buildPlaceholderAvatar(BuildContext context, settings) {
    // 显示当前用户名称的首字母或从设置中获取
    String displayText;
    if (isMe && settings != null && settings.username.isNotEmpty) {
      displayText = settings.username[0].toUpperCase();
    } else {
      displayText =
          isMe
              ? 'Me'
              : (message.senderName?.isNotEmpty == true
                  ? message.senderName![0].toUpperCase()
                  : '?');
    }

    return Center(
      child: Text(
        displayText,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
