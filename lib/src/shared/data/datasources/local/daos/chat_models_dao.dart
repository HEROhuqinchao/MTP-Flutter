import 'package:drift/drift.dart';
import 'package:mtp/src/shared/data/datasources/local/app_database.dart';
import 'package:mtp/src/shared/data/datasources/local/tables/chat_model_table.dart';

part 'chat_models_dao.g.dart';

@DriftAccessor(tables: [ChatModels])
class ChatModelsDao extends DatabaseAccessor<AppDatabase>
    with _$ChatModelsDaoMixin {
  ChatModelsDao(super.db);
}
