import '../../../../shared/domain/entities/chat_model_entity.dart';
import '../../../../shared/domain/entities/completion_request_entity.dart';
import '../../../../shared/domain/entities/completion_response_entity.dart';

abstract class LlmRepository {
  Future<CompletionResponseEntity> generateCompletion(
    CompletionRequestEntity request,
    ChatModelEntity model,
  );

  Future<Stream<String>> generateCompletionStream(
    CompletionRequestEntity request,
    ChatModelEntity model,
  );
}
