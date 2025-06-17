// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_details_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SessionDetailsEntity _$SessionDetailsEntityFromJson(
  Map<String, dynamic> json,
) => _SessionDetailsEntity(
  id: json['id'] as String,
  title: json['title'] as String,
  type: (json['type'] as num).toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  isPinned: json['isPinned'] as bool,
  avatar: json['avatar'] as String?,
  lastMessageAt:
      json['lastMessageAt'] == null
          ? null
          : DateTime.parse(json['lastMessageAt'] as String),
  lastMessage:
      json['lastMessage'] == null
          ? null
          : ChatMessageEntity.fromJson(
            json['lastMessage'] as Map<String, dynamic>,
          ),
  roleIds: (json['roleIds'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$SessionDetailsEntityToJson(
  _SessionDetailsEntity instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'type': instance.type,
  'createdAt': instance.createdAt.toIso8601String(),
  'isPinned': instance.isPinned,
  'avatar': instance.avatar,
  'lastMessageAt': instance.lastMessageAt?.toIso8601String(),
  'lastMessage': instance.lastMessage,
  'roleIds': instance.roleIds,
};
