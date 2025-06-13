import '../../domain/entities/settings_entity.dart';
import '../../domain/entities/chat_model_entity.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/local/settings_local_datasource.dart';
import '../models/settings.dart';
import '../datasources/local/tables/model_table.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDatasource localDatasource;

  SettingsRepositoryImpl(this.localDatasource);

  @override
  Future<SettingsEntity> getSettings() async {
    final settings = await localDatasource.getSettings();
    return _mapSettingsToEntity(settings);
  }

  @override
  Future<void> updateSettings(SettingsEntity settings) async {
    await localDatasource.updateSettings(_mapEntityToSettings(settings));
  }

  @override
  Future<void> updateUsername(String username) async {
    await localDatasource.updateUsername(username);
  }

  @override
  Future<void> updateUserAvatar(String avatarPath) async {
    await localDatasource.updateUserAvatar(avatarPath);
  }

  @override
  Future<void> updateTheme(String theme) async {
    await localDatasource.updateTheme(theme);
  }

  @override
  Future<void> addModel(ChatModelEntity model) async {
    await localDatasource.addModel(_mapEntityToModel(model));
  }

  @override
  Future<void> updateModel(ChatModelEntity model) async {
    await localDatasource.updateModel(_mapEntityToModel(model));
  }

  @override
  Future<void> deleteModel(String modelId) async {
    await localDatasource.deleteModel(modelId);
  }

  @override
  Future<List<ChatModelEntity>> getAllModels() async {
    final models = await localDatasource.getAllModels();
    return models.map(_mapModelToEntity).toList();
  }

  @override
  Future<ChatModelEntity?> getModelById(String modelId) async {
    final model = await localDatasource.getModelById(modelId);
    if (model == null) return null;
    return _mapModelToEntity(model);
  }

  @override
  Future<void> resetToDefault() async {
    await localDatasource.resetToDefault();
  }

  // 辅助方法：将设置模型转换为实体
  SettingsEntity _mapSettingsToEntity(Settings settings) {
    return SettingsEntity(
      id: settings.key,
      username: settings.username,
      userAvatar: settings.userAvatar,
      theme: settings.theme,
      models: settings.models.map(_mapModelToEntity).toList(),
    );
  }

  // 辅助方法：将设置实体转换为模型
  Settings _mapEntityToSettings(SettingsEntity entity) {
    return Settings(
      key: entity.id,
      username: entity.username,
      userAvatar: entity.userAvatar,
      theme: entity.theme,
      models: entity.models.map(_mapEntityToModel).toList(),
    );
  }

  // 辅助方法：将聊天模型转换为实体
  ChatModelEntity _mapModelToEntity(ChatModel model) {
    return ChatModelEntity(
      id: model.key,
      name: model.name,
      endpoint: model.endpoint,
      apiKey: model.apiKey,
      temparture: model.temparture,
      isSelected: model.isSelected,
    );
  }

  // 辅助方法：将聊天模型实体转换为模型
  ChatModel _mapEntityToModel(ChatModelEntity entity) {
    return ChatModel(
      key: entity.id,
      name: entity.name,
      endpoint: entity.endpoint,
      apiKey: entity.apiKey,
      temparture: entity.temparture,
      isSelected: entity.isSelected,
    );
  }
}
