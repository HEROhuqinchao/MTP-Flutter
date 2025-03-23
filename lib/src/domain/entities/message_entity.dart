import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_entity.freezed.dart';
part 'message_entity.g.dart';

@freezed
abstract class MessageEntity with _$MessageEntity {
  const factory MessageEntity({
    String? id,
    required String content,
    required DateTime timestamp,
    required bool isFromUser,
    @Default(false) bool isRead,
    @Default(false) bool isGenerating,
    @Default(false) bool isSystem,
    String? senderName,
    String? senderAvatar,
  }) = _MessageEntity;

  factory MessageEntity.fromJson(Map<String, dynamic> json) =>
      _$MessageEntityFromJson(json);
}
