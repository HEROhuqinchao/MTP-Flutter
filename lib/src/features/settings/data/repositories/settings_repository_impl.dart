import 'package:drift/drift.dart';
import 'package:mtp/src/features/settings/data/datasources/local/dao/settings_dao.dart';
import 'package:mtp/src/features/settings/domain/entities/settings_entity.dart';
import 'package:mtp/src/features/settings/domain/repositories/settings_repository.dart';
import 'package:mtp/src/shared/data/datasources/local/app_database.dart';
import 'package:mtp/src/shared/domain/entities/chat_model_entity.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsDao dao;

  SettingsRepositoryImpl(this.dao);

  @override
  Future<SettingsEntity> getSettings() async {
    final (settingsData, modelDataList) = await dao.getSettingsDetails();
    return _fromData(settingsData, modelDataList);
  }

  @override
  Future<void> updateSettings(SettingsEntity settings) async {
    final settingsData = SettingsCompanion(
      id: Value(settings.id),
      username: Value(settings.username),
      userAvatar: Value(settings.userAvatar),
      theme: Value(settings.theme),
    );

    final modelsCompanions = settings.models.map((m) =>
      ChatModelsCompanion(
        settingsId: Value(settings.id),
        name: Value(m.name),
        endpoint: Value(m.endpoint),
        apiKey: Value(m.apiKey),
        temparture: Value(m.temparture),
        isSelected: Value(m.isSelected),
      )
    ).toList();

    await dao.updateSettingsWithModels(
      settingsData: settingsData,
      models: modelsCompanions,
    );
  }

  @override
  Future<void> updateUsername(String username) async {
    final id = (await dao.getOrCreateSettings()).id;
    await dao.updateUsername(id: id, username: username);
  }

  @override
  Future<void> updateUserAvatar(String avatarPath) async {
    final id = (await dao.getOrCreateSettings()).id;
    await dao.updateUserAvatar(id: id, avatarPath: avatarPath);
  }

  @override
  Future<void> updateTheme(String theme) async {
    final id = (await dao.getOrCreateSettings()).id;
    await dao.updateTheme(id: id, theme: theme);
  }

  @override
  Future<void> addModel(ChatModelEntity model) async {
    final id = (await dao.getOrCreateSettings()).id;
    await dao.addModel(
      ChatModelsCompanion.insert(
        settingsId: id,
        name: model.name,
        endpoint: model.endpoint,
        apiKey: model.apiKey,
        temparture: model.temparture,
        isSelected: model.isSelected,
      ),
    );
  }

  @override
  Future<void> updateModel(ChatModelEntity model) async {
    final id = (await dao.getOrCreateSettings()).id;
    await dao.updateModel(
      ChatModelsCompanion(
        settingsId: Value(id),
        name: Value(model.name),
        endpoint: Value(model.endpoint),
        apiKey: Value(model.apiKey),
        temparture: Value(model.temparture),
        isSelected: Value(model.isSelected),
      ),
    );
  }

  @override
  Future<void> deleteModel(String modelId) async {
    await dao.deleteModel(modelId);
  }

  @override
  Future<List<ChatModelEntity>> getAllModels() async {
    final list = await dao.getAllModels();
    return list.map(_modelDataToEntity).toList();
  }

  @override
  Future<ChatModelEntity?> getModelById(String modelId) async {
    final m = await dao.getModelById(modelId);
    return m == null ? null : _modelDataToEntity(m);
  }

  @override
  Future<void> resetToDefault() async {
    await dao.resetToDefault();
  }

  SettingsEntity _fromData(Setting s, List<ChatModel> ms) {
    return SettingsEntity(
      id: s.id,
      username: s.username,
      userAvatar: s.userAvatar,
      theme: s.theme,
      models: ms.map(_modelDataToEntity).toList(),
    );
  }

  ChatModelEntity _modelDataToEntity(ChatModel m) {
    return ChatModelEntity(
      id: m.id,
      name: m.name,
      endpoint: m.endpoint,
      apiKey: m.apiKey,
      temparture: m.temparture,
      isSelected: m.isSelected,
    );
  }
}