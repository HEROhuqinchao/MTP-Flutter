import 'package:drift/drift.dart';
import 'package:mtp/src/features/chat/data/datasources/local/tables/message_table.dart';
import 'package:mtp/src/features/chat/data/datasources/local/tables/session_roles_table.dart';
import 'package:mtp/src/features/chat/data/datasources/local/tables/session_table.dart';
import 'package:mtp/src/features/chat/data/models/session_with_details.dart';
import 'package:mtp/src/shared/data/datasources/local/app_database.dart';

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

  /// 更新会话的可选属性，并返回影响行数
  Future<int> updateSession(
    String sessionId, {
    DateTime? lastMessageAt,
    String? title,
    bool? isPinned,
  }) => (update(sessions)..where((t) => t.id.equals(sessionId))).write(
    SessionsCompanion(
      lastMessageAt: Value.absentIfNull(lastMessageAt),
      title: Value.absentIfNull(title),
      isPinned: Value.absentIfNull(isPinned),
    ),
  );

  /// 更新会话、角色列表及消息列表
  Future<void> updateSessionWithRolesAndMessages({
    required Session session,
    required List<String> newRoleIds,
    required List<ChatMessagesCompanion> newMessages,
  }) => transaction(() async {
    final replaced = await update(sessions).replace(session);
    if (!replaced) throw StateError('Session not found');

    await (delete(sessionRoles)
      ..where((sr) => sr.sessionId.equals(session.id))).go();
    await batch((b) {
      b.insertAll(
        sessionRoles,
        newRoleIds
            .map(
              (rid) => SessionRolesCompanion.insert(
                sessionId: session.id,
                roleId: rid,
              ),
            )
            .toList(),
      );
    });

    await (delete(chatMessages)
      ..where((cm) => cm.sessionId.equals(session.id))).go();
    await batch((b) {
      b.insertAll(chatMessages, newMessages);
    });
  });

  /// 删除会话
  Future<bool> deleteSession(String id) async {
    final cnt = await (delete(sessions)..where((t) => t.id.equals(id))).go();
    return cnt > 0;
  }

  /// 搜索会话标题，忽略大小写+模糊匹配
  Future<List<Session>> searchSessions(String query) =>
      (select(sessions)
        ..where((t) => t.title.lower().like('%${query.toLowerCase()}%'))).get();
}
