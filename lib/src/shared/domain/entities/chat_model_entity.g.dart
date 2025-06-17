// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_model_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatModelEntity _$ChatModelEntityFromJson(Map<String, dynamic> json) =>
    _ChatModelEntity(
      id: json['id'] as String,
      name: json['name'] as String,
      endpoint: json['endpoint'] as String,
      temparture: (json['temparture'] as num).toDouble(),
      apiKey: json['apiKey'] as String,
      isSelected: json['isSelected'] as bool,
    );

Map<String, dynamic> _$ChatModelEntityToJson(_ChatModelEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'endpoint': instance.endpoint,
      'temparture': instance.temparture,
      'apiKey': instance.apiKey,
      'isSelected': instance.isSelected,
    };
