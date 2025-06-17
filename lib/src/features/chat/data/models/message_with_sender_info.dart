class MessageWithSenderInfo {
  final int id;
  final String content;
  final DateTime createdAt;
  final bool isFromUser;
  final bool isSystem;
  final String senderId;
  final String senderName;
  final String senderAvatar;
  final bool isRead;

  MessageWithSenderInfo(
    this.id,
    this.content,
    this.createdAt,
    this.isFromUser,
    this.isSystem,
    this.isRead,
    this.senderId,
    this.senderName,
    this.senderAvatar,
  );
}
