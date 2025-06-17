import 'package:mtp/src/shared/data/datasources/local/app_database.dart';

class SessionWithDetails {
  /// 会话
  final Session session;

  /// 角色 ID 列表
  final List<String> roleIds;

  /// 会话中最后一条消息
  final ChatMessage? lastMessage;

  SessionWithDetails(this.session, this.roleIds, this.lastMessage);
}
