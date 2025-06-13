// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
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

 String? get id; String get name; String get endpoint; double get temparture; String get apiKey; bool get isSelected;
/// Create a copy of ChatModelEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatModelEntityCopyWith<ChatModelEntity> get copyWith => _$ChatModelEntityCopyWithImpl<ChatModelEntity>(this as ChatModelEntity, _$identity);

  /// Serializes this ChatModelEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatModelEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.endpoint, endpoint) || other.endpoint == endpoint)&&(identical(other.temparture, temparture) || other.temparture == temparture)&&(identical(other.apiKey, apiKey) || other.apiKey == apiKey)&&(identical(other.isSelected, isSelected) || other.isSelected == isSelected));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,endpoint,temparture,apiKey,isSelected);

@override
String toString() {
  return 'ChatModelEntity(id: $id, name: $name, endpoint: $endpoint, temparture: $temparture, apiKey: $apiKey, isSelected: $isSelected)';
}


}

/// @nodoc
abstract mixin class $ChatModelEntityCopyWith<$Res>  {
  factory $ChatModelEntityCopyWith(ChatModelEntity value, $Res Function(ChatModelEntity) _then) = _$ChatModelEntityCopyWithImpl;
@useResult
$Res call({
 String? id, String name, String endpoint, double temparture, String apiKey, bool isSelected
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = null,Object? endpoint = null,Object? temparture = null,Object? apiKey = null,Object? isSelected = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,endpoint: null == endpoint ? _self.endpoint : endpoint // ignore: cast_nullable_to_non_nullable
as String,temparture: null == temparture ? _self.temparture : temparture // ignore: cast_nullable_to_non_nullable
as double,apiKey: null == apiKey ? _self.apiKey : apiKey // ignore: cast_nullable_to_non_nullable
as String,isSelected: null == isSelected ? _self.isSelected : isSelected // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _ChatModelEntity implements ChatModelEntity {
  const _ChatModelEntity({this.id, required this.name, required this.endpoint, required this.temparture, required this.apiKey, required this.isSelected});
  factory _ChatModelEntity.fromJson(Map<String, dynamic> json) => _$ChatModelEntityFromJson(json);

@override final  String? id;
@override final  String name;
@override final  String endpoint;
@override final  double temparture;
@override final  String apiKey;
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatModelEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.endpoint, endpoint) || other.endpoint == endpoint)&&(identical(other.temparture, temparture) || other.temparture == temparture)&&(identical(other.apiKey, apiKey) || other.apiKey == apiKey)&&(identical(other.isSelected, isSelected) || other.isSelected == isSelected));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,endpoint,temparture,apiKey,isSelected);

@override
String toString() {
  return 'ChatModelEntity(id: $id, name: $name, endpoint: $endpoint, temparture: $temparture, apiKey: $apiKey, isSelected: $isSelected)';
}


}

/// @nodoc
abstract mixin class _$ChatModelEntityCopyWith<$Res> implements $ChatModelEntityCopyWith<$Res> {
  factory _$ChatModelEntityCopyWith(_ChatModelEntity value, $Res Function(_ChatModelEntity) _then) = __$ChatModelEntityCopyWithImpl;
@override @useResult
$Res call({
 String? id, String name, String endpoint, double temparture, String apiKey, bool isSelected
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = null,Object? endpoint = null,Object? temparture = null,Object? apiKey = null,Object? isSelected = null,}) {
  return _then(_ChatModelEntity(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,endpoint: null == endpoint ? _self.endpoint : endpoint // ignore: cast_nullable_to_non_nullable
as String,temparture: null == temparture ? _self.temparture : temparture // ignore: cast_nullable_to_non_nullable
as double,apiKey: null == apiKey ? _self.apiKey : apiKey // ignore: cast_nullable_to_non_nullable
as String,isSelected: null == isSelected ? _self.isSelected : isSelected // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
