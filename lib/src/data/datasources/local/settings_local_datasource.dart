import 'package:hive_ce/hive.dart';

import '../../models/settings.dart';
import '../../models/chat/model.dart';

class SettingsLocalDatasource {
  static const String _boxName = 'settings';
  static const String _settingsKey = 'user_settings';
  late Box<Settings> settingsBox;

  // 初始化数据库
  Future<void> initialize() async {
    settingsBox = await Hive.openBox<Settings>(_boxName);

    // 确保有默认设置
    if (!settingsBox.containsKey(_settingsKey)) {
      await settingsBox.put(_settingsKey, Settings.defaultSettings());
    }
  }

  // 获取设置
  Future<Settings> getSettings() async {
    return settingsBox.get(_settingsKey) ?? Settings.defaultSettings();
  }

  // 更新设置
  Future<void> updateSettings(Settings settings) async {
    await settingsBox.put(_settingsKey, settings);
  }

  // 更新用户名
  Future<void> updateUsername(String username) async {
    final settings = await getSettings();
    settings.username = username;
    await updateSettings(settings);
  }

  // 更新用户头像
  Future<void> updateUserAvatar(String avatarPath) async {
    final settings = await getSettings();
    settings.userAvatar = avatarPath;
    await updateSettings(settings);
  }

  // 更新主题
  Future<void> updateTheme(String theme) async {
    final settings = await getSettings();
    settings.theme = theme;
    await updateSettings(settings);
  }

  // 添加模型
  Future<void> addModel(ChatModel model) async {
    final settings = await getSettings();
    settings.addModel(model);
    await updateSettings(settings);
  }

  // 更新模型
  Future<void> updateModel(ChatModel model) async {
    if (model.key == null) {
      throw Exception('无法更新没有key的模型');
    }

    final settings = await getSettings();
    final index = settings.models.indexWhere((m) => m.key == model.key);

    if (index >= 0) {
      settings.models[index] = model;
      await updateSettings(settings);
    } else {
      throw Exception('未找到要更新的模型');
    }
  }

  // 删除模型
  Future<void> deleteModel(String modelId) async {
    final settings = await getSettings();
    settings.removeModel(modelId);
    await updateSettings(settings);
  }

  // 获取所有模型
  Future<List<ChatModel>> getAllModels() async {
    final settings = await getSettings();
    return settings.models;
  }

  // 获取特定模型
  Future<ChatModel?> getModelById(String modelId) async {
    final settings = await getSettings();
    return settings.getModel(modelId);
  }

  // 重置设置为默认值
  Future<void> resetToDefault() async {
    await updateSettings(Settings.defaultSettings());
  }
}
