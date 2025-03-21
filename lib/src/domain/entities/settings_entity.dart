import 'chat_model_entity.dart';

class SettingsEntity {
  final String? id;
  final String username;
  final String userAvatar;
  final String theme;
  final List<ChatModelEntity> models;

  SettingsEntity({
    this.id,
    required this.username,
    required this.userAvatar,
    required this.theme,
    required this.models,
  });

  SettingsEntity copyWith({
    String? username,
    String? userAvatar,
    String? theme,
    List<ChatModelEntity>? models,
  }) {
    return SettingsEntity(
      username: username ?? this.username,
      userAvatar: userAvatar ?? this.userAvatar,
      theme: theme ?? this.theme,
      models: models ?? this.models,
    );
  }
}
