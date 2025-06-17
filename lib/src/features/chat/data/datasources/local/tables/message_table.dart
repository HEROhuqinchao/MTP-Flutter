import 'package:drift/drift.dart';
import 'session_table.dart';

class ChatMessages extends Table {
  /// 消息ID
  IntColumn get id => integer().autoIncrement()();

  /// 消息对应的会话ID
  TextColumn get sessionId =>
      text().references(Sessions, #id, onDelete: KeyAction.cascade)();

  /// 消息类型, 'user', 'agent'
  TextColumn get type => text()();

  /// 消息发送者ID
  TextColumn get sender => text()();

  /// 消息发送时间
  DateTimeColumn get createdAt => dateTime()();

  /// 消息内容
  TextColumn get content => text()();

  /// 消息是否已读
  BoolColumn get isRead => boolean().nullable()();
}
