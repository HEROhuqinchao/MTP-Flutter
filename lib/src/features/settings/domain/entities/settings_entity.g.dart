// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SettingsEntity _$SettingsEntityFromJson(Map<String, dynamic> json) =>
    _SettingsEntity(
      id: json['id'] as String,
      username: json['username'] as String,
      userAvatar: json['userAvatar'] as String,
      theme: json['theme'] as String,
      models:
          (json['models'] as List<dynamic>)
              .map((e) => ChatModelEntity.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$SettingsEntityToJson(_SettingsEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'userAvatar': instance.userAvatar,
      'theme': instance.theme,
      'models': instance.models,
    };
