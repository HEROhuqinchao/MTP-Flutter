import 'dart:io';

import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mtp/src/core/constants/app_info.dart';
import 'package:mtp/src/core/widgets/data_management_sheet.dart';
import 'package:mtp/src/features/role/domain/entities/role_entity.dart';
import 'package:mtp/src/features/chat/presentation/providers/chat_provider.dart';
import 'package:mtp/src/features/role/persentation/providers/role_provider.dart';
import 'package:mtp/src/features/settings/presentation/providers/settings_provider.dart';
import 'package:mtp/src/utils/logger.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

class MobileDrawer extends ConsumerWidget {
  const MobileDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    // 计算抽屉宽度 - 使用屏幕宽度的80%或300点，取较小值
    final drawerWidth = isPortrait ? screenWidth : 360.0;
    final avatarWidget = Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).colorScheme.surfaceBright,
          width: 2,
        ),
      ),
      child: CircleAvatar(
        radius: 28, // 设置为所需尺寸的一半
        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        backgroundImage:
            settings?.userAvatar.isNotEmpty == true
                ? settings!.userAvatar.startsWith('assets/')
                    ? AssetImage(settings.userAvatar)
                    : FileImage(File(settings.userAvatar)) as ImageProvider
                : null,
        child:
            settings?.userAvatar.isEmpty != false
                ? Icon(
                  Icons.person,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                )
                : null,
      ),
    );

    return Material(
      elevation: 0,
      child: SizedBox(
        width: drawerWidth, // 设置抽屉宽度
        child: SizedBox(
          width: drawerWidth, // 确保Drawer也使用相同宽度
          child: SafeArea(
            child: Column(
              children: [
                // 顶部标题栏
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      avatarWidget,
                      const SizedBox(width: 16),
                      Text(
                        settings?.username ?? '',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      // 聊天功能分组
                      _buildSectionHeader(context, '聊天'),

                      _buildMenuItem(
                        context: context,
                        icon: Ionicons.chatbubble_outline,
                        title: '聊天',
                        onTap: () {
                          GoRouter.of(context).pop();
                          GoRouter.of(context).go('/chat');
                        },
                      ),

                      // 新建会话按钮 (保留注释)
                      _buildMenuItem(
                        context: context,
                        icon: Ionicons.add_circle_outline,
                        title: '新建会话',
                        onTap: () {
                          GoRouter.of(context).pop();
                          _showNewConversationDialog(context, ref);
                        },
                      ),
                      const SizedBox(height: 16),

                      // 工具分组
                      _buildSectionHeader(context, '工具'),

                      _buildMenuItem(
                        context: context,
                        icon: Ionicons.folder_open_outline,
                        title: '导入/导出数据',
                        onTap: () {
                          GoRouter.of(context).pop();
                          // 显示导入导出对话框
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => const DataManagementSheet(),
                          );
                        },
                      ),

                      const SizedBox(height: 16),

                      // 帮助与信息分组
                      _buildSectionHeader(context, '帮助与信息'),

                      _buildMenuItem(
                        context: context,
                        icon: Ionicons.help_circle_outline,
                        title: '帮助与反馈',
                        onTap: () async {
                          // 实现帮助功能 - 打开帮助网页
                          final Uri helpUrl = Uri.parse(appHelpUrl);

                          try {
                            // 根据平台选择不同的实现方式
                            if (Platform.isWindows) {
                              // Windows 平台使用系统命令打开
                              await Process.run('explorer.exe', [
                                helpUrl.toString(),
                              ]);
                            } else {
                              // 其他平台使用 url_launcher
                              if (!await launchUrl(
                                helpUrl,
                                mode: LaunchMode.externalApplication,
                              )) {
                                // 如果打开失败，显示错误消息
                                if (context.mounted) {
                                  ElegantNotification.error(
                                    title: Text('发生错误'),
                                    description: Text('无法打开帮助页面，请稍后再试'),
                                    icon: Icon(Ionicons.sad),
                                    position: Alignment.topRight,
                                  ).show(context);
                                }
                              }
                            }
                          } catch (e) {
                            // 捕获可能的异常并提供反馈
                            if (context.mounted) {
                              ElegantNotification.error(
                                title: Text('发生错误'),
                                description: Text('打开帮助页面时出错: $e'),
                                icon: Icon(Ionicons.sad),
                                position: Alignment.topRight,
                              ).show(context);
                            }
                          }
                        },
                      ),

                      _buildMenuItem(
                        context: context,
                        icon: Ionicons.information_circle_outline,
                        title: '关于',
                        onTap: () {
                          // 实现关于功能
                          showAboutDialog(
                            context: context,
                            applicationName: appName,
                            applicationIcon: CircleAvatar(
                              radius: 25,
                              backgroundColor:
                                  Theme.of(
                                    context,
                                  ).colorScheme.primaryContainer,
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/logo.png',
                                    width: 46,
                                    height: 46,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            applicationVersion: appVersion,
                            applicationLegalese:
                                ' © ${DateTime.now().year} MomoTalk Plus. 保留所有权利',
                          );
                        },
                      ),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                // 统计卡片
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color:
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '会话统计',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatItem(
                              context,
                              '${ref.watch(chatStateProvider).sessions.length}',
                              '会话',
                              Ionicons.chatbubbles_outline,
                            ),
                            _buildStatItem(
                              context,
                              '${ref.watch(settingsProvider)?.models.length ?? 0}',
                              '模型',
                              Ionicons.server_outline,
                            ),
                            _buildStatItem(
                              context,
                              _calculateTotalMessages(ref),
                              '消息',
                              Ionicons.chatbox_outline,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // 底部工具栏
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      // 设置按钮
                      IconButton(
                        tooltip: '设置',
                        onPressed: () {
                          GoRouter.of(context).pop(); // 关闭抽屉
                          GoRouter.of(context).push('/settings');
                        },
                        icon: const Icon(Ionicons.cog_outline),
                      ),

                      // 主题切换按钮
                      IconButton(
                        tooltip: _getThemeTooltip(settings?.theme ?? 'system'),
                        onPressed: () {
                          // 获取下一个主题
                          final nextTheme = _getNextTheme(
                            settings?.theme ?? 'system',
                          );
                          ref
                              .read(settingsProvider.notifier)
                              .updateTheme(nextTheme);
                        },
                        icon: _getThemeIcon(
                          settings?.theme ?? 'system',
                          context,
                        ),
                      ),

                      const Spacer(),

                      // 应用版本
                      Text(
                        'v$appVersion',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 构建分组标题
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Divider(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            thickness: 1,
          ),
        ],
      ),
    );
  }

  // 构建菜单项
  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 0,
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        highlightColor: Theme.of(context).colorScheme.primary.withOpacity(0.05),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(
                icon,
                size: 22,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
        ),
      ),
    );
  }

  // 获取主题图标
  Widget _getThemeIcon(String themeMode, BuildContext context) {
    switch (themeMode) {
      case 'light':
        return const Icon(Ionicons.sunny_outline);
      case 'dark':
        return const Icon(Ionicons.moon_outline);
      case 'system':
        return const Icon(Ionicons.contrast_outline);
      default:
        // 判断当前实际主题以显示合适的图标
        final brightness = Theme.of(context).brightness;
        return brightness == Brightness.dark
            ? const Icon(Ionicons.moon_outline)
            : const Icon(Ionicons.sunny_outline);
    }
  }

  // 获取主题提示文本
  String _getThemeTooltip(String themeMode) {
    switch (themeMode) {
      case 'light':
        return '当前：亮色主题\n点击切换到暗色主题';
      case 'dark':
        return '当前：暗色主题\n点击切换到跟随系统';
      case 'system':
        return '当前：跟随系统\n点击切换到亮色主题';
      default:
        return '点击切换主题';
    }
  }

  // 获取下一个主题
  String _getNextTheme(String currentTheme) {
    switch (currentTheme) {
      case 'light':
        return 'dark';
      case 'dark':
        return 'system';
      case 'system':
        return 'light';
      default:
        return 'light'; // 如果当前主题未知，默认切换到亮色主题
    }
  }

  // 构建统计项目
  Widget _buildStatItem(
    BuildContext context,
    String value,
    String label,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  // 计算总消息数
  String _calculateTotalMessages(WidgetRef ref) {
    final sessions = ref.watch(chatStateProvider).sessions;
    int total = 0;
    for (var session in sessions) {
      total += session.messages.length;
    }

    // 格式化大数字
    if (total > 1000) {
      return '${(total / 1000).toStringAsFixed(1)}k';
    }
    return '$total';
  }

  // 新建会话对话框
  void _showNewConversationDialog(BuildContext context, WidgetRef ref) {
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

                GoRouter.of(context).pop();
              } catch (e) {
                ElegantNotification.error(
                  title: Text('发生错误'),
                  description: Text('创建失败: $e'),
                  icon: Icon(Ionicons.sad),
                  position: Alignment.topRight,
                ).show(context);
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
                              isCreating
                                  ? null
                                  : () => GoRouter.of(context).pop(),
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
}
