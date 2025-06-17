class MessageWithSenderInfo {
  final int id;
  final String content;
  final DateTime createdAt;
  final bool isFromUser;
  final String senderId;
  final String senderName;
  final String senderAvatar;
  final bool isRead;

  MessageWithSenderInfo({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.isFromUser,
    required this.isRead,
    required this.senderId,
    required this.senderName,
    required this.senderAvatar,
  });
}
