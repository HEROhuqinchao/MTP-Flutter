import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_list_item_entity.freezed.dart';
part 'session_list_item_entity.g.dart';

/// 表示会话列表中的单个会话项。
///
/// 用于在会话列表中展示会话的摘要信息。
@freezed
abstract class SessionListItemEntity with _$SessionListItemEntity {
  /// 创建一个 [SessionListItemEntity] 实例。
  const factory SessionListItemEntity({
    /// 会话的唯一标识符。
    required String id,

    /// 会话的标题或名称。
    required String title,

    /// 会话类型。
    ///
    /// 0 代表私聊，1 代表群聊。
    required int type,

    /// 会话的创建时间。
    required DateTime createdAt,

    /// 指示会话是否被置顶。
    required bool isPinned,

    /// 会话的头像URL或本地路径。
    ///
    /// 如果没有头像，则为 `null`。
    String? avatar,

    /// 会话中未读消息的数量。
    ///
    /// 如果没有未读消息，则为 `0`。
    required int unreadCount,

    /// 会话中最后一条消息的发送时间。
    ///
    /// 如果会话中没有消息，则为 `null`。
    DateTime? lastMessageAt,

    /// 会话中的最后一条消息实体。
    required String lastMessage,
  }) = _SessionListItemEntity;

  /// 从JSON映射创建一个 [SessionListItemEntity] 实例。
  factory SessionListItemEntity.fromJson(Map<String, dynamic> json) =>
      _$SessionListItemEntityFromJson(json);
}
