import '../entities/session_entity.dart';
import '../entities/message_entity.dart';

abstract class ChatRepository {
  Future<void> addSession(SessionEntity session);
  Future<List<SessionEntity>> getAllSessions();
  Future<SessionEntity?> getSessionById(String id);
  Future<List<SessionEntity>> getSessionsByRoleId(String roleId);
  Future<void> updateSession(SessionEntity session);
  Future<void> addMessageToSession(String sessionId, MessageEntity message);
  Future<void> deleteSession(String id);
  Future<List<MessageEntity>> getMessagesFromSession(String sessionId);

  // 添加清除所有会话的方法
  Future<void> clearAllSessions();

  // 添加清空所有聊天记录但保留会话的方法
  Future<void> clearAllMessages();
}
