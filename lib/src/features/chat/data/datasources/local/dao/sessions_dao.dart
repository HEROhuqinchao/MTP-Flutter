import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:mtp/src/features/chat/data/datasources/local/tables/message_table.dart';
import 'package:mtp/src/features/chat/data/datasources/local/tables/session_roles_table.dart';
import 'package:mtp/src/features/chat/data/datasources/local/tables/session_table.dart';
import 'package:mtp/src/features/chat/data/models/active_session.dart';
import 'package:mtp/src/features/chat/data/models/message_with_sender_info.dart';
import 'package:mtp/src/features/chat/data/models/session_with_details.dart';
import 'package:mtp/src/shared/data/datasources/local/app_database.dart';
import 'package:mtp/src/utils/logger.dart';
import 'package:uuid/uuid.dart';

part 'sessions_dao.g.dart';

@DriftAccessor(tables: [Sessions, SessionRoles, ChatMessages])
class SessionsDao extends DatabaseAccessor<AppDatabase>
    with _$SessionsDaoMixin {
  SessionsDao(super.db);

  /// 添加单个会话
  Future<int> addSession(SessionsCompanion session) =>
      into(sessions).insert(session);

  /// 查询所有会话
  Future<List<Session>> _getAllSessions() => select(sessions).get();

  /// 查询所有会话的具体信息
  Future<List<SessionWithDetails>> getAllSessionsWithDetails() => transaction(
    () async {
      final sessions = await _getAllSessions();
      return Future.wait(
        sessions.map((session) async => (await getSessionDetails(session.id))!),
      );
    },
  );

  /// 根据 ID 查询单个会话
  Future<Session?> getSessionById(String id) =>
      (select(sessions)..where((s) => s.id.equals(id))).getSingleOrNull();

  /// 根据 ID 查询单个会话
  Future<ActiveSession?> getSessionWithAllInfoById(String id) =>
      transaction(() async {
        final session =
            await (select(sessions)
              ..where((s) => s.id.equals(id))).getSingleOrNull();

        if (session == null) return null;

        final roles =
            await (select(sessionRoles)..where(
              (sr) => sr.sessionId.equals(id),
            )).map((r) => r.roleId).get();

        final messages = await getMessagesFromSession(id, 20);

        return ActiveSession(
          id: session.id,
          title: session.title,
          type: session.type,
          createdAt: session.createdAt,
          isPinned: session.isPinned,
          avatar: session.avatar,
          roleIds: roles,
          messages: messages,
        );
      });

  /// 查询指定会话中的未读消息数量。
  ///
  /// 未读消息定义为 isRead 字段为 false 或 null 的消息。
  /// - [sessionId]: 要查询的会话ID。
  /// - 返回: 一个包含未读消息数量的 Future<int>。
  Future<int> getUnreadMessagesCount(String sessionId) async {
    // 构建查询表达式来计算符合条件的消息数量
    // 条件是：sessionId 匹配，并且 isRead 为 false 或者 isRead 为 NULL
    final countExpression = countAll(
      filter:
          chatMessages.sessionId.equals(sessionId) &
          (chatMessages.isRead.equals(false) | chatMessages.isRead.isNull()),
    );

    // 只选择计数结果
    final query = selectOnly(chatMessages)..addColumns([countExpression]);

    // 执行查询并获取单个结果（即计数）
    final result =
        await query.map((row) => row.read(countExpression)).getSingle();

    // countAll 结果是非空的，但如果没有任何行匹配filter，它会返回0。
    // row.read(countExpression) 可能会返回 null 如果没有行被聚合，但对于 countAll 通常是 0。
    // 为了安全起见，如果结果是 null，则返回 0。
    return result ?? 0;
  }

  /// 根据 ID 查询会话、角色 ID 列表及最新消息
  Future<SessionWithDetails?> getSessionDetails(String id) =>
      transaction(() async {
        final session = await getSessionById(id);
        if (session == null) return null;

        final lastMsg =
            await (select(chatMessages)
                  ..where((cm) => cm.sessionId.equals(id))
                  ..orderBy([(cm) => OrderingTerm.desc(cm.createdAt)])
                  ..limit(1))
                .getSingleOrNull();

        final unreadMsg = await getUnreadMessagesCount(id);

        return SessionWithDetails(
          session: session,
          lastMessage: lastMsg != null ? lastMsg.content : '',
          unreadCount: unreadMsg,
        );
      });

  Future<void> ensureRoleSessionsExist(List<(String, String)> roles) async {
    for (final role in roles) {
      final existing =
          await (select(sessionRoles)
            ..where((sr) => sr.roleId.equals(role.$1))).getSingleOrNull();

      if (existing == null) {
        final newSessionId = const Uuid().v4();

        try {
          await transaction(() async {
            await into(sessions).insert(
              SessionsCompanion.insert(
                id: newSessionId,
                title: role.$2,
                type: 0,
                isPinned: false,
              ),
            );

            await into(sessionRoles).insert(
              SessionRolesCompanion.insert(
                sessionId: newSessionId,
                roleId: role.$1,
              ),
            );
          });
          localLogger.config('为角色 ${role.$2} 创建了默认会话');
        } catch (e) {
          localLogger.shout('为角色 ${role.$2} 创建会话失败: $e');
        }
      }
    }
  }

  /// 向会话中插入消息
  Future<int> insertMessage(ChatMessagesCompanion message) =>
      into(chatMessages).insert(message);

  /// 更新会话
  Future<void> updateSession({required Session session}) =>
      transaction(() async {
        await update(sessions).replace(session);
      });

  /// 更新会话的参与角色
  Future<void> updateSessionRoles({
    required String sessionId,
    required List<String> roleIds,
  }) => transaction(() async {
    // 删除旧的角色关联
    await (delete(sessionRoles)
      ..where((sr) => sr.sessionId.equals(sessionId))).go();

    // 插入新的角色关联
    for (final roleId in roleIds) {
      await into(sessionRoles).insert(
        SessionRolesCompanion(
          sessionId: Value(sessionId),
          roleId: Value(roleId),
        ),
      );
    }
  });

  /// 删除会话
  Future<bool> deleteSession(String id) async {
    final cnt = await (delete(sessions)..where((t) => t.id.equals(id))).go();
    return cnt > 0;
  }

  /// 清空所有会话内的聊天记录
  Future<void> clearAllMessages() => delete(chatMessages).go();

  /// 清空所有会话
  Future<void> clearAllSessions() => delete(sessions).go();

  /// 搜索会话标题，忽略大小写+模糊匹配
  Future<List<Session>> searchSessions(String query) =>
      (select(sessions)
        ..where((t) => t.title.lower().like('%${query.toLowerCase()}%'))).get();

  Future<List<MessageWithSenderInfo>> getMessagesFromSession(
    String sessionId,
    int limit,
  ) async {
    final messages =
        await (select(chatMessages)
              ..where((cm) => cm.sessionId.equals(sessionId))
              ..orderBy([(cm) => OrderingTerm.desc(cm.createdAt)])
              ..limit(limit))
            .get();
    return Future.wait(
      messages.map((message) async {
        final sender =
            await (select(roles)
              ..where((u) => u.id.equals(message.sender))).getSingle();
        List<String> avatars =
            (jsonDecode(sender.avatars) as List<dynamic>).cast<String>();

        return MessageWithSenderInfo(
          id: message.id,
          content: message.content,
          createdAt: message.createdAt,
          isFromUser: message.type == 'user',
          isRead: message.isRead ?? false,
          senderId: sender.id,
          senderName: sender.name,
          senderAvatar: avatars.isEmpty ? '' : avatars.first,
        );
      }),
    );
  }
}
