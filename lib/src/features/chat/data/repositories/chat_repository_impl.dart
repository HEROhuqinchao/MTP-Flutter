import 'package:mtp/src/features/chat/data/datasources/local/dao/sessions_dao.dart';
import 'package:mtp/src/features/chat/domain/repositories/chat_repository.dart';


class ChatRepositoryImpl implements ChatRepository {
  final SessionsDao dao;

  ChatRepositoryImpl(this.dao);

  @override
  Future<void> addMessageToSession(
    String sessionId,
    MessageEntity message,
  ) async {
    final messageModel = ChatMessage(
      role: message.isFromUser ? 'user' : 'assistant',
      content: message.content,
    );

    await localDatasource.addMessageToSession(sessionId, messageModel);
  }

  @override
  Future<void> addSession(SessionEntity session) async {
    final messageModels =
        session.messages
            .map(
              (m) => ChatMessage(
                role: m.isFromUser ? 'user' : 'assistant',
                content: m.content,
                isRead: m.isRead,
              ),
            )
            .toList();

    final sessionModel = Session(
      key: session.id,
      roleId: session.roleId,
      title: session.title,
      messages: messageModels,
      createdAt: session.createdAt,
      updatedAt: session.updatedAt,
      isPinned: session.isPinned,
    );

    await localDatasource.addSession(sessionModel);
  }

  @override
  Future<void> deleteSession(String id) async {
    await localDatasource.deleteSession(id);
  }

  @override
  Future<List<SessionEntity>> getAllSessions() async {
    final sessions = await localDatasource.getAllSessions();
    return sessions.map((session) {
      final messageEntities =
          session.messages
              .map(
                (msg) => MessageEntity(
                  id:
                      msg.key ??
                      '', // Using message key as ID or empty string if null
                  content: msg.content,
                  isRead: msg.isRead ?? false,
                  timestamp:
                      DateTime.now(), // Default to current time if not available in msg
                  isFromUser: msg.role == 'user',
                ),
              )
              .toList();

      return SessionEntity(
        id: session.key,
        roleId: session.roleId,
        title: session.title,
        messages: messageEntities,
        createdAt: session.createdAt,
        updatedAt: session.updatedAt,
        isPinned: session.isPinned,
      );
    }).toList();
  }

  @override
  Future<List<MessageEntity>> getMessagesFromSession(String sessionId) async {
    final messages = await localDatasource.getMessagesFromSession(sessionId);
    return messages
        .map(
          (msg) => MessageEntity(
            id:
                msg.key ??
                '', // Using message key as ID or empty string if null
            content: msg.content,
            isRead: msg.isRead ?? false,
            timestamp:
                DateTime.now(), // Default to current time if not available
            isFromUser: msg.role == 'user',
          ),
        )
        .toList();
  }

  @override
  Future<SessionEntity?> getSessionById(String id) async {
    final session = await localDatasource.getSessionById(id);
    if (session == null) return null;

    final messageEntities =
        session.messages
            .map(
              (msg) => MessageEntity(
                id:
                    msg.key ??
                    '', // Using message key as ID or empty string if null
                content: msg.content,
                timestamp:
                    DateTime.now(), // Default to current time if not available
                isFromUser: msg.role == 'user',
              ),
            )
            .toList();

    return SessionEntity(
      id: session.key,
      roleId: session.roleId,
      title: session.title,
      messages: messageEntities,
      createdAt: session.createdAt,
      updatedAt: session.updatedAt,
    );
  }

  @override
  Future<List<SessionEntity>> getSessionsByRoleId(String roleId) async {
    final sessions = await localDatasource.getSessionsByRoleId(roleId);
    return sessions.map((session) {
      final messageEntities =
          session.messages
              .map(
                (msg) => MessageEntity(
                  id:
                      msg.key ??
                      '', // Using message key as ID or empty string if null
                  content: msg.content,
                  timestamp:
                      DateTime.now(), // Default to current time if not available
                  isFromUser: msg.role == 'user',
                ),
              )
              .toList();

      return SessionEntity(
        id: session.key,
        roleId: session.roleId,
        title: session.title,
        messages: messageEntities,
        createdAt: session.createdAt,
        updatedAt: session.updatedAt,
      );
    }).toList();
  }

  @override
  Future<void> updateSession(SessionEntity session) async {
    if (session.id == null) {
      throw Exception('无法更新没有ID的会话');
    }

    final messageModels =
        session.messages
            .map(
              (m) => ChatMessage(
                role: m.isFromUser ? 'user' : 'assistant',
                content: m.content,
              ),
            )
            .toList();

    final sessionModel = Session(
      roleId: session.roleId,
      title: session.title,
      messages: messageModels,
      createdAt: session.createdAt,
      updatedAt: session.updatedAt,
      isPinned: session.isPinned,
    )..key = session.id;

    await localDatasource.updateSession(sessionModel);
  }

  @override
  Future<void> clearAllSessions() async {
    await localDatasource.clearAllSessions();
  }

  @override
  Future<void> clearAllMessages() async {
    await localDatasource.clearAllMessages();
  }
}
