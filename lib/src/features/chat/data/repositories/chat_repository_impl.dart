import 'package:drift/drift.dart';
import 'package:mtp/src/features/chat/data/datasources/local/dao/sessions_dao.dart';
import 'package:mtp/src/features/chat/data/mappers/message_mapper.dart';
import 'package:mtp/src/features/chat/domain/entities/chat_message_entity.dart';
import 'package:mtp/src/features/chat/domain/entities/session_details_entity.dart';
import 'package:mtp/src/features/chat/domain/repositories/chat_repository.dart';
import 'package:mtp/src/shared/data/datasources/local/app_database.dart';
import 'package:mtp/src/features/chat/data/mappers/session_mapper.dart';

class ChatRepositoryImpl implements ChatRepository {
  final SessionsDao dao;

  ChatRepositoryImpl(this.dao);

  @override
  Future<void> addMessageToSession(
    String sessionId,
    ChatMessageEntity message,
  ) async {
    try {
      final companion = ChatMessagesCompanion(
        sessionId: Value(sessionId),
        sender: Value(message.senderId),
        content: Value(message.content),
        createdAt: Value(message.createdAt),
      );

      await dao.insertMessage(companion);
    } on Exception catch (e) {
      throw Exception('❗ 添加消息至会话失败: $e');
    }
  }

  @override
  Future<void> addSession(SessionDetailsEntity session) async {
    await dao.addSession(
      SessionsCompanion(
        id: Value(session.id),
        title: Value(session.title),
        avatar: Value(session.avatar),
        type: Value(session.type),
        createdAt: Value(session.createdAt),
        lastMessageAt: Value(session.lastMessageAt),
        isPinned: Value(session.isPinned),
      ),
    );
  }

  @override
  Future<void> clearAllMessages() async {
    await dao.clearAllMessages();
  }

  @override
  Future<void> clearAllSessions() async {
    await dao.clearAllSessions();
  }

  @override
  Future<void> deleteSession(String id) async {
    await dao.deleteSession(id);
  }

  @override
  Future<List<SessionDetailsEntity>> getAllSessions() async {
    final sessions = await dao.getAllSessionsWithDetails();
    return sessions.map((session) => session.toEntity()).toList();
  }

  @override
  Future<List<ChatMessageEntity>> getMessagesFromSession(
    String sessionId,
    int limit,
  ) async {
    final messages = await dao.getMessagesFromSession(sessionId, limit);
    return messages.map((message) => message.toEntity()).toList();
  }

  @override
  Future<SessionDetailsEntity?> getSessionById(String id) async {
    return (await dao.getSessionDetails(id))?.toEntity();
  }

  @override
  Future<void> updateSession(SessionDetailsEntity session) async {
    await dao.updateSessionAndRoles(
      session: Session(
        id: session.id,
        title: session.title,
        type: session.type,
        createdAt: session.createdAt,
        lastMessageAt: session.lastMessageAt,
        isPinned: session.isPinned,
      ),
      roleIds: session.roleIds,
    );
  }
}
