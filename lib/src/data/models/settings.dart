import 'package:hive_ce/hive.dart';
import 'chat/model.dart';

class Settings extends HiveObject {
  Settings({
    this.key,
    required this.username,
    required this.userAvatar,
    required this.theme,
    required this.models,
  });

  @override
  String? key;
  String username;
  String userAvatar;
  String theme;
  List<ChatModel> models;

  // 创建默认设置
  factory Settings.defaultSettings() {
    return Settings(
      username: "Sensei",
      userAvatar: "assets/default_avatar.png",
      theme: "system",
      models: [],
    );
  }

  // 添加聊天模型
  void addModel(ChatModel model) {
    models.add(model);
  }

  // 删除聊天模型
  void removeModel(String modelId) {
    models.removeWhere((model) => model.key == modelId);
  }

  // 获取特定模型
  ChatModel? getModel(String modelId) {
    try {
      return models.firstWhere((model) => model.key == modelId);
    } catch (e) {
      return null;
    }
  }
}
