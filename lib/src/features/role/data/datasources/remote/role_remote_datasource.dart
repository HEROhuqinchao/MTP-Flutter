import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:mtp/src/shared/data/datasources/local/app_database.dart';
import 'package:mtp/src/utils/logger.dart';
import 'package:uuid/uuid.dart';

class RoleRemoteDatasource {
  final Dio _dio;

  RoleRemoteDatasource({Dio? dio}) : _dio = dio ?? Dio();

  Future<List<RolesCompanion>> fetchDefaultRoles() async {
    try {
      final response = await _dio.get(
        'https://aronacdn.hanasaki.tech/mtp/student.json',
      );

      if (response.statusCode == 200) {
        final List<dynamic> rolesData = response.data;
        remoteLogger.info('获取默认角色成功');
        final uuid = Uuid();

        return rolesData.map((data) {
          String avatars = '';

          if (data['avatars'] is String) {
            avatars = data['avatars'];
          } else if (data['avatars'] is List) {
            avatars = jsonEncode(data['avatars']);
          } else {
            // null或其他类型，使用默认值
            avatars = "[\"assets//default_avatar.png\"]";
          }

          return RolesCompanion(
            id: Value(uuid.v4()),
            name: Value(data['name']),
            avatars: Value(avatars),
            prompt: Value(data['prompt']),
          );
        }).toList();
      } else {
        throw Exception('获取默认角色失败: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('获取默认角色时出错: $e');
    }
  }
}
