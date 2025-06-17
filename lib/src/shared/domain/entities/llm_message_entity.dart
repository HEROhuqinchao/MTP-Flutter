/// 表示发送给大型语言模型 (LLM) 或从其接收的单条消息。
///
/// 每条消息都有一个角色 (如 "system", "user", "assistant") 和内容。
class LLMMessageEntity {
  /// 消息发送者的角色。
  ///
  /// 例如："system", "user", "assistant"。
  final String role;

  /// 消息的文本内容。
  final String content;

  /// 创建一个 [LLMMessageEntity] 实例。
  LLMMessageEntity({required this.role, required this.content});
}
