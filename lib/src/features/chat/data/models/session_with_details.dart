import 'package:mtp/src/shared/data/datasources/local/app_database.dart';

class SessionWithDetails {
  /// 会话
  final Session session;

  /// 会话中未读消息的数量
  final int unreadCount;

  /// 会话中最后一条消息
  final String lastMessage;

  SessionWithDetails({
    required this.session,
    required this.unreadCount,
    required this.lastMessage,
  });
}
