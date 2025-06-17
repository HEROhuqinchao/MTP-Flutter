import 'package:drift/drift.dart';
import 'package:mtp/src/features/settings/data/datasources/local/tables/chat_model_table.dart';
import 'package:mtp/src/features/settings/data/datasources/local/tables/settings_table.dart';
import 'package:mtp/src/features/settings/domain/entities/settings_entity.dart';
import 'package:mtp/src/shared/data/datasources/local/app_database.dart';
import 'package:mtp/src/shared/domain/entities/chat_model_entity.dart';

part 'settings_dao.g.dart';

@DriftAccessor(tables: [Settings, ChatModels])
class SettingsDao extends DatabaseAccessor<AppDatabase>
    with _$SettingsDaoMixin {
  SettingsDao(super.db);

  /// 获取设置
  Future<Setting> getOrCreateSettings() async {
    final row = await select(settings).getSingleOrNull();
    if (row != null) return row;

    final companion = SettingsCompanion(
      username: const Value('Sensei'),
      userAvatar: const Value('assets/default_avatar.png'),
      theme: const Value('system'),
    );

    await into(settings).insert(companion);
    return (select(settings)).getSingle();
  }

  /// 更新设置
  Future<void> updateSettings({
    required SettingsCompanion settingsData,
    required List<ChatModelsCompanion> models,
  }) async {
    await transaction(() async {
      await update(settings).replace(settingsData);

      await (delete(chatModels)
        ..where((cm) => cm.settingsId.equals(settingsData.id.toString()))).go();

      await batch((b) {
        b.insertAll(chatModels, models, mode: InsertMode.insertOrReplace);
      });
    });
  }

  /// 更新用户名
  Future<void> updateUsername({
    required String id,
    required String username,
  }) async {
    await (update(settings)..where(
      (s) => s.id.equals(id),
    )).write(SettingsCompanion(username: Value(username)));
  }

  // 更新用户头像
  Future<void> updateUserAvatar({
    required String id,
    required String avatarPath,
  }) async {
    await (update(settings)..where(
      (s) => s.id.equals(id),
    )).write(SettingsCompanion(userAvatar: Value(avatarPath)));
  }

  // 更新主题
  Future<void> updateTheme({required String id, required String theme}) async {
    await (update(settings)..where(
      (s) => s.id.equals(id),
    )).write(SettingsCompanion(theme: Value(theme)));
  }

  // 添加模型
  Future<void> addModel(ChatModelsCompanion model) async {
    await into(chatModels).insert(model);
  }

  // 更新模型
  Future<void> updateModel(ChatModelsCompanion model) async {
    await update(chatModels).replace(model);
  }

  // 删除模型
  Future<void> deleteModel(String id) async {
    await (delete(chatModels)..where((cm) => cm.id.equals(id))).go();
  }

  // 获取所有模型
  Future<List<ChatModel>> getAllModels() async {
    return await select(chatModels).get();
  }

  // 获取特定模型
  Future<ChatModel?> getModelById(String id) async {
    return await (select(chatModels)
      ..where((cm) => cm.id.equals(id))).getSingleOrNull();
  }

  // 重置设置为默认值
  Future<void> resetToDefault() async {
    await (delete(settings)).go();
    final companion = SettingsCompanion(
      username: const Value('Sensei'),
      userAvatar: const Value('assets/default_avatar.png'),
      theme: const Value('system'),
    );

    await into(settings).insert(companion);
  }

  // 更新设置时同时插入/替换 Models
  Future<void> updateSettingsWithModels({
    required SettingsCompanion settingsData,
    required List<ChatModelsCompanion> models,
  }) async {
    await transaction(() async {
      await update(settings).replace(settingsData);

      await (delete(chatModels)
        ..where((t) => t.settingsId.equals(settingsData.id.toString()))).go();

      if (models.isNotEmpty) {
        await batch((b) {
          b.insertAll(chatModels, models, mode: InsertMode.insertOrReplace);
        });
      }
    });
  }

  // 获取组合：设置 + 聊天模型列表
  Future<(Setting, List<ChatModel>)> getSettingsDetails() async {
    final s = await getOrCreateSettings();
    final models =
        await (select(chatModels)
          ..where((c) => c.settingsId.equals(s.id))).get();
    return (s, models);
  }

  // 单一方法完成：获取并转成 Domain 实体
  Future<SettingsEntity> loadSettings() async {
    final (s, models) = await getSettingsDetails();
    final modelsEntity =
        models
            .map(
              (model) => ChatModelEntity(
                id: model.id,
                name: model.name,
                endpoint: model.endpoint,
                temparture: model.temparture,
                apiKey: model.apiKey,
                isSelected: model.isSelected,
              ),
            )
            .toList();
    return SettingsEntity(
      id: s.id,
      username: s.username,
      userAvatar: s.userAvatar,
      theme: s.theme,
      models: modelsEntity,
    );
  }
}
