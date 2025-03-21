import '../../domain/entities/role_entity.dart';
import '../../domain/repositories/role_repository.dart';
import '../datasources/local/role_local_datasource.dart';
import '../datasources/remote/role_remote_datasource.dart';
import '../models/role.dart';

class RoleRepositoryImpl implements RoleRepository {
  final RoleLocalDatasource localDatasource;
  final RoleRemoteDatasource remoteDatasource;

  RoleRepositoryImpl(this.localDatasource, this.remoteDatasource);

  @override
  Future<List<RoleEntity>> initialize() async {
    await localDatasource.initialize();

    List<Role> addedRoles = [];

    // 检查是否首次运行，由仓库决定是否加载初始数据
    if (await localDatasource.isEmpty()) {
      try {
        // 从远程获取数据
        final roles = await remoteDatasource.fetchDefaultRoles();
        print('获取到${roles.length}个远程角色');

        // 保存到本地
        for (final role in roles) {
          try {
            await localDatasource.addRole(role);
            addedRoles.add(role);
            print('成功添加角色: ${role.name}');
          } catch (e) {
            print('添加单个角色失败: ${role.name}, 错误: $e');
          }
        }
      } catch (e, stackTrace) {
        print('远程获取或处理数据失败: $e');
        print('堆栈: $stackTrace');

        // 远程获取失败，加载备用数据
        addedRoles = await _loadFallbackRoles();
        print('远程获取失败，加载备用数据');
      }
    }

    // 返回添加的角色实体列表
    return addedRoles
        .map(
          (role) => RoleEntity(
            id: role.key,
            name: role.name,
            avatars: role.avatars,
            prompt: role.prompt,
            lastMessage: role.lastMessage,
          ),
        )
        .toList();
  }

  // 备用角色加载
  Future<List<Role>> _loadFallbackRoles() async {
    final fallbackRoles = [
      Role(
        name: "助手",
        avatars: ["assets/avatars/assistant.png"],
        prompt: "你是一个有用的AI助手。",
        lastMessage: "",
      ),
      // 添加更多默认角色
    ];

    for (final role in fallbackRoles) {
      await localDatasource.addRole(role);
    }

    return fallbackRoles;
  }

  @override
  Future<void> addRole(RoleEntity role) async {
    await localDatasource.addRole(
      Role(
        key: role.id,
        name: role.name,
        avatars: role.avatars,
        prompt: role.prompt,
        lastMessage: role.lastMessage,
      ),
    );
  }

  @override
  Future<List<RoleEntity>> getAllRoles() async {
    final roles = await localDatasource.getAllRoles();
    return roles
        .map(
          (role) => RoleEntity(
            id: role.key,
            name: role.name,
            avatars: role.avatars,
            prompt: role.prompt,
            lastMessage: role.lastMessage,
          ),
        )
        .toList();
  }

  @override
  Future<void> deleteRole(String id) async {
    await localDatasource.deleteRole(id);
  }

  @override
  Future<RoleEntity?> getRoleById(String id) async {
    final role = await localDatasource.getRoleById(id);
    if (role == null) return null;

    return RoleEntity(
      id: role.key,
      name: role.name,
      avatars: role.avatars,
      prompt: role.prompt,
      lastMessage: role.lastMessage,
    );
  }

  @override
  Future<List<RoleEntity>> searchRolesByName(String query) async {
    final roles = await localDatasource.searchRolesByName(query);
    return roles
        .map(
          (role) => RoleEntity(
            id: role.key,
            name: role.name,
            avatars: role.avatars,
            prompt: role.prompt,
            lastMessage: role.lastMessage,
          ),
        )
        .toList();
  }

  @override
  Future<void> updateRole(RoleEntity role) async {
    if (role.id == null) {
      throw Exception('无法更新没有ID的角色');
    }

    final roleModel = Role(
      key: role.id,
      name: role.name,
      avatars: role.avatars,
      prompt: role.prompt,
      lastMessage: role.lastMessage,
    );

    await localDatasource.updateRole(roleModel);
  }
}
