import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_model_entity.freezed.dart';
part 'chat_model_entity.g.dart';

@freezed
abstract class ChatModelEntity with _$ChatModelEntity {
  const factory ChatModelEntity({
    required String id,
    required String name,
    required String endpoint,
    required double temparture,
    required String apiKey,
    required bool isSelected,
  }) = _ChatModelEntity;

  factory ChatModelEntity.fromJson(Map<String, dynamic> json) =>
      _$ChatModelEntityFromJson(json);
}
