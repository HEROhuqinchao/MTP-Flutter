import 'package:drift/drift.dart';

class Sessions extends Table {
  /// 会话id(UUID)
  TextColumn get id => text()();

  /// 会话标题
  TextColumn get title => text()();

  /// 会话头像
  TextColumn get avatar => text().nullable()();

  /// 会话类型 0: 私聊 1: 群聊
  IntColumn get type => integer()();

  /// 会话创建时间
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// 最后一条消息更新时间
  DateTimeColumn get lastMessageAt =>
      dateTime().nullable()();

  /// 会话是否被置顶
  BoolColumn get isPinned => boolean()();

  @override
  Set<Column> get primaryKey => {id};
}
