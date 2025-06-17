import 'package:mtp/src/features/chat/data/models/session_with_details.dart';
import 'package:mtp/src/features/chat/domain/entities/session_details_entity.dart';

extension SessionWithDetailsX on SessionWithDetails {
  SessionDetailsEntity toEntity() => SessionDetailsEntity(
    id: session.id,
    title: session.title,
    type: session.type,
    avatar: session.avatar,
    isPinned: session.isPinned,
    lastMessageAt: session.lastMessageAt,
    createdAt: session.createdAt,
    roleIds: roleIds,
  );
}
