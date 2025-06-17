import 'package:mtp/src/features/chat/data/mappers/message_mapper.dart';
import 'package:mtp/src/features/chat/data/models/active_session.dart';
import 'package:mtp/src/features/chat/data/models/session_with_details.dart';
import 'package:mtp/src/features/chat/domain/entities/active_session_entity.dart';
import 'package:mtp/src/features/chat/domain/entities/session_list_item_entity.dart';

extension SessionWithDetailsMapper on SessionWithDetails {
  SessionListItemEntity toEntity() => SessionListItemEntity(
    id: session.id,
    title: session.title,
    type: session.type,
    avatar: session.avatar,
    isPinned: session.isPinned,
    lastMessageAt: session.lastMessageAt,
    lastMessage: lastMessage,
    createdAt: session.createdAt,
    unreadCount: unreadCount,
  );
}

extension ActiveSessionMapper on ActiveSession {
  ActiveSessionEntity toEntity() => ActiveSessionEntity(
    id: id,
    title: title,
    type: type,
    createdAt: createdAt,
    isPinned: isPinned,
    avatar: avatar,
    roleIds: roleIds,
    messages: messages.map((m) => m.toEntity()).toList(),
  );
}
