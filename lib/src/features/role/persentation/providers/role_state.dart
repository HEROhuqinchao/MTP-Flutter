import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/role_entity.dart';

part 'role_state.freezed.dart';

@freezed
abstract class RoleState with _$RoleState {
  const factory RoleState({
    /// 角色列表
    @Default([]) List<RoleEntity> roles,

    /// 选中的角色
    RoleEntity? selectedRole,

    /// 正在加载
    @Default(false) bool isLoading,

    /// 错误消息
    String? errorMessage,
  }) = _RoleState;
}
