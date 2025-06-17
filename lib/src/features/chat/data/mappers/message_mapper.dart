import 'package:mtp/src/features/chat/data/models/message_with_sender_info.dart';
import 'package:mtp/src/features/chat/domain/entities/chat_message_entity.dart';

extension MessageWithSenderInfoX on MessageWithSenderInfo {
  ChatMessageEntity toEntity() => ChatMessageEntity(
    id: id,
    content: content,
    createdAt: createdAt,
    isFromUser: isFromUser,
    isSystem: false,
    senderId: senderId,
    senderName: senderName,
    senderAvatar: senderAvatar,
  );
}
