import 'package:mtp/src/features/chat/domain/entities/chat_message_entity.dart';
import 'package:mtp/src/features/chat/domain/repositories/llm_repository.dart';
import 'package:mtp/src/features/chat/domain/services/ai_response_service.dart';
import 'package:mtp/src/shared/domain/entities/completion_request_entity.dart';
import 'package:mtp/src/shared/domain/entities/llm_message_entity.dart';

/// 实现AI回复服务
class AIResponseServiceImpl implements AIResponseService {
  final LLMRepository _llmRepository;

  AIResponseServiceImpl(this._llmRepository);

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
                role: msg.isFromUser ? 'user' : 'assistant',
                content: msg.content,
              ),
            )
            .toList();

    final request = CompletionRequestEntity(
      messages: requestMessages,
      temperature: temperature,
      maxTokens: 2000,
      model: modelName,
      // TODO: 需要根据实际情况设置 endpoint 和 apiKey
      endpoint: 'https://apis.iflow.cn/v1',
      apiKey: 'sk-c84388db8701adf6a7ba8eaeb39ab683',
    );

    return await _llmRepository.generateCompletionStream(request);
  }
}
