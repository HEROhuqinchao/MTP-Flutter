// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
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

/// 设置 ID
 String get id;/// 用户名称
 String get username;/// 用户头像
 String get userAvatar;/// 主题
 String get theme;/// 聊天模型列表
 List<ChatModelEntity> get models;
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
 String id, String username, String userAvatar, String theme, List<ChatModelEntity> models
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? username = null,Object? userAvatar = null,Object? theme = null,Object? models = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,userAvatar: null == userAvatar ? _self.userAvatar : userAvatar // ignore: cast_nullable_to_non_nullable
as String,theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as String,models: null == models ? _self.models : models // ignore: cast_nullable_to_non_nullable
as List<ChatModelEntity>,
  ));
}

}


/// Adds pattern-matching-related methods to [SettingsEntity].
extension SettingsEntityPatterns on SettingsEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SettingsEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SettingsEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SettingsEntity value)  $default,){
final _that = this;
switch (_that) {
case _SettingsEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SettingsEntity value)?  $default,){
final _that = this;
switch (_that) {
case _SettingsEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String username,  String userAvatar,  String theme,  List<ChatModelEntity> models)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SettingsEntity() when $default != null:
return $default(_that.id,_that.username,_that.userAvatar,_that.theme,_that.models);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String username,  String userAvatar,  String theme,  List<ChatModelEntity> models)  $default,) {final _that = this;
switch (_that) {
case _SettingsEntity():
return $default(_that.id,_that.username,_that.userAvatar,_that.theme,_that.models);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String username,  String userAvatar,  String theme,  List<ChatModelEntity> models)?  $default,) {final _that = this;
switch (_that) {
case _SettingsEntity() when $default != null:
return $default(_that.id,_that.username,_that.userAvatar,_that.theme,_that.models);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SettingsEntity implements SettingsEntity {
  const _SettingsEntity({required this.id, required this.username, required this.userAvatar, required this.theme, required final  List<ChatModelEntity> models}): _models = models;
  factory _SettingsEntity.fromJson(Map<String, dynamic> json) => _$SettingsEntityFromJson(json);

/// 设置 ID
@override final  String id;
/// 用户名称
@override final  String username;
/// 用户头像
@override final  String userAvatar;
/// 主题
@override final  String theme;
/// 聊天模型列表
 final  List<ChatModelEntity> _models;
/// 聊天模型列表
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
 String id, String username, String userAvatar, String theme, List<ChatModelEntity> models
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? username = null,Object? userAvatar = null,Object? theme = null,Object? models = null,}) {
  return _then(_SettingsEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,userAvatar: null == userAvatar ? _self.userAvatar : userAvatar // ignore: cast_nullable_to_non_nullable
as String,theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as String,models: null == models ? _self._models : models // ignore: cast_nullable_to_non_nullable
as List<ChatModelEntity>,
  ));
}


}

// dart format on
