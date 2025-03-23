import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mtp/src/domain/entities/message_entity.dart';
import 'package:mtp/src/domain/entities/role_entity.dart';
import 'package:mtp/src/domain/entities/session_entity.dart';
import 'package:mtp/src/presentation/providers/chat/chat_provider.dart';
import 'package:mtp/src/presentation/providers/role/role_provider.dart';
import 'package:mtp/src/presentation/widgets/simple_icon_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
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
  final GlobalKey _headerKey = GlobalKey();
  double _headerHeight = 0;

  @override
  void initState() {
    super.initState();
    // 在下一帧计算标题栏高度
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateHeaderHeight();
    });
  }

  // 计算标题栏高度
  void _calculateHeaderHeight() {
    if (_headerKey.currentContext != null) {
      final RenderBox renderBox =
          _headerKey.currentContext!.findRenderObject() as RenderBox;
      setState(() {
        _headerHeight = renderBox.size.height;
      });
    }
  }

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

    // 使用Scaffold来支持endDrawer
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      endDrawer: _buildRoleManagementDrawer(context, currentSession.roleId),
      onEndDrawerChanged: (isOpened) {
        if (!isOpened) {
          // 抽屉关闭时重新计算标题栏高度
          _calculateHeaderHeight();
        }
      },
      // 移除默认的抽屉按钮
      appBar: PreferredSize(
        preferredSize: Size.zero,
        child: AppBar(automaticallyImplyLeading: false),
      ),
      body: Column(
        children: [
          // 对话标题栏
          _buildHeader(context, title, isActive, avatarUrl, role),

          // 消息列表
          Expanded(
            child:
                messages.isEmpty
                    ? _buildEmptyConversation(context)
                    : _buildMessagesList(context, messages),
          ),

          // 分隔线
          // Divider(height: 1, color: theme.dividerColor),

          // 消息输入区域
          _buildMessageComposer(context),
        ],
      ),
    );
  }

  // 角色管理抽屉
  Widget _buildRoleManagementDrawer(
    BuildContext context,
    String? currentRoleId,
  ) {
    final screenHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final roleState = ref.watch(roleStateProvider);

    // 获取当前角色
    final currentRole =
        currentRoleId != null && roleState.roles.isNotEmpty
            ? roleState.roles.firstWhere(
              (r) => r.id == currentRoleId,
              orElse: () => roleState.roles.first,
            )
            : null;

    if (currentRole == null) {
      return const Drawer(child: Center(child: Text("没有找到当前角色信息")));
    }

    ImageProvider<Object>? currentRoleAvatar =
        currentRole.avatars.isNotEmpty
            ? (currentRole.avatars.first.startsWith('http')
                ? NetworkImage(currentRole.avatars.first)
                : FileImage(File(currentRole.avatars.first)))
            : null;

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(8),
        bottomLeft: Radius.circular(8),
      ),
      child: Drawer(
        width: 300,
        // 设置抽屉高度为屏幕高度减去标题栏高度
        child: Container(
          height: screenHeight - _headerHeight,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 抽屉标题
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("角色信息", style: theme.textTheme.titleLarge),
                    // IconButton(
                    //   icon: const Icon(Icons.close),
                    //   onPressed: () => Navigator.of(context).pop(),
                    //   tooltip: "关闭",
                    // ),
                  ],
                ),
              ),

              // 使用Expanded和SingleChildScrollView包裹主要内容，使其可滚动
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 角色头像区域
                      Center(
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 48,
                              backgroundImage: currentRoleAvatar,
                              child:
                                  currentRole.avatars.isEmpty
                                      ? Text(
                                        currentRole.name.isNotEmpty
                                            ? currentRole.name[0].toUpperCase()
                                            : '?',
                                        style: theme.textTheme.headlineMedium,
                                      )
                                      : null,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              currentRole.name,
                              style: theme.textTheme.titleLarge,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 16),

                      // 角色详细信息
                      Text("角色信息", style: theme.textTheme.titleMedium),
                      const SizedBox(height: 8),

                      // 提示词区域
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "提示词",
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              currentRole.prompt.isEmpty
                                  ? "未设置提示词"
                                  : currentRole.prompt,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // 最后一条消息
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "最近消息",
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              currentRole.lastMessage.isEmpty
                                  ? "暂无消息记录"
                                  : currentRole.lastMessage,
                              style: theme.textTheme.bodyMedium,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),

                      // 添加足够的底部空间，防止底部按钮遮挡
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              // 操作按钮区域 - 保持在滚动区域外
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Column(
                  children: [
                    // 清除历史记录按钮
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        icon: const Icon(Ionicons.trash),
                        label: const Text("清除历史记录"),
                        onPressed: () {
                          Navigator.pop(context);
                          _showClearHistoryConfirmation(context);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: theme.colorScheme.error,
                          side: BorderSide(
                            color: theme.colorScheme.error.withOpacity(0.5),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // 编辑与删除按钮行
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.edit),
                          label: const Text("编辑角色"),
                          onPressed: () {
                            Navigator.pop(context);
                            _showEditRoleDialog(context, currentRole);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: theme.colorScheme.onPrimary,
                          ),
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.delete_outline),
                          label: const Text("删除角色"),
                          onPressed: () {
                            if (currentRole.id != null) {
                              final currentSession = ref.watch(
                                currentSessionProvider,
                              );
                              if (currentSession != null) {
                                _showDeleteRoleConfirmation(
                                  context,
                                  currentRole.id!,
                                  currentSession.id!,
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('无法删除：找不到当前会话')),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.errorContainer,
                            foregroundColor: theme.colorScheme.onErrorContainer,
                          ),
                        ),
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

  // 显示编辑角色对话框
  void _showEditRoleDialog(BuildContext context, RoleEntity role) {
    final roleNameController = TextEditingController(text: role.name);
    final rolePromptController = TextEditingController(text: role.prompt);
    File? selectedAvatar;
    String? avatarPath;
    bool isUpdating = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            // 选择头像方法
            Future<void> pickImage() async {
              final ImagePicker picker = ImagePicker();
              final XFile? image = await picker.pickImage(
                source: ImageSource.gallery,
              );

              if (image != null) {
                setState(() {
                  selectedAvatar = File(image.path);
                });
              }
            }

            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Container(
                width: 400,
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 标题
                    Text(
                      '编辑角色',
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    // 角色头像
                    Center(
                      child: GestureDetector(
                        onTap: pickImage,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color:
                                Theme.of(
                                  context,
                                ).colorScheme.surfaceContainerHighest,
                            shape: BoxShape.circle,
                            image:
                                selectedAvatar != null
                                    ? DecorationImage(
                                      image: FileImage(selectedAvatar!),
                                      fit: BoxFit.cover,
                                    )
                                    : role.avatars.isNotEmpty
                                    ? DecorationImage(
                                      image: FileImage(
                                        File(role.avatars.first),
                                      ),
                                      fit: BoxFit.cover,
                                    )
                                    : null,
                          ),
                          child:
                              selectedAvatar == null && role.avatars.isEmpty
                                  ? Icon(
                                    Icons.add_a_photo,
                                    size: 40,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  )
                                  : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 角色名称
                    TextField(
                      controller: roleNameController,
                      decoration: const InputDecoration(
                        labelText: '角色名称',
                        hintText: '请输入角色名称',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // 角色提示词
                    TextField(
                      controller: rolePromptController,
                      decoration: const InputDecoration(
                        labelText: '角色提示词',
                        hintText: '请输入角色提示词（可选）',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.psychology),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 24),

                    // 按钮
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed:
                              isUpdating ? null : () => Navigator.pop(context),
                          child: const Text('取消'),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed:
                              isUpdating
                                  ? null
                                  : () async {
                                    if (roleNameController.text
                                        .trim()
                                        .isEmpty) {
                                      return;
                                    }

                                    setState(() {
                                      isUpdating = true;
                                    });

                                    try {
                                      // 保存头像（如果有新选择的）
                                      if (selectedAvatar != null) {
                                        avatarPath = await _saveRoleAvatar(
                                          selectedAvatar!,
                                        );
                                      }

                                      // 更新角色
                                      final updatedRole = RoleEntity(
                                        id: role.id,
                                        name: roleNameController.text.trim(),
                                        prompt:
                                            rolePromptController.text.trim(),
                                        avatars:
                                            avatarPath != null
                                                ? [avatarPath!]
                                                : role.avatars,
                                        lastMessage: role.lastMessage,
                                      );

                                      await ref
                                          .read(roleStateProvider.notifier)
                                          .updateRole(updatedRole);
                                      Navigator.of(context).pop();
                                    } catch (e) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(content: Text('更新失败: $e')),
                                      );
                                    } finally {
                                      if (mounted) {
                                        setState(() {
                                          isUpdating = false;
                                        });
                                      }
                                    }
                                  },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor:
                                Theme.of(context).colorScheme.onPrimary,
                          ),
                          child:
                              isUpdating
                                  ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                  : const Text('保存'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // 显示删除角色确认对话框
  void _showDeleteRoleConfirmation(
    BuildContext context,
    String roleId,
    String sessionId,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("删除角色"),
            content: const Text("确定要删除这个角色吗？与该角色的所有对话也会被删除。"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("取消"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // 关闭确认对话框
                  Navigator.pop(context); // 关闭角色管理抽屉
                  ref.read(roleStateProvider.notifier).deleteRole(roleId);
                  ref.read(chatStateProvider.notifier).deleteSession(sessionId);
                },
                child: const Text("删除", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  // 显示清除历史记录确认对话框
  void _showClearHistoryConfirmation(BuildContext context) {
    final currentSession = ref.read(currentSessionProvider);
    if (currentSession == null) return;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("清除历史记录"),
            content: const Text("确定要清除所有聊天记录吗？此操作不可撤销，但会保留会话本身。"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("取消"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _clearChatHistory(currentSession);
                },
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                ),
                child: const Text("清除"),
              ),
            ],
          ),
    );
  }

  // 清除聊天历史记录的方法
  void _clearChatHistory(SessionEntity session) {
    if (session.id == null) return;

    // 创建一个新会话，保留原有信息但清空消息
    final clearedSession = session.copyWith(
      messages: [],
      updatedAt: DateTime.now(),
    );

    // 更新会话
    ref.read(chatStateProvider.notifier).importSession(clearedSession);

    // 显示提示
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('聊天记录已清除')));
  }

  Widget _buildHeader(
    BuildContext context,
    String title,
    bool isActive,
    String? avatarUrl,
    RoleEntity? role,
  ) {
    final theme = Theme.of(context);
    final isMobile = Platform.isAndroid || Platform.isIOS;

    return Container(
      key: _headerKey, // 添加key以测量高度
      padding:
          isMobile
              ? const EdgeInsets.only(top: 28, left: 8, right: 8, bottom: 12)
              : const EdgeInsets.only(top: 28, bottom: 12, left: 16, right: 16),
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
          if (isMobile)
            IconButton(
              onPressed: () => GoRouter.of(context).pop(),
              icon: Icon(Ionicons.chevron_back),
            ),
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
                        image:
                            avatarUrl.startsWith('http')
                                ? NetworkImage(avatarUrl)
                                : FileImage(File(avatarUrl)),
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
                if (role != null)
                  Text(
                    role.name,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
              ],
            ),
          ),

          // 操作按钮 - 修改为打开抽屉
          Builder(
            builder:
                (context) => IconButton(
                  iconSize: 16,
                  constraints: BoxConstraints(maxHeight: 32, maxWidth: 32),
                  icon: const Icon(Ionicons.ellipsis_horizontal),
                  onPressed: () {
                    // 打开右侧抽屉
                    Scaffold.of(context).openEndDrawer();
                  },
                  tooltip: '角色管理',
                ),
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
    final isMobile = Platform.isAndroid || Platform.isIOS;
    // 计算消息区域实际宽度
    final messageAreaWidth =
        MediaQuery.of(context).size.width - (isMobile ? 0 : 252);

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
              maxWidth: messageAreaWidth * 0.7,
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
      color: theme.primaryColor.withAlpha(5),
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
            Ionicons.chatbox,
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

  // 保存角色头像到本地
  Future<String?> _saveRoleAvatar(File imageFile) async {
    try {
      // 获取应用文档目录
      final appDir = await getApplicationDocumentsDirectory();

      // 创建角色头像目录
      final avatarDir = Directory('${appDir.path}/role_avatars');
      if (!await avatarDir.exists()) {
        await avatarDir.create(recursive: true);
      }

      // 创建唯一的文件名
      final fileName =
          'role_avatar_${DateTime.now().millisecondsSinceEpoch}${path.extension(imageFile.path)}';
      final savedImagePath = '${avatarDir.path}/$fileName';

      // 复制图片到应用目录
      final savedFile = await imageFile.copy(savedImagePath);
      return savedFile.path;
    } catch (e) {
      print('保存角色头像失败: $e');
      return null;
    }
  }
}
