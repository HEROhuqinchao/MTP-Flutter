import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/role_entity.dart';
import '../../../domain/entities/session_entity.dart';
import '../../../domain/repositories/chat_repository.dart';
import '../../../domain/repositories/role_repository.dart';
import '../../../di/providers/repository_providers.dart';
import 'role_state.dart';

// 角色状态提供者
final roleStateProvider = StateNotifierProvider<RoleNotifier, RoleState>((ref) {
  final roleRepository = ref.watch(roleRepositoryProvider);
  final chatRepository = ref.watch(chatRepositoryProvider); // 添加聊天仓库
  return RoleNotifier(roleRepository, chatRepository);
});

// 角色状态管理器
class RoleNotifier extends StateNotifier<RoleState> {
  final RoleRepository _roleRepository;
  final ChatRepository _chatRepository;

  RoleNotifier(this._roleRepository, this._chatRepository)
    : super(const RoleState()) {
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
      await _ensureDefaultSessionsForRoles(roles);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: '加载角色失败: $e');
    }
  }

  // 确保每个角色都有一个默认会话
  Future<void> _ensureDefaultSessionsForRoles(List<RoleEntity> roles) async {
    try {
      for (final role in roles) {
        // 检查该角色是否已有会话
        final roleSessions = await _chatRepository.getSessionsByRoleId(
          role.id!,
        );

        // 如果该角色没有会话，创建一个默认会话
        if (roleSessions.isEmpty) {
          final defaultSession = SessionEntity(
            id: null,
            roleId: role.id!,
            title: "与${role.name}的对话",
            messages: [],
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

          await _chatRepository.addSession(defaultSession);
        }
      }
    } catch (e) {
      print('为角色创建默认会话失败: $e');
      // 这里可以选择是否更新状态，因为这只是一个辅助功能
    }
  }

  // 选择角色
  void selectRole(String roleId) {
    final role = state.roles.firstWhere(
      (r) => r.id == roleId,
      orElse: () => state.roles.first,
    );

    state = state.copyWith(selectedRole: role);
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
