import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mtp/src/domain/entities/message_entity.dart';
import 'package:mtp/src/presentation/providers/chat/chat_provider.dart';
import 'package:mtp/src/presentation/providers/role/role_provider.dart';
import 'package:mtp/src/presentation/widgets/simple_icon_button.dart';
import '../../../widgets/message_bubble.dart';

class ConversationView extends ConsumerStatefulWidget {
  const ConversationView({super.key});

  @override
  ConsumerState<ConversationView> createState() => _ConversationViewState();
}

class _ConversationViewState extends ConsumerState<ConversationView> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isComposing = false;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // 使用Provider获取当前会话
    final currentSession = ref.watch(currentSessionProvider);

    if (currentSession == null) {
      return _buildEmptyConversationView();
    }

    final roleState = ref.watch(roleStateProvider);
    final messages = currentSession.messages;
    final title = currentSession.title;
    // 确定是否活跃 (最近10分钟有新消息)
    final isActive =
        currentSession.updatedAt != null &&
        DateTime.now().difference(currentSession.updatedAt!).inMinutes < 10;
    // 根据 roleId 获取角色信息
    final role =
        roleState.roles.isEmpty
            ? null
            : roleState.roles.firstWhere(
              (role) => role.id == currentSession.roleId,
              orElse: () => roleState.roles.first,
            );
    // 获取角色头像
    String? avatarUrl;
    if (role != null && role.avatars.isNotEmpty) {
      avatarUrl = role.avatars.first;
    }

    // 确保消息列表底部有足够空间，避免输入框遮挡
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Column(
        children: [
          // 对话标题栏
          _buildHeader(context, title, isActive, avatarUrl),

          // 消息列表
          Expanded(
            child:
                messages.isEmpty
                    ? _buildEmptyConversation(context)
                    : _buildMessagesList(context, messages),
          ),

          // 分隔线
          Divider(height: 1, color: theme.dividerColor),

          // 消息输入区域
          _buildMessageComposer(context),
        ],
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    String title,
    bool isActive,
    String? avatarUrl,
  ) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.only(top: 28, bottom: 12, left: 16, right: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 1),
            blurRadius: 3,
          ),
        ],
      ),
      child: Row(
        children: [
          // 头像
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.surfaceContainerHighest,
              image:
                  avatarUrl != null
                      ? DecorationImage(
                        image: NetworkImage(avatarUrl),
                        fit: BoxFit.cover,
                      )
                      : null,
            ),
            child:
                avatarUrl == null
                    ? Center(
                      child: Text(
                        title.isNotEmpty ? title[0].toUpperCase() : '?',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    )
                    : null,
          ),

          const SizedBox(width: 12),

          // 标题和状态
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (isActive)
                  Text(
                    '在线',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.green,
                    ),
                  ),
              ],
            ),
          ),

          // 操作按钮
          IconButton(
            iconSize: 16,
            constraints: BoxConstraints(maxHeight: 32, maxWidth: 32),
            icon: const Icon(Ionicons.ellipsis_horizontal),
            onPressed: () {
              // 显示更多操作菜单
            },
            tooltip: '更多操作',
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyConversation(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Ionicons.chatbubble,
            size: 80,
            color: Colors.grey.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            '没有消息',
            style: TextStyle(fontSize: 18, color: Colors.grey.withOpacity(0.8)),
          ),
          const SizedBox(height: 8),
          Text(
            '发送一条消息开始对话',
            style: TextStyle(fontSize: 14, color: Colors.grey.withOpacity(0.6)),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList(
    BuildContext context,
    List<MessageEntity> messages,
  ) {
    // 计算消息区域实际宽度
    final messageAreaWidth = MediaQuery.of(context).size.width - 252;

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isMe = message.isFromUser;

        // 显示日期分隔
        final showDate =
            index == 0 ||
            _shouldShowDateSeparator(
              messages[index - 1].timestamp,
              message.timestamp,
            );

        return Column(
          children: [
            if (showDate) _buildDateSeparator(message.timestamp),
            MessageBubble(
              message: message,
              isMe: isMe,
              maxWidth: messageAreaWidth * 0.72,
            ),
          ],
        );
      },
    );
  }

  bool _shouldShowDateSeparator(DateTime previous, DateTime current) {
    return previous.year != current.year ||
        previous.month != current.month ||
        previous.day != current.day;
  }

  Widget _buildDateSeparator(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(date.year, date.month, date.day);

    String dateText;
    if (messageDate == today) {
      dateText = '今天';
    } else if (messageDate == yesterday) {
      dateText = '昨天';
    } else {
      dateText = '${date.year}年${date.month}月${date.day}日';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            dateText,
            style: TextStyle(fontSize: 12, color: Colors.grey.withOpacity(0.8)),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageComposer(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: theme.scaffoldBackgroundColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end, // 关键：底部对齐
        children: [
          // 附件按钮
          Container(
            height: 32, // 固定高度
            alignment: Alignment.bottomCenter,
            child: IconButton(
              iconSize: 16,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              icon: const Icon(Icons.attach_file),
              onPressed: () {
                // 处理附件
              },
              tooltip: '添加附件(暂不支持)',
            ),
          ),

          const SizedBox(width: 8),

          // 消息输入框 - 允许扩展但有最大高度限制
          Expanded(
            child: Container(
              constraints: const BoxConstraints(maxHeight: 120), // 限制最大高度
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: '输入消息...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  // 在输入框内部右侧添加表情按钮
                  suffixIcon: SimpleIconButton(
                    size: 16,
                    icon: Icons.emoji_emotions_outlined,
                    onPressed: () {},
                  ),
                  isDense: true, // 使输入框更紧凑
                ),
                maxLines: null, // 允许多行
                minLines: 1, // 最少一行
                textInputAction: TextInputAction.newline, // 允许换行
                keyboardType: TextInputType.multiline, // 多行输入
                onChanged: (text) {
                  setState(() {
                    _isComposing = text.trim().isNotEmpty;
                  });
                },
              ),
            ),
          ),

          const SizedBox(width: 8),

          // 语音/发送按钮
          Container(
            height: 32, // 固定高度
            alignment: Alignment.bottomCenter,
            child: IconButton(
              iconSize: 16,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              icon:
                  _isComposing ? const Icon(Icons.send) : const Icon(Icons.mic),
              color:
                  _isComposing
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
              onPressed:
                  _isComposing
                      ? () => _handleSubmitted(_messageController.text)
                      : () {
                        // 处理语音输入
                        print('开始语音输入');
                      },
              tooltip: _isComposing ? '发送' : '语音输入(暂不支持)',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyConversationView() {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 100,
            color: Colors.grey.withOpacity(0.5),
          ),
          const SizedBox(height: 24),
          Text(
            "请选择一个会话或创建新的会话",
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.grey.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "在左侧列表选择一个会话，或点击 + 按钮创建新会话",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return;

    _messageController.clear();
    setState(() {
      _isComposing = false;
    });

    // 使用Provider发送消息
    ref.read(chatStateProvider.notifier).sendMessage(text);

    // 滚动到底部查看新消息
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }
}
