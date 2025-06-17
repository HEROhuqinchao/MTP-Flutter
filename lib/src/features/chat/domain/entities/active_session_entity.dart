import 'package:freezed_annotation/freezed_annotation.dart';
import 'chat_message_entity.dart';

part 'active_session_entity.freezed.dart';
part 'active_session_entity.g.dart';

@freezed
abstract class ActiveSessionEntity with _$ActiveSessionEntity {
  const factory ActiveSessionEntity({
    /// 会话ID
    required String id,

    /// 会话标题
    required String title,

    /// 会话类型，0: 私聊，1: 群聊
    required int type,

    /// 会话创建时间
    required DateTime createdAt,

    /// 是否置顶
    required bool isPinned,

    /// 会话头像
    String? avatar,

    /// 会话内的角色列表
    required List<String> roleIds,

    /// 会话内的所有消息
    required List<ChatMessageEntity> messages,

    // TODO:添加分页加载相关的状态
  }) = _ActiveSessionEntity;

  factory ActiveSessionEntity.fromJson(Map<String, dynamic> json) =>
      _$ActiveSessionEntityFromJson(json);
}
