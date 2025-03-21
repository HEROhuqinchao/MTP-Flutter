import '../../models/completion/request.dart';
import '../../models/completion/response.dart';
import '../../models/chat/model.dart';

abstract class LlmRemoteDatasource {
  Future<CompletionResponse> generateCompletion(
    CompletionRequest request,
    ChatModel model,
  );

  Future<Stream<String>> generateCompletionStream(
    CompletionRequest request,
    ChatModel model,
  );
}
