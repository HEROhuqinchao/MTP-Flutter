// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_session_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ActiveSessionEntity _$ActiveSessionEntityFromJson(Map<String, dynamic> json) =>
    _ActiveSessionEntity(
      id: json['id'] as String,
      title: json['title'] as String,
      type: (json['type'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      isPinned: json['isPinned'] as bool,
      avatar: json['avatar'] as String?,
      roleIds:
          (json['roleIds'] as List<dynamic>).map((e) => e as String).toList(),
      messages:
          (json['messages'] as List<dynamic>)
              .map((e) => ChatMessageEntity.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$ActiveSessionEntityToJson(
  _ActiveSessionEntity instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'type': instance.type,
  'createdAt': instance.createdAt.toIso8601String(),
  'isPinned': instance.isPinned,
  'avatar': instance.avatar,
  'roleIds': instance.roleIds,
  'messages': instance.messages,
};
