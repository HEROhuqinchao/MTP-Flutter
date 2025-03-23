class MessageEntity {
  final String id;
  final String content;
  final DateTime timestamp;
  final bool isFromUser;
  final bool isRead;
  final bool isGenerating;
  final bool isSystem;
  final String? senderName;
  final String? senderAvatar;

  MessageEntity({
    required this.id,
    required this.content,
    required this.timestamp,
    required this.isFromUser,
    this.isRead = false,
    this.isGenerating = false,
    this.isSystem = false,
    this.senderName,
    this.senderAvatar,
  });
}
