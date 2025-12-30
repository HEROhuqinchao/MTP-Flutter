// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_model_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatModelEntity {

/// 模型的唯一标识符。
 String get id;/// 用户可读的模型名称。
 String get customName;/// 模型名称。
 String get modelName;/// 调用此模型的API端点URL。
 String get endpoint;/// 模型的默认温度设置。
///
/// 温度控制生成文本的随机性。
 double get temperature;// 注意：这里可能是拼写错误，应为 temperature
/// 与此模型关联的API密钥。
 String get apiKey;/// 指示此模型当前是否被选中或激活。
 bool get isSelected;
/// Create a copy of ChatModelEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatModelEntityCopyWith<ChatModelEntity> get copyWith => _$ChatModelEntityCopyWithImpl<ChatModelEntity>(this as ChatModelEntity, _$identity);

  /// Serializes this ChatModelEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatModelEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.customName, customName) || other.customName == customName)&&(identical(other.modelName, modelName) || other.modelName == modelName)&&(identical(other.endpoint, endpoint) || other.endpoint == endpoint)&&(identical(other.temperature, temperature) || other.temperature == temperature)&&(identical(other.apiKey, apiKey) || other.apiKey == apiKey)&&(identical(other.isSelected, isSelected) || other.isSelected == isSelected));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,customName,modelName,endpoint,temperature,apiKey,isSelected);

@override
String toString() {
  return 'ChatModelEntity(id: $id, customName: $customName, modelName: $modelName, endpoint: $endpoint, temperature: $temperature, apiKey: $apiKey, isSelected: $isSelected)';
}


}

/// @nodoc
abstract mixin class $ChatModelEntityCopyWith<$Res>  {
  factory $ChatModelEntityCopyWith(ChatModelEntity value, $Res Function(ChatModelEntity) _then) = _$ChatModelEntityCopyWithImpl;
@useResult
$Res call({
 String id, String customName, String modelName, String endpoint, double temperature, String apiKey, bool isSelected
});




}
/// @nodoc
class _$ChatModelEntityCopyWithImpl<$Res>
    implements $ChatModelEntityCopyWith<$Res> {
  _$ChatModelEntityCopyWithImpl(this._self, this._then);

  final ChatModelEntity _self;
  final $Res Function(ChatModelEntity) _then;

/// Create a copy of ChatModelEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? customName = null,Object? modelName = null,Object? endpoint = null,Object? temperature = null,Object? apiKey = null,Object? isSelected = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,customName: null == customName ? _self.customName : customName // ignore: cast_nullable_to_non_nullable
as String,modelName: null == modelName ? _self.modelName : modelName // ignore: cast_nullable_to_non_nullable
as String,endpoint: null == endpoint ? _self.endpoint : endpoint // ignore: cast_nullable_to_non_nullable
as String,temperature: null == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as double,apiKey: null == apiKey ? _self.apiKey : apiKey // ignore: cast_nullable_to_non_nullable
as String,isSelected: null == isSelected ? _self.isSelected : isSelected // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatModelEntity].
extension ChatModelEntityPatterns on ChatModelEntity {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatModelEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatModelEntity() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatModelEntity value)  $default,){
final _that = this;
switch (_that) {
case _ChatModelEntity():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatModelEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ChatModelEntity() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String customName,  String modelName,  String endpoint,  double temperature,  String apiKey,  bool isSelected)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatModelEntity() when $default != null:
return $default(_that.id,_that.customName,_that.modelName,_that.endpoint,_that.temperature,_that.apiKey,_that.isSelected);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String customName,  String modelName,  String endpoint,  double temperature,  String apiKey,  bool isSelected)  $default,) {final _that = this;
switch (_that) {
case _ChatModelEntity():
return $default(_that.id,_that.customName,_that.modelName,_that.endpoint,_that.temperature,_that.apiKey,_that.isSelected);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String customName,  String modelName,  String endpoint,  double temperature,  String apiKey,  bool isSelected)?  $default,) {final _that = this;
switch (_that) {
case _ChatModelEntity() when $default != null:
return $default(_that.id,_that.customName,_that.modelName,_that.endpoint,_that.temperature,_that.apiKey,_that.isSelected);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatModelEntity implements ChatModelEntity {
  const _ChatModelEntity({required this.id, required this.customName, required this.modelName, required this.endpoint, required this.temperature, required this.apiKey, required this.isSelected});
  factory _ChatModelEntity.fromJson(Map<String, dynamic> json) => _$ChatModelEntityFromJson(json);

/// 模型的唯一标识符。
@override final  String id;
/// 用户可读的模型名称。
@override final  String customName;
/// 模型名称。
@override final  String modelName;
/// 调用此模型的API端点URL。
@override final  String endpoint;
/// 模型的默认温度设置。
///
/// 温度控制生成文本的随机性。
@override final  double temperature;
// 注意：这里可能是拼写错误，应为 temperature
/// 与此模型关联的API密钥。
@override final  String apiKey;
/// 指示此模型当前是否被选中或激活。
@override final  bool isSelected;

/// Create a copy of ChatModelEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatModelEntityCopyWith<_ChatModelEntity> get copyWith => __$ChatModelEntityCopyWithImpl<_ChatModelEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatModelEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatModelEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.customName, customName) || other.customName == customName)&&(identical(other.modelName, modelName) || other.modelName == modelName)&&(identical(other.endpoint, endpoint) || other.endpoint == endpoint)&&(identical(other.temperature, temperature) || other.temperature == temperature)&&(identical(other.apiKey, apiKey) || other.apiKey == apiKey)&&(identical(other.isSelected, isSelected) || other.isSelected == isSelected));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,customName,modelName,endpoint,temperature,apiKey,isSelected);

@override
String toString() {
  return 'ChatModelEntity(id: $id, customName: $customName, modelName: $modelName, endpoint: $endpoint, temperature: $temperature, apiKey: $apiKey, isSelected: $isSelected)';
}


}

/// @nodoc
abstract mixin class _$ChatModelEntityCopyWith<$Res> implements $ChatModelEntityCopyWith<$Res> {
  factory _$ChatModelEntityCopyWith(_ChatModelEntity value, $Res Function(_ChatModelEntity) _then) = __$ChatModelEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String customName, String modelName, String endpoint, double temperature, String apiKey, bool isSelected
});




}
/// @nodoc
class __$ChatModelEntityCopyWithImpl<$Res>
    implements _$ChatModelEntityCopyWith<$Res> {
  __$ChatModelEntityCopyWithImpl(this._self, this._then);

  final _ChatModelEntity _self;
  final $Res Function(_ChatModelEntity) _then;

/// Create a copy of ChatModelEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? customName = null,Object? modelName = null,Object? endpoint = null,Object? temperature = null,Object? apiKey = null,Object? isSelected = null,}) {
  return _then(_ChatModelEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,customName: null == customName ? _self.customName : customName // ignore: cast_nullable_to_non_nullable
as String,modelName: null == modelName ? _self.modelName : modelName // ignore: cast_nullable_to_non_nullable
as String,endpoint: null == endpoint ? _self.endpoint : endpoint // ignore: cast_nullable_to_non_nullable
as String,temperature: null == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as double,apiKey: null == apiKey ? _self.apiKey : apiKey // ignore: cast_nullable_to_non_nullable
as String,isSelected: null == isSelected ? _self.isSelected : isSelected // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
