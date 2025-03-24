import 'package:hive_ce/hive.dart';
import 'message.dart';

class Session extends HiveObject {
  Session({
    this.key,
    required this.roleId,
    required this.title,
    this.messages = const [],
    this.createdAt,
    this.updatedAt,
    this.isPinned = false,
  });

  @override
  String? key;
  String roleId;
  String title;
  List<ChatMessage> messages;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? isPinned;

  // 添加新消息
  void addMessage(ChatMessage message) {
    messages.add(message);
    updatedAt = DateTime.now();
  }

  // 获取最后一条消息
  ChatMessage? get lastMessage {
    if (messages.isEmpty) return null;
    return messages.last;
  }

  // 获取消息数量
  int get messageCount => messages.length;
}
