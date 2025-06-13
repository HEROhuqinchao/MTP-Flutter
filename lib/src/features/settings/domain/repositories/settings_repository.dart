import '../entities/settings_entity.dart';
import '../entities/chat_model_entity.dart';

abstract class SettingsRepository {
  Future<SettingsEntity> getSettings();
  Future<void> updateSettings(SettingsEntity settings);
  Future<void> updateUsername(String username);
  Future<void> updateUserAvatar(String avatarPath);
  Future<void> updateTheme(String theme);
  Future<void> addModel(ChatModelEntity model);
  Future<void> updateModel(ChatModelEntity model);
  Future<void> deleteModel(String modelId);
  Future<List<ChatModelEntity>> getAllModels();
  Future<ChatModelEntity?> getModelById(String modelId);
  Future<void> resetToDefault();
}
