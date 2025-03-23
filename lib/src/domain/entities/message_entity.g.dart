// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MessageEntity _$MessageEntityFromJson(Map<String, dynamic> json) =>
    _MessageEntity(
      id: json['id'] as String?,
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isFromUser: json['isFromUser'] as bool,
      isRead: json['isRead'] as bool? ?? false,
      isGenerating: json['isGenerating'] as bool? ?? false,
      isSystem: json['isSystem'] as bool? ?? false,
      senderName: json['senderName'] as String?,
      senderAvatar: json['senderAvatar'] as String?,
    );

Map<String, dynamic> _$MessageEntityToJson(_MessageEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'timestamp': instance.timestamp.toIso8601String(),
      'isFromUser': instance.isFromUser,
      'isRead': instance.isRead,
      'isGenerating': instance.isGenerating,
      'isSystem': instance.isSystem,
      'senderName': instance.senderName,
      'senderAvatar': instance.senderAvatar,
    };
