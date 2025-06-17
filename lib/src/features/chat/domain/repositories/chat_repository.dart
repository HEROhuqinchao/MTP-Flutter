import 'package:mtp/src/features/chat/domain/entities/active_session_entity.dart';
import 'package:mtp/src/features/chat/domain/entities/chat_message_entity.dart';
import 'package:mtp/src/features/chat/domain/entities/session_list_item_entity.dart';

/// 聊天仓库接口。
///
/// 定义了对会话及其消息的 CRUD 操作，抽象了数据存储实现细节，
/// 可用于本地数据库、缓存或远程服务。
abstract class ChatRepository {
  /// 添加一个新的会话。
  ///
  /// [session] 是包含会话元数据、角色和最新消息信息的实体对象。
  /// 返回时表明会话数据已被持久化。
  Future<void> addSession(SessionListItemEntity session);

  /// 获取所有会话的详情列表。
  ///
  /// 返回每个会话的完整信息，包括最新消息和角色关联。
  Future<List<SessionListItemEntity>> getAllSessions();

  /// 根据会话 [id] 获取会话详情。
  ///
  /// 返回对应的 [ActiveSessionEntity]，若 ID 不存在则返回 `null`。
  Future<ActiveSessionEntity?> getSessionById(String id);

  /// 更新已有会话的全部字段。
  ///
  /// [session] 包含新的字段值，必须包含有效的 `id`，若会话不存在会抛出异常。
  Future<void> updateSession(SessionListItemEntity session);

  /// 更新会话角色列表。
  ///
  /// [sessionId] 指定目标会话， [roleIds] 是角色 ID 列表，
  Future<void> updateSessionRoles(String sessionId, List<String> roleIds);

  /// 向指定会话添加一条新消息。
  ///
  /// [sessionId] 指定目标会话， [message] 为待添加的消息实体，
  /// 若会话不存在应抛出错误。
  Future<void> addMessageToSession(String sessionId, ChatMessageEntity message);

  /// 删除指定 ID 的会话。
  ///
  /// [id] 是会话唯一标识，删除时同时清除其消息和角色关联，
  /// 若会话不存在会抛出异常。
  Future<void> deleteSession(String id);

  /// 获取某个会话中最近的多条消息。
  ///
  /// [sessionId] 指定目标会话， [limit] 为返回消息数量上限，
  /// 返回按消息发送时间倒序排列的消息列表。
  Future<List<ChatMessageEntity>> getMessagesFromSession(
    String sessionId,
    int limit,
  );

  /// 清除所有会话及其关联数据。
  Future<void> clearAllSessions();

  /// 清除所有聊天消息，但保留会话元数据。
  Future<void> clearAllMessages();
}
