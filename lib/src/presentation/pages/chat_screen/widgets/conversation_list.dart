import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mtp/src/domain/entities/role_entity.dart';
import 'package:mtp/src/presentation/providers/chat/chat_provider.dart';
import 'package:mtp/src/presentation/providers/role/role_provider.dart';
import 'package:mtp/src/utils/logger.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
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
                      leading: const Icon(Ionicons.search, size: 16),
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
                  icon: const Icon(Ionicons.person_add),
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
                  tooltip: "新建角色",
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
    // final sessionTitleController = TextEditingController();
    final roleNameController = TextEditingController();
    final rolePromptController = TextEditingController();
    File? selectedAvatar;
    String? avatarPath;
    bool isCreating = false;
    final uuid = Uuid();

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

            // 表单验证
            bool isFormValid() {
              // return sessionTitleController.text.trim().isNotEmpty &&
              //     roleNameController.text.trim().isNotEmpty;
              return roleNameController.text.trim().isNotEmpty;
            }

            // 创建会话和角色
            Future<void> createSessionAndRole() async {
              if (!isFormValid()) {
                localLogger.warning('表单');
                return;
              }

              setState(() {
                isCreating = true;
              });

              try {
                // 保存头像（如果有）
                if (selectedAvatar != null) {
                  avatarPath = await _saveRoleAvatar(selectedAvatar!);
                }

                // 创建角色
                final roleId = uuid.v4();
                final newRole = RoleEntity(
                  id: roleId,
                  name: roleNameController.text.trim(),
                  prompt: rolePromptController.text.trim(),
                  avatars: avatarPath != null ? [avatarPath!] : [],
                  lastMessage: '',
                );

                await ref.read(roleStateProvider.notifier).addRole(newRole);

                // 创建会话
                await ref
                    .read(chatStateProvider.notifier)
                    .createSession(roleNameController.text.trim(), roleId);
                // .createSession(sessionTitleController.text.trim(), roleId);

                Navigator.of(context).pop();
              } catch (e) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('创建失败: $e')));
              } finally {
                setState(() {
                  isCreating = false;
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
                      '创建新角色',
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    // 会话信息部分
                    // Text(
                    //   '会话信息',
                    //   style: Theme.of(context).textTheme.titleMedium,
                    // ),
                    // const SizedBox(height: 12),
                    // TextField(
                    //   controller: sessionTitleController,
                    //   decoration: const InputDecoration(
                    //     labelText: '会话标题',
                    //     hintText: '请输入会话标题',
                    //     border: OutlineInputBorder(),
                    //     prefixIcon: Icon(Icons.chat),
                    //   ),
                    // ),
                    // const SizedBox(height: 24),

                    // 角色信息部分
                    Text(
                      '创建新角色',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),

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
                                    : null,
                          ),
                          child:
                              selectedAvatar == null
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
                              isCreating ? null : () => Navigator.pop(context),
                          child: const Text('取消'),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: isCreating ? null : createSessionAndRole,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor:
                                Theme.of(context).colorScheme.onPrimary,
                          ),
                          child:
                              isCreating
                                  ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                  : const Text('创建'),
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

  // // 新建会话对话框
  // void _showNewConversationDialog(BuildContext context, WidgetRef ref) {
  //   final titleController = TextEditingController();

  //   showDialog(
  //     context: context,
  //     builder:
  //         (context) => AlertDialog(
  //           title: const Text('新建对话'),
  //           content: TextField(
  //             controller: titleController,
  //             decoration: const InputDecoration(hintText: '请输入对话标题'),
  //             autofocus: true,
  //           ),
  //           actions: [
  //             TextButton(
  //               onPressed: () => Navigator.pop(context),
  //               child: const Text('取消'),
  //             ),
  //             TextButton(
  //               onPressed: () {
  //                 if (titleController.text.trim().isNotEmpty) {
  //                   ref
  //                       .read(chatStateProvider.notifier)
  //                       .createSession(
  //                         titleController.text,
  //                         'default', // 默认角色ID
  //                       );
  //                   Navigator.pop(context);
  //                 }
  //               },
  //               child: const Text('创建'),
  //             ),
  //           ],
  //         ),
  //   );
  // }
}

// 添加这个新方法来显示"没有会话"的状态
Widget _buildNoConversations() {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Ionicons.chatbubble,
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
