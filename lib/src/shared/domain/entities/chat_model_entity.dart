import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_model_entity.freezed.dart';
part 'chat_model_entity.g.dart';

/// 表示一个可用的聊天模型配置。
///
/// 包含了模型的标识、名称、API端点、默认温度和API密钥等信息。
@freezed
abstract class ChatModelEntity with _$ChatModelEntity {
  /// 创建一个 [ChatModelEntity] 实例。
  const factory ChatModelEntity({
    /// 模型的唯一标识符。
    required String id,

    /// 用户可读的模型名称。
    required String customName,

    /// 模型名称。
    required String modelName,

    /// 调用此模型的API端点URL。
    required String endpoint,

    /// 模型的默认温度设置。
    ///
    /// 温度控制生成文本的随机性。
    required double temperature, // 注意：这里可能是拼写错误，应为 temperature
    /// 与此模型关联的API密钥。
    required String apiKey,

    /// 指示此模型当前是否被选中或激活。
    required bool isSelected,
  }) = _ChatModelEntity;

  /// 从JSON映射创建一个 [ChatModelEntity] 实例。
  factory ChatModelEntity.fromJson(Map<String, dynamic> json) =>
      _$ChatModelEntityFromJson(json);
}
