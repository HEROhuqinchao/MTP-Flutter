class CompletionRequestEntity {
  final List<LLMMessageEntity> messages;
  final double temperature;
  final int maxTokens;
  final String model;

  CompletionRequestEntity({
    required this.messages,
    this.temperature = 0.7,
    this.maxTokens = 2000,
    this.model = 'gpt-3.5-turbo',
  });
}

class LLMMessageEntity {
  final String role;
  final String content;

  LLMMessageEntity({required this.role, required this.content});
}
