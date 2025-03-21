import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../domain/entities/message_entity.dart';
import '../../../domain/entities/session_entity.dart';
import '../../../domain/repositories/chat_repository.dart';
import '../../../di/providers/repository_providers.dart';
import 'chat_state.dart';

// 会话状态管理提供者
final chatStateProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatNotifier(chatRepository);
});

// 过滤后的会话列表提供者
final filteredSessionsProvider = Provider<List<SessionEntity>>((ref) {
  final state = ref.watch(chatStateProvider);
  final query = state.searchQuery.toLowerCase();

  if (query.isEmpty) {
    return state.sessions;
  }

  return state.sessions.where((session) {
    return session.title.toLowerCase().contains(query) ||
        session.messages.any(
          (message) => message.content.toLowerCase().contains(query),
        );
  }).toList();
});

// 当前选择的会话提供者
final currentSessionProvider = Provider<SessionEntity?>((ref) {
  final state = ref.watch(chatStateProvider);
  return state.currentSession;
});

// 会话状态管理器
class ChatNotifier extends StateNotifier<ChatState> {
  final ChatRepository _chatRepository;
  final uuid = Uuid();

  ChatNotifier(this._chatRepository) : super(const ChatState()) {
    // 初始化时加载会话列表
    loadSessions();
    print('ChatNotifier初始化，加载会话列表');
  }

  // 加载所有会话
  Future<void> loadSessions() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final sessions = await _chatRepository.getAllSessions();
      state = state.copyWith(
        sessions: sessions,
        isLoading: false,
        currentSession:
            sessions.isNotEmpty && sessions.length > state.selectedSessionIndex
                ? sessions[state.selectedSessionIndex]
                : null,
      );
    } catch (e) {
      // 详细记录错误
      print('加载会话失败: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: '加载会话失败: ${e.toString()}',
      );
    }
  }

  // 选择会话
  void selectSession(int index) {
    if (index >= 0 && index < state.sessions.length) {
      state = state.copyWith(
        selectedSessionIndex: index,
        currentSession: state.sessions[index],
      );
    }
  }

  // 发送消息
  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty || state.currentSession == null) return;

    final currentSession = state.currentSession!;

    if (currentSession.id == null) {
      state = state.copyWith(errorMessage: '无法发送消息：会话ID为空');
      return;
    }

    final message = MessageEntity(
      id: uuid.v4(),
      content: content,
      timestamp: DateTime.now(),
      isFromUser: true,
      isRead: true,
    );

    // 创建更新后的会话
    final updatedMessages = [...currentSession.messages, message];
    final updatedSession = currentSession.copyWith(
      messages: updatedMessages,
      updatedAt: DateTime.now(),
    );

    // 更新状态
    final updatedSessions = [...state.sessions];
    updatedSessions[state.selectedSessionIndex] = updatedSession;

    state = state.copyWith(
      sessions: updatedSessions,
      currentSession: updatedSession,
    );

    // 保存到仓库
    try {
      await _chatRepository.addMessageToSession(currentSession.id!, message);
    } catch (e) {
      state = state.copyWith(errorMessage: '发送消息失败: $e');
    }

    // 在这里你还可以调用生成回复的方法
  }

  // 设置搜索查询
  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  // 创建新会话
  Future<void> createSession(String title, String roleId) async {
    final session = SessionEntity(
      id: uuid.v4(), // 新会话，ID为空
      roleId: roleId,
      title: title,
      messages: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    try {
      await _chatRepository.addSession(session);
      // 重新加载会话列表
      await loadSessions();
      // 选择新创建的会话
      selectSession(0); // 假设新会话会出现在列表头部
    } catch (e) {
      state = state.copyWith(errorMessage: '创建会话失败: $e');
    }
  }

  // 删除会话
  Future<void> deleteSession(String sessionId) async {
    try {
      await _chatRepository.deleteSession(sessionId);
      await loadSessions();
    } catch (e) {
      state = state.copyWith(errorMessage: '删除会话失败: $e');
    }
  }

  // 删除错误消息
  Future<void> clearErrorMessage() async {
    state = state.copyWith(errorMessage: null);
  }
}
