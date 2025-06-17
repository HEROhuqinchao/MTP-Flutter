import 'package:mtp/src/features/chat/data/models/message_with_sender_info.dart';
import 'package:mtp/src/features/chat/domain/entities/chat_message_entity.dart';

extension MessageWithSenderInfoMapper on MessageWithSenderInfo {
  ChatMessageEntity toEntity() => ChatMessageEntity(
    id: id,
    content: content,
    createdAt: createdAt,
    isFromUser: isFromUser,
    senderId: senderId,
    senderName: senderName,
    senderAvatar: senderAvatar,
  );
}
