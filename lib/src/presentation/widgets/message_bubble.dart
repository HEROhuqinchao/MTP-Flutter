import 'package:flutter/material.dart';
import 'package:mtp/src/domain/entities/message_entity.dart';

class MessageBubble extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) _buildAvatar(context),

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
                    horizontal: 16,
                    vertical: 10,
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
                          if (isMe) ...[
                            const SizedBox(width: 4),
                            Icon(
                              Icons.done_all,
                              size: 12,
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

          // Container(
          //   constraints: BoxConstraints(
          //     maxWidth: MediaQuery.of(context).size.width * 0.7,
          //   ),
          //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          // ),
          const SizedBox(width: 8),

          if (isMe) _buildAvatar(context),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    if (!isMe && message.senderAvatar == null) {
      return const SizedBox(width: 32, height: 32);
    }

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        image:
            message.senderAvatar != null
                ? DecorationImage(
                  image: NetworkImage(message.senderAvatar!),
                  fit: BoxFit.cover,
                )
                : null,
      ),
      child:
          message.senderAvatar == null
              ? Center(
                child: Text(
                  isMe
                      ? 'Me'
                      : (message.senderName?.isNotEmpty == true
                          ? message.senderName![0].toUpperCase()
                          : '?'),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
              : null,
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
