class CompletionResponse {
  final String id;
  final String content;
  final Usage usage;
  final String modelName;
  final double? temperature;
  final int created;
  final String? errorMessage;

  CompletionResponse({
    required this.id,
    required this.content,
    required this.usage,
    required this.modelName,
    this.temperature,
    required this.created,
    this.errorMessage,
  });

  factory CompletionResponse.fromJson(Map<String, dynamic> json) {
    final choices = json['choices'] as List;
    final firstChoice = choices.first;
    final messageContent = firstChoice['message']['content'];

    return CompletionResponse(
      id: json['id'],
      content: messageContent,
      usage: Usage.fromJson(json['usage']),
      modelName: json['model'],
      created: json['created'],
      temperature: json['temperature'],
      errorMessage: null,
    );
  }

  factory CompletionResponse.fromError(String message) {
    return CompletionResponse(
      id: '',
      content: '',
      usage: Usage(promptTokens: 0, completionTokens: 0, totalTokens: 0),
      modelName: '',
      created: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      errorMessage: message,
    );
  }

  bool get hasError => errorMessage != null && errorMessage!.isNotEmpty;
}

class Usage {
  final int promptTokens;
  final int completionTokens;
  final int totalTokens;

  Usage({
    required this.promptTokens,
    required this.completionTokens,
    required this.totalTokens,
  });

  factory Usage.fromJson(Map<String, dynamic> json) {
    return Usage(
      promptTokens: json['prompt_tokens'],
      completionTokens: json['completion_tokens'],
      totalTokens: json['total_tokens'],
    );
  }
}
