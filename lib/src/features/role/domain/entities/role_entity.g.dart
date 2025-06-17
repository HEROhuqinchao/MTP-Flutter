// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RoleEntity _$RoleEntityFromJson(Map<String, dynamic> json) => _RoleEntity(
  id: json['id'] as String,
  name: json['name'] as String,
  avatars: (json['avatars'] as List<dynamic>).map((e) => e as String).toList(),
  prompt: json['prompt'] as String?,
);

Map<String, dynamic> _$RoleEntityToJson(_RoleEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'avatars': instance.avatars,
      'prompt': instance.prompt,
    };
