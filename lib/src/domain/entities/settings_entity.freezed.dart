// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SettingsEntity {

 String? get id; String get username; String get userAvatar; String get theme; List<ChatModelEntity> get models;
/// Create a copy of SettingsEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsEntityCopyWith<SettingsEntity> get copyWith => _$SettingsEntityCopyWithImpl<SettingsEntity>(this as SettingsEntity, _$identity);

  /// Serializes this SettingsEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.userAvatar, userAvatar) || other.userAvatar == userAvatar)&&(identical(other.theme, theme) || other.theme == theme)&&const DeepCollectionEquality().equals(other.models, models));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,userAvatar,theme,const DeepCollectionEquality().hash(models));

@override
String toString() {
  return 'SettingsEntity(id: $id, username: $username, userAvatar: $userAvatar, theme: $theme, models: $models)';
}


}

/// @nodoc
abstract mixin class $SettingsEntityCopyWith<$Res>  {
  factory $SettingsEntityCopyWith(SettingsEntity value, $Res Function(SettingsEntity) _then) = _$SettingsEntityCopyWithImpl;
@useResult
$Res call({
 String? id, String username, String userAvatar, String theme, List<ChatModelEntity> models
});




}
/// @nodoc
class _$SettingsEntityCopyWithImpl<$Res>
    implements $SettingsEntityCopyWith<$Res> {
  _$SettingsEntityCopyWithImpl(this._self, this._then);

  final SettingsEntity _self;
  final $Res Function(SettingsEntity) _then;

/// Create a copy of SettingsEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? username = null,Object? userAvatar = null,Object? theme = null,Object? models = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,userAvatar: null == userAvatar ? _self.userAvatar : userAvatar // ignore: cast_nullable_to_non_nullable
as String,theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as String,models: null == models ? _self.models : models // ignore: cast_nullable_to_non_nullable
as List<ChatModelEntity>,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _SettingsEntity implements SettingsEntity {
  const _SettingsEntity({this.id, required this.username, required this.userAvatar, required this.theme, required final  List<ChatModelEntity> models}): _models = models;
  factory _SettingsEntity.fromJson(Map<String, dynamic> json) => _$SettingsEntityFromJson(json);

@override final  String? id;
@override final  String username;
@override final  String userAvatar;
@override final  String theme;
 final  List<ChatModelEntity> _models;
@override List<ChatModelEntity> get models {
  if (_models is EqualUnmodifiableListView) return _models;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_models);
}


/// Create a copy of SettingsEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SettingsEntityCopyWith<_SettingsEntity> get copyWith => __$SettingsEntityCopyWithImpl<_SettingsEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SettingsEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SettingsEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.userAvatar, userAvatar) || other.userAvatar == userAvatar)&&(identical(other.theme, theme) || other.theme == theme)&&const DeepCollectionEquality().equals(other._models, _models));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,userAvatar,theme,const DeepCollectionEquality().hash(_models));

@override
String toString() {
  return 'SettingsEntity(id: $id, username: $username, userAvatar: $userAvatar, theme: $theme, models: $models)';
}


}

/// @nodoc
abstract mixin class _$SettingsEntityCopyWith<$Res> implements $SettingsEntityCopyWith<$Res> {
  factory _$SettingsEntityCopyWith(_SettingsEntity value, $Res Function(_SettingsEntity) _then) = __$SettingsEntityCopyWithImpl;
@override @useResult
$Res call({
 String? id, String username, String userAvatar, String theme, List<ChatModelEntity> models
});




}
/// @nodoc
class __$SettingsEntityCopyWithImpl<$Res>
    implements _$SettingsEntityCopyWith<$Res> {
  __$SettingsEntityCopyWithImpl(this._self, this._then);

  final _SettingsEntity _self;
  final $Res Function(_SettingsEntity) _then;

/// Create a copy of SettingsEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? username = null,Object? userAvatar = null,Object? theme = null,Object? models = null,}) {
  return _then(_SettingsEntity(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,userAvatar: null == userAvatar ? _self.userAvatar : userAvatar // ignore: cast_nullable_to_non_nullable
as String,theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as String,models: null == models ? _self._models : models // ignore: cast_nullable_to_non_nullable
as List<ChatModelEntity>,
  ));
}


}

// dart format on
