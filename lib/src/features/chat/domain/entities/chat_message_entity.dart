import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message_entity.freezed.dart';
part 'chat_message_entity.g.dart';

/// 表示一条聊天消息。
@freezed
abstract class ChatMessageEntity with _$ChatMessageEntity {
  /// 创建一个 [ChatMessageEntity] 实例。
  const factory ChatMessageEntity({
    /// 消息的唯一标识符。
    required int id,

    /// 消息的文本内容。
    required String content,

    /// 消息的创建或发送时间。
    required DateTime createdAt,

    /// 指示此消息是否由当前用户发送。
    required bool isFromUser,

    /// 消息发送者的唯一标识符。
    required String senderId,

    /// 消息发送者的显示名称。
    required String senderName,

    /// 消息发送者的头像URL或本地路径。
    required String senderAvatar,

    /// 指示消息是否已被接收方阅读。
    ///
    /// 默认为 `false`。
    @Default(false) bool isRead,

    /// 指示是否正在为此消息（通常是用户消息）生成AI回复。
    ///
    /// 默认为 `false`。
    @Default(false) bool isGenerating,
  }) = _ChatMessageEntity;

  /// 从JSON映射创建一个 [ChatMessageEntity] 实例。
  factory ChatMessageEntity.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageEntityFromJson(json);
}
