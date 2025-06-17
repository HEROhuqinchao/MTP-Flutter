// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_list_item_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SessionListItemEntity _$SessionListItemEntityFromJson(
  Map<String, dynamic> json,
) => _SessionListItemEntity(
  id: json['id'] as String,
  title: json['title'] as String,
  type: (json['type'] as num).toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  isPinned: json['isPinned'] as bool,
  avatar: json['avatar'] as String?,
  unreadCount: (json['unreadCount'] as num).toInt(),
  lastMessageAt:
      json['lastMessageAt'] == null
          ? null
          : DateTime.parse(json['lastMessageAt'] as String),
  lastMessage: json['lastMessage'] as String,
);

Map<String, dynamic> _$SessionListItemEntityToJson(
  _SessionListItemEntity instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'type': instance.type,
  'createdAt': instance.createdAt.toIso8601String(),
  'isPinned': instance.isPinned,
  'avatar': instance.avatar,
  'unreadCount': instance.unreadCount,
  'lastMessageAt': instance.lastMessageAt?.toIso8601String(),
  'lastMessage': instance.lastMessage,
};
