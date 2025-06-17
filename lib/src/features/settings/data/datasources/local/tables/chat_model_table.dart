import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'settings_table.dart';

class ChatModels extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get settingsId =>
      text().references(Settings, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  TextColumn get endpoint => text()();
  TextColumn get apiKey => text()();
  RealColumn get temparture => real()();
  BoolColumn get isSelected => boolean()();

  @override
  Set<Column> get primaryKey => {id};
}
