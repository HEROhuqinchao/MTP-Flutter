import '../../../settings/domain/entities/chat_model_entity.dart';
import '../../../../shared/domain/entities/completion_request_entity.dart';
import '../repositories/llm_repository.dart';

class GenerateCompletionStream {
  final LlmRepository repository;

  GenerateCompletionStream(this.repository);

  Future<Stream<String>> call(
    CompletionRequestEntity request,
    ChatModelEntity model,
  ) async {
    return await repository.generateCompletionStream(request, model);
  }
}
