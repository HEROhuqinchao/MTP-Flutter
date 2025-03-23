import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/settings_entity.dart';
import '../../../domain/entities/chat_model_entity.dart';
import '../../../domain/repositories/settings_repository.dart';
import '../../../di/providers/repository_providers.dart';

// 设置状态提供者
final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsEntity?>((ref) {
      final settingsRepository = ref.watch(settingsRepositoryProvider);
      return SettingsNotifier(settingsRepository);
    });

// 当前选中的模型提供者
final selectedModelProvider = Provider<ChatModelEntity?>((ref) {
  final settings = ref.watch(settingsProvider);
  if (settings == null || settings.models.isEmpty) return null;

  // 返回当前选中的模型
  return settings.models.firstWhere(
    (model) => model.isSelected,
    // orElse: () => settings.models.first,
  );
});

// 设置状态管理器
class SettingsNotifier extends StateNotifier<SettingsEntity?> {
  final SettingsRepository _settingsRepository;

  SettingsNotifier(this._settingsRepository) : super(null) {
    // 初始化时加载设置
    loadSettings();
  }

  // 加载设置
  Future<void> loadSettings() async {
    try {
      final settings = await _settingsRepository.getSettings();
      state = settings;
    } catch (e) {
      print('加载设置失败: $e');
    }
  }

  // 更新设置
  Future<void> updateSettings(SettingsEntity settings) async {
    try {
      await _settingsRepository.updateSettings(settings);
      state = settings;
    } catch (e) {
      print('更新设置失败: $e');
    }
  }

  // 更新用户名
  Future<void> updateUsername(String username) async {
    if (state == null) return;

    try {
      await _settingsRepository.updateUsername(username);
      state = state!.copyWith(username: username);
    } catch (e) {
      print('更新用户名失败: $e');
    }
  }

  // 更新用户头像方法中，确保处理文件路径
  Future<void> updateUserAvatar(String avatarPath) async {
    if (state == null) return;

    state = state!.copyWith(userAvatar: avatarPath);
    await _settingsRepository.updateUserAvatar(avatarPath);
  }

  // 更新主题
  Future<void> updateTheme(String theme) async {
    if (state == null) return;

    try {
      await _settingsRepository.updateTheme(theme);
      state = state!.copyWith(theme: theme);
    } catch (e) {
      print('更新主题失败: $e');
    }
  }

  // 添加语言模型
  Future<void> addModel(ChatModelEntity model) async {
    if (state == null) return;

    try {
      await _settingsRepository.addModel(model);
      await loadSettings(); // 重新加载所有设置
    } catch (e) {
      print('添加模型失败: $e');
    }
  }

  // 更新语言模型
  Future<void> updateModel(ChatModelEntity model) async {
    if (state == null) return;

    try {
      List<ChatModelEntity> updatedModels;

      // 如果是要选中模型
      if (model.isSelected) {
        // 确保互斥选择：将其他所有模型设置为未选中
        updatedModels =
            state!.models.map((existingModel) {
              return existingModel.id == model.id
                  ? model // 当前模型保持选中
                  : existingModel.copyWith(isSelected: false); // 其他模型取消选中
            }).toList();
      } else {
        // 如果是要取消选中模型，直接允许操作
        updatedModels =
            state!.models.map((existingModel) {
              return existingModel.id == model.id ? model : existingModel;
            }).toList();
      }

      // 创建新的设置实体，替换模型列表
      final updatedSettings = state!.copyWith(models: updatedModels);
      await _settingsRepository.updateSettings(updatedSettings);
      state = updatedSettings;
    } catch (e) {
      print('更新模型失败: $e');
    }
  }

  // 删除语言模型
  Future<void> deleteModel(String modelId) async {
    if (state == null) return;

    try {
      await _settingsRepository.deleteModel(modelId);
      await loadSettings(); // 重新加载所有设置
    } catch (e) {
      print('删除模型失败: $e');
    }
  }

  // 重置为默认设置
  Future<void> resetToDefault() async {
    try {
      await _settingsRepository.resetToDefault();
      await loadSettings();
    } catch (e) {
      print('重置设置失败: $e');
    }
  }
}
