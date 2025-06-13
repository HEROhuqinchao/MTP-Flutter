import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:mtp/src/shared/data/datasources/local/app_database.dart';
import 'package:mtp/src/shared/data/models/completion/request.dart';
import 'package:mtp/src/shared/data/models/completion/response.dart';
import 'package:mtp/src/utils/logger.dart';
import './llm_remote_datasource.dart';

class OpenAiRemoteDatasource implements LlmRemoteDatasource {
  final Dio dio;
  final Logger _logger = AppLogger.getLogger('OpenAI');

  OpenAiRemoteDatasource({required this.dio});

  @override
  Future<CompletionResponse> generateCompletion(
    CompletionRequest request,
    ChatModel model,
  ) async {
    try {
      _logger.info('Generating completion using model: ${request.model}');
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${model.apiKey}',
      };

      final uri = '${model.endpoint}/v1/chat/completions';
      final requestBody = request.toJson();

      final response = await dio.post(
        uri,
        data: requestBody,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        _logger.info('Successfully received completion response');
        return CompletionResponse.fromJson(response.data);
      } else {
        final error = response.data;
        final errorMsg = error['error']['message'] ?? '未知错误';
        _logger.warning('Error in completion response: $errorMsg');
        return CompletionResponse.fromError(errorMsg);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        try {
          final error = e.response!.data;
          final errorMessage =
              error['error']['message'] ?? '请求失败: ${e.message}';
          _logger.severe('DioException with response: $errorMessage', e);
          return CompletionResponse.fromError(errorMessage);
        } catch (_) {
          _logger.severe('DioException parsing error: ${e.message}', e);
          return CompletionResponse.fromError('请求失败: ${e.message}');
        }
      }
      _logger.severe('DioException: ${e.message}', e);
      return CompletionResponse.fromError('请求失败: ${e.message}');
    } catch (e) {
      _logger.severe('Unexpected error: $e', e);
      return CompletionResponse.fromError('请求失败: $e');
    }
  }

  @override
  Future<Stream<String>> generateCompletionStream(
    CompletionRequest request,
    ChatModel model,
  ) async {
    try {
      _logger.info(
        'Starting streaming completion using model: ${request.model}',
      );
      // 检查是否存在系统消息并进行RAG处理
      if (request.messages.isNotEmpty) {
        // 检查第一条消息是否为系统消息
        final firstMessage = request.messages.first;
        if (firstMessage.role == 'system') {
          final systemContent = firstMessage.content;
          _logger.info('检测到系统消息，尝试进行RAG处理');

          // 尝试使用RAG API获取增强内容
          try {
            final ragContent = await _fetchRagContent(systemContent);
            if (ragContent != null && ragContent.isNotEmpty) {
              _logger.info('成功获取RAG内容，增强系统提示');

              // 创建增强后的系统消息
              final enhancedContent = '''$systemContent
以下是一些可能有助于回答的相关参考信息:
$ragContent''';

              // 更新请求中的系统消息
              request.messages[0] = Message(
                role: 'system',
                content: enhancedContent,
              );
            }
          } catch (e) {
            _logger.warning('RAG处理失败: $e，将使用原始系统提示');
            // 继续使用原始提示，不中断流程
          }
        }
      }

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${model.apiKey}',
        'Accept': 'text/event-stream',
      };

      // 添加stream参数
      final requestWithStream = Map<String, dynamic>.from(request.toJson())
        ..['stream'] = true;

      final uri = '${model.endpoint}/chat/completions';

      // 使用Dio的响应类型为流
      final response = await dio.post(
        uri,
        data: requestWithStream,
        options: Options(headers: headers, responseType: ResponseType.stream),
      );

      if (response.statusCode == 200) {
        _logger.info('Stream response started successfully');
        final stream = response.data.stream as Stream<List<int>>;

        return stream
            .transform(
              StreamTransformer<Uint8List, String>.fromHandlers(
                handleData: (data, sink) {
                  sink.add(utf8.decode(data));
                },
              ),
            )
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
                _logger.warning('Error parsing stream data: $e');
              }
              return '';
            })
            .where((text) => text.isNotEmpty);
      } else {
        _logger.warning(
          'Stream error: HTTP status code ${response.statusCode}',
        );
        return Stream.value('错误: HTTP状态码 ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null && e.response!.data != null) {
        try {
          final error = e.response!.data;
          final errorMessage =
              error['error']['message'] ?? '请求失败: ${e.message}';
          _logger.severe('DioException with stream response: $errorMessage', e);
          return Stream.value('错误: $errorMessage');
        } catch (_) {
          _logger.severe('DioException parsing stream error: ${e.message}', e);
          return Stream.value('请求失败: ${e.message}');
        }
      }
      _logger.severe('DioException with stream: ${e.message}', e);
      return Stream.value('请求失败: ${e.message}');
    } catch (e) {
      _logger.severe('Unexpected error with stream: $e', e);
      return Stream.value('请求失败: $e');
    }
  }

  // 从RAG API获取增强内容
  Future<String?> _fetchRagContent(String prompt) async {
    try {
      _logger.info('开始从RAG API获取增强内容');

      // 创建单独的Dio实例，避免影响主请求
      final ragDio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 8),
        ),
      );

      // 编码查询参数
      final encodedQuery = Uri.encodeQueryComponent(prompt);
      final url = 'https://miluvs.hanasaki.tech/api/search?q=$encodedQuery';

      // 发送请求
      final response = await ragDio.get(url);

      if (response.statusCode == 200) {
        final data = response.data;

        // 根据API实际返回格式提取内容
        if (data['results'] != null &&
            data['results'] is List &&
            data['results'].isNotEmpty) {
          // 提取前3个最相关的结果（如果有）
          final maxResults = 5;
          final results = data['results'] as List;
          final relevantResults =
              results.length > maxResults
                  ? results.sublist(0, maxResults)
                  : results;

          // 格式化RAG结果
          final List<String> formattedResults = [];
          for (var result in relevantResults) {
            // 根据API返回的具体字段调整
            if (result['content'] != null) {
              formattedResults.add(result['content'].toString());
            }
          }

          return formattedResults.join('\n\n---\n\n');
        }
        _logger.info('RAG API返回了结果，但未找到相关内容');
      } else {
        _logger.warning('RAG API请求失败，状态码: ${response.statusCode}');
      }

      return null;
    } catch (e) {
      _logger.warning('获取RAG内容时发生错误: $e');
      return null;
    }
  }
}
