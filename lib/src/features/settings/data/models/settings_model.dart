import 'package:mtp/src/shared/data/datasources/local/app_database.dart';
import 'package:uuid/uuid.dart';

class SettingsModel {
  String id;
  String username;
  String userAvatar;
  String theme;
  List<ChatModel> models;

  SettingsModel({
    required this.id,
    required this.username,
    required this.userAvatar,
    required this.theme,
    required this.models,
  });

  /// 创建默认设置
  factory SettingsModel.defaultSettings() => SettingsModel(
    id: Uuid().v4(),
    username: "Sensei",
    userAvatar: "assets/default_avatar.png",
    theme: "system",
    models: [],
  );
}
