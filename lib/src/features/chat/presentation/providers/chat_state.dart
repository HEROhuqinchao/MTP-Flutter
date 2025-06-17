import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mtp/src/features/chat/domain/entities/session_details_entity.dart';

part 'chat_state.freezed.dart';

@freezed
abstract class ChatState with _$ChatState {
  const factory ChatState({
    @Default([]) List<SessionDetailsEntity> sessions,
    @Default(0) int selectedSessionIndex,
    SessionDetailsEntity? currentSession,
    @Default(false) bool isLoading,
    @Default(false) bool isGenerating,
    String? errorMessage,
    @Default('') String searchQuery,
  }) = _ChatState;
}
