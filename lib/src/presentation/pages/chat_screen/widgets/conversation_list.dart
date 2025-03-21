import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mtp/src/presentation/providers/chat/chat_provider.dart';
import 'package:mtp/src/presentation/providers/role/role_provider.dart';
import 'conversation_list_item.dart';

class ConversationList extends ConsumerWidget {
  const ConversationList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 使用Provider获取会话列表和状态
    final chatState = ref.watch(chatStateProvider);
    final filteredSessions = ref.watch(filteredSessionsProvider);
    final roleState = ref.watch(roleStateProvider);
    final selectedSessionIndex = chatState.selectedSessionIndex;
    print(
      '会话列表构建: 总共${chatState.sessions.length}个会话，过滤后${filteredSessions.length}个',
    );

    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          // header with search
          Container(
            color: Theme.of(context).colorScheme.surfaceContainer,
            padding: const EdgeInsets.only(
              top: 28,
              bottom: 20,
              left: 16,
              right: 16,
            ),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 32,
                    child: SearchBar(
                      leading: const Icon(Icons.search, size: 16),
                      hintText: "搜索对话",
                      hintStyle: WidgetStateProperty.all(
                        TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          height: 1.0,
                        ),
                      ),
                      textStyle: WidgetStateProperty.all(
                        const TextStyle(fontSize: 12, height: 1.0), // 确保输入文本也居中
                      ),
                      backgroundColor: WidgetStateProperty.all(
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                      ),
                      shadowColor: WidgetStateProperty.all(Colors.transparent),
                      elevation: WidgetStateProperty.all(0),
                      // padding: WidgetStateProperty.all(
                      //   EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      // ),
                      constraints: const BoxConstraints(
                        maxHeight: 32, // 添加最大高度约束
                        minHeight: 32, // 添加最小高度约束
                      ),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onChanged: (value) {
                        ref
                            .read(chatStateProvider.notifier)
                            .setSearchQuery(value);
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  iconSize: 16,
                  icon: const Icon(Icons.add_comment_rounded),
                  onPressed: () {
                    // 创建新会话的逻辑，可以打开一个对话框
                    _showNewConversationDialog(context, ref);
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      Theme.of(context).colorScheme.surfaceContainerHighest,
                    ),
                    minimumSize: WidgetStateProperty.all(const Size(32, 32)),
                    maximumSize: WidgetStateProperty.all(const Size(32, 32)),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  tooltip: "新建对话",
                ),
              ],
            ),
          ),

          // 会话列表
          Expanded(
            child:
                chatState.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : filteredSessions.isEmpty
                    ? chatState.searchQuery.isEmpty
                        ? _buildNoConversations() // 无搜索且列表为空 - 显示"没有会话"
                        : _buildEmptySearchResult(
                          chatState.searchQuery,
                        ) // 有搜索但无结果
                    : ListView.builder(
                      itemCount: filteredSessions.length,
                      itemBuilder: (context, index) {
                        final session = filteredSessions[index];
                        final originalIndex = chatState.sessions.indexOf(
                          session,
                        );

                        // 根据 roleId 获取角色信息
                        final role =
                            roleState.roles.isEmpty
                                ? null
                                : roleState.roles.firstWhere(
                                  (role) => role.id == session.roleId,
                                  orElse: () => roleState.roles.first,
                                );

                        // 计算未读消息数量
                        final unreadCount =
                            session.messages
                                .where((msg) => !msg.isRead && !msg.isFromUser)
                                .length;

                        // 确定是否活跃 (最近10分钟有新消息)
                        final isActive =
                            session.updatedAt != null &&
                            DateTime.now()
                                    .difference(session.updatedAt!)
                                    .inMinutes <
                                10;

                        // 获取角色头像
                        String? avatarUrl;
                        if (role != null && role.avatars.isNotEmpty) {
                          avatarUrl = role.avatars.first;
                        }

                        return Column(
                          children: [
                            ConversationListItem(
                              title: session.title,
                              lastMessage:
                                  session.messages.isNotEmpty
                                      ? session.messages.last.content
                                      : "",
                              timestamp: session.updatedAt ?? DateTime.now(),
                              avatarUrl: avatarUrl, // 这里可以从角色数据中获取
                              unreadCount: unreadCount, // 从会话数据中获取
                              isActive: isActive, // 从用户状态中获取
                              isSelected: selectedSessionIndex == originalIndex,
                              onTap: () {
                                // 使用Provider选择会话
                                ref
                                    .read(chatStateProvider.notifier)
                                    .selectSession(originalIndex);
                              },
                            ),
                          ],
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  // 无搜索结果时显示的界面
  Widget _buildEmptySearchResult(String query) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey.withOpacity(0.5)),
          const SizedBox(height: 16),
          Text(
            "未找到匹配\"$query\"的对话",
            style: TextStyle(color: Colors.grey.withOpacity(0.8), fontSize: 16),
          ),
        ],
      ),
    );
  }

  // 新建会话对话框
  void _showNewConversationDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('新建对话'),
            content: TextField(
              controller: titleController,
              decoration: const InputDecoration(hintText: '请输入对话标题'),
              autofocus: true,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('取消'),
              ),
              TextButton(
                onPressed: () {
                  if (titleController.text.trim().isNotEmpty) {
                    ref
                        .read(chatStateProvider.notifier)
                        .createSession(
                          titleController.text,
                          'default', // 默认角色ID
                        );
                    Navigator.pop(context);
                  }
                },
                child: const Text('创建'),
              ),
            ],
          ),
    );
  }
}

// 添加这个新方法来显示"没有会话"的状态
Widget _buildNoConversations() {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.chat_bubble_outline,
          size: 64,
          color: Colors.grey.withOpacity(0.5),
        ),
        const SizedBox(height: 16),
        Text(
          "暂无对话",
          style: TextStyle(color: Colors.grey.withOpacity(0.8), fontSize: 16),
        ),
        const SizedBox(height: 8),
        Text(
          "点击右上角按钮创建新对话",
          style: TextStyle(color: Colors.grey.withOpacity(0.6), fontSize: 14),
        ),
      ],
    ),
  );
}
