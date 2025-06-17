import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mtp/src/shared/domain/entities/chat_model_entity.dart';

part 'settings_entity.freezed.dart';
part 'settings_entity.g.dart';

@freezed
abstract class SettingsEntity with _$SettingsEntity {
  const factory SettingsEntity({
    /// 设置 ID
    required String id,

    /// 用户名称
    required String username,

    /// 用户头像
    required String userAvatar,

    /// 主题
    required String theme,

    /// 聊天模型列表
    required List<ChatModelEntity> models,
  }) = _SettingsEntity;

  factory SettingsEntity.fromJson(Map<String, dynamic> json) =>
      _$SettingsEntityFromJson(json);
}
