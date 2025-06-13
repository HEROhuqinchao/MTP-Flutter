import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/role_entity.dart';
import '../../domain/repositories/role_repository.dart';
import '../../../../di/providers/repository_providers.dart';
import 'role_state.dart';
import '../../../../utils/logger.dart';

// 角色状态提供者
final roleStateProvider = StateNotifierProvider<RoleNotifier, RoleState>((ref) {
  final roleRepository = ref.watch(roleRepositoryProvider);
  return RoleNotifier(roleRepository);
});

// 角色状态管理器
class RoleNotifier extends StateNotifier<RoleState> {
  final RoleRepository _roleRepository;

  RoleNotifier(this._roleRepository) : super(const RoleState()) {
    // 初始化时加载所有角色
    loadRoles();
  }

  // 加载所有角色
  Future<void> loadRoles() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final roles = await _roleRepository.getAllRoles();
      state = state.copyWith(
        roles: roles,
        isLoading: false,
        selectedRole: roles.isNotEmpty ? roles.first : null,
      );
      // 为每个角色检查并创建默认会话
      // await _ensureDefaultSessionsForRoles(roles);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: '加载角色失败: $e');
    }
  }

  // 根据ID获取角色
  Future<RoleEntity?> getRoleById(String roleId) async {
    try {
      // 先尝试从本地状态中查找
      final localRole = state.roles.firstWhere(
        (role) => role.id == roleId,
        orElse: () => throw Exception('未在本地状态中找到角色'),
      );
      return localRole;
    } catch (_) {
      try {
        // 如果本地状态中没有，则从仓库中获取
        final role = await _roleRepository.getRoleById(roleId);
        return role;
      } catch (e) {
        localLogger.shout('获取角色失败: $e');
        return null;
      }
    }
  }

  // 添加角色
  Future<void> addRole(RoleEntity role) async {
    try {
      await _roleRepository.addRole(role);
      await loadRoles();
    } catch (e) {
      state = state.copyWith(errorMessage: '添加角色失败: $e');
    }
  }

  // 更新角色
  Future<void> updateRole(RoleEntity role) async {
    try {
      await _roleRepository.updateRole(role);
      await loadRoles();
    } catch (e) {
      state = state.copyWith(errorMessage: '更新角色失败: $e');
    }
  }

  // 删除角色
  Future<void> deleteRole(String roleId) async {
    try {
      await _roleRepository.deleteRole(roleId);
      await loadRoles();
    } catch (e) {
      state = state.copyWith(errorMessage: '删除角色失败: $e');
    }
  }
}
