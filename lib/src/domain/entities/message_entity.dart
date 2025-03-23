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

  MessageEntity copyWith({
    String? id,
    String? content,
    DateTime? timestamp,
    bool? isFromUser,
    bool? isRead,
    bool? isGenerating,
    bool? isSystem,
    String? senderName,
    String? senderAvatar,
  }) {
    return MessageEntity(
      id: id ?? this.id,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      isFromUser: isFromUser ?? this.isFromUser,
      isRead: isRead ?? this.isRead,
      isGenerating: isGenerating ?? this.isGenerating,
      isSystem: isSystem ?? this.isSystem,
      senderName: senderName ?? this.senderName,
      senderAvatar: senderAvatar ?? this.senderAvatar,
    );
  }
}
