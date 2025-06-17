import 'package:mtp/src/features/chat/domain/entities/chat_message_entity.dart';

/// AI回复服务接口
abstract class AIResponseService {
  Future<Stream<String>> generateResponse({
    required List<ChatMessageEntity> messages,
    required String modelName,
    required double temperature,
  });
}
