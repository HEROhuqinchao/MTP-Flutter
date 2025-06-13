import 'package:dio/dio.dart';

import '../../../settings/domain/entities/chat_model_entity.dart';
import '../../../../shared/domain/entities/completion_request_entity.dart';
import '../../../../shared/domain/entities/completion_response_entity.dart';
import '../../domain/repositories/llm_repository.dart';
import '../datasources/remote/llm_remote_datasource.dart';
import '../datasources/remote/open_ai_remote_datasource.dart';
import '../datasources/remote/azure_open_ai_remote_datasource.dart';
import '../../../settings/data/datasources/local/tables/model_table.dart';
import '../../../../shared/data/models/completion/request.dart';

class LlmRepositoryImpl implements LlmRepository {
  final Dio dio;

  LlmRepositoryImpl({required this.dio});

  @override
  Future<CompletionResponseEntity> generateCompletion(
    CompletionRequestEntity request,
    ChatModelEntity model,
  ) async {
    print('正在请求模型: ${model.name}');
    print('端点: ${model.endpoint}');
    print('使用模型/部署: ${request.model}');

    // 转换请求实体为数据模型
    final requestModel = _mapRequestEntityToModel(request);
    final modelModel = _mapModelEntityToModel(model);

    // 获取适合的数据源
    final datasource = _getDatasourceForModel(model);

    // 执行请求
    final response = await datasource.generateCompletion(
      requestModel,
      modelModel,
    );

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
    ChatModelEntity model,
  ) async {
    // 转换请求实体为数据模型
    final requestModel = _mapRequestEntityToModel(request);
    final modelModel = _mapModelEntityToModel(model);

    // 获取适合的数据源
    final datasource = _getDatasourceForModel(model);

    // 执行请求并返回流
    return datasource.generateCompletionStream(requestModel, modelModel);
  }

  // 根据模型类型选择适当的数据源
  LlmRemoteDatasource _getDatasourceForModel(ChatModelEntity model) {
    if (model.endpoint.contains('azure')) {
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
      temperature: entity.temperature,
      maxTokens: entity.maxTokens,
      model: entity.model,
    );
  }

  // 模型实体转换为数据模型
  ChatModel _mapModelEntityToModel(ChatModelEntity entity) {
    return ChatModel(
      key: entity.id,
      name: entity.name,
      endpoint: entity.endpoint,
      apiKey: entity.apiKey,
      temparture: entity.temparture,
      isSelected: entity.isSelected,
    );
  }
}
