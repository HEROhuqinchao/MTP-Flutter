class CompletionRequest {
  final List<Message> messages;
  final double temperature;
  final int maxTokens;
  final String model;
  final String endpoint;
  final String apiKey;

  CompletionRequest({
    required this.messages,
    required this.model,
    required this.endpoint,
    required this.apiKey,
    this.temperature = 0.7,
    this.maxTokens = 2000,
  });

  Map<String, dynamic> toJson() {
    return {
      'messages': messages.map((e) => e.toJson()).toList(),
      'temperature': temperature,
      'max_tokens': maxTokens,
      'model': model,
      'endpoint': endpoint,
      'api_key': apiKey,
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
