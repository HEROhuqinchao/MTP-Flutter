// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SessionEntity {

 String? get id; String get roleId; String get title; List<MessageEntity> get messages; DateTime? get createdAt; DateTime? get updatedAt; bool? get isPinned;
/// Create a copy of SessionEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionEntityCopyWith<SessionEntity> get copyWith => _$SessionEntityCopyWithImpl<SessionEntity>(this as SessionEntity, _$identity);

  /// Serializes this SessionEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.roleId, roleId) || other.roleId == roleId)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other.messages, messages)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.isPinned, isPinned) || other.isPinned == isPinned));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,roleId,title,const DeepCollectionEquality().hash(messages),createdAt,updatedAt,isPinned);

@override
String toString() {
  return 'SessionEntity(id: $id, roleId: $roleId, title: $title, messages: $messages, createdAt: $createdAt, updatedAt: $updatedAt, isPinned: $isPinned)';
}


}

/// @nodoc
abstract mixin class $SessionEntityCopyWith<$Res>  {
  factory $SessionEntityCopyWith(SessionEntity value, $Res Function(SessionEntity) _then) = _$SessionEntityCopyWithImpl;
@useResult
$Res call({
 String? id, String roleId, String title, List<MessageEntity> messages, DateTime? createdAt, DateTime? updatedAt, bool? isPinned
});




}
/// @nodoc
class _$SessionEntityCopyWithImpl<$Res>
    implements $SessionEntityCopyWith<$Res> {
  _$SessionEntityCopyWithImpl(this._self, this._then);

  final SessionEntity _self;
  final $Res Function(SessionEntity) _then;

/// Create a copy of SessionEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? roleId = null,Object? title = null,Object? messages = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? isPinned = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,roleId: null == roleId ? _self.roleId : roleId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,messages: null == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as List<MessageEntity>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isPinned: freezed == isPinned ? _self.isPinned : isPinned // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _SessionEntity implements SessionEntity {
  const _SessionEntity({this.id, required this.roleId, required this.title, final  List<MessageEntity> messages = const [], this.createdAt, this.updatedAt, this.isPinned = false}): _messages = messages;
  factory _SessionEntity.fromJson(Map<String, dynamic> json) => _$SessionEntityFromJson(json);

@override final  String? id;
@override final  String roleId;
@override final  String title;
 final  List<MessageEntity> _messages;
@override@JsonKey() List<MessageEntity> get messages {
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messages);
}

@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;
@override@JsonKey() final  bool? isPinned;

/// Create a copy of SessionEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionEntityCopyWith<_SessionEntity> get copyWith => __$SessionEntityCopyWithImpl<_SessionEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SessionEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.roleId, roleId) || other.roleId == roleId)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other._messages, _messages)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.isPinned, isPinned) || other.isPinned == isPinned));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,roleId,title,const DeepCollectionEquality().hash(_messages),createdAt,updatedAt,isPinned);

@override
String toString() {
  return 'SessionEntity(id: $id, roleId: $roleId, title: $title, messages: $messages, createdAt: $createdAt, updatedAt: $updatedAt, isPinned: $isPinned)';
}


}

/// @nodoc
abstract mixin class _$SessionEntityCopyWith<$Res> implements $SessionEntityCopyWith<$Res> {
  factory _$SessionEntityCopyWith(_SessionEntity value, $Res Function(_SessionEntity) _then) = __$SessionEntityCopyWithImpl;
@override @useResult
$Res call({
 String? id, String roleId, String title, List<MessageEntity> messages, DateTime? createdAt, DateTime? updatedAt, bool? isPinned
});




}
/// @nodoc
class __$SessionEntityCopyWithImpl<$Res>
    implements _$SessionEntityCopyWith<$Res> {
  __$SessionEntityCopyWithImpl(this._self, this._then);

  final _SessionEntity _self;
  final $Res Function(_SessionEntity) _then;

/// Create a copy of SessionEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? roleId = null,Object? title = null,Object? messages = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? isPinned = freezed,}) {
  return _then(_SessionEntity(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,roleId: null == roleId ? _self.roleId : roleId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,messages: null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<MessageEntity>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isPinned: freezed == isPinned ? _self.isPinned : isPinned // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
