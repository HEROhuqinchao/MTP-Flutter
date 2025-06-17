import 'dart:io';

import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mtp/src/core/utils/immersive_mode.dart';
import 'package:mtp/src/core/widgets/message_bubble.dart';
import 'package:mtp/src/features/chat/domain/entities/chat_message_entity.dart';
import 'package:mtp/src/features/role/domain/entities/role_entity.dart';
import 'package:mtp/src/features/chat/presentation/providers/chat_provider.dart';
import 'package:mtp/src/features/role/persentation/providers/role_provider.dart';
import 'package:mtp/src/core/widgets/simple_icon_button.dart';
import 'package:collection/collection.dart';

class ChatDetailScreen extends ConsumerStatefulWidget {
  const ChatDetailScreen({super.key});

  @override
  ConsumerState<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends ConsumerState<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isComposing = false;
  final GlobalKey _headerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _updateStatusBarColor();
      }
    });
  }

  void _updateStatusBarColor() {
    final brightness = Theme.of(context).brightness;
    final headerColor = Theme.of(context).colorScheme.surface;

    ImmersiveMode.set(
      statusBarColor: headerColor,
      isDark: brightness == Brightness.dark,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateStatusBarColor();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients &&
        _scrollController.position.hasContentDimensions) {
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
    final chatState = ref.watch(sessionStateProvider);
    final activeSession = chatState.currentSession;

    ref.listen<String?>(
      sessionStateProvider.select((value) => value.errorMessage),
      (previous, next) {
        if (next != null && next.isNotEmpty) {
          ElegantNotification.error(
            title: const Text('发生错误'),
            description: Text(next),
            icon: const Icon(Ionicons.sad_outline),
            position: Alignment.bottomRight,
          ).show(context);
          ref.read(sessionStateProvider.notifier).clearErrorMessage();
        }
      },
    );

    if (activeSession == null) {
      return _buildEmptyConversationView();
    }

    final roleState = ref.watch(roleStateProvider);
    final messages = activeSession.messages;
    final title = activeSession.title;

    // 使用最后一条消息的创建时间来判断活跃状态
    final DateTime? lastMessageTime =
        activeSession.messages.lastOrNull?.createdAt;
    final bool isActive =
        lastMessageTime != null &&
        DateTime.now().difference(lastMessageTime).inMinutes < 10;

    // 从 roleIds 获取第一个角色用于显示
    final String? currentDisplayRoleId = activeSession.roleIds.firstOrNull;
    final RoleEntity? displayRole =
        roleState.roles.isNotEmpty && currentDisplayRoleId != null
            ? roleState.roles.firstWhereOrNull(
              // 使用 firstWhereOrNull 避免异常
              (role) => role.id == currentDisplayRoleId,
            )
            : null;

    String? avatarUrl = activeSession.avatar; // 优先使用会话头像
    if (avatarUrl == null || avatarUrl.isEmpty) {
      // 如果会话头像为空，则尝试使用角色的头像
      if (displayRole != null && displayRole.avatars.isNotEmpty) {
        avatarUrl = displayRole.avatars.first;
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      // endDrawer:
      //     currentDisplayRoleId != null &&
      //             displayRole !=
      //                 null // 确保 displayRole 也存在
      //         ? _buildRoleManagementDrawer(
      //           context,
      //           displayRole,
      //           activeSession,
      //         ) // 传递 RoleEntity
      //         : null,
      appBar: PreferredSize(
        preferredSize: Size.zero,
        child: AppBar(automaticallyImplyLeading: false),
      ),
      body: Column(
        children: [
          _buildHeader(context, title, isActive, avatarUrl, displayRole),
          Expanded(
            child:
                messages.isEmpty
                    ? _buildEmptyConversation(context)
                    : _buildMessagesList(context, messages),
          ),
          _buildMessageComposer(context),
        ],
      ),
    );
  }

  // Widget _buildRoleManagementDrawer(
  //   BuildContext context,
  //   RoleEntity currentRole, // 直接接收 RoleEntity
  //   ActiveSessionEntity activeSession,
  // ) {
  //   final theme = Theme.of(context);
  //   // final roleState = ref.watch(roleStateProvider); // currentRole 已经传入

  //   ImageProvider<Object>? currentRoleAvatar =
  //       currentRole.avatars.isNotEmpty
  //           ? (currentRole.avatars.first.startsWith('http')
  //               ? NetworkImage(currentRole.avatars.first)
  //               : FileImage(File(currentRole.avatars.first)))
  //           : null;

  //   final isMobile = Platform.isAndroid || Platform.isIOS;
  //   final screenWidth = MediaQuery.of(context).size.width;
  //   final width = isMobile ? screenWidth : 300.0;

  //   final String lastMessageContent =
  //       activeSession.messages.lastOrNull?.content ?? "暂无消息记录";

  //   return Material(
  //     borderRadius:
  //         isMobile
  //             ? BorderRadius.zero
  //             : const BorderRadius.only(
  //               topLeft: Radius.circular(8),
  //               bottomLeft: Radius.circular(8),
  //             ),
  //     child: SizedBox(
  //       width: width,
  //       child: Container(
  //         padding: const EdgeInsets.all(16),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Padding(
  //               padding: const EdgeInsets.only(bottom: 16),
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Text("角色信息", style: theme.textTheme.titleLarge),
  //                   if (isMobile)
  //                     IconButton(
  //                       icon: const Icon(Icons.close),
  //                       onPressed: () => GoRouter.of(context).pop(),
  //                       tooltip: "关闭",
  //                     ),
  //                 ],
  //               ),
  //             ),
  //             Expanded(
  //               child: SingleChildScrollView(
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Center(
  //                       child: Column(
  //                         children: [
  //                           CircleAvatar(
  //                             radius: 48,
  //                             backgroundImage: currentRoleAvatar,
  //                             child:
  //                                 currentRole.avatars.isEmpty
  //                                     ? Text(
  //                                       currentRole.name.isNotEmpty
  //                                           ? currentRole.name[0].toUpperCase()
  //                                           : '?',
  //                                       style: theme.textTheme.headlineMedium,
  //                                     )
  //                                     : null,
  //                           ),
  //                           const SizedBox(height: 16),
  //                           Text(
  //                             currentRole.name,
  //                             style: theme.textTheme.titleLarge,
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                     const SizedBox(height: 24),
  //                     const Divider(),
  //                     const SizedBox(height: 16),
  //                     Text("角色详细信息", style: theme.textTheme.titleMedium),
  //                     const SizedBox(height: 8),
  //                     Container(
  //                       padding: const EdgeInsets.all(12),
  //                       decoration: BoxDecoration(
  //                         color: theme.colorScheme.surfaceContainerHighest,
  //                         borderRadius: BorderRadius.circular(8),
  //                       ),
  //                       child: Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Text(
  //                             "提示词",
  //                             style: theme.textTheme.labelLarge?.copyWith(
  //                               color: theme.colorScheme.primary,
  //                             ),
  //                           ),
  //                           const SizedBox(height: 4),
  //                           Text(
  //                             currentRole.prompt == null ||
  //                                     currentRole.prompt!.isEmpty
  //                                 ? "未设置提示词"
  //                                 : currentRole.prompt!,
  //                             style: theme.textTheme.bodyMedium,
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                     const SizedBox(height: 16),
  //                     Container(
  //                       padding: const EdgeInsets.all(12),
  //                       decoration: BoxDecoration(
  //                         color: theme.colorScheme.surfaceContainerHighest,
  //                         borderRadius: BorderRadius.circular(8),
  //                       ),
  //                       child: Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Text(
  //                             "最近消息",
  //                             style: theme.textTheme.labelLarge?.copyWith(
  //                               color: theme.colorScheme.primary,
  //                             ),
  //                           ),
  //                           const SizedBox(height: 4),
  //                           Text(
  //                             lastMessageContent,
  //                             style: theme.textTheme.bodyMedium,
  //                             maxLines: 2,
  //                             overflow: TextOverflow.ellipsis,
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                     const SizedBox(height: 20),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             Padding(
  //               padding: const EdgeInsets.only(top: 16),
  //               child: Column(
  //                 children: [
  //                   SizedBox(
  //                     width: double.infinity,
  //                     child: OutlinedButton.icon(
  //                       icon: const Icon(Ionicons.trash_outline),
  //                       label: const Text("清除历史记录"),
  //                       onPressed: () {
  //                         GoRouter.of(context).pop();
  //                         _showClearHistoryConfirmation(context, activeSession);
  //                       },
  //                       style: OutlinedButton.styleFrom(
  //                         foregroundColor: theme.colorScheme.error,
  //                         side: BorderSide(
  //                           color: theme.colorScheme.error.withAlpha(120),
  //                         ),
  //                         padding: const EdgeInsets.symmetric(vertical: 10),
  //                       ),
  //                     ),
  //                   ),
  //                   const SizedBox(height: 16),
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                     children: [
  //                       ElevatedButton.icon(
  //                         icon: const Icon(Icons.edit_outlined),
  //                         label: const Text("编辑角色"),
  //                         onPressed: () {
  //                           GoRouter.of(context).pop();
  //                           _showEditRoleDialog(context, currentRole);
  //                         },
  //                         style: ElevatedButton.styleFrom(
  //                           backgroundColor: theme.colorScheme.primary,
  //                           foregroundColor: theme.colorScheme.onPrimary,
  //                         ),
  //                       ),
  //                       ElevatedButton.icon(
  //                         icon: const Icon(Icons.delete_outline),
  //                         label: const Text("删除角色"),
  //                         onPressed: () {
  //                           if (activeSession.id.isNotEmpty &&
  //                               currentRole.id != null) {
  //                             _showDeleteRoleConfirmation(
  //                               context,
  //                               currentRole.id!,
  //                               activeSession.id,
  //                             );
  //                           } else {
  //                             ElegantNotification.error(
  //                               title: const Text('发生错误'),
  //                               description: const Text('无法删除：缺少角色或会话信息'),
  //                               icon: const Icon(Ionicons.sad_outline),
  //                               position:
  //                                   isMobile
  //                                       ? Alignment.topCenter
  //                                       : Alignment.bottomRight,
  //                               animation:
  //                                   isMobile
  //                                       ? AnimationType.fromTop
  //                                       : AnimationType.fromRight,
  //                             ).show(context);
  //                           }
  //                         },
  //                         style: ElevatedButton.styleFrom(
  //                           backgroundColor: theme.colorScheme.errorContainer,
  //                           foregroundColor: theme.colorScheme.onErrorContainer,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // void _showEditRoleDialog(BuildContext context, RoleEntity role) {
  //   final roleNameController = TextEditingController(text: role.name);
  //   final rolePromptController = TextEditingController(text: role.prompt);
  //   File? selectedAvatarFile;
  //   bool isUpdating = false;

  //   if (!mounted) return;

  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return StatefulBuilder(
  //         builder: (context, setStateDialog) {
  //           Future<void> pickImage() async {
  //             final ImagePicker picker = ImagePicker();
  //             final XFile? image = await picker.pickImage(
  //               source: ImageSource.gallery,
  //             );
  //             if (image != null) {
  //               setStateDialog(() {
  //                 selectedAvatarFile = File(image.path);
  //               });
  //             }
  //           }

  //           return Dialog(
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(8),
  //             ),
  //             child: Container(
  //               width: 400,
  //               padding: const EdgeInsets.all(24),
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 crossAxisAlignment: CrossAxisAlignment.stretch,
  //                 children: [
  //                   Text(
  //                     '编辑角色',
  //                     style: Theme.of(context).textTheme.titleLarge,
  //                     textAlign: TextAlign.center,
  //                   ),
  //                   const SizedBox(height: 24),
  //                   Center(
  //                     child: GestureDetector(
  //                       onTap: pickImage,
  //                       child: Container(
  //                         width: 100,
  //                         height: 100,
  //                         decoration: BoxDecoration(
  //                           color:
  //                               Theme.of(
  //                                 context,
  //                               ).colorScheme.surfaceContainerHighest,
  //                           shape: BoxShape.circle,
  //                           image:
  //                               selectedAvatarFile != null
  //                                   ? DecorationImage(
  //                                     image: FileImage(selectedAvatarFile!),
  //                                     fit: BoxFit.cover,
  //                                   )
  //                                   : (role.avatars.isNotEmpty &&
  //                                           role.avatars.first.isNotEmpty
  //                                       ? DecorationImage(
  //                                         image:
  //                                             role.avatars.first.startsWith(
  //                                                   'http',
  //                                                 )
  //                                                 ? NetworkImage(
  //                                                   role.avatars.first,
  //                                                 )
  //                                                 : FileImage(
  //                                                       File(
  //                                                         role.avatars.first,
  //                                                       ),
  //                                                     )
  //                                                     as ImageProvider,
  //                                         fit: BoxFit.cover,
  //                                       )
  //                                       : null),
  //                         ),
  //                         child:
  //                             selectedAvatarFile == null &&
  //                                     (role.avatars.isEmpty ||
  //                                         role.avatars.first.isEmpty)
  //                                 ? Icon(
  //                                   Icons.add_a_photo_outlined,
  //                                   size: 40,
  //                                   color:
  //                                       Theme.of(context).colorScheme.primary,
  //                                 )
  //                                 : null,
  //                       ),
  //                     ),
  //                   ),
  //                   const SizedBox(height: 16),
  //                   TextField(
  //                     controller: roleNameController,
  //                     decoration: const InputDecoration(
  //                       labelText: '角色名称',
  //                       hintText: '请输入角色名称',
  //                       border: OutlineInputBorder(),
  //                       prefixIcon: Icon(Icons.person_outline),
  //                     ),
  //                   ),
  //                   const SizedBox(height: 12),
  //                   TextField(
  //                     controller: rolePromptController,
  //                     decoration: const InputDecoration(
  //                       labelText: '角色提示词',
  //                       hintText: '请输入角色提示词（可选）',
  //                       border: OutlineInputBorder(),
  //                       prefixIcon: Icon(Icons.psychology_outlined),
  //                     ),
  //                     maxLines: 3,
  //                   ),
  //                   const SizedBox(height: 24),
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.end,
  //                     children: [
  //                       TextButton(
  //                         onPressed:
  //                             isUpdating
  //                                 ? null
  //                                 : () => GoRouter.of(context).pop(),
  //                         child: const Text('取消'),
  //                       ),
  //                       const SizedBox(width: 16),
  //                       ElevatedButton(
  //                         onPressed:
  //                             isUpdating
  //                                 ? null
  //                                 : () async {
  //                                   if (roleNameController.text
  //                                       .trim()
  //                                       .isEmpty) {
  //                                     ElegantNotification.error(
  //                                       title: const Text('提示'),
  //                                       description: const Text('角色名称不能为空'),
  //                                     ).show(context);
  //                                     return;
  //                                   }
  //                                   setStateDialog(() {
  //                                     isUpdating = true;
  //                                   });
  //                                   try {
  //                                     String? finalAvatarPath;
  //                                     if (selectedAvatarFile != null) {
  //                                       finalAvatarPath = await _saveRoleAvatar(
  //                                         selectedAvatarFile!,
  //                                       );
  //                                     }
  //                                     final updatedRole = RoleEntity(
  //                                       id: role.id, // 确保 RoleEntity 有 id
  //                                       name: roleNameController.text.trim(),
  //                                       prompt:
  //                                           rolePromptController.text.trim(),
  //                                       avatars:
  //                                           finalAvatarPath != null
  //                                               ? [finalAvatarPath]
  //                                               : role.avatars,
  //                                       lastMessage: role.lastMessage,
  //                                     );
  //                                     await ref
  //                                         .read(roleStateProvider.notifier)
  //                                         .updateRole(updatedRole);
  //                                     if (mounted) GoRouter.of(context).pop();
  //                                   } catch (e) {
  //                                     ElegantNotification.error(
  //                                       title: const Text('发生错误'),
  //                                       description: Text('更新失败: $e'),
  //                                       icon: const Icon(Ionicons.sad_outline),
  //                                       position: Alignment.bottomRight,
  //                                     ).show(context);
  //                                   } finally {
  //                                     if (mounted) {
  //                                       setStateDialog(() {
  //                                         isUpdating = false;
  //                                       });
  //                                     }
  //                                   }
  //                                 },
  //                         style: ElevatedButton.styleFrom(
  //                           backgroundColor:
  //                               Theme.of(context).colorScheme.primary,
  //                           foregroundColor:
  //                               Theme.of(context).colorScheme.onPrimary,
  //                         ),
  //                         child:
  //                             isUpdating
  //                                 ? const SizedBox(
  //                                   width: 20,
  //                                   height: 20,
  //                                   child: CircularProgressIndicator(
  //                                     strokeWidth: 2,
  //                                     color: Colors.white,
  //                                   ),
  //                                 )
  //                                 : const Text('保存'),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  // void _showDeleteRoleConfirmation(
  //   BuildContext context,
  //   String roleId,
  //   String sessionId,
  // ) {
  //   showDialog(
  //     context: context,
  //     builder:
  //         (context) => AlertDialog(
  //           title: const Text("删除角色"),
  //           content: const Text(
  //             "确定要删除这个角色吗？这将会从当前会话中移除该角色，但不会删除会话本身。如果该角色未被其他会话使用，它将被彻底删除。",
  //           ), // 更新提示信息
  //           actions: [
  //             TextButton(
  //               onPressed: () => GoRouter.of(context).pop(),
  //               child: const Text("取消"),
  //             ),
  //             TextButton(
  //               onPressed: () async {
  //                 GoRouter.of(context).pop();

  //                 // 从会话中移除角色ID
  //                 await ref
  //                     .read(sessionStateProvider.notifier)
  //                     .removeRoleFromSession(sessionId, roleId);
  //                 // 尝试删除角色（如果不再被任何会话引用，角色仓库的实现应处理实际删除）
  //                 await ref.read(roleStateProvider.notifier).deleteRole(roleId);

  //                 // 刷新当前会话视图或导航
  //                 final chatNotifier = ref.read(sessionStateProvider.notifier);
  //                 final currentChatState = ref.read(sessionStateProvider);
  //                 if (currentChatState.currentSession?.id == sessionId) {
  //                   // 如果当前会话仍然是这个，重新加载它以反映角色变化
  //                   final selectedIndex = currentChatState.selectedSessionIndex;
  //                   if (selectedIndex != -1) {
  //                     await chatNotifier.selectSession(selectedIndex);
  //                   }
  //                 } else if (currentChatState.sessions.isEmpty ||
  //                     currentChatState.currentSession == null) {
  //                   if (mounted) GoRouter.of(context).go('/chat');
  //                 }
  //               },
  //               child: const Text(
  //                 "确认移除",
  //                 style: TextStyle(color: Colors.red),
  //               ), // 更改按钮文本
  //             ),
  //           ],
  //         ),
  //   );
  // }

  // void _showClearHistoryConfirmation(
  //   BuildContext context,
  //   ActiveSessionEntity activeSession,
  // ) {
  //   if (activeSession.id.isEmpty) return;

  //   showDialog(
  //     context: context,
  //     builder:
  //         (context) => AlertDialog(
  //           title: const Text("清除历史记录"),
  //           content: const Text("确定要清除当前会话的所有聊天记录吗？此操作不可撤销，但会保留会话本身。"),
  //           actions: [
  //             TextButton(
  //               onPressed: () => GoRouter.of(context).pop(),
  //               child: const Text("取消"),
  //             ),
  //             TextButton(
  //               onPressed: () {
  //                 GoRouter.of(context).pop();
  //                 _clearChatHistory(activeSession.id);
  //               },
  //               style: TextButton.styleFrom(
  //                 foregroundColor: Theme.of(context).colorScheme.error,
  //               ),
  //               child: const Text("清除"),
  //             ),
  //           ],
  //         ),
  //   );
  // }

  // void _clearChatHistory(String sessionId) {
  //   ref.read(sessionStateProvider.notifier).clearMessagesForSession(sessionId);
  //   ElegantNotification.success(
  //     description: const Text('聊天记录已清除'),
  //     icon: const Icon(Ionicons.checkmark_done_circle_outline),
  //     position: Alignment.bottomRight,
  //   ).show(context);
  // }

  Widget _buildHeader(
    BuildContext context,
    String title,
    bool isActive,
    String? avatarUrl, // 这个 avatarUrl 已经考虑了会话头像和角色头像
    RoleEntity? displayRole,
  ) {
    final theme = Theme.of(context);
    final isMobile = Platform.isAndroid || Platform.isIOS;
    final statusBarHeight = ImmersiveMode.getStatusBarHeight(context);
    final headerColor = theme.colorScheme.surface;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ImmersiveMode.set(
          statusBarColor: headerColor,
          isDark: theme.brightness == Brightness.dark,
        );
      }
    });

    return Container(
      key: _headerKey,
      padding: EdgeInsets.only(
        top: statusBarHeight + (isMobile ? 8 : 12),
        left: isMobile ? 8 : 16,
        right: isMobile ? 8 : 16,
        bottom: 12,
      ),
      decoration: BoxDecoration(
        color: headerColor,
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
              onPressed: () {
                ref.read(sessionStateProvider.notifier).selectSession(-1);
                GoRouter.of(context).go('/chat');
              },
              icon: const Icon(Ionicons.chevron_back),
              tooltip: "返回列表",
            ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.surfaceContainerHighest,
              image:
                  avatarUrl != null && avatarUrl.isNotEmpty
                      ? DecorationImage(
                        image:
                            avatarUrl.startsWith('http')
                                ? NetworkImage(avatarUrl)
                                : FileImage(File(avatarUrl)) as ImageProvider,
                        fit: BoxFit.cover,
                      )
                      : null,
            ),
            child:
                avatarUrl == null || avatarUrl.isEmpty
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
                if (displayRole != null) // 使用 displayRole
                  Text(
                    displayRole.name, // 使用 displayRole.name
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          if (displayRole != null) // 只有当有关联角色时才显示抽屉按钮
            Builder(
              builder:
                  (context) => IconButton(
                    iconSize: 20,
                    constraints: const BoxConstraints(
                      maxHeight: 32,
                      maxWidth: 32,
                    ),
                    icon: const Icon(Ionicons.ellipsis_horizontal),
                    onPressed: () {
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
            Ionicons.chatbubble_ellipses_outline,
            size: 80,
            color: Theme.of(context).disabledColor,
          ),
          const SizedBox(height: 16),
          Text(
            '没有消息',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).disabledColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '发送一条消息开始对话',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Theme.of(context).hintColor),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList(
    BuildContext context,
    List<ChatMessageEntity> messages,
  ) {
    final isMobile = Platform.isAndroid || Platform.isIOS;
    final messageAreaWidth =
        MediaQuery.of(context).size.width -
        (isMobile
            ? 0
            : (Scaffold.of(context).hasEndDrawer &&
                    Scaffold.of(context).isEndDrawerOpen
                ? 300 + 32
                : 32));

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isMe = message.isFromUser;
        final showDate =
            index == 0 ||
            _shouldShowDateSeparator(
              messages[index - 1].createdAt,
              message.createdAt,
            );

        return Column(
          children: [
            if (showDate) _buildDateSeparator(message.createdAt),
            MessageBubble(
              message: message,
              isMe: isMe,
              maxWidth: messageAreaWidth * 0.75,
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
            color: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest.withOpacity(0.7),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            dateText,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageComposer(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(top: BorderSide(color: theme.dividerColor, width: 0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            height: 40,
            alignment: Alignment.center,
            child: IconButton(
              iconSize: 22,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              icon: const Icon(Ionicons.attach_outline),
              onPressed: () {
                ElegantNotification.info(
                  description: const Text('附件功能暂未实现'),
                ).show(context);
              },
              tooltip: '添加附件(暂不支持)',
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              constraints: const BoxConstraints(maxHeight: 120),
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: '输入消息...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.surfaceContainerHighest,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  suffixIcon: SimpleIconButton(
                    size: 22,
                    icon: Icons.emoji_emotions_outlined,
                    onPressed: () {
                      ElegantNotification.info(
                        description: const Text('表情功能暂未实现'),
                      ).show(context);
                    },
                    // tooltip: "表情(暂不支持)",
                  ),
                  isDense: true,
                ),
                maxLines: null,
                minLines: 1,
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.multiline,
                onChanged: (text) {
                  setState(() {
                    _isComposing = text.trim().isNotEmpty;
                  });
                },
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            height: 40,
            alignment: Alignment.center,
            child: IconButton(
              iconSize: 22,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              icon:
                  _isComposing
                      ? const Icon(Ionicons.send)
                      : const Icon(Ionicons.mic_outline),
              color:
                  _isComposing
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
              onPressed:
                  _isComposing
                      ? () => _handleSubmitted(_messageController.text)
                      : () {
                        ElegantNotification.info(
                          description: const Text('语音输入功能暂未实现'),
                        ).show(context);
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
            Ionicons.chatbubbles_outline,
            size: 100,
            color: theme.disabledColor,
          ),
          const SizedBox(height: 24),
          Text(
            "请选择或创建会话",
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.hintColor,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              "在左侧列表选择一个已有会话，或点击上方的 '+' 按钮创建新的聊天。",
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.hintColor.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return;

    final currentText = text.trim();
    _messageController.clear();
    setState(() {
      _isComposing = false;
    });

    ref.read(sessionStateProvider.notifier).sendMessage(currentText);

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  // Future<String?> _saveRoleAvatar(File imageFile) async {
  //   try {
  //     final appDir = await getApplicationDocumentsDirectory();
  //     final avatarDir = Directory(path.join(appDir.path, 'role_avatars'));
  //     if (!await avatarDir.exists()) {
  //       await avatarDir.create(recursive: true);
  //     }
  //     final fileName =
  //         'role_avatar_${DateTime.now().millisecondsSinceEpoch}${path.extension(imageFile.path)}';
  //     final savedImagePath = path.join(avatarDir.path, fileName);
  //     final savedFile = await imageFile.copy(savedImagePath);
  //     return savedFile.path;
  //   } catch (e) {
  //     ElegantNotification.error(
  //       title: const Text("错误"),
  //       description: Text("保存角色头像失败: $e"),
  //     ).show(context);
  //     return null;
  //   }
  // }
}
