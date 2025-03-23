import 'dart:io';

import 'package:flutter/material.dart';

class ConversationListItem extends StatefulWidget {
  final String title;
  final String lastMessage;
  final DateTime timestamp;
  final String? avatarUrl;
  final int unreadCount;
  final bool isActive;
  final bool isSelected;
  final VoidCallback onTap;

  const ConversationListItem({
    super.key,
    required this.title,
    required this.lastMessage,
    required this.timestamp,
    this.avatarUrl,
    this.unreadCount = 0,
    this.isActive = false,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  State<ConversationListItem> createState() => _ConversationListItemState();
}

class _ConversationListItemState extends State<ConversationListItem> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    // Format the timestamp
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(
      widget.timestamp.year,
      widget.timestamp.month,
      widget.timestamp.day,
    );

    String formattedTime;
    if (messageDate == today) {
      // Today: show only time
      formattedTime =
          '${widget.timestamp.hour.toString().padLeft(2, '0')}:${widget.timestamp.minute.toString().padLeft(2, '0')}';
    } else if (messageDate == today.subtract(const Duration(days: 1))) {
      // Yesterday
      formattedTime = '昨天';
    } else if (now.difference(messageDate).inDays < 7) {
      // Within a week: show day name
      final weekdays = ['星期一', '星期二', '星期三', '星期四', '星期五', '星期六', '星期日'];
      formattedTime = weekdays[widget.timestamp.weekday - 1];
    } else {
      // Older: show date
      formattedTime =
          '${widget.timestamp.day}/${widget.timestamp.month}/${widget.timestamp.year}';
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: InkWell(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          decoration: BoxDecoration(
            color:
                widget.isSelected
                    ? theme.colorScheme.primaryContainer.withValues(alpha: 0.5)
                    : _isHovering
                    ? theme.colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.3,
                    )
                    : Colors.transparent,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar with active indicator
              Stack(
                children: [
                  // Avatar
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.colorScheme.surfaceContainerHighest,
                      image:
                          widget.avatarUrl != null
                              ? DecorationImage(
                                image:
                                    widget.avatarUrl!.startsWith('http')
                                        ? NetworkImage(widget.avatarUrl!)
                                        : FileImage(File(widget.avatarUrl!)),
                                fit: BoxFit.cover,
                              )
                              : null,
                    ),
                    child:
                        widget.avatarUrl == null
                            ? Center(
                              child: Text(
                                widget.title.isNotEmpty
                                    ? widget.title[0].toUpperCase()
                                    : '?',
                                style: textTheme.titleLarge?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            )
                            : null,
                  ),

                  // Active indicator
                  if (widget.isActive)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: theme.scaffoldBackgroundColor,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(width: 12.0),

              // Conversation details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and time row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Title
                        Flexible(
                          child: Text(
                            widget.title,
                            style: textTheme.titleSmall?.copyWith(
                              fontWeight:
                                  widget.unreadCount > 0
                                      ? FontWeight.bold
                                      : FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        // Timestamp
                        Text(
                          formattedTime,
                          style: textTheme.bodySmall?.copyWith(
                            color:
                                widget.unreadCount > 0
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.onSurfaceVariant,
                            fontWeight:
                                widget.unreadCount > 0
                                    ? FontWeight.bold
                                    : FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4.0),

                    // Message preview and unread count
                    Row(
                      children: [
                        // Message preview
                        Expanded(
                          child: Text(
                            widget.lastMessage,
                            style: textTheme.bodySmall?.copyWith(
                              color:
                                  widget.unreadCount > 0
                                      ? theme.colorScheme.onSurface
                                      : theme.colorScheme.onSurfaceVariant,
                              fontWeight:
                                  widget.unreadCount > 0
                                      ? FontWeight.w500
                                      : FontWeight.normal,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        if (widget.unreadCount > 0) ...[
                          const SizedBox(width: 6.0), // 减小间距
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5.0, // 减小水平内边距
                              vertical: 2.0, // 减小垂直内边距
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 18.0, // 设置最小宽度保证圆形效果
                              minHeight: 18.0, // 设置最小高度
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              borderRadius: BorderRadius.circular(
                                9.0,
                              ), // 减小圆角半径
                            ),
                            alignment: Alignment.center, // 确保内容居中
                            child: Text(
                              widget.unreadCount.toString(),
                              style: textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 10.0, // 减小字体大小
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
