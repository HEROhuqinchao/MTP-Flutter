// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_model_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatModelEntity _$ChatModelEntityFromJson(Map<String, dynamic> json) =>
    _ChatModelEntity(
      id: json['id'] as String,
      customName: json['customName'] as String,
      modelName: json['modelName'] as String,
      endpoint: json['endpoint'] as String,
      temperature: (json['temperature'] as num).toDouble(),
      apiKey: json['apiKey'] as String,
      isSelected: json['isSelected'] as bool,
    );

Map<String, dynamic> _$ChatModelEntityToJson(_ChatModelEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'customName': instance.customName,
      'modelName': instance.modelName,
      'endpoint': instance.endpoint,
      'temperature': instance.temperature,
      'apiKey': instance.apiKey,
      'isSelected': instance.isSelected,
    };
