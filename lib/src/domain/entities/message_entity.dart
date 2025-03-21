class MessageEntity {
  final String id;
  final String content;
  final DateTime timestamp;
  final bool isFromUser;
  final bool isRead;
  final String? senderName;
  final String? senderAvatar;

  MessageEntity({
    required this.id,
    required this.content,
    required this.timestamp,
    required this.isFromUser,
    this.isRead = false,
    this.senderName,
    this.senderAvatar,
  });
}
