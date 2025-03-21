class CompletionRequest {
  final List<Message> messages;
  final double temperature;
  final int maxTokens;
  final String model;

  CompletionRequest({
    required this.messages,
    this.temperature = 0.7,
    this.maxTokens = 2000,
    this.model = 'gpt-3.5-turbo',
  });

  Map<String, dynamic> toJson() {
    return {
      'messages': messages.map((e) => e.toJson()).toList(),
      'temperature': temperature,
      'max_tokens': maxTokens,
      'model': model,
    };
  }
}

class Message {
  final String role;
  final String content;

  Message({required this.role, required this.content});

  Map<String, dynamic> toJson() {
    return {'role': role, 'content': content};
  }
}
