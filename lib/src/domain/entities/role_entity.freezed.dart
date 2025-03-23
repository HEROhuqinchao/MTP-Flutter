// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'role_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RoleEntity {

 String? get id; String get name; List<String> get avatars; String get prompt; String get lastMessage;
/// Create a copy of RoleEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoleEntityCopyWith<RoleEntity> get copyWith => _$RoleEntityCopyWithImpl<RoleEntity>(this as RoleEntity, _$identity);

  /// Serializes this RoleEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoleEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.avatars, avatars)&&(identical(other.prompt, prompt) || other.prompt == prompt)&&(identical(other.lastMessage, lastMessage) || other.lastMessage == lastMessage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(avatars),prompt,lastMessage);

@override
String toString() {
  return 'RoleEntity(id: $id, name: $name, avatars: $avatars, prompt: $prompt, lastMessage: $lastMessage)';
}


}

/// @nodoc
abstract mixin class $RoleEntityCopyWith<$Res>  {
  factory $RoleEntityCopyWith(RoleEntity value, $Res Function(RoleEntity) _then) = _$RoleEntityCopyWithImpl;
@useResult
$Res call({
 String? id, String name, List<String> avatars, String prompt, String lastMessage
});




}
/// @nodoc
class _$RoleEntityCopyWithImpl<$Res>
    implements $RoleEntityCopyWith<$Res> {
  _$RoleEntityCopyWithImpl(this._self, this._then);

  final RoleEntity _self;
  final $Res Function(RoleEntity) _then;

/// Create a copy of RoleEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = null,Object? avatars = null,Object? prompt = null,Object? lastMessage = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatars: null == avatars ? _self.avatars : avatars // ignore: cast_nullable_to_non_nullable
as List<String>,prompt: null == prompt ? _self.prompt : prompt // ignore: cast_nullable_to_non_nullable
as String,lastMessage: null == lastMessage ? _self.lastMessage : lastMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _RoleEntity implements RoleEntity {
  const _RoleEntity({this.id, required this.name, required final  List<String> avatars, required this.prompt, required this.lastMessage}): _avatars = avatars;
  factory _RoleEntity.fromJson(Map<String, dynamic> json) => _$RoleEntityFromJson(json);

@override final  String? id;
@override final  String name;
 final  List<String> _avatars;
@override List<String> get avatars {
  if (_avatars is EqualUnmodifiableListView) return _avatars;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_avatars);
}

@override final  String prompt;
@override final  String lastMessage;

/// Create a copy of RoleEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoleEntityCopyWith<_RoleEntity> get copyWith => __$RoleEntityCopyWithImpl<_RoleEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RoleEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoleEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._avatars, _avatars)&&(identical(other.prompt, prompt) || other.prompt == prompt)&&(identical(other.lastMessage, lastMessage) || other.lastMessage == lastMessage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(_avatars),prompt,lastMessage);

@override
String toString() {
  return 'RoleEntity(id: $id, name: $name, avatars: $avatars, prompt: $prompt, lastMessage: $lastMessage)';
}


}

/// @nodoc
abstract mixin class _$RoleEntityCopyWith<$Res> implements $RoleEntityCopyWith<$Res> {
  factory _$RoleEntityCopyWith(_RoleEntity value, $Res Function(_RoleEntity) _then) = __$RoleEntityCopyWithImpl;
@override @useResult
$Res call({
 String? id, String name, List<String> avatars, String prompt, String lastMessage
});




}
/// @nodoc
class __$RoleEntityCopyWithImpl<$Res>
    implements _$RoleEntityCopyWith<$Res> {
  __$RoleEntityCopyWithImpl(this._self, this._then);

  final _RoleEntity _self;
  final $Res Function(_RoleEntity) _then;

/// Create a copy of RoleEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = null,Object? avatars = null,Object? prompt = null,Object? lastMessage = null,}) {
  return _then(_RoleEntity(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatars: null == avatars ? _self._avatars : avatars // ignore: cast_nullable_to_non_nullable
as List<String>,prompt: null == prompt ? _self.prompt : prompt // ignore: cast_nullable_to_non_nullable
as String,lastMessage: null == lastMessage ? _self.lastMessage : lastMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
