import 'package:freezed_annotation/freezed_annotation.dart';

part 'role_entity.freezed.dart';
part 'role_entity.g.dart';

@freezed
abstract class RoleEntity with _$RoleEntity {
  const factory RoleEntity({
    /// 角色 ID
    required String id,

    /// 角色名称
    required String name,

    /// 角色头像
    required List<String> avatars,

    /// 角色提示词
    String? prompt,
  }) = _RoleEntity;

  factory RoleEntity.fromJson(Map<String, dynamic> json) =>
      _$RoleEntityFromJson(json);
}
