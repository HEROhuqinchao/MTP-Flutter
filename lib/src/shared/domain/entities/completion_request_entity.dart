import 'package:mtp/src/shared/domain/entities/llm_message_entity.dart';

/// 表示发送给大型语言模型 (LLM) 以请求文本补全的请求。
///
/// 包含消息历史、温度、最大token数和目标模型等参数。
class CompletionRequestEntity {
  /// 构成对话历史或上下文的消息列表。
  final List<LLMMessageEntity> messages;

  /// 控制生成文本随机性的温度参数。
  ///
  /// 较高的值（如0.8）使输出更随机，而较低的值（如0.2）使其更具确定性。
  /// 默认为 0.7。
  final double temperature;

  /// 生成的补全内容允许的最大 token 数量。
  ///
  /// 默认为 2000。
  final int maxTokens;

  /// 要用于生成补全的目标模型的名称或标识符。
  ///
  /// 默认为 'gpt-3.5-turbo'。
  final String model;

  /// LLM API 的端点 URL。
  final String endpoint;

  /// LLM API 的访问密钥。
  final String apiKey;

  /// 创建一个 [CompletionRequestEntity] 实例。
  CompletionRequestEntity({
    required this.messages,
    required this.endpoint,
    required this.apiKey,
    required this.model,
    this.temperature = 0.7,
    this.maxTokens = 2000,
  });
}
