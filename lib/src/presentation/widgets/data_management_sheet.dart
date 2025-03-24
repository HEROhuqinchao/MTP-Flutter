import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mtp/src/domain/entities/role_entity.dart';
import 'package:mtp/src/domain/entities/session_entity.dart';
import 'package:mtp/src/domain/entities/settings_entity.dart';
import 'package:mtp/src/presentation/providers/chat/chat_provider.dart';
import 'package:mtp/src/presentation/providers/role/role_provider.dart';
import 'package:mtp/src/presentation/providers/settings/settings_provider.dart';
import 'package:mtp/src/utils/logger.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';

class DataManagementSheet extends ConsumerStatefulWidget {
  const DataManagementSheet({super.key});

  @override
  ConsumerState<DataManagementSheet> createState() =>
      _DataManagementSheetState();
}

class _DataManagementSheetState extends ConsumerState<DataManagementSheet> {
  bool _isExporting = false;
  bool _isImporting = false;
  String? _exportedFilePath;
  String? _importMessage;
  bool _importSuccess = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 标题
            Text('数据管理', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 24),

            // 导出部分
            _buildExportSection(),
            const SizedBox(height: 24),

            // 导入部分
            _buildImportSection(),
            const SizedBox(height: 24),

            // 底部按钮
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => GoRouter.of(context).pop(),
                child: const Text('关闭'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExportSection() {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Ionicons.cloud_download_outline,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text('导出数据', style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              '导出所有数据，包括聊天记录、角色设置及应用配置。您可以选择保存位置。',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            if (_exportedFilePath != null)
              Text(
                '文件已导出到: $_exportedFilePath',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (_exportedFilePath != null)
                  TextButton.icon(
                    onPressed: _shareExportedFile,
                    icon: const Icon(Ionicons.share_outline),
                    label: const Text('分享'),
                  ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _isExporting ? null : _exportData,
                  child:
                      _isExporting
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : const Text('选择位置并导出'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImportSection() {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Ionicons.cloud_upload_outline,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text('导入数据', style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              '从之前的备份文件中恢复数据。注意: 此操作将覆盖当前数据。',
              style: TextStyle(fontSize: 14),
            ),
            if (_importMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _importMessage!,
                  style: TextStyle(
                    fontSize: 12,
                    color:
                        _importSuccess
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: _isImporting ? null : _importData,
                  child:
                      _isImporting
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : const Text('导入'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportData() async {
    // 首先请求权限
    // final hasPermission = await _requestStoragePermission();

    // if (!hasPermission) {
    //   _showPermissionDeniedDialog();
    //   return;
    // }
    // 只在需要时请求权限
    if (Platform.isAndroid) {
      final sdkInt = await _getAndroidSDKVersion();
      if (sdkInt < 33) {
        // 只在老版本Android上检查权限
        final hasPermission = await _requestStoragePermission();
        if (!hasPermission) {
          _showPermissionDeniedDialog();
          return;
        }
      }
    }

    setState(() {
      _isExporting = true;
      _exportedFilePath = null;
    });

    try {
      // 1. 收集需要导出的数据
      final exportData = await _collectDataForExport();

      // 2. 转换为JSON字符串
      final jsonStr = jsonEncode(exportData);

      // 3. 创建并保存文件
      final exportPath = await _saveExportFile(jsonStr);

      setState(() {
        _isExporting = false;
        _exportedFilePath = exportPath;
      });
    } catch (e) {
      localLogger.shout('导出数据时发生错误: $e');
      setState(() {
        _isExporting = false;
      });
      _showErrorDialog('导出失败', '导出数据时发生错误: $e');
    }
  }

  Future<Map<String, dynamic>> _collectDataForExport() async {
    // 收集所有需要导出的数据
    final settings = ref.read(settingsProvider);
    final chatState = ref.read(chatStateProvider);
    final roleState = ref.read(roleStateProvider);

    return {
      'version': 1, // 数据版本号，方便未来向后兼容
      'timestamp': DateTime.now().toIso8601String(),
      'settings': settings?.toJson(),
      'sessions': chatState.sessions.map((s) => s.toJson()).toList(),
      'roles': roleState.roles.map((r) => r.toJson()).toList(),
    };
  }

  Future<String> _saveExportFile(String jsonStr) async {
    final now = DateTime.now();
    final dateStr =
        '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
    final fileName = 'mtp_backup_$dateStr.json';

    // 将JSON字符串转换为字节数据
    final bytes = utf8.encode(jsonStr);

    try {
      // 使用FilePicker保存文件，让系统接管文件写入过程
      final String? outputPath = await FilePicker.platform.saveFile(
        dialogTitle: '选择备份文件保存位置',
        fileName: fileName,
        type: FileType.custom,
        allowedExtensions: ['json'],
        bytes: bytes, // 提供字节数据让FilePicker处理写入
      );

      // 如果用户取消选择，抛出异常
      if (outputPath == null) {
        throw Exception('用户取消了保存操作');
      }

      // 直接返回路径，无需再次写入文件
      return outputPath;
    } catch (e) {
      localLogger.shout('保存文件失败: $e');
      throw Exception('保存文件失败: $e');
    }
  }

  Future<void> _shareExportedFile() async {
    if (_exportedFilePath == null) return;

    try {
      // 1. 先创建应用内临时文件
      final tempDir = await getTemporaryDirectory();
      final fileName = path.basename(_exportedFilePath!);
      final tempFile = File(path.join(tempDir.path, fileName));

      // 2. 从导出的文件中读取数据
      final originalFile = File(_exportedFilePath!);

      // 3. 尝试通过两种方式获取内容
      try {
        // 方法1: 直接复制文件内容到临时文件
        await tempFile.writeAsBytes(await originalFile.readAsBytes());
      } catch (e) {
        // 如果直接访问文件失败，重新收集导出数据
        final exportData = await _collectDataForExport();
        final jsonStr = jsonEncode(exportData);
        await tempFile.writeAsString(jsonStr);
      }

      // 4. 使用临时文件分享
      final xFile = XFile(tempFile.path);
      await Share.shareXFiles([xFile], text: 'MomoTalk Plus 数据备份');
    } catch (e) {
      _showErrorDialog('分享失败', '分享备份文件时发生错误: $e');
    }
  }

  Future<void> _importData() async {
    // 只在需要时请求权限
    if (Platform.isAndroid) {
      final sdkInt = await _getAndroidSDKVersion();
      if (sdkInt < 33) {
        // 只在老版本Android上检查权限
        final hasPermission = await _requestStoragePermission();
        if (!hasPermission) {
          _showPermissionDeniedDialog();
          return;
        }
      }
    }

    setState(() {
      _isImporting = true;
      _importMessage = null;
      _importSuccess = false;
    });

    try {
      // 1. 让用户选择文件
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result == null || result.files.isEmpty) {
        setState(() {
          _isImporting = false;
          _importMessage = '未选择文件';
        });
        return;
      }

      // 2. 读取文件内容
      final file = File(result.files.single.path!);
      final jsonStr = await file.readAsString();

      // 3. 解析JSON数据
      final importData = jsonDecode(jsonStr) as Map<String, dynamic>;

      // 4. 验证数据格式
      if (!_validateImportData(importData)) {
        setState(() {
          _isImporting = false;
          _importMessage = '导入的文件格式不正确';
        });
        return;
      }

      // 5. 确认导入操作
      final shouldImport = await _showImportConfirmDialog();
      if (!shouldImport) {
        setState(() {
          _isImporting = false;
        });
        return;
      }

      // 6. 导入数据
      await _importDataToApp(importData);

      setState(() {
        _isImporting = false;
        _importMessage = '数据导入成功';
        _importSuccess = true;
      });
    } catch (e) {
      localLogger.shout('导入数据时发生错误: $e');
      setState(() {
        _isImporting = false;
        _importMessage = '导入失败: $e';
      });
    }
  }

  bool _validateImportData(Map<String, dynamic> data) {
    // 验证数据结构是否完整
    return data.containsKey('version') &&
        data.containsKey('timestamp') &&
        data.containsKey('settings') &&
        data.containsKey('sessions') &&
        data.containsKey('roles');
  }

  Future<bool> _showImportConfirmDialog() async {
    return await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('确认导入'),
                content: const Text('导入数据将覆盖当前的设置、聊天记录和角色信息。此操作不可撤销，确定要继续吗？'),
                actions: [
                  TextButton(
                    onPressed: () => GoRouter.of(context).pop(false),
                    child: const Text('取消'),
                  ),
                  ElevatedButton(
                    onPressed: () => GoRouter.of(context).pop(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.error,
                      foregroundColor: Theme.of(context).colorScheme.onError,
                    ),
                    child: const Text('确认导入'),
                  ),
                ],
              ),
        ) ??
        false;
  }

  Future<void> _importDataToApp(Map<String, dynamic> data) async {
    // 导入设置
    if (data['settings'] != null) {
      // 转换JSON到实体类
      final settingsEntity = SettingsEntity.fromJson(data['settings']);
      await ref.read(settingsProvider.notifier).updateSettings(settingsEntity);
    }

    // 导入角色
    if (data['roles'] != null && data['roles'] is List) {
      for (final roleJson in data['roles']) {
        final role = RoleEntity.fromJson(roleJson);
        await ref.read(roleStateProvider.notifier).addRole(role);
      }
    }

    // 导入会话
    if (data['sessions'] != null && data['sessions'] is List) {
      final chatNotifier = ref.read(chatStateProvider.notifier);
      for (final sessionJson in data['sessions']) {
        final session = SessionEntity.fromJson(sessionJson);
        await chatNotifier.importSession(session);
      }
    }
  }

  // 请求存储权限
  Future<bool> _requestStoragePermission() async {
    // 对于Android 13+直接返回true
    if (Platform.isAndroid) {
      final sdkInt = await _getAndroidSDKVersion();
      if (sdkInt >= 33) return true;

      if (sdkInt >= 30) {
        final status = await Permission.manageExternalStorage.status;
        if (status.isGranted) return true;

        return await Permission.manageExternalStorage.request().isGranted;
      } else {
        final status = await Permission.storage.status;
        if (status.isGranted) return true;

        return await Permission.storage.request().isGranted;
      }
    }

    return true; // 非Android平台
    // // 检查当前权限状态
    // PermissionStatus status;

    // // Android 13+ (API 33+) 使用细分的媒体权限
    // if (Platform.isAndroid) {
    //   final sdkInt = await _getAndroidSDKVersion();
    //   if (sdkInt >= 33) {
    //     // Android 13+ (API 33+): 不需要请求存储权限，因为使用 FilePicker
    //     // 已经通过 SAF (Storage Access Framework) 处理了文件选择
    //     return true;
    //   } else if (sdkInt >= 30) {
    //     // Android 11-12：使用管理外部存储权限
    //     status = await Permission.manageExternalStorage.request();
    //     return status.isGranted;
    //   } else {
    //     // Android 10及以下: 使用存储权限
    //     status = await Permission.storage.request();
    //     return status.isGranted;
    //   }
    // } else if (Platform.isIOS) {
    //   return true;
    // }

    // // 其他平台默认返回true
    // return true;
  }

  // 获取Android SDK版本
  Future<int> _getAndroidSDKVersion() async {
    if (!Platform.isAndroid) return 0;

    try {
      // 使用device_info_plus插件获取系统信息
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.version.sdkInt;
    } catch (e) {
      print('获取Android SDK版本失败: $e');
      // 如果无法获取，返回一个足够高的版本号让应用默认使用SAF
      return 33; // 默认视为Android 13+
    }
  }

  // 显示权限被拒绝的对话框
  void _showPermissionDeniedDialog() async {
    final sdkInt = Platform.isAndroid ? await _getAndroidSDKVersion() : 0;

    if (!mounted) return;

    final String message;
    if (Platform.isAndroid && sdkInt >= 33) {
      // Android 13+提示
      message = '此应用需要访问文件选择器来导入/导出数据。请在下一步的文件选择器中选择适当的位置。';
    } else if (Platform.isAndroid && sdkInt >= 30) {
      // Android 11-12提示
      message = '为了导出或导入数据，应用需要"管理所有文件"权限。请在设置中允许此权限。';
    } else {
      // 其他版本
      message = '为了导出或导入数据，应用需要访问设备存储的权限。请在设置中允许此权限。';
    }

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('需要文件访问权限'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => GoRouter.of(context).pop(),
                child: const Text('取消'),
              ),
              if (sdkInt < 33) // 只在旧版Android上显示前往设置按钮
                ElevatedButton(
                  onPressed: () {
                    GoRouter.of(context).pop();
                    openAppSettings();
                  },
                  child: const Text('前往设置'),
                ),
              if (sdkInt >= 33) // 在新版Android上直接确认
                ElevatedButton(
                  onPressed: () {
                    GoRouter.of(context).pop();
                  },
                  child: const Text('我知道了'),
                ),
            ],
          ),
    );
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => GoRouter.of(context).pop(),
                child: const Text('确定'),
              ),
            ],
          ),
    );
  }
}
