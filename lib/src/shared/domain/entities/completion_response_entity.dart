/// 表示从大型语言模型 (LLM) 返回的补全响应。
///
/// 包含了响应内容、token 使用情况、模型信息等。
class CompletionResponseEntity {
  /// 响应的唯一标识符。
  final String id;

  /// LLM 生成的主要内容。
  final String content;

  /// 输入提示中使用的 token 数量。
  final int promptTokens;

  /// 生成的补全内容中使用的 token 数量。
  final int completionTokens;

  /// 本次请求总共使用的 token 数量 (promptTokens + completionTokens)。
  final int totalTokens;

  /// 用于生成此响应的模型名称。
  final String modelName;

  /// 生成响应时使用的温度参数。
  ///
  /// 如果未指定或不适用，则为 `null`。
  final double? temperature;

  /// 响应的创建时间。
  final DateTime createdAt;

  /// 如果请求过程中发生错误，则包含错误信息。
  ///
  /// 如果没有错误，则为 `null`。
  final String? errorMessage;

  /// 创建一个 [CompletionResponseEntity] 实例。
  CompletionResponseEntity({
    required this.id,
    required this.content,
    required this.promptTokens,
    required this.completionTokens,
    required this.totalTokens,
    required this.modelName,
    this.temperature,
    required this.createdAt,
    this.errorMessage,
  });

  /// 创建一个表示错误的 [CompletionResponseEntity] 实例。
  ///
  /// [message] 是描述错误的字符串。
  factory CompletionResponseEntity.error(String message) {
    return CompletionResponseEntity(
      id: '', // 通常错误响应没有有效的ID
      content: '', // 错误响应没有内容
      promptTokens: 0,
      completionTokens: 0,
      totalTokens: 0,
      modelName: '', // 模型信息可能未知或不适用
      createdAt: DateTime.now(),
      errorMessage: message,
    );
  }

  /// 指示此响应是否表示一个错误。
  ///
  /// 如果 [errorMessage] 不为 `null` 且不为空，则返回 `true`。
  bool get hasError => errorMessage != null && errorMessage!.isNotEmpty;
}
