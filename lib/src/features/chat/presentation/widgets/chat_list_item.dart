import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ChatListItem extends StatefulWidget {
  final String title;
  final String lastMessage;
  final DateTime timestamp;
  final String? avatarUrl;
  final int unreadCount;
  final bool isActive;
  final bool isSelected;
  final bool isPinned;
  final VoidCallback onTap;
  final VoidCallback? onPin;
  final VoidCallback? onClear;

  const ChatListItem({
    super.key,
    required this.title,
    required this.lastMessage,
    required this.timestamp,
    this.avatarUrl,
    this.unreadCount = 0,
    this.isActive = false,
    this.isSelected = false,
    this.isPinned = false,
    required this.onTap,
    this.onPin,
    this.onClear,
  });

  @override
  State<ChatListItem> createState() => _ChatListItemState();
}

class _ChatListItemState extends State<ChatListItem> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final isMobile = Platform.isAndroid || Platform.isIOS;

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

    // 构建主内容
    Widget content = MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: InkWell(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          decoration: BoxDecoration(
            color:
                widget.isSelected || widget.isPinned
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
              // 头像部分
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

                  // 置顶标识
                  if (widget.isPinned)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: theme.scaffoldBackgroundColor,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.push_pin,
                          size: 8,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(width: 12.0),

              // 会话详情
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

    // 在移动设备上使用 Slidable
    if (isMobile && (widget.onPin != null || widget.onClear != null)) {
      return Slidable(
        // 设置只能从右向左滑动（即向右滑）
        direction: Axis.horizontal,

        // 右侧显示的操作按钮
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            // 置顶/取消置顶按钮
            if (widget.onPin != null)
              SlidableAction(
                onPressed: (_) => widget.onPin!(),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                icon:
                    widget.isPinned ? Icons.push_pin_outlined : Icons.push_pin,
                label: widget.isPinned ? '取消置顶' : '置顶',
              ),

            // 删除按钮
            if (widget.onClear != null)
              SlidableAction(
                onPressed: (_) => widget.onClear!(),
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                icon: Icons.delete_outline,
                label: '删除',
              ),
          ],
        ),

        // 主内容
        child: content,
      );
    }

    return content;
  }
}
