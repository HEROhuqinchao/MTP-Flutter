import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mtp/src/di/providers/repository_providers.dart';
import 'package:mtp/src/features/chat/data/services/ai_response_service_impl.dart';
import 'package:mtp/src/features/chat/data/services/session_service_impl.dart';
import 'package:mtp/src/features/chat/domain/entities/chat_message_entity.dart';
import 'package:mtp/src/features/chat/domain/entities/session_details_entity.dart';
import 'package:mtp/src/features/chat/domain/repositories/chat_repository.dart';
import 'package:mtp/src/features/chat/domain/repositories/llm_repository.dart';
import 'package:mtp/src/features/chat/domain/services/ai_response_service.dart';
import 'package:mtp/src/features/chat/domain/services/session_service.dart';
import 'package:mtp/src/features/chat/presentation/providers/chat_state.dart';
import 'package:mtp/src/features/role/domain/entities/role_entity.dart';
import 'package:mtp/src/features/role/domain/repositories/role_repository.dart';
import 'package:mtp/src/features/settings/presentation/providers/settings_provider.dart';
import 'package:mtp/src/shared/domain/entities/chat_model_entity.dart';
import 'package:mtp/src/shared/domain/entities/completion_request_entity.dart';
import 'package:mtp/src/utils/logger.dart';
import 'package:uuid/uuid.dart';

// // 角色服务接口 - 用于解耦
// abstract class RoleService {
//   Future<RoleEntity?> getRoleById(String roleId);
//   Future<void> updateRoleLastMessage(RoleEntity role, String message);
// }

// // 实现角色服务
// class DefaultRoleService implements RoleService {
//   final RoleRepository _roleRepository;

//   DefaultRoleService(this._roleRepository);

//   @override
//   Future<RoleEntity?> getRoleById(String roleId) async {
//     return await _roleRepository.getRoleById(roleId);
//   }

//   @override
//   Future<void> updateRoleLastMessage(RoleEntity role, String message) async {
//     final updatedRole = role.copyWith(lastMessage: message);
//     await _roleRepository.updateRole(updatedRole);
//   }
// }

/// 会话状态管理提供者
final chatStateProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);

  // AI响应服务
  AIResponseService? aiService;

  try {
    // 尝试从选择的模型创建服务
    final model = ref.watch(selectedModelProvider);

    // 如果有选择的模型，使用它创建服务
    if (model != null) {
      final llmRepository = ref.read(llmRepositoryProvider);
      aiService = AIResponseServiceImpl(llmRepository, model);
    }
  } catch (e) {
    localLogger.shout('创建AI服务失败: $e');
  }

  // 创建会话服务
  final roleRepository = ref.read(roleRepositoryProvider);
  // TODO: 使用 Session 接管 Role服务为核心服务，breaking update
  final sessionService = SessionServiceImpl();

  return ChatNotifier(
    chatRepository: chatRepository,
    aiService: aiService,
    sessionService: sessionService,
  );
});

// 过滤后的会话列表提供者
final filteredSessionsProvider = Provider<List<SessionDetailsEntity>>((ref) {
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
final currentSessionProvider = Provider<SessionDetailsEntity?>((ref) {
  final state = ref.watch(chatStateProvider);
  return state.currentSession;
});

// 会话状态管理器
class ChatNotifier extends StateNotifier<ChatState> {
  final ChatRepository _chatRepository;
  final AIResponseService? _aiService; // 可能为空，表示未配置模型
  final SessionService _sessionService;
  final uuid = Uuid();

  ChatNotifier({
    required ChatRepository chatRepository,
    required SessionService sessionService,
    AIResponseService? aiService,
  }) : _chatRepository = chatRepository,
       _sessionService = sessionService,
       _aiService = aiService,
       super(const ChatState()) {
    // 初始化时加载会话列表
    loadSessions();
    localLogger.info('ChatNotifier初始化，加载会话列表');
  }

  // 加载所有会话
  Future<void> loadSessions() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final sessions = await _chatRepository.getAllSessions();

      // // 处理每个会话的消息，为AI消息添加角色信息
      // final enrichedSessions = await Future.wait(
      //   sessions.map((session) async {
      //     // 如果会话没有消息，直接返回原始会话
      //     if (session.messages.isEmpty) return session;

      //     // 获取会话对应的角色
      //     final role = await _sessionService.getRoleById(session.roleId);
      //     if (role == null) return session;

      //     // 为每条AI消息添加角色信息
      //     final enrichedMessages =
      //         session.messages.map((message) {
      //           // 只处理非用户消息且缺少发送者信息的消息
      //           if (!message.isFromUser &&
      //               (message.senderAvatar == null ||
      //                   message.senderAvatar!.isEmpty)) {
      //             return message.copyWith(
      //               senderName: role.name,
      //               senderAvatar:
      //                   role.avatars.isNotEmpty ? role.avatars.first : '',
      //             );
      //           }
      //           return message;
      //         }).toList();

      //     // 返回更新了消息的会话
      //     return session.copyWith(messages: enrichedMessages);
      //   }),
      // );

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
      localLogger.shout('加载会话失败: $e');
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
    } else {
      state = state.copyWith(selectedSessionIndex: -1, currentSession: null);
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

    final message = ChatMessageEntity(
      content: content,
      createdAt: DateTime.now(),
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

    // 生成AI回复
    await generateAiResponse(currentSession.id!, updatedSession);
  }

  // 生成AI回复
  Future<void> generateAiResponse(
    String sessionId,
    SessionDetailsEntity session,
  ) async {
    try {
      // 检查AI服务是否可用
      if (_aiService == null) {
        // 更友好的错误提示，指导用户配置模型
        state = state.copyWith(errorMessage: '请先在设置中配置并选择一个AI模型才能生成回复');
        return; // 早期返回，不继续执行
      }

      final role = await _sessionService.getRoleById(session.roleId);
      String avatarPath = '';
      if (role != null && role.avatars.isNotEmpty) {
        avatarPath = role.avatars.first;
      }

      // 1. 添加一个等待中的消息
      final waitingMessage = ChatMessageEntity(
        id: uuid.v4(),
        content: '...',
        timestamp: DateTime.now(),
        senderName: role != null ? role.name : '',
        senderAvatar: avatarPath,
        isFromUser: false,
        isRead: true,
        isGenerating: true,
      );

      // 更新状态以显示等待消息
      final messagesWithWaiting = [...session.messages, waitingMessage];
      final updatedSession = session.copyWith(
        messages: messagesWithWaiting,
        updatedAt: DateTime.now(),
      );

      final updatedSessions = [...state.sessions];
      updatedSessions[state.selectedSessionIndex] = updatedSession;

      state = state.copyWith(
        sessions: updatedSessions,
        currentSession: updatedSession,
      );

      // 2. 准备请求数据
      final chatMessages = await _prepareRequestMessages(session);

      // 3. 获取响应流 - 使用AI服务
      final modelName =
          _aiService is DefaultAIResponseService
              ? (_aiService)._model.name
              : '默认模型';

      final responseStream = await _aiService.generateResponse(
        messages: chatMessages,
        modelName: modelName,
        temperature: 0.7,
      );

      // 4. 处理流式响应
      final aiMessageId = uuid.v4();
      String aiContent = '';

      // 使用计数器减少更新频率
      int updateCounter = 0;
      const updateFrequency = 3; // 每收到3个片段更新一次UI

      // 监听流式响应
      responseStream.listen(
        (chunk) {
          // 累加内容
          aiContent += chunk;
          updateCounter++;

          // 按设定频率更新UI，减少状态更新次数
          if (updateCounter >= updateFrequency) {
            updateCounter = 0;
            _updateStreamingMessage(
              aiMessageId,
              aiContent,
              waitingMessage,
              updatedSession,
            );
          }
        },
        onDone: () async {
          // 确保最后一次更新被应用
          if (updateCounter > 0) {
            _updateStreamingMessage(
              aiMessageId,
              aiContent,
              waitingMessage,
              updatedSession,
            );
          }

          // 完成时保存最终消息
          await _finishAiResponse(sessionId, session, aiMessageId, aiContent);
        },
        onError: (error) {
          print('AI回复生成错误: $error');
          state = state.copyWith(errorMessage: 'AI回复生成失败: $error');

          // 发生错误时重置会话状态
          final errorSessions = [...state.sessions];
          errorSessions[state.selectedSessionIndex] = session;

          state = state.copyWith(
            sessions: errorSessions,
            currentSession: session,
          );
        },
      );
    } catch (e) {
      print('生成AI回复过程中出错: $e');

      // 根据错误类型提供更具体的错误消息
      String errorMessage = '生成AI回复失败';
      if (e.toString().contains('模型') || e.toString().contains('model')) {
        errorMessage = '模型相关错误: 请检查AI模型配置，可能需要在设置中重新配置模型';
      } else if (e.toString().contains('网络') ||
          e.toString().contains('network') ||
          e.toString().contains('connect')) {
        errorMessage = '网络错误: 请检查网络连接或API端点配置';
      } else if (e.toString().contains('API') || e.toString().contains('key')) {
        errorMessage = 'API错误: 请检查API密钥是否正确';
      }

      state = state.copyWith(errorMessage: '$errorMessage: ${e.toString()}');
    }
  }

  // 准备请求消息（包括系统提示和历史消息）
  Future<List<ChatMessageEntity>> _prepareRequestMessages(
    SessionDetailsEntity session,
  ) async {
    final messages = <ChatMessageEntity>[];

    // 获取角色信息 - 通过服务而非Provider
    final role = await _sessionService.getRoleById(session.roleId);

    // 如果有角色提示词，添加系统消息
    if (role != null && role.prompt.isNotEmpty) {
      messages.add(
        ChatMessageEntity(
          id: uuid.v4(),
          content: role.prompt,
          timestamp: DateTime.now(),
          isFromUser: false,
          isRead: true,
          isSystem: true,
        ),
      );
    }

    // 筛选出非生成中的消息
    final filteredMessages =
        session.messages.where((msg) => !msg.isGenerating).toList();

    // 确保消息以用户消息开始且保持用户-助手交替
    final formattedMessages = <ChatMessageEntity>[];

    // 如果第一条消息不是用户消息，跳过
    int startIndex = 0;
    if (filteredMessages.isNotEmpty && !filteredMessages[0].isFromUser) {
      startIndex = 1;
    }

    // 构建交替的消息序列
    for (int i = startIndex; i < filteredMessages.length; i++) {
      final currentMsg = filteredMessages[i];

      // 确保消息交替 - 如果当前消息与前一条消息角色相同，则合并(兼容deepseek)
      if (formattedMessages.isNotEmpty) {
        final lastMsg = formattedMessages.last;
        if ((currentMsg.isFromUser && lastMsg.isFromUser) ||
            (!currentMsg.isFromUser && !lastMsg.isFromUser)) {
          formattedMessages[formattedMessages.length - 1] = formattedMessages
              .last
              .copyWith(content: lastMsg.content + currentMsg.content);
        }
      }

      // 添加到格式化消息列表
      formattedMessages.add(currentMsg);
    }

    // 若消息数量过多，取最近的一部分
    final historyMessages =
        formattedMessages.length > 100
            ? formattedMessages.sublist(formattedMessages.length - 100)
            : formattedMessages;

    messages.addAll(historyMessages);
    return messages;
  }

  // 更新流式消息
  void _updateStreamingMessage(
    String messageId,
    String content,
    ChatMessageEntity waitingMessage,
    SessionDetailsEntity sessionWithWaiting,
  ) {
    // 创建更新的AI消息
    final aiMessage = ChatMessageEntity(
      id: messageId,
      content: content,
      timestamp: DateTime.now(),
      senderName: waitingMessage.senderName, // 从等待消息中获取发送者名称
      senderAvatar: waitingMessage.senderAvatar, // 从等待消息中获取发送者头像
      isFromUser: false,
      isRead: true,
      isGenerating: true,
    );

    // 替换等待消息为AI消息
    final messages = List<ChatMessageEntity>.from(sessionWithWaiting.messages);
    final waitingIndex = messages.indexOf(waitingMessage);

    if (waitingIndex != -1) {
      messages[waitingIndex] = aiMessage;

      final updatedSession = sessionWithWaiting.copyWith(
        messages: messages,
        updatedAt: DateTime.now(),
      );

      final updatedSessions = [...state.sessions];
      updatedSessions[state.selectedSessionIndex] = updatedSession;

      state = state.copyWith(
        sessions: updatedSessions,
        currentSession: updatedSession,
      );
    }
  }

  // 完成AI响应
  Future<void> _finishAiResponse(
    String sessionId,
    SessionDetailsEntity originalSession,
    String messageId,
    String content,
  ) async {
    final role = await _sessionService.getRoleById(originalSession.roleId);
    String avatarPath = '';
    if (role != null && role.avatars.isNotEmpty) {
      avatarPath = role.avatars.first;
    }

    // 创建最终的AI消息
    final finalAiMessage = ChatMessageEntity(
      id: messageId,
      content: content,
      timestamp: DateTime.now(),
      senderName: role != null ? role.name : '',
      senderAvatar: avatarPath,
      isFromUser: false,
      isRead: true,
      isGenerating: false,
    );

    // 更新最终状态
    final finalMessages = [...originalSession.messages, finalAiMessage];
    final finalSession = originalSession.copyWith(
      messages: finalMessages,
      updatedAt: DateTime.now(),
    );

    final finalSessions = [...state.sessions];
    finalSessions[state.selectedSessionIndex] = finalSession;

    state = state.copyWith(
      sessions: finalSessions,
      currentSession: finalSession,
    );

    // 保存AI消息到数据库
    try {
      await _chatRepository.addMessageToSession(sessionId, finalAiMessage);

      // 更新角色的最后一条消息 - 通过服务而非Provider
      final role = await _sessionService.getRoleById(originalSession.roleId);
      if (role != null) {
        await _sessionService.updateRoleLastMessage(role, content);
      }
    } catch (e) {
      print('保存AI回复时出错: $e');
      state = state.copyWith(errorMessage: '保存AI回复失败: $e');
    }
  }

  // 设置搜索查询
  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  // 创建新会话
  Future<void> createSession(String title, String roleId) async {
    final String newSessionId = uuid.v4();

    final session = SessionDetailsEntity(
      id: newSessionId, // 新会话，ID为空
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
      // 在会话列表中查找新创建的会话
      final newSessionIndex = state.sessions.indexWhere(
        (s) => s.id == newSessionId,
      );
      if (newSessionIndex != -1) {
        // 找到后选择它
        selectSession(newSessionIndex);
      } else {
        // 如果找不到(极少情况)，选择最后一个会话
        selectSession(state.sessions.length - 1);
      }
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

  // 清除所有会话
  Future<void> clearAllSessions() async {
    try {
      await _chatRepository.clearAllSessions();

      // 清空本地状态
      state = state.copyWith(
        sessions: [],
        currentSession: null,
        selectedSessionIndex: -1,
      );
    } catch (e) {
      print('清除所有会话失败: $e');
      state = state.copyWith(errorMessage: '清除所有会话失败: $e');
    }
  }

  // 清空所有聊天记录（保留会话）
  Future<void> clearAllMessages() async {
    try {
      await _chatRepository.clearAllMessages();

      // 清空本地状态中的消息，但保留会话
      final updatedSessions =
          state.sessions.map((session) {
            return session.copyWith(messages: [], updatedAt: DateTime.now());
          }).toList();

      // 更新状态
      state = state.copyWith(
        sessions: updatedSessions,
        currentSession: state.currentSession?.copyWith(messages: []),
      );
    } catch (e) {
      print('清空聊天记录失败: $e');
      state = state.copyWith(errorMessage: '清空聊天记录失败: $e');
    }
  }

  // 删除错误消息
  Future<void> clearErrorMessage() async {
    state = state.copyWith(errorMessage: null);
  }

  // 导入单个会话
  Future<void> importSession(SessionDetailsEntity session) async {
    try {
      // 检查会话是否已存在
      final existingIndex = state.sessions.indexWhere(
        (s) => s.id == session.id,
      );

      if (existingIndex >= 0) {
        // 已存在，更新
        await _chatRepository.updateSession(session);
      } else {
        // 不存在，添加
        await _chatRepository.addSession(session);
      }

      // 重新加载会话列表
      await loadSessions();
    } catch (e) {
      print('导入会话失败: $e');
      state = state.copyWith(errorMessage: '导入会话失败: $e');
    }
  }

  // 置顶或取消置顶会话
  Future<void> togglePinSession(String sessionId) async {
    final sessionIndex = state.sessions.indexWhere((s) => s.id == sessionId);
    if (sessionIndex == -1) return;

    final session = state.sessions[sessionIndex];
    final isPinned = session.isPinned ?? false;

    // 更新会话的置顶状态
    final updatedSession = session.copyWith(isPinned: !isPinned);

    // 更新本地状态
    final updatedSessions = [...state.sessions];
    updatedSessions[sessionIndex] = updatedSession;

    // 重新排序会话：置顶的在前面
    updatedSessions.sort((a, b) {
      final aIsPinned = a.isPinned ?? false;
      final bIsPinned = b.isPinned ?? false;

      if (aIsPinned && !bIsPinned) return -1;
      if (!aIsPinned && bIsPinned) return 1;

      // 同为置顶或非置顶时，按更新时间排序
      final aTime = a.updatedAt ?? DateTime(1970);
      final bTime = b.updatedAt ?? DateTime(1970);
      return bTime.compareTo(aTime); // 最新的在前
    });

    state = state.copyWith(sessions: updatedSessions);

    // 更新数据库
    try {
      await _chatRepository.updateSession(updatedSession);
    } catch (e) {
      state = state.copyWith(errorMessage: '更新会话状态失败: $e');
    }
  }
}
