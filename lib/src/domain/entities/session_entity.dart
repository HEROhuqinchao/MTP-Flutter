import 'package:freezed_annotation/freezed_annotation.dart';
import 'message_entity.dart';

part 'session_entity.freezed.dart';
part 'session_entity.g.dart';

@freezed
abstract class SessionEntity with _$SessionEntity {
  const factory SessionEntity({
    String? id,
    required String roleId,
    required String title,
    @Default([]) List<MessageEntity> messages,
    DateTime? createdAt,
    DateTime? updatedAt,
    @Default(false) bool? isPinned,
  }) = _SessionEntity;

  factory SessionEntity.fromJson(Map<String, dynamic> json) =>
      _$SessionEntityFromJson(json);
}
