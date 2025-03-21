import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/role_entity.dart';

part 'role_state.freezed.dart';

@freezed
abstract class RoleState with _$RoleState {
  const factory RoleState({
    @Default([]) List<RoleEntity> roles,
    RoleEntity? selectedRole,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _RoleState;
}
