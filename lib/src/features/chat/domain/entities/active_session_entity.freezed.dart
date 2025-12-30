// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'active_session_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ActiveSessionEntity {

/// 会话ID
 String get id;/// 会话标题
 String get title;/// 会话类型，0: 私聊，1: 群聊
 int get type;/// 会话创建时间
 DateTime get createdAt;/// 是否置顶
 bool get isPinned;/// 会话头像
 String? get avatar;/// 会话内的角色列表
 List<String> get roleIds;/// 会话内的所有消息
 List<ChatMessageEntity> get messages;
/// Create a copy of ActiveSessionEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActiveSessionEntityCopyWith<ActiveSessionEntity> get copyWith => _$ActiveSessionEntityCopyWithImpl<ActiveSessionEntity>(this as ActiveSessionEntity, _$identity);

  /// Serializes this ActiveSessionEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActiveSessionEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.type, type) || other.type == type)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isPinned, isPinned) || other.isPinned == isPinned)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&const DeepCollectionEquality().equals(other.roleIds, roleIds)&&const DeepCollectionEquality().equals(other.messages, messages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,type,createdAt,isPinned,avatar,const DeepCollectionEquality().hash(roleIds),const DeepCollectionEquality().hash(messages));

@override
String toString() {
  return 'ActiveSessionEntity(id: $id, title: $title, type: $type, createdAt: $createdAt, isPinned: $isPinned, avatar: $avatar, roleIds: $roleIds, messages: $messages)';
}


}

/// @nodoc
abstract mixin class $ActiveSessionEntityCopyWith<$Res>  {
  factory $ActiveSessionEntityCopyWith(ActiveSessionEntity value, $Res Function(ActiveSessionEntity) _then) = _$ActiveSessionEntityCopyWithImpl;
@useResult
$Res call({
 String id, String title, int type, DateTime createdAt, bool isPinned, String? avatar, List<String> roleIds, List<ChatMessageEntity> messages
});




}
/// @nodoc
class _$ActiveSessionEntityCopyWithImpl<$Res>
    implements $ActiveSessionEntityCopyWith<$Res> {
  _$ActiveSessionEntityCopyWithImpl(this._self, this._then);

  final ActiveSessionEntity _self;
  final $Res Function(ActiveSessionEntity) _then;

/// Create a copy of ActiveSessionEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? type = null,Object? createdAt = null,Object? isPinned = null,Object? avatar = freezed,Object? roleIds = null,Object? messages = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,isPinned: null == isPinned ? _self.isPinned : isPinned // ignore: cast_nullable_to_non_nullable
as bool,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String?,roleIds: null == roleIds ? _self.roleIds : roleIds // ignore: cast_nullable_to_non_nullable
as List<String>,messages: null == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as List<ChatMessageEntity>,
  ));
}

}


/// Adds pattern-matching-related methods to [ActiveSessionEntity].
extension ActiveSessionEntityPatterns on ActiveSessionEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActiveSessionEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActiveSessionEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActiveSessionEntity value)  $default,){
final _that = this;
switch (_that) {
case _ActiveSessionEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActiveSessionEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ActiveSessionEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  int type,  DateTime createdAt,  bool isPinned,  String? avatar,  List<String> roleIds,  List<ChatMessageEntity> messages)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActiveSessionEntity() when $default != null:
return $default(_that.id,_that.title,_that.type,_that.createdAt,_that.isPinned,_that.avatar,_that.roleIds,_that.messages);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  int type,  DateTime createdAt,  bool isPinned,  String? avatar,  List<String> roleIds,  List<ChatMessageEntity> messages)  $default,) {final _that = this;
switch (_that) {
case _ActiveSessionEntity():
return $default(_that.id,_that.title,_that.type,_that.createdAt,_that.isPinned,_that.avatar,_that.roleIds,_that.messages);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  int type,  DateTime createdAt,  bool isPinned,  String? avatar,  List<String> roleIds,  List<ChatMessageEntity> messages)?  $default,) {final _that = this;
switch (_that) {
case _ActiveSessionEntity() when $default != null:
return $default(_that.id,_that.title,_that.type,_that.createdAt,_that.isPinned,_that.avatar,_that.roleIds,_that.messages);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActiveSessionEntity implements ActiveSessionEntity {
  const _ActiveSessionEntity({required this.id, required this.title, required this.type, required this.createdAt, required this.isPinned, this.avatar, required final  List<String> roleIds, required final  List<ChatMessageEntity> messages}): _roleIds = roleIds,_messages = messages;
  factory _ActiveSessionEntity.fromJson(Map<String, dynamic> json) => _$ActiveSessionEntityFromJson(json);

/// 会话ID
@override final  String id;
/// 会话标题
@override final  String title;
/// 会话类型，0: 私聊，1: 群聊
@override final  int type;
/// 会话创建时间
@override final  DateTime createdAt;
/// 是否置顶
@override final  bool isPinned;
/// 会话头像
@override final  String? avatar;
/// 会话内的角色列表
 final  List<String> _roleIds;
/// 会话内的角色列表
@override List<String> get roleIds {
  if (_roleIds is EqualUnmodifiableListView) return _roleIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_roleIds);
}

/// 会话内的所有消息
 final  List<ChatMessageEntity> _messages;
/// 会话内的所有消息
@override List<ChatMessageEntity> get messages {
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messages);
}


/// Create a copy of ActiveSessionEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActiveSessionEntityCopyWith<_ActiveSessionEntity> get copyWith => __$ActiveSessionEntityCopyWithImpl<_ActiveSessionEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActiveSessionEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActiveSessionEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.type, type) || other.type == type)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isPinned, isPinned) || other.isPinned == isPinned)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&const DeepCollectionEquality().equals(other._roleIds, _roleIds)&&const DeepCollectionEquality().equals(other._messages, _messages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,type,createdAt,isPinned,avatar,const DeepCollectionEquality().hash(_roleIds),const DeepCollectionEquality().hash(_messages));

@override
String toString() {
  return 'ActiveSessionEntity(id: $id, title: $title, type: $type, createdAt: $createdAt, isPinned: $isPinned, avatar: $avatar, roleIds: $roleIds, messages: $messages)';
}


}

/// @nodoc
abstract mixin class _$ActiveSessionEntityCopyWith<$Res> implements $ActiveSessionEntityCopyWith<$Res> {
  factory _$ActiveSessionEntityCopyWith(_ActiveSessionEntity value, $Res Function(_ActiveSessionEntity) _then) = __$ActiveSessionEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, int type, DateTime createdAt, bool isPinned, String? avatar, List<String> roleIds, List<ChatMessageEntity> messages
});




}
/// @nodoc
class __$ActiveSessionEntityCopyWithImpl<$Res>
    implements _$ActiveSessionEntityCopyWith<$Res> {
  __$ActiveSessionEntityCopyWithImpl(this._self, this._then);

  final _ActiveSessionEntity _self;
  final $Res Function(_ActiveSessionEntity) _then;

/// Create a copy of ActiveSessionEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? type = null,Object? createdAt = null,Object? isPinned = null,Object? avatar = freezed,Object? roleIds = null,Object? messages = null,}) {
  return _then(_ActiveSessionEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,isPinned: null == isPinned ? _self.isPinned : isPinned // ignore: cast_nullable_to_non_nullable
as bool,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String?,roleIds: null == roleIds ? _self._roleIds : roleIds // ignore: cast_nullable_to_non_nullable
as List<String>,messages: null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<ChatMessageEntity>,
  ));
}


}

// dart format on
