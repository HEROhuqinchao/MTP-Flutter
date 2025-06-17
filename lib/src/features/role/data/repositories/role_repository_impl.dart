import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:mtp/src/features/role/data/datasources/local/dao/roles_dao.dart';
import 'package:mtp/src/features/role/data/datasources/remote/role_remote_datasource.dart';
import 'package:mtp/src/features/role/domain/entities/role_entity.dart';
import 'package:mtp/src/features/role/domain/repositories/role_repository.dart';
import 'package:mtp/src/shared/data/datasources/local/app_database.dart';
import 'package:mtp/src/utils/logger.dart';

class RoleRepositoryImpl implements RoleRepository {
  final RolesDao dao;
  final RoleRemoteDatasource remoteDatasource;

  RoleRepositoryImpl(this.dao, this.remoteDatasource);

  @override
  Future<List<RoleEntity>> initialize() async {
    List<Role> addedRoles = [];

    // 检查是否首次运行，由仓库决定是否加载初始数据
    if (await dao.isEmpty()) {
      try {
        List<RolesCompanion> roles;
        try {
          // 先尝试从本地获取数据
          roles = await dao.fetchDefaultRoles();
        } catch (e) {
          localLogger.warning('从本地获取数据失败，尝试从远程获取数据');
          // 从远程获取数据
          roles = await remoteDatasource.fetchDefaultRoles();
        }
        localLogger.fine('获取到${roles.length}个角色');

        // 保存到本地
        for (final role in roles) {
          try {
            await dao.addRole(role);
            addedRoles = await dao.getAllRoles();
            localLogger.fine('成功添加角色: ${role.name}');
          } catch (e) {
            localLogger.shout('添加单个角色失败: ${role.name}, 错误: $e');
          }
        }
      } catch (e, stackTrace) {
        localLogger.shout('远程获取或处理数据失败: $e');
        localLogger.shout('堆栈: $stackTrace');

        // 远程获取失败，加载备用数据
        addedRoles = await _loadFallbackRoles();
        localLogger.info('远程获取失败，加载备用数据');
      }
    }

    // 返回添加的角色实体列表
    return addedRoles
        .map(
          (role) => RoleEntity(
            id: role.id,
            name: role.name,
            avatars: List<String>.from(jsonDecode(role.avatars)),
            prompt: role.prompt ?? '请你扮演${role.name}',
          ),
        )
        .toList();
  }

  // 备用角色加载
  Future<List<Role>> _loadFallbackRoles() async {
    final fallbackRoles = [
      RolesCompanion(
        name: Value("助手"),
        avatars: Value("[\"assets/default_assist_avatar.png\"]"),
        prompt: Value("你是一个有用的AI助手。"),
      ),
      //TODO: 添加更多默认角色
    ];

    for (final role in fallbackRoles) {
      await dao.addRole(role);
    }

    return await dao.getAllRoles();
  }

  @override
  Future<void> addRole(RoleEntity role) async {
    await dao.addRole(
      RolesCompanion(
        name: Value(role.name),
        avatars: Value(jsonEncode(role.avatars)),
        prompt: Value(role.prompt),
      ),
    );
  }

  @override
  Future<List<RoleEntity>> getAllRoles() async {
    final roles = await dao.getAllRoles();
    return roles
        .map(
          (role) => RoleEntity(
            id: role.id,
            name: role.name,
            avatars: List<String>.from(jsonDecode(role.avatars)),
            prompt: role.prompt,
          ),
        )
        .toList();
  }

  @override
  Future<void> deleteRole(String id) async {
    await dao.deleteRole(id);
  }

  @override
  Future<RoleEntity?> getRoleById(String id) async {
    final role = await dao.getRoleById(id);
    if (role == null) return null;

    return RoleEntity(
      id: role.id,
      name: role.name,
      avatars: List<String>.from(jsonDecode(role.avatars)),
      prompt: role.prompt,
    );
  }

  @override
  Future<List<RoleEntity>> searchRolesByName(String query) async {
    final roles = await dao.searchRolesByName(query);
    return roles
        .map(
          (role) => RoleEntity(
            id: role.id,
            name: role.name,
            avatars: List<String>.from(jsonDecode(role.avatars)),
            prompt: role.prompt,
          ),
        )
        .toList();
  }

  @override
  Future<void> updateRole(RoleEntity role) async {
    final roleModel = RolesCompanion(
      name: Value(role.name),
      avatars: Value(jsonEncode(role.avatars)),
      prompt: Value(role.prompt),
    );

    await dao.updateRole(roleModel);
  }
}
