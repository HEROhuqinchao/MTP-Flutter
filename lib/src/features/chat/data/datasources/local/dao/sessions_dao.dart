import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:mtp/src/features/chat/data/datasources/local/tables/message_table.dart';
import 'package:mtp/src/features/chat/data/datasources/local/tables/session_roles_table.dart';
import 'package:mtp/src/features/chat/data/datasources/local/tables/session_table.dart';
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
  Future<List<Session>> getAllSessions() => select(sessions).get();

  /// 查询所有会话的具体信息
  Future<List<SessionWithDetails>> getAllSessionsWithDetails() => transaction(
    () async {
      final sessions = await getAllSessions();
      return Future.wait(
        sessions.map((session) async => (await getSessionDetails(session.id))!),
      );
    },
  );

  /// 根据 ID 查询单个会话
  Future<Session?> getSessionById(String id) =>
      (select(sessions)..where((t) => t.id.equals(id))).getSingleOrNull();

  /// 根据 ID 查询会话、角色 ID 列表及最新消息
  Future<SessionWithDetails?> getSessionDetails(String id) =>
      transaction(() async {
        final session = await getSessionById(id);
        if (session == null) return null;

        final roles =
            await (select(sessionRoles)..where(
              (sr) => sr.sessionId.equals(id),
            )).map((r) => r.roleId).get();

        final lastMsg =
            await (select(chatMessages)
                  ..where((cm) => cm.sessionId.equals(id))
                  ..orderBy([(cm) => OrderingTerm.desc(cm.createdAt)])
                  ..limit(1))
                .getSingleOrNull();

        return SessionWithDetails(session, roles, lastMsg);
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

  /// 更新会话、角色列表及消息列表
  Future<void> updateSessionAndRoles({
    required Session session,
    required List<String> roleIds,
  }) => transaction(() async {
    await update(sessions).replace(session);
    await (delete(sessionRoles)
      ..where((r) => r.sessionId.equals(session.id))).go();
    await batch((b) {
      b.insertAll(
        sessionRoles,
        roleIds
            .map(
              (rid) => SessionRolesCompanion.insert(
                sessionId: session.id,
                roleId: rid,
              ),
            )
            .toList(),
      );
    });
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
          message.id,
          message.content,
          message.createdAt,
          message.type == 'user',
          message.isRead ?? false,
          sender.id,
          sender.name,
          avatars.isEmpty ? '' : avatars.first,
        );
      }),
    );
  }
}
