import 'package:mtp/src/features/chat/domain/entities/chat_message_entity.dart';
import 'package:mtp/src/features/chat/domain/repositories/llm_repository.dart';
import 'package:mtp/src/features/chat/domain/services/ai_response_service.dart';
import 'package:mtp/src/shared/domain/entities/chat_model_entity.dart';
import 'package:mtp/src/shared/domain/entities/completion_request_entity.dart';

/// 实现AI回复服务
class AIResponseServiceImpl implements AIResponseService {
  final LlmRepository _llmRepository;
  final ChatModelEntity _model;

  AIResponseServiceImpl(this._llmRepository, this._model);

  @override
  Future<Stream<String>> generateResponse({
    required List<ChatMessageEntity> messages,
    required String modelName,
    required double temperature,
  }) async {
    final requestMessages =
        messages
            .map(
              (msg) => LLMMessageEntity(
                role:
                    msg.isSystem
                        ? 'system'
                        : (msg.isFromUser ? 'user' : 'assistant'),
                content: msg.content,
              ),
            )
            .toList();

    final request = CompletionRequestEntity(
      messages: requestMessages,
      temperature: temperature,
      maxTokens: 800,
      model: modelName,
    );

    return await _llmRepository.generateCompletionStream(request, _model);
  }
}
