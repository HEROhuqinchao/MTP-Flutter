import 'package:mtp/src/shared/data/datasources/local/app_database.dart';
import 'package:mtp/src/shared/data/models/completion/request.dart';
import 'package:mtp/src/shared/data/models/completion/response.dart';

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
