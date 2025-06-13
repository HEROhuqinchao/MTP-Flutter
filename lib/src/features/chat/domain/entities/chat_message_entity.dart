import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message_entity.freezed.dart';
part 'chat_message_entity.g.dart';

@freezed
abstract class ChatMessageEntity with _$ChatMessageEntity {
  const factory ChatMessageEntity({
    /// 消息ID
    required String id,

    /// 消息内容
    required String content,

    /// 消息创建时间
    required DateTime createAt,

    /// 是否为用户自身消息
    required bool isFromUser,

    /// 发送者名称
    required String senderName,

    /// 发送者头像
    required String senderAvatar,

    /// 是否已读
    @Default(false) bool isRead,

    /// 是否正在生成回复
    @Default(false) bool isGenerating,
  }) = _ChatMessageEntity;

  factory ChatMessageEntity.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageEntityFromJson(json);
}
