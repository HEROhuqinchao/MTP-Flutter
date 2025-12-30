import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:mtp/src/di/providers/repository_providers.dart';
import 'package:mtp/src/features/chat/data/services/ai_response_service_impl.dart';
import 'package:mtp/src/features/chat/domain/entities/active_session_entity.dart';
import 'package:mtp/src/features/chat/domain/entities/chat_message_entity.dart';
import 'package:mtp/src/features/chat/domain/entities/session_list_item_entity.dart';
import 'package:mtp/src/features/chat/domain/repositories/chat_repository.dart';
import 'package:mtp/src/features/chat/domain/services/ai_response_service.dart';
import 'package:mtp/src/features/chat/presentation/providers/chat_state.dart';
import 'package:mtp/src/features/settings/presentation/providers/settings_provider.dart';
import 'package:mtp/src/shared/domain/entities/chat_model_entity.dart';
import 'package:mtp/src/utils/logger.dart';
import 'package:uuid/uuid.dart';

/// 会话状态管理提供者
final sessionStateProvider = StateNotifierProvider<ChatNotifier, ChatState>((
  ref,
) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  // 将 ref 传递给 ChatNotifier，以便它可以观察 selectedModelProvider
  return ChatNotifier(chatRepository: chatRepository, ref: ref);
});

// 过滤后的会话列表提供者
final filteredSessionsProvider = Provider<List<SessionListItemEntity>>((ref) {
  final state = ref.watch(sessionStateProvider);
  final query = state.searchQuery.toLowerCase();

  if (query.isEmpty) {
    return state.sessions;
  }

  return state.sessions.where((session) {
    return session.title.toLowerCase().contains(query);
  }).toList();
});

// 当前选择的会话提供者 (ActiveSessionEntity)
final currentActiveSessionProvider = Provider<ActiveSessionEntity?>((ref) {
  // 此提供者现在直接提供 ActiveSessionEntity
  return ref.watch(sessionStateProvider).currentSession;
});

// 当前选择的会话列表项提供者 (SessionListItemEntity)
// 如果UI需要快速访问当前会话的列表项版本，则此项很有用
final currentSessionListItemProvider = Provider<SessionListItemEntity?>((ref) {
  final state = ref.watch(sessionStateProvider);
  if (state.selectedSessionIndex >= 0 &&
      state.selectedSessionIndex < state.sessions.length) {
    return state.sessions[state.selectedSessionIndex];
  }
  return null;
});

// 会话状态管理器
class ChatNotifier extends StateNotifier<ChatState> {
  final ChatRepository _chatRepository;
  final Ref _ref; // 存储 Ref 以观察其他提供者
  AIResponseService? _aiService;
  final Uuid _uuid = const Uuid(); // 已修正：Uuid 实例

  ChatNotifier({
    required ChatRepository chatRepository,
    required Ref ref, // 接受 Ref
  }) : _chatRepository = chatRepository,
       _ref = ref,
       super(const ChatState()) {
    _initializeAIClient(); // 基于选定模型初始化AI客户端
    loadSessions();
    localLogger.info('ChatNotifier初始化，加载会话列表');

    // 监听 selectedModelProvider 的变化以重新初始化AI客户端
    _ref.listen<ChatModelEntity?>(selectedModelProvider, (previous, next) {
      localLogger.info('选定模型已更改，正在重新初始化AI客户端。');
      _initializeAIClient();
    });
  }

  void _initializeAIClient() {
    final llmRepository = _ref.read(llmRepositoryProvider); // 读取一次
    final selectedModel = _ref.read(selectedModelProvider);

    if (selectedModel != null) {
      _aiService = AIResponseServiceImpl(
        llmRepository,
      ); // 假设 AIResponseServiceImpl 只需要 LlmRepository
      localLogger.info(
        'AI 服务已使用模型初始化：${selectedModel.customName}', // 使用 customName 进行日志记录
      );
    } else {
      _aiService = null;
      localLogger.warning('AI 服务未初始化：未选择模型。');
    }
  }

  // 加载所有会话
  Future<void> loadSessions() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final sessions = await _chatRepository.getAllSessions();
      state = state.copyWith(sessions: sessions, isLoading: false);
      if (sessions.isNotEmpty && state.selectedSessionIndex == -1) {
        // 如果之前没有选择会话并且我们有会话，则选择第一个。
        await selectSession(0);
      } else if (state.selectedSessionIndex != -1 &&
          state.selectedSessionIndex < sessions.length) {
        // 如果已选择一个会话，则刷新其数据
        await selectSession(state.selectedSessionIndex);
      } else if (sessions.isEmpty) {
        state = state.copyWith(currentSession: null, selectedSessionIndex: -1);
      }
    } catch (e) {
      localLogger.shout('加载会话失败: $e');
      state = state.copyWith(isLoading: false, errorMessage: '加载会话失败: $e');
    }
  }

  // 选择会话
  Future<void> selectSession(int index) async {
    if (index >= 0 && index < state.sessions.length) {
      state = state.copyWith(
        isLoading: true,
        errorMessage: null,
        selectedSessionIndex: index,
      );
      final selectedListItem = state.sessions[index];
      try {
        final activeSession = await _chatRepository.getSessionById(
          selectedListItem.id,
        );
        state = state.copyWith(
          currentSession: activeSession, // 这是 ActiveSessionEntity
          isLoading: false,
        );
      } catch (e) {
        localLogger.shout('加载活动会话失败，ID为：${selectedListItem.id}');
        state = state.copyWith(
          isLoading: false,
          errorMessage: '加载会话详情失败: $e',
          currentSession: null,
        );
      }
    } else {
      localLogger.warning('选择会话索引无效: $index');
      state = state.copyWith(currentSession: null, selectedSessionIndex: -1);
    }
  }

  // 发送消息
  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty) return;
    if (state.currentSession == null) {
      state = state.copyWith(errorMessage: "没有活动的会话可发送消息。");
      return;
    }
    if (state.selectedSessionIndex == -1) {
      state = state.copyWith(errorMessage: "没有选中的会话。");
      return;
    }

    final activeSession = state.currentSession!;
    final now = DateTime.now();

    final userMessage = ChatMessageEntity(
      id: DateTime.now().millisecondsSinceEpoch,
      content: content,
      createdAt: now,
      isFromUser: true,
      senderId: 'user',
      senderName: 'You',
      senderAvatar: '',
      isGenerating: true,
    );

    final updatedMessages = List<ChatMessageEntity>.from(activeSession.messages)
      ..add(userMessage);
    final updatedActiveSession = activeSession.copyWith(
      messages: updatedMessages,
    );

    final sessionsList = List<SessionListItemEntity>.from(state.sessions);
    if (state.selectedSessionIndex < sessionsList.length) {
      sessionsList[state.selectedSessionIndex] =
          sessionsList[state.selectedSessionIndex].copyWith(
            lastMessage: userMessage.content,
            lastMessageAt: userMessage.createdAt,
          );
    }

    state = state.copyWith(
      currentSession: updatedActiveSession,
      sessions: sessionsList,
      isGenerating: true,
    );

    try {
      await _chatRepository.addMessageToSession(activeSession.id, userMessage);
    } catch (e) {
      localLogger.shout('发送消息失败: $e');
      state = state.copyWith(errorMessage: '发送消息失败: $e', isGenerating: false);
      return;
    }

    await _generateAiResponse(activeSession.id, updatedActiveSession);
  }

  Future<void> _generateAiResponse(
    String sessionId,
    ActiveSessionEntity sessionWithUserMessage,
  ) async {
    if (_aiService == null) {
      localLogger.warning('AI Service未配置，无法生成回复。');
      final updatedMessages =
          sessionWithUserMessage.messages.map((m) {
            if (m.isGenerating) return m.copyWith(isGenerating: false);
            return m;
          }).toList();
      state = state.copyWith(
        isGenerating: false,
        currentSession: state.currentSession?.copyWith(
          messages: updatedMessages,
        ),
        errorMessage: 'AI服务未配置。',
      );
      return;
    }

    final selectedModel = _ref.read(selectedModelProvider);
    if (selectedModel == null) {
      state = state.copyWith(isGenerating: false, errorMessage: 'AI模型未选择。');
      return;
    }

    final aiMessagePlaceholder = ChatMessageEntity(
      id: DateTime.now().millisecondsSinceEpoch + 1,
      content: '',
      createdAt: DateTime.now(),
      isFromUser: false,
      senderId: selectedModel.id,
      senderName: selectedModel.customName,
      senderAvatar: '',
      isGenerating: true,
    );

    var currentMessages = List<ChatMessageEntity>.from(
      sessionWithUserMessage.messages,
    )..add(aiMessagePlaceholder);
    var currentActiveSession = sessionWithUserMessage.copyWith(
      messages: currentMessages,
    );

    _updateStateWithNewAIMessage(
      currentActiveSession,
      aiMessagePlaceholder,
      true,
    );

    try {
      final requestMessages = await _prepareRequestMessages(
        currentActiveSession,
      );

      final responseStream = await _aiService!.generateResponse(
        messages: requestMessages,
        modelName: selectedModel.modelName,
        temperature: selectedModel.temperature,
      );

      String fullResponseContent = '';
      await for (final chunk in responseStream) {
        fullResponseContent += chunk;
        final updatedAIMessage = aiMessagePlaceholder.copyWith(
          content: fullResponseContent,
          isGenerating: true,
        );
        _updateStreamingMessage(updatedAIMessage);
      }

      final finalAIMessage = aiMessagePlaceholder.copyWith(
        content: fullResponseContent,
        isGenerating: false,
        createdAt: DateTime.now(),
      );
      await _finishAiResponse(finalAIMessage);
    } catch (e) {
      localLogger.shout('生成AI回复失败: $e');
      final finalAIMessage = aiMessagePlaceholder.copyWith(
        content: "抱歉，我在回复时遇到了问题。",
        isGenerating: false,
        createdAt: DateTime.now(),
      );
      await _finishAiResponse(finalAIMessage, isError: true);
      state = state.copyWith(isGenerating: false, errorMessage: 'AI回复生成失败: $e');
    }
  }

  void _updateStateWithNewAIMessage(
    ActiveSessionEntity sessionToUpdateWith,
    ChatMessageEntity aiMessage,
    bool isGenerating,
  ) {
    final sessionsList = List<SessionListItemEntity>.from(state.sessions);
    if (state.selectedSessionIndex != -1 &&
        state.selectedSessionIndex < sessionsList.length) {
      sessionsList[state.selectedSessionIndex] =
          sessionsList[state.selectedSessionIndex].copyWith(
            lastMessage: aiMessage.content,
            lastMessageAt: aiMessage.createdAt,
          );
    }
    state = state.copyWith(
      currentSession: sessionToUpdateWith,
      sessions: sessionsList,
      isGenerating: isGenerating,
    );
  }

  Future<List<ChatMessageEntity>> _prepareRequestMessages(
    ActiveSessionEntity session,
  ) async {
    return List<ChatMessageEntity>.from(
      session.messages.where((m) => !m.isGenerating || m.content.isNotEmpty),
    );
  }

  void _updateStreamingMessage(ChatMessageEntity streamingAIMessage) {
    if (state.currentSession == null) return;

    final messages = List<ChatMessageEntity>.from(
      state.currentSession!.messages,
    );
    final messageIndex = messages.indexWhere(
      (m) => m.id == streamingAIMessage.id,
    );

    if (messageIndex != -1) {
      messages[messageIndex] = streamingAIMessage;
      final updatedActiveSession = state.currentSession!.copyWith(
        messages: messages,
      );

      final sessionsList = List<SessionListItemEntity>.from(state.sessions);
      if (state.selectedSessionIndex != -1 &&
          state.selectedSessionIndex < sessionsList.length) {
        sessionsList[state.selectedSessionIndex] =
            sessionsList[state.selectedSessionIndex].copyWith(
              lastMessage: streamingAIMessage.content,
              lastMessageAt: streamingAIMessage.createdAt,
            );
      }
      state = state.copyWith(
        currentSession: updatedActiveSession,
        sessions: sessionsList,
      );
    }
  }

  Future<void> _finishAiResponse(
    ChatMessageEntity finalAIMessage, {
    bool isError = false,
  }) async {
    if (state.currentSession == null) return;

    final messages = List<ChatMessageEntity>.from(
      state.currentSession!.messages,
    );
    final messageIndex = messages.indexWhere((m) => m.id == finalAIMessage.id);

    if (messageIndex != -1) {
      messages[messageIndex] = finalAIMessage;
    } else {
      messages.add(finalAIMessage);
    }

    final updatedActiveSession = state.currentSession!.copyWith(
      messages: messages,
    );

    final sessionsList = List<SessionListItemEntity>.from(state.sessions);
    if (state.selectedSessionIndex != -1 &&
        state.selectedSessionIndex < sessionsList.length) {
      sessionsList[state.selectedSessionIndex] =
          sessionsList[state.selectedSessionIndex].copyWith(
            lastMessage: finalAIMessage.content,
            lastMessageAt: finalAIMessage.createdAt,
          );
    }

    state = state.copyWith(
      currentSession: updatedActiveSession,
      sessions: sessionsList,
      isGenerating: false,
    );

    if (!isError) {
      try {
        await _chatRepository.addMessageToSession(
          state.currentSession!.id,
          finalAIMessage,
        );
      } catch (e) {
        localLogger.shout('保存AI消息失败: $e');
        state = state.copyWith(errorMessage: '保存AI回复失败: $e');
      }
    }
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  Future<void> createSession(String title, List<String> roleIds) async {
    state = state.copyWith(isLoading: true);
    try {
      final now = DateTime.now();
      final newSessionId = _uuid.v4();

      final newListItem = SessionListItemEntity(
        id: newSessionId,
        title: title.isEmpty ? "新会话" : title,
        type: 0,
        unreadCount: 0,
        createdAt: now,
        isPinned: false,
        lastMessage: '',
      );

      await _chatRepository.addSession(newListItem);
      if (roleIds.isNotEmpty) {
        await _chatRepository.updateSessionRoles(newSessionId, roleIds);
      }

      final sessions = await _chatRepository.getAllSessions();
      state = state.copyWith(sessions: sessions);
      final newSessionIndex = sessions.indexWhere((s) => s.id == newSessionId);
      if (newSessionIndex != -1) {
        await selectSession(newSessionIndex);
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      localLogger.shout('创建会话失败: $e');
      state = state.copyWith(isLoading: false, errorMessage: '创建会话失败: $e');
    }
  }

  Future<void> deleteSession(String sessionId) async {
    state = state.copyWith(isLoading: true);
    try {
      await _chatRepository.deleteSession(sessionId);
      final sessions = await _chatRepository.getAllSessions();
      int newSelectedIndex = -1;
      ActiveSessionEntity? newCurrentSession;

      if (state.currentSession?.id == sessionId) {
        if (sessions.isNotEmpty) {
          newSelectedIndex = 0;
          newCurrentSession = await _chatRepository.getSessionById(
            sessions[0].id,
          );
        }
      } else if (sessions.isNotEmpty) {
        newSelectedIndex = sessions.indexWhere(
          (s) => s.id == state.currentSession?.id,
        );
        if (newSelectedIndex == -1 && sessions.isNotEmpty) newSelectedIndex = 0;
        if (newSelectedIndex != -1) {
          newCurrentSession = await _chatRepository.getSessionById(
            sessions[newSelectedIndex].id,
          );
        }
      }

      state = state.copyWith(
        sessions: sessions,
        selectedSessionIndex: newSelectedIndex,
        currentSession: newCurrentSession,
        isLoading: false,
      );
      if (newSelectedIndex == -1 && sessions.isNotEmpty) {
        await selectSession(0);
      } else if (newSelectedIndex != -1) {
        await selectSession(newSelectedIndex);
      }
    } catch (e) {
      localLogger.shout('删除会话失败: $e');
      state = state.copyWith(isLoading: false, errorMessage: '删除会话失败: $e');
    }
  }

  Future<void> clearAllSessions() async {
    state = state.copyWith(isLoading: true);
    try {
      await _chatRepository.clearAllSessions();
      state = state.copyWith(
        sessions: [],
        selectedSessionIndex: -1,
        currentSession: null,
        isLoading: false,
      );
    } catch (e) {
      localLogger.shout('清除所有会话失败: $e');
      state = state.copyWith(isLoading: false, errorMessage: '清除所有会话失败: $e');
    }
  }

  Future<void> clearAllMessages() async {
    state = state.copyWith(isLoading: true);
    try {
      await _chatRepository.clearAllMessages();
      if (state.currentSession != null) {
        final activeSession = await _chatRepository.getSessionById(
          state.currentSession!.id,
        );
        state = state.copyWith(currentSession: activeSession, isLoading: false);
      } else {
        state = state.copyWith(isLoading: false);
      }
      final updatedSessionListItems =
          state.sessions
              .map((s) => s.copyWith(lastMessage: '', lastMessageAt: null))
              .toList();
      state = state.copyWith(sessions: updatedSessionListItems);
    } catch (e) {
      localLogger.shout('清空所有聊天记录失败: $e');
      state = state.copyWith(isLoading: false, errorMessage: '清空聊天记录失败: $e');
    }
  }

  void clearErrorMessage() {
    state = state.copyWith(errorMessage: null);
  }

  Future<void> importSession(ActiveSessionEntity sessionToImport) async {
    state = state.copyWith(isLoading: true);
    try {
      final listItem = SessionListItemEntity(
        id: sessionToImport.id,
        title: sessionToImport.title,
        type: sessionToImport.type,
        createdAt: sessionToImport.createdAt,
        isPinned: sessionToImport.isPinned,
        avatar: sessionToImport.avatar,
        lastMessage:
            sessionToImport.messages.isNotEmpty
                ? sessionToImport.messages.last.content
                : '',
        lastMessageAt:
            sessionToImport.messages.isNotEmpty
                ? sessionToImport.messages.last.createdAt
                : null,
        unreadCount: 0,
      );
      await _chatRepository.addSession(listItem);
      for (final message in sessionToImport.messages) {
        await _chatRepository.addMessageToSession(sessionToImport.id, message);
      }
      if (sessionToImport.roleIds.isNotEmpty) {
        await _chatRepository.updateSessionRoles(
          sessionToImport.id,
          sessionToImport.roleIds,
        );
      }

      await loadSessions();
    } catch (e) {
      localLogger.shout('导入会话失败: $e');
      state = state.copyWith(isLoading: false, errorMessage: '导入会话失败: $e');
    }
  }

  Future<void> togglePinSession(String sessionId) async {
    final sessionIndex = state.sessions.indexWhere((s) => s.id == sessionId);
    if (sessionIndex == -1) return;

    final sessionToUpdate = state.sessions[sessionIndex];
    final updatedSession = sessionToUpdate.copyWith(
      isPinned: !sessionToUpdate.isPinned,
    );

    try {
      await _chatRepository.updateSession(updatedSession);
      final updatedSessions = List<SessionListItemEntity>.from(state.sessions);
      updatedSessions[sessionIndex] = updatedSession;
      updatedSessions.sort((a, b) {
        if (a.isPinned && !b.isPinned) return -1;
        if (!a.isPinned && b.isPinned) return 1;
        final dateA = a.lastMessageAt ?? a.createdAt;
        final dateB = b.lastMessageAt ?? b.createdAt;
        return dateB.compareTo(dateA);
      });
      state = state.copyWith(sessions: updatedSessions);
      final newCurrentIndex =
          state.currentSession != null
              ? updatedSessions.indexWhere(
                (s) => s.id == state.currentSession!.id,
              )
              : -1;
      if (newCurrentIndex != -1 &&
          newCurrentIndex != state.selectedSessionIndex) {
        state = state.copyWith(selectedSessionIndex: newCurrentIndex);
      } else if (newCurrentIndex == -1 && state.currentSession != null) {
        await selectSession(0);
      }
    } catch (e) {
      localLogger.shout('切换置顶状态失败: $e');
      state = state.copyWith(errorMessage: '操作失败: $e');
    }
  }
}
