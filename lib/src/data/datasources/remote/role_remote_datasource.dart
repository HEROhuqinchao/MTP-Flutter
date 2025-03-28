import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';
import '../../models/role.dart';

class RoleRemoteDatasource {
  final Dio _dio;

  RoleRemoteDatasource({Dio? dio}) : _dio = dio ?? Dio();

  Future<List<Role>> fetchDefaultRoles() async {
    try {
      final response = await _dio.get(
        'https://aronacdn.hanasaki.tech/mtp/student.json',
      );

      if (response.statusCode == 200) {
        final List<dynamic> rolesData = response.data;
        print('获取默认角色成功');
        final uuid = Uuid();

        return rolesData.map((data) {
          // 处理avatars字段
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
              print('解析avatars字段失败: $e，使用原始字符串');
              avatars = [avatarsStr]; // 解析失败时作为单个字符串处理
            }
          } else if (data['avatars'] is List) {
            // 已经是列表，直接转换
            avatars = List<String>.from(data['avatars']);
          } else {
            // null或其他类型，使用默认值
            avatars = ["assets//default_avatar.png"];
          }

          return Role(
            key: uuid.v4(),
            name: data['name'],
            avatars: avatars,
            prompt: data['prompt'],
            lastMessage: data['lastMessage'] ?? '',
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
