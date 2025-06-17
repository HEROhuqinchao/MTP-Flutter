import 'package:mtp/src/shared/domain/entities/completion_request_entity.dart';
import 'package:mtp/src/shared/domain/entities/completion_response_entity.dart';

/// 定义了与大型语言模型 (LLM) 交互的仓库接口。
///
/// 此接口抽象了获取文本补全操作的具体实现，
/// 允许以一次性响应或流式响应的方式与 LLM 进行通信。
abstract class LLMRepository {
  /// 向 LLM 请求一次性的文本补全。
  ///
  /// 根据提供的 [request]（包含消息历史、温度等参数）和
  /// 指定的 [model] 配置，生成并返回一个完整的 [CompletionResponseEntity]。
  ///
  /// - [request]: 包含发送给 LLM 的所有参数和消息。
  /// - [model]: 指定用于生成补全的聊天模型配置。
  /// - 返回: 一个包含 LLM 响应内容的 [Future<CompletionResponseEntity>]。
  Future<CompletionResponseEntity> generateCompletion(
    CompletionRequestEntity request,
  );

  /// 向 LLM 请求流式的文本补全。
  ///
  /// 根据提供的 [request] 和 [model] 配置，
  /// 返回一个 [Stream<String>]，该流会逐步推送 LLM 生成的文本片段。
  ///
  /// - [request]: 包含发送给 LLM 的所有参数和消息。
  /// - [model]: 指定用于生成补全的聊天模型配置。
  /// - 返回: 一个 [Future<Stream<String>>]，其中流中的每个字符串元素代表 LLM 生成的部分文本。
  Future<Stream<String>> generateCompletionStream(
    CompletionRequestEntity request,
  );
}
