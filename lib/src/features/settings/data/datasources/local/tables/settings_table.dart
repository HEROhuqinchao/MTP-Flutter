import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

class Settings extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get username => text()();
  TextColumn get userAvatar => text()();
  TextColumn get theme => text()();

  @override
  Set<Column> get primaryKey => {id};
}
