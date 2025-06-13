class CompletionResponseEntity {
  final String id;
  final String content;
  final int promptTokens;
  final int completionTokens;
  final int totalTokens;
  final String modelName;
  final double? temperature;
  final DateTime createdAt;
  final String? errorMessage;

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

  // 创建错误响应
  factory CompletionResponseEntity.error(String message) {
    return CompletionResponseEntity(
      id: '',
      content: '',
      promptTokens: 0,
      completionTokens: 0,
      totalTokens: 0,
      modelName: '',
      createdAt: DateTime.now(),
      errorMessage: message,
    );
  }

  bool get hasError => errorMessage != null && errorMessage!.isNotEmpty;
}
