import 'package:drift/drift.dart';

class Roles extends Table {
  /// 角色id
  TextColumn get id => text()();

  /// 角色名称
  TextColumn get name => text()();

  /// 角色头像
  TextColumn get avatars => text()(); // List<String>

  /// 角色描述
  TextColumn get description => text().nullable()();

  /// 角色提示词
  TextColumn get prompt => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
