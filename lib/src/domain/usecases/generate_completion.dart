import '../entities/chat_model_entity.dart';
import '../entities/completion_request_entity.dart';
import '../entities/completion_response_entity.dart';
import '../repositories/llm_repository.dart';

class GenerateCompletion {
  final LlmRepository repository;

  GenerateCompletion(this.repository);

  Future<CompletionResponseEntity> call(
    CompletionRequestEntity request,
    ChatModelEntity model,
  ) async {
    return await repository.generateCompletion(request, model);
  }
}
