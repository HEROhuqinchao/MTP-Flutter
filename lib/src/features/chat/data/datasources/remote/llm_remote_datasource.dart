import 'package:mtp/src/shared/data/models/completion/request.dart';
import 'package:mtp/src/shared/data/models/completion/response.dart';

abstract class LlmRemoteDatasource {
  Future<CompletionResponse> generateCompletion(CompletionRequest request);

  Future<Stream<String>> generateCompletionStream(CompletionRequest request);
}
