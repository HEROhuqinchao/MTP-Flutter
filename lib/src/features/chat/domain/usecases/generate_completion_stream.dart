import 'package:mtp/src/features/chat/domain/repositories/llm_repository.dart';
import 'package:mtp/src/shared/domain/entities/chat_model_entity.dart';
import 'package:mtp/src/shared/domain/entities/completion_request_entity.dart';

class GenerateCompletionStream {
  final LLMRepository repository;

  GenerateCompletionStream(this.repository);

  Future<Stream<String>> call(
    CompletionRequestEntity request,
    ChatModelEntity model,
  ) async {
    return await repository.generateCompletionStream(request);
  }
}
