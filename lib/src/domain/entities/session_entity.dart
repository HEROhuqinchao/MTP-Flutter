import 'message_entity.dart';

class SessionEntity {
  final String? id;
  final String roleId;
  final String title;
  final List<MessageEntity> messages;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SessionEntity({
    this.id,
    required this.roleId,
    required this.title,
    required this.messages,
    this.createdAt,
    this.updatedAt,
  });

  SessionEntity copyWith({
    String? id,
    String? roleId,
    String? title,
    List<MessageEntity>? messages,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SessionEntity(
      id: id ?? this.id,
      roleId: roleId ?? this.roleId,
      title: title ?? this.title,
      messages: messages ?? this.messages,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
