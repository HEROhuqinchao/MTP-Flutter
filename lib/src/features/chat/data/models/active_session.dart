import 'package:mtp/src/features/chat/data/models/message_with_sender_info.dart';

class ActiveSession {
  final String id;
  final String title;
  final int type;
  final DateTime createdAt;
  final bool isPinned;
  final String? avatar;
  final List<String> roleIds;
  final List<MessageWithSenderInfo> messages;

  ActiveSession({
    /// 会话ID
    required this.id,

    /// 会话标题
    required this.title,

    /// 会话类型，0: 私聊，1: 群聊
    required this.type,

    /// 会话创建时间
    required this.createdAt,

    /// 是否置顶
    required this.isPinned,

    /// 会话头像
    this.avatar = '',

    /// 会话内的角色列表
    required this.roleIds,

    /// 会话内的所有消息
    required this.messages,

    // TODO:添加分页加载相关的状态
  });
}
