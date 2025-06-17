import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:mtp/src/shared/data/models/completion/request.dart';
import 'package:mtp/src/shared/data/models/completion/response.dart';
import 'package:mtp/src/utils/logger.dart';
import 'llm_remote_datasource.dart';

class AzureOpenAiRemoteDatasource implements LlmRemoteDatasource {
  final Dio dio;
  final Logger _logger = AppLogger.getLogger('AzureOpenAI');

  AzureOpenAiRemoteDatasource({required this.dio});

  @override
  Future<CompletionResponse> generateCompletion(
    CompletionRequest request,
  ) async {
    try {
      _logger.info(
        'Generating Azure completion using deployment: ${request.model}',
      );
      final headers = {
        'Content-Type': 'application/json',
        'api-key': request.apiKey,
      };

      // Azure OpenAI 的端点格式不同
      final uri =
          '${request.endpoint}/openai/deployments/${request.model}/chat/completions?api-version=2023-05-15';

      // Azure不需要model字段
      final requestData = Map<String, dynamic>.from(request.toJson());
      requestData.remove('model');

      final response = await dio.post(
        uri,
        data: requestData,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        _logger.info('Successfully received Azure completion response');
        return CompletionResponse.fromJson(response.data);
      } else {
        final error = response.data;
        final errorMsg = error['error']['message'] ?? '未知错误';
        _logger.warning('Error in Azure completion response: $errorMsg');
        return CompletionResponse.fromError(errorMsg);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        try {
          final error = e.response!.data;
          final errorMessage =
              error['error']['message'] ?? '请求失败: ${e.message}';
          return CompletionResponse.fromError(errorMessage);
        } catch (_) {
          return CompletionResponse.fromError('请求失败: ${e.message}');
        }
      }
      return CompletionResponse.fromError('请求失败: ${e.message}');
    } catch (e) {
      _logger.severe('Unexpected error: $e', e);
      return CompletionResponse.fromError('请求失败: $e');
    }
  }

  @override
  Future<Stream<String>> generateCompletionStream(
    CompletionRequest request,
  ) async {
    try {
      _logger.info(
        'Starting Azure streaming completion using deployment: ${request.model}',
      );
      final headers = {
        'Content-Type': 'application/json',
        'api-key': request.apiKey,
        'Accept': 'text/event-stream',
      };

      // 添加stream参数
      final requestData = Map<String, dynamic>.from(request.toJson());
      requestData.remove('model');
      requestData['stream'] = true;

      final uri =
          '${request.endpoint}/openai/deployments/${request.model}/chat/completions?api-version=2023-05-15';

      // 使用Dio的响应类型为流
      final response = await dio.post(
        uri,
        data: requestData,
        options: Options(headers: headers, responseType: ResponseType.stream),
      );

      if (response.statusCode == 200) {
        final stream = response.data.stream as Stream<List<int>>;

        return stream
            .transform(utf8.decoder)
            .transform(const LineSplitter())
            .where(
              (line) =>
                  line.trim().startsWith('data: ') && !line.contains('[DONE]'),
            )
            .map((line) {
              try {
                final jsonData = jsonDecode(line.substring(6));
                if (jsonData['choices'] != null &&
                    jsonData['choices'].isNotEmpty &&
                    jsonData['choices'][0]['delta'] != null &&
                    jsonData['choices'][0]['delta']['content'] != null) {
                  return jsonData['choices'][0]['delta']['content'] as String;
                }
              } catch (e) {
                // 忽略解析错误
              }
              return '';
            })
            .where((text) => text.isNotEmpty);
      } else {
        return Stream.value('错误: HTTP状态码 ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null && e.response!.data != null) {
        try {
          final error = e.response!.data;
          final errorMessage =
              error['error']['message'] ?? '请求失败: ${e.message}';
          return Stream.value('错误: $errorMessage');
        } catch (_) {
          return Stream.value('请求失败: ${e.message}');
        }
      }
      return Stream.value('请求失败: ${e.message}');
    } catch (e) {
      _logger.severe('Unexpected error with stream: $e', e);
      return Stream.value('请求失败: $e');
    }
  }
}
