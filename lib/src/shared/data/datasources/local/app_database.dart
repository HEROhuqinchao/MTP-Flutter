import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:mtp/src/features/chat/data/datasources/local/dao/sessions_dao.dart';
import 'package:mtp/src/features/chat/data/datasources/local/tables/message_table.dart';
import 'package:mtp/src/features/chat/data/datasources/local/tables/session_roles_table.dart';
import 'package:mtp/src/features/settings/data/datasources/local/tables/model_table.dart';
import 'package:mtp/src/features/chat/data/datasources/local/tables/session_table.dart';
import 'package:mtp/src/features/role/data/datasources/local/tables/role.dart';
import 'package:mtp/src/features/settings/data/models/settings.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [ChatMessages, Sessions, Roles, SessionRoles, Settings, ChatModels],
  daos: [SessionsDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'mtp'));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }
}
