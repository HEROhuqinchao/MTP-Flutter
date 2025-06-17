import 'package:drift/drift.dart';
import 'package:mtp/src/features/chat/data/datasources/local/tables/session_table.dart';
import 'package:mtp/src/features/role/data/datasources/local/tables/role_table.dart';

class SessionRoles extends Table {
  /// 会话ID
  TextColumn get sessionId =>
      text().references(Sessions, #id, onDelete: KeyAction.cascade)();

  /// 角色ID
  TextColumn get roleId =>
      text().references(Roles, #id, onDelete: KeyAction.cascade)();

  /// 角色加入会话的时间
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {sessionId, roleId};
}
