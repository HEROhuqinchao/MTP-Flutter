import 'package:drift/drift.dart';
import 'package:mtp/src/features/settings/data/datasources/local/tables/settings_table.dart';
import 'package:uuid/uuid.dart';

/// 定义了在本地数据库中存储聊天模型配置的表。
///
/// 每个聊天模型代表一个可用于生成文本补全的LLM配置，
/// 包括其名称、API端点、密钥和默认参数等。
class ChatModels extends Table {
  /// 模型的唯一标识符，使用UUID v4自动生成。
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();

  /// 关联的设置ID。
  ///
  /// 用于将此聊天模型与特定的设置项关联起来。
  /// 当关联的设置被删除时，此模型记录也会被级联删除。
  TextColumn get settingsId =>
      text().references(Settings, #id, onDelete: KeyAction.cascade)();

  /// 用户可读的模型名称。
  TextColumn get customName => text()();

  /// 模型名称。
  TextColumn get modelName => text()();

  /// 调用此模型的API端点URL。
  TextColumn get endpoint => text()();

  /// 与此模型关联的API密钥。
  TextColumn get apiKey => text()();

  /// 模型的默认温度设置。
  ///
  /// 温度控制生成文本的随机性。较高的值使输出更随机，较低的值使其更具确定性。
  RealColumn get temperature => real()();

  /// 指示此模型当前是否被用户选中或激活为默认模型。
  BoolColumn get isSelected => boolean()();

  @override
  Set<Column> get primaryKey => {id};
}
