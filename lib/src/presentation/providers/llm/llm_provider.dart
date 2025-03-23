import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/completion_request_entity.dart';
import '../../../domain/entities/completion_response_entity.dart';
import '../../../di/providers/repository_providers.dart';
import '../settings/settings_provider.dart';

// 消息生成提供者 - 用于发起生成请求
final llmGenerateProvider =
    FutureProvider.family<CompletionResponseEntity, CompletionRequestEntity>((
      ref,
      request,
    ) async {
      final llmRepository = ref.watch(llmRepositoryProvider);
      final model = ref.watch(selectedModelProvider);

      if (model == null) {
        throw Exception('未选择模型');
      }

      // 执行生成请求
      return await llmRepository.generateCompletion(request, model);
    });

// 流式消息生成提供者 - 用于流式响应
final llmStreamProvider =
    FutureProvider.family<Stream<String>, CompletionRequestEntity>((
      ref,
      request,
    ) async {
      final llmRepository = ref.watch(llmRepositoryProvider);
      final model = ref.watch(selectedModelProvider);

      if (model == null) {
        throw Exception('未选择模型');
      }

      // 执行流式生成请求
      return await llmRepository.generateCompletionStream(request, model);
    });

// 创建会话请求辅助方法
class LlmHelper {
  static CompletionRequestEntity createCompletionRequest({
    required List<LLMMessageEntity> messages,
    required String modelName,
    double temperature = 0.7,
    int maxTokens = 800,
  }) {
    return CompletionRequestEntity(
      messages: messages,
      temperature: temperature,
      maxTokens: maxTokens,
      model: modelName,
    );
  }
}
