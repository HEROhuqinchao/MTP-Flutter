// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SessionEntity _$SessionEntityFromJson(Map<String, dynamic> json) =>
    _SessionEntity(
      id: json['id'] as String?,
      roleId: json['roleId'] as String,
      title: json['title'] as String,
      messages:
          (json['messages'] as List<dynamic>?)
              ?.map((e) => MessageEntity.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt:
          json['createdAt'] == null
              ? null
              : DateTime.parse(json['createdAt'] as String),
      updatedAt:
          json['updatedAt'] == null
              ? null
              : DateTime.parse(json['updatedAt'] as String),
      isPinned: json['isPinned'] as bool? ?? false,
    );

Map<String, dynamic> _$SessionEntityToJson(_SessionEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'roleId': instance.roleId,
      'title': instance.title,
      'messages': instance.messages,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'isPinned': instance.isPinned,
    };
