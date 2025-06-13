// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatMessageEntity _$ChatMessageEntityFromJson(Map<String, dynamic> json) =>
    _ChatMessageEntity(
      id: json['id'] as String,
      content: json['content'] as String,
      createAt: DateTime.parse(json['createAt'] as String),
      isFromUser: json['isFromUser'] as bool,
      senderName: json['senderName'] as String,
      senderAvatar: json['senderAvatar'] as String,
      isRead: json['isRead'] as bool? ?? false,
      isGenerating: json['isGenerating'] as bool? ?? false,
    );

Map<String, dynamic> _$ChatMessageEntityToJson(_ChatMessageEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'createAt': instance.createAt.toIso8601String(),
      'isFromUser': instance.isFromUser,
      'senderName': instance.senderName,
      'senderAvatar': instance.senderAvatar,
      'isRead': instance.isRead,
      'isGenerating': instance.isGenerating,
    };
