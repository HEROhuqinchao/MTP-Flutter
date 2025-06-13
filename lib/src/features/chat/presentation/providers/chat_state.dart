import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/session_entity.dart';

part 'chat_state.freezed.dart';

// 使用freezed管理状态
@freezed
abstract class ChatState with _$ChatState {
  const factory ChatState({
    @Default([]) List<SessionEntity> sessions,
    @Default(0) int selectedSessionIndex,
    SessionEntity? currentSession,
    @Default(false) bool isLoading,
    @Default(false) bool isGenerating,
    String? errorMessage,
    @Default('') String searchQuery,
  }) = _ChatState;
}
