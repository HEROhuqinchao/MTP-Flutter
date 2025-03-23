import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import '../../models/completion/request.dart';
import '../../models/completion/response.dart';
import '../../models/chat/model.dart';
import 'llm_remote_datasource.dart';
import '../../../utils/logger.dart';

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
}
