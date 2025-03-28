import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:hive_ce/hive.dart';
import 'package:mtp/src/utils/logger.dart';
import 'package:uuid/uuid.dart';
import '../../models/role.dart';

class RoleLocalDatasource {
  static const String _boxName = 'roles';
  late Box<Role> rolesBox;
  bool _isInitialized = false;

  // 移除对远程数据源的依赖
  RoleLocalDatasource();

  Future<List<Role>> fetchDefaultRoles() async {
    try {
      // 从本地资源加载数据
      final String jsonString = await rootBundle.loadString(
        'assets/data/student_updated.json',
      );
      final List<dynamic> rolesData = jsonDecode(jsonString);
      localLogger.info('从本地资源加载默认角色成功');
      final uuid = Uuid();

      return rolesData.map((data) {
        // 处理avatars字段 - 保持原有的解析逻辑
        List<String> avatars = [];

        if (data['avatars'] is String) {
          String avatarsStr = data['avatars'];

          try {
            // 尝试解析JSON数组字符串
            if (avatarsStr.startsWith('[') && avatarsStr.endsWith(']')) {
              // 这是一个JSON数组字符串
              List<dynamic> parsedList = jsonDecode(avatarsStr);
              avatars = parsedList.map((item) => item.toString()).toList();
            } else {
              // 单个字符串，视为单元素列表
              avatars = [avatarsStr];
            }
          } catch (e) {
            localLogger.shout('解析avatars字段失败: $e，使用原始字符串');
            avatars = [avatarsStr]; // 解析失败时作为单个字符串处理
          }
        } else if (data['avatars'] is List) {
          // 已经是列表，直接转换
          avatars = List<String>.from(data['avatars']);
        } else {
          // null或其他类型，使用默认值
          avatars = ["assets/images/default_avatar.png"];
        }

        return Role(
          key: uuid.v4(),
          name: data['name'],
          avatars: avatars,
          prompt: data['prompt'],
          lastMessage: data['lastMessage'] ?? '',
        );
      }).toList();
    } catch (e) {
      throw Exception('读取本地默认角色数据时出错: $e');
    }
  }

  // 检查是否为空（替代isFirstRun）
  Future<bool> isEmpty() async {
    await _ensureInitialized();
    return rolesBox.isEmpty;
  }

  // 初始化方法，只负责打开Box
  Future<void> initialize() async {
    if (!_isInitialized) {
      rolesBox = await Hive.openBox<Role>(_boxName);
      _isInitialized = true;
      print('Role box initialized successfully, has ${rolesBox.length} items');
    }
  }

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  // 添加角色
  Future<void> addRole(Role role) async {
    await _ensureInitialized();
    await rolesBox.add(role);
  }

  // 获取所有角色
  Future<List<Role>> getAllRoles() async {
    await _ensureInitialized();
    return rolesBox.values.toList();
  }

  // 根据ID获取单个角色
  Future<Role?> getRoleById(String id) async {
    await _ensureInitialized();
    // 查找ID对应的索引
    for (int i = 0; i < rolesBox.length; i++) {
      final role = rolesBox.getAt(i);
      if (role?.key == id) {
        return role;
      }
    }
    return null;
  }

  // 更新角色
  Future<void> updateRole(Role role) async {
    await _ensureInitialized();
    if (role.key == null) {
      throw Exception('无法更新没有key的角色');
    }

    // 查找对应的索引
    for (int i = 0; i < rolesBox.length; i++) {
      final existingRole = rolesBox.getAt(i);
      if (existingRole?.key == role.key) {
        await rolesBox.putAt(i, role);
        return;
      }
    }

    throw Exception('未找到要更新的角色');
  }

  // 删除角色
  Future<void> deleteRole(String id) async {
    await _ensureInitialized();
    // 查找对应的索引
    for (int i = 0; i < rolesBox.length; i++) {
      final role = rolesBox.getAt(i);
      if (role?.key == id) {
        await rolesBox.deleteAt(i);
        return;
      }
    }
  }

  // 清空所有角色
  Future<void> clearAllRoles() async {
    await _ensureInitialized();
    await rolesBox.clear();
  }

  // 根据名称搜索角色
  Future<List<Role>> searchRolesByName(String query) async {
    await _ensureInitialized();
    return rolesBox.values
        .where((role) => role.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
