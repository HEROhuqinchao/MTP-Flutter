import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/services.dart';
import 'package:mtp/src/features/role/data/datasources/local/tables/role_table.dart';
import 'package:mtp/src/shared/data/datasources/local/app_database.dart';
import 'package:mtp/src/utils/logger.dart';
import 'package:uuid/uuid.dart';

part 'roles_dao.g.dart';

@DriftAccessor(tables: [Roles])
class RolesDao extends DatabaseAccessor<AppDatabase> with _$RolesDaoMixin {
  RolesDao(super.db);

  Future<List<RolesCompanion>> fetchDefaultRoles() async {
    try {
      // 从本地资源加载数据
      final String jsonString = await rootBundle.loadString(
        'assets/data/student_updated.json',
      );
      final List<dynamic> rolesData = jsonDecode(jsonString);
      localLogger.info('从本地资源加载默认角色成功');
      final uuid = Uuid();

      return rolesData.map((data) {
        String avatars = '';

        if (data['avatars'] is String) {
          avatars = data['avatars'];
        } else if (data['avatars'] is List) {
          avatars = jsonEncode(data['avatars']);
        } else {
          avatars = "[\"assets/images/default_avatar.png\"]";
        }

        return RolesCompanion(
          id: Value(uuid.v4()),
          name: Value(data['name']),
          avatars: Value(avatars),
          prompt: Value(data['prompt']),
        );
      }).toList();
    } catch (e) {
      throw Exception('读取本地默认角色数据时出错: $e');
    }
  }

  // 检查是否为空
  Future<bool> isEmpty() async {
    final exists = await customSelect(
      'SELECT EXISTS(SELECT 1 FROM roles LIMIT 1) AS hasRow',
      readsFrom: {roles},
    ).getSingle().then((row) => row.read<bool>('hasRow'));

    return !exists;
  }

  /// 添加角色
  Future<void> addRole(RolesCompanion role) async {
    await into(roles).insert(role);
  }

  /// 获取所有角色
  Future<List<Role>> getAllRoles() async {
    return await select(roles).get();
  }

  /// 根据ID获取单个角色
  Future<Role?> getRoleById(String id) =>
      (select(roles)..where((r) => r.id.equals(id))).getSingleOrNull();

  /// 更新角色
  Future<void> updateRole(RolesCompanion role) async {
    await update(roles).replace(role);
  }

  /// 删除角色
  Future<void> deleteRole(String id) async {
    await (delete(roles)..where((r) => r.id.equals(id))).go();
  }

  /// 清空所有角色
  Future<void> clearAllRoles() async {
    await delete(roles).go();
  }

  /// 根据名称搜索角色
  Future<List<Role>> searchRolesByName(String query) async {
    return (select(roles)
      ..where((r) => r.name.lower().like('${query.toLowerCase()}%'))).get();
  }
}
