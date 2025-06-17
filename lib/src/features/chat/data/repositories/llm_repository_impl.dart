import 'package:dio/dio.dart';
import 'package:mtp/src/features/chat/data/datasources/remote/azure_open_ai_remote_datasource.dart';
import 'package:mtp/src/features/chat/data/datasources/remote/llm_remote_datasource.dart';
import 'package:mtp/src/features/chat/data/datasources/remote/open_ai_remote_datasource.dart';
import 'package:mtp/src/features/chat/domain/repositories/llm_repository.dart';
import 'package:mtp/src/shared/data/models/completion/request.dart';
import 'package:mtp/src/shared/domain/entities/completion_request_entity.dart';
import 'package:mtp/src/shared/domain/entities/completion_response_entity.dart';
import 'package:mtp/src/utils/logger.dart';

class LlmRepositoryImpl implements LLMRepository {
  final Dio dio;

  LlmRepositoryImpl({required this.dio});

  @override
  Future<CompletionResponseEntity> generateCompletion(
    CompletionRequestEntity request,
  ) async {
    remoteLogger.info('正在请求模型: ${request.model}');
    remoteLogger.info('端点: ${request.endpoint}');
    remoteLogger.info('使用模型/部署: ${request.model}');

    // 转换请求实体为数据模型
    final requestModel = _mapRequestEntityToModel(request);

    // 获取适合的数据源
    final datasource = _getDatasourceForModel(request.model);

    // 执行请求
    final response = await datasource.generateCompletion(requestModel);

    // 转换响应为实体
    return CompletionResponseEntity(
      id: response.id,
      content: response.content,
      promptTokens: response.usage.promptTokens,
      completionTokens: response.usage.completionTokens,
      totalTokens: response.usage.totalTokens,
      modelName: response.modelName,
      temperature: response.temperature,
      createdAt: DateTime.fromMillisecondsSinceEpoch(response.created * 1000),
      errorMessage: response.errorMessage,
    );
  }

  @override
  Future<Stream<String>> generateCompletionStream(
    CompletionRequestEntity request,
  ) async {
    // 转换请求实体为数据模型
    final requestModel = _mapRequestEntityToModel(request);

    // 获取适合的数据源
    final datasource = _getDatasourceForModel(request.model);

    // 执行请求并返回流
    return datasource.generateCompletionStream(requestModel);
  }

  // 根据模型类型选择适当的数据源
  LlmRemoteDatasource _getDatasourceForModel(String model) {
    if (model.contains('azure')) {
      return AzureOpenAiRemoteDatasource(dio: dio);
    } else {
      return OpenAiRemoteDatasource(dio: dio);
    }
  }

  // 请求实体转换为模型
  CompletionRequest _mapRequestEntityToModel(CompletionRequestEntity entity) {
    return CompletionRequest(
      messages:
          entity.messages
              .map((m) => Message(role: m.role, content: m.content))
              .toList(),
      model: entity.model,
      endpoint: entity.endpoint,
      apiKey: entity.apiKey,
      temperature: entity.temperature,
      maxTokens: entity.maxTokens,
    );
  }
}
