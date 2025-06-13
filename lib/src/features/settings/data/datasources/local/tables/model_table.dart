import 'package:drift/drift.dart';
import '../../../models/settings.dart';

class ChatModels extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get settingsId =>
      text().references(Settings, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  TextColumn get endpoint => text()();
  TextColumn get apiKey => text()();
  RealColumn get temparture => real()();
  BoolColumn get isSelected => boolean()();
}
