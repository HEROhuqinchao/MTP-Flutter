import 'package:mtp/src/features/chat/domain/repositories/llm_repository.dart';
import 'package:mtp/src/shared/domain/entities/chat_model_entity.dart';
import 'package:mtp/src/shared/domain/entities/completion_request_entity.dart';
import 'package:mtp/src/shared/domain/entities/completion_response_entity.dart';

class GenerateCompletion {
  final LLMRepository repository;

  GenerateCompletion(this.repository);

  Future<CompletionResponseEntity> call(
    CompletionRequestEntity request,
    ChatModelEntity model,
  ) async {
    return await repository.generateCompletion(request);
  }
}
