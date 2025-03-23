import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mtp/src/core/widgets/custom_window/window_title_bar.dart';
import 'package:mtp/src/core/widgets/platform_aware/desktop_layout.dart';
import 'package:mtp/src/domain/entities/chat_model_entity.dart';
import 'package:mtp/src/domain/entities/settings_entity.dart';
import 'package:mtp/src/presentation/providers/settings/settings_provider.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _usernameController = TextEditingController();
  bool _isEditingUsername = false;
  bool _isHoveringAvatar = false;

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);

    if (settings == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // 检测是否是在桌面平台
    final isDesktopLayout = MediaQuery.of(context).size.width > 650;

    final content = ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // 用户资料设置卡片
        _buildSection(
          title: '用户资料',
          icon: Icons.person_outline,
          children: [_buildProfileSettings(settings)],
        ),

        const SizedBox(height: 16),

        // 外观设置卡片
        _buildSection(
          title: '外观',
          icon: Icons.palette_outlined,
          children: [_buildThemeSettings(settings)],
        ),

        const SizedBox(height: 16),

        // 语言模型设置卡片
        _buildSection(
          title: '语言模型',
          icon: Icons.smart_toy_outlined,
          children: [_buildModelsSettings(settings)],
        ),
      ],
    );

    if (isDesktopLayout) {
      return Stack(
        children: [
          DesktopLayout(title: '设置', child: content),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: WindowTitleBar(
              onReset: () => _showResetConfirmDialog(context),
            ),
          ),
        ],
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('设置'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: '重置为默认设置',
              onPressed: () => _showResetConfirmDialog(context),
            ),
          ],
        ),
        body: content,
      );
    }
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSettings(SettingsEntity settings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 用户头像设置
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: MouseRegion(
            onEnter: (_) => setState(() => _isHoveringAvatar = true),
            onExit: (_) => setState(() => _isHoveringAvatar = false),
            child: GestureDetector(
              onTap: () async {
                await _selectUserAvatar();
              },
              child: Stack(
                children: [
                  // 头像
                  CircleAvatar(
                    radius: 24,
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    child:
                        settings.userAvatar.isNotEmpty
                            ? ClipOval(
                              child:
                                  settings.userAvatar.startsWith('assets/')
                                      ? Image.asset(
                                        settings.userAvatar,
                                        width: 48,
                                        height: 48,
                                        fit: BoxFit.cover,
                                      )
                                      : Image.file(
                                        File(settings.userAvatar),
                                        width: 48,
                                        height: 48,
                                        fit: BoxFit.cover,
                                        errorBuilder: (
                                          context,
                                          error,
                                          stackTrace,
                                        ) {
                                          return Text(
                                            settings.username.isNotEmpty
                                                ? settings.username[0]
                                                    .toUpperCase()
                                                : 'U',
                                            style: TextStyle(
                                              color:
                                                  Theme.of(context)
                                                      .colorScheme
                                                      .onPrimaryContainer,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                          );
                                        },
                                      ),
                            )
                            : Text(
                              settings.username.isNotEmpty
                                  ? settings.username[0].toUpperCase()
                                  : 'U',
                              style: TextStyle(
                                color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                  ),

                  // 悬停效果 - 显示半透明蒙版和相机图标
                  if (_isHoveringAvatar)
                    Positioned.fill(
                      child: ClipOval(
                        child: Container(
                          color: Colors.black.withOpacity(0.5),
                          child: const Center(
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          title:
              _isEditingUsername
                  ? TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      hintText: '输入用户名',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.check),
                        onPressed: () {
                          if (_usernameController.text.trim().isNotEmpty) {
                            ref
                                .read(settingsProvider.notifier)
                                .updateUsername(
                                  _usernameController.text.trim(),
                                );
                            setState(() {
                              _isEditingUsername = false;
                            });
                          }
                        },
                      ),
                    ),
                    autofocus: true,
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        ref
                            .read(settingsProvider.notifier)
                            .updateUsername(value.trim());
                        setState(() {
                          _isEditingUsername = false;
                        });
                      }
                    },
                  )
                  : Row(
                    children: [
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          settings.username.isEmpty ? '未设置' : settings.username,
                          style: TextStyle(
                            color:
                                settings.username.isEmpty
                                    ? Theme.of(context).colorScheme.outline
                                    : Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, size: 18),
                        onPressed: () {
                          setState(() {
                            _usernameController.text = settings.username;
                            _isEditingUsername = true;
                          });
                        },
                      ),
                    ],
                  ),
        ),
      ],
    );
  }

  Widget _buildThemeSettings(SettingsEntity settings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text('主题模式', style: Theme.of(context).textTheme.titleMedium),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 150, // 调整高度以提供更好的展示空间
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(vertical: 4), // 添加垂直内边距
            children: [
              _buildThemePreviewCard(
                settings: settings,
                themeId: 'light',
                label: '浅色',
              ),
              const SizedBox(width: 16), // 增加卡片间距
              _buildThemePreviewCard(
                settings: settings,
                themeId: 'dark',
                label: '深色',
              ),
              const SizedBox(width: 16), // 增加卡片间距
              _buildThemePreviewCard(
                settings: settings,
                themeId: 'system',
                label: '跟随系统',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildThemePreviewCard({
    required SettingsEntity settings,
    required String themeId,
    required String label,
  }) {
    final isSelected = settings.theme == themeId;

    Widget previewContent;

    switch (themeId) {
      case 'light':
        previewContent = Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFE6F0FF), Color(0xFFCCE4FF)],
                ),
              ),
            ),
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                height: 20,
                width: 20,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFD700),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              left: 8,
              top: 36,
              child: Container(
                height: 12,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            Positioned(
              left: 8,
              bottom: 8,
              child: Container(
                height: 12,
                width: 70,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        );
        break;

      case 'dark':
        previewContent = Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF333333), Color(0xFF111111)],
                ),
              ),
            ),
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                height: 20,
                width: 20,
                decoration: const BoxDecoration(
                  color: Color(0xFF7AB5FF),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              left: 8,
              top: 36,
              child: Container(
                height: 12,
                width: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFF444444),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            Positioned(
              left: 8,
              bottom: 8,
              child: Container(
                height: 12,
                width: 70,
                decoration: BoxDecoration(
                  color: const Color(0xFF444444).withOpacity(0.8),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        );
        break;

      case 'system':
        previewContent = Row(
          children: [
            // Light half
            Expanded(
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Color(0xFFE6F0FF), Colors.white],
                      ),
                    ),
                  ),
                  Positioned(
                    right: 4,
                    top: 8,
                    child: Container(
                      height: 14,
                      width: 14,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFD700),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 4,
                    top: 30,
                    child: Container(
                      height: 8,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Dark half
            Expanded(
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Color(0xFF333333), Color(0xFF111111)],
                      ),
                    ),
                  ),
                  Positioned(
                    right: 4,
                    top: 8,
                    child: Container(
                      height: 14,
                      width: 14,
                      decoration: const BoxDecoration(
                        color: Color(0xFF7AB5FF),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 4,
                    top: 30,
                    child: Container(
                      height: 8,
                      width: 30,
                      decoration: BoxDecoration(
                        color: const Color(0xFF444444),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
        break;

      default:
        // 默认情况下显示一个简单的容器
        previewContent = Container(
          color: Theme.of(context).colorScheme.surface,
          child: const Center(child: Icon(Icons.palette_outlined)),
        );
        break;
    }

    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          ref.read(settingsProvider.notifier).updateTheme(themeId);
        }
      },
      child: Container(
        width: 140, // 调整为更适合的宽度
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outline.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
          // 添加轻微的阴影效果增强立体感
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.2),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ]
                  : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(10), // 增加边距
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: previewContent,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12, top: 4), // 调整文字区域的内边距
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isSelected)
                    Icon(
                      Icons.check_circle,
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  if (isSelected) const SizedBox(width: 4),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color:
                          isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModelsSettings(SettingsEntity settings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 语言模型列表
        if (settings.models.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '暂无语言模型',
                style: TextStyle(color: Theme.of(context).colorScheme.outline),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: settings.models.length,
            itemBuilder: (context, index) {
              final model = settings.models[index];
              return _buildModelItem(model);
            },
          ),

        // 添加模型按钮
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: OutlinedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('添加语言模型'),
            onPressed: () => _showAddModelDialog(context),
          ),
        ),
      ],
    );
  }

  Widget _buildModelItem(ChatModelEntity model) {
    return Card(
      elevation: 0,
      color:
          model.isSelected
              ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5)
              : Theme.of(context).colorScheme.surface,
      margin: const EdgeInsets.only(bottom: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color:
              model.isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.outline.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: ListTile(
        title: Text(model.name),
        subtitle: Text(model.endpoint, style: TextStyle(fontSize: 12)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 选择模型
            IconButton(
              icon: Icon(
                model.isSelected
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                color:
                    model.isSelected
                        ? Theme.of(context).colorScheme.primary
                        : null,
              ),
              onPressed: () {
                // 更新选中状态
                final updatedModel = model.copyWith(
                  isSelected: !model.isSelected,
                );
                ref.read(settingsProvider.notifier).updateModel(updatedModel);
              },
            ),
            // 编辑模型
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => _showEditModelDialog(context, model),
            ),
            // 删除模型
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _showDeleteModelDialog(context, model.id ?? ''),
            ),
          ],
        ),
      ),
    );
  }

  // 弹窗：添加语言模型
  Future<void> _showAddModelDialog(BuildContext context) async {
    final nameController = TextEditingController();
    final endpointController = TextEditingController();
    final apiKeyController = TextEditingController();
    final tempartureController = TextEditingController(text: "0.7"); // 默认值0.7

    return showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('添加语言模型'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: '模型名称',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: endpointController,
                  decoration: const InputDecoration(
                    labelText: '基础URL',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: apiKeyController,
                  decoration: const InputDecoration(
                    labelText: 'API密钥',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: tempartureController,
                  decoration: const InputDecoration(
                    labelText: '温度 (0.0-1.0)',
                    hintText: '较低的值使输出更确定，较高的值使输出更随机',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            actions: [
              TextButton(
                child: const Text('取消'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: const Text('添加'),
                onPressed: () {
                  if (nameController.text.trim().isNotEmpty &&
                      endpointController.text.trim().isNotEmpty) {
                    // 解析温度值，并确保在有效范围内
                    double temparture = 0.7;
                    try {
                      temparture = double.parse(
                        tempartureController.text.trim(),
                      );
                      temparture = temparture.clamp(0.0, 1.0);
                    } catch (e) {
                      // 如果解析失败，使用默认值
                    }

                    final newModel = ChatModelEntity(
                      id: Uuid().v4(),
                      name: nameController.text.trim(),
                      endpoint: endpointController.text.trim(),
                      apiKey: apiKeyController.text.trim(),
                      temparture: temparture, // 添加缺失的参数
                      isSelected: false,
                    );
                    ref.read(settingsProvider.notifier).addModel(newModel);
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
    );
  }

  // 弹窗：编辑语言模型
  Future<void> _showEditModelDialog(
    BuildContext context,
    ChatModelEntity model,
  ) async {
    final nameController = TextEditingController(text: model.name);
    final endpointController = TextEditingController(text: model.endpoint);
    final apiKeyController = TextEditingController(text: model.apiKey);
    final tempartureController = TextEditingController(
      text: model.temparture.toString(),
    );

    return showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('编辑语言模型'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: '模型名称'),
                ),
                TextField(
                  controller: endpointController,
                  decoration: const InputDecoration(labelText: '基础URL'),
                ),
                TextField(
                  controller: apiKeyController,
                  decoration: const InputDecoration(labelText: 'API密钥'),
                  obscureText: true,
                ),
                TextField(
                  controller: tempartureController,
                  decoration: const InputDecoration(
                    labelText: '温度 (0.0-1.0)',
                    hintText: '较低的值使输出更确定，较高的值使输出更随机',
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            actions: [
              TextButton(
                child: const Text('取消'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: const Text('保存'),
                onPressed: () {
                  if (nameController.text.trim().isNotEmpty &&
                      endpointController.text.trim().isNotEmpty) {
                    // 解析温度值，确保在有效范围内
                    double temparture = model.temparture;
                    try {
                      temparture = double.parse(
                        tempartureController.text.trim(),
                      );
                      temparture = temparture.clamp(0.0, 1.0);
                    } catch (e) {
                      // 解析失败使用原值
                    }

                    final updatedModel = model.copyWith(
                      name: nameController.text.trim(),
                      endpoint: endpointController.text.trim(),
                      apiKey: apiKeyController.text.trim(),
                      temparture: temparture, // 添加此参数
                    );
                    ref
                        .read(settingsProvider.notifier)
                        .updateModel(updatedModel);
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
    );
  }

  // 弹窗：删除语言模型
  Future<void> _showDeleteModelDialog(
    BuildContext context,
    String modelId,
  ) async {
    return showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('删除模型'),
            content: const Text('确定要删除此语言模型吗？此操作无法撤销。'),
            actions: [
              TextButton(
                child: const Text('取消'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                onPressed: () {
                  ref.read(settingsProvider.notifier).deleteModel(modelId);
                  Navigator.of(context).pop();
                },
                child: const Text('删除'),
              ),
            ],
          ),
    );
  }

  // 弹窗：重置为默认设置
  Future<void> _showResetConfirmDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('重置设置'),
            content: const Text('确定要将所有设置重置为默认值吗？此操作无法撤销。'),
            actions: [
              TextButton(
                child: const Text('取消'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                onPressed: () {
                  ref.read(settingsProvider.notifier).resetToDefault();
                  Navigator.of(context).pop();
                },
                child: const Text('重置'),
              ),
            ],
          ),
    );
  }

  // 选择用户头像
  Future<void> _selectUserAvatar() async {
    final ImagePicker imagePicker = ImagePicker();
    final bool isMobile = Platform.isAndroid || Platform.isIOS;

    if (isMobile) {
      // 显示选择方式的底部弹窗
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                // 在非Windows平台上显示相机选项
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('拍照'),
                  onTap: () async {
                    Navigator.pop(context);
                    final XFile? image = await imagePicker.pickImage(
                      source: ImageSource.camera,
                      imageQuality: 80,
                    );
                    if (image != null) {
                      _processSelectedImage(File(image.path));
                    }
                  },
                ),

                // 所有平台都显示相册选项
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('从相册选择'),
                  onTap: () async {
                    Navigator.pop(context);
                    final XFile? image = await imagePicker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 80,
                    );
                    if (image != null) {
                      _processSelectedImage(File(image.path));
                    }
                  },
                ),
              ],
            ),
          );
        },
      );
    } else {
      final XFile? image = await imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (image != null) {
        _processSelectedImage(File(image.path));
      }
    }
  }

  // 处理选中的图片
  Future<void> _processSelectedImage(File imageFile) async {
    try {
      // 获取应用文档目录
      final appDir = await getApplicationDocumentsDirectory();

      // 创建头像目录
      final avatarDir = Directory('${appDir.path}/avatars');
      if (!await avatarDir.exists()) {
        await avatarDir.create(recursive: true);
      }

      // 创建唯一的文件名
      final fileName =
          'avatar_${DateTime.now().millisecondsSinceEpoch}${path.extension(imageFile.path)}';
      final savedImagePath = '${avatarDir.path}/$fileName';

      // 复制图片到应用目录
      final savedFile = await imageFile.copy(savedImagePath);

      // 更新状态
      ref.read(settingsProvider.notifier).updateUserAvatar(savedFile.path);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('头像更新失败: $e')));
    }
  }
}
