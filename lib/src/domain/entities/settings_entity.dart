import 'package:freezed_annotation/freezed_annotation.dart';
import 'chat_model_entity.dart';

part 'settings_entity.freezed.dart';
part 'settings_entity.g.dart';

@freezed
abstract class SettingsEntity with _$SettingsEntity {
  const factory SettingsEntity({
    String? id,
    required String username,
    required String userAvatar,
    required String theme,
    required List<ChatModelEntity> models,
  }) = _SettingsEntity;

  factory SettingsEntity.fromJson(Map<String, dynamic> json) =>
      _$SettingsEntityFromJson(json);
}
