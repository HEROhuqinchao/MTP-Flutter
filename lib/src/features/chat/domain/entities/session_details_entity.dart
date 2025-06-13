import 'package:freezed_annotation/freezed_annotation.dart';
import 'chat_message_entity.dart';

part 'session_details_entity.freezed.dart';
part 'session_details_entity.g.dart';

@freezed
abstract class SessionDetailsEntity with _$SessionDetailsEntity {
  const factory SessionDetailsEntity({
    /// 会话ID
    required String id,

    /// 会话标题
    required String title,

    /// 会话类型，0: 私聊，1: 群聊
    required String type,

    /// 会话创建时间
    required DateTime createdAt,

    /// 是否置顶
    required bool isPinned,

    /// 最后一次消息时间
    DateTime? lastMessageAt,

    /// 最后一条消息
    ChatMessageEntity? lastMessage,

    /// 会话内的角色列表
    required List<String> roleIds,
  }) = _SessionDetailsEntity;

  factory SessionDetailsEntity.fromJson(Map<String, dynamic> json) =>
      _$SessionDetailsEntityFromJson(json);
}
