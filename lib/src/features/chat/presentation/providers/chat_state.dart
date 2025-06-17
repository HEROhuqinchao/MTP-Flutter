import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mtp/src/features/chat/domain/entities/active_session_entity.dart';
import 'package:mtp/src/features/chat/domain/entities/session_list_item_entity.dart';

part 'chat_state.freezed.dart';

/// 表示聊天功能的状态。
///
/// 这包括聊天会话列表、当前选中的会话、
/// 加载状态、错误信息和搜索查询。
@freezed
abstract class ChatState with _$ChatState {
  /// 创建一个 [ChatState] 实例。
  const factory ChatState({
    /// 所有可用的聊天会话列表。
    /// 默认为空列表。
    @Default([]) List<SessionListItemEntity> sessions,

    /// 当前在 [sessions] 列表中选中的会话索引。
    /// 默认为 0。
    @Default(-1) int selectedSessionIndex,

    /// 当前活动或正在查看的聊天会话。
    /// 如果当前没有活动的会话，则可以为 `null`。
    ActiveSessionEntity? currentSession,

    /// 指示聊天数据（例如，会话列表）当前是否正在加载。
    /// 默认为 `false`。
    @Default(false) bool isLoading,

    /// 指示当前是否正在为消息生成AI回复。
    /// 默认为 `false`。
    @Default(false) bool isGenerating,

    /// 如果发生错误，则为错误信息字符串，否则为 `null`。
    String? errorMessage,

    /// 用户输入的用于筛选会话的当前搜索查询文本。
    /// 默认为空字符串。
    @Default('') String searchQuery,
  }) = _ChatState;
}
