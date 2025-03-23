import 'package:freezed_annotation/freezed_annotation.dart';

part 'role_entity.freezed.dart';
part 'role_entity.g.dart';

@freezed
abstract class RoleEntity with _$RoleEntity {
  const factory RoleEntity({
    String? id,
    required String name,
    required List<String> avatars,
    required String prompt,
    required String lastMessage,
  }) = _RoleEntity;

  factory RoleEntity.fromJson(Map<String, dynamic> json) =>
      _$RoleEntityFromJson(json);
}
