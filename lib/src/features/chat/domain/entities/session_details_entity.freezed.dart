// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_details_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SessionDetailsEntity {

 String get id; String get title; String get type; DateTime get createdAt; bool get isPinned; DateTime? get lastMessageAt; List<String> get roleIds; ChatMessageEntity? get lastMessage;
/// Create a copy of SessionDetailsEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionDetailsEntityCopyWith<SessionDetailsEntity> get copyWith => _$SessionDetailsEntityCopyWithImpl<SessionDetailsEntity>(this as SessionDetailsEntity, _$identity);

  /// Serializes this SessionDetailsEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionDetailsEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.type, type) || other.type == type)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isPinned, isPinned) || other.isPinned == isPinned)&&(identical(other.lastMessageAt, lastMessageAt) || other.lastMessageAt == lastMessageAt)&&const DeepCollectionEquality().equals(other.roleIds, roleIds)&&(identical(other.lastMessage, lastMessage) || other.lastMessage == lastMessage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,type,createdAt,isPinned,lastMessageAt,const DeepCollectionEquality().hash(roleIds),lastMessage);

@override
String toString() {
  return 'SessionDetailsEntity(id: $id, title: $title, type: $type, createdAt: $createdAt, isPinned: $isPinned, lastMessageAt: $lastMessageAt, roleIds: $roleIds, lastMessage: $lastMessage)';
}


}

/// @nodoc
abstract mixin class $SessionDetailsEntityCopyWith<$Res>  {
  factory $SessionDetailsEntityCopyWith(SessionDetailsEntity value, $Res Function(SessionDetailsEntity) _then) = _$SessionDetailsEntityCopyWithImpl;
@useResult
$Res call({
 String id, String title, String type, DateTime createdAt, bool isPinned, DateTime? lastMessageAt, List<String> roleIds, ChatMessageEntity? lastMessage
});


$ChatMessageEntityCopyWith<$Res>? get lastMessage;

}
/// @nodoc
class _$SessionDetailsEntityCopyWithImpl<$Res>
    implements $SessionDetailsEntityCopyWith<$Res> {
  _$SessionDetailsEntityCopyWithImpl(this._self, this._then);

  final SessionDetailsEntity _self;
  final $Res Function(SessionDetailsEntity) _then;

/// Create a copy of SessionDetailsEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? type = null,Object? createdAt = null,Object? isPinned = null,Object? lastMessageAt = freezed,Object? roleIds = null,Object? lastMessage = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,isPinned: null == isPinned ? _self.isPinned : isPinned // ignore: cast_nullable_to_non_nullable
as bool,lastMessageAt: freezed == lastMessageAt ? _self.lastMessageAt : lastMessageAt // ignore: cast_nullable_to_non_nullable
as DateTime?,roleIds: null == roleIds ? _self.roleIds : roleIds // ignore: cast_nullable_to_non_nullable
as List<String>,lastMessage: freezed == lastMessage ? _self.lastMessage : lastMessage // ignore: cast_nullable_to_non_nullable
as ChatMessageEntity?,
  ));
}
/// Create a copy of SessionDetailsEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChatMessageEntityCopyWith<$Res>? get lastMessage {
    if (_self.lastMessage == null) {
    return null;
  }

  return $ChatMessageEntityCopyWith<$Res>(_self.lastMessage!, (value) {
    return _then(_self.copyWith(lastMessage: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _SessionDetailsEntity implements SessionDetailsEntity {
  const _SessionDetailsEntity({required this.id, required this.title, required this.type, required this.createdAt, required this.isPinned, this.lastMessageAt, required final  List<String> roleIds, this.lastMessage}): _roleIds = roleIds;
  factory _SessionDetailsEntity.fromJson(Map<String, dynamic> json) => _$SessionDetailsEntityFromJson(json);

@override final  String id;
@override final  String title;
@override final  String type;
@override final  DateTime createdAt;
@override final  bool isPinned;
@override final  DateTime? lastMessageAt;
 final  List<String> _roleIds;
@override List<String> get roleIds {
  if (_roleIds is EqualUnmodifiableListView) return _roleIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_roleIds);
}

@override final  ChatMessageEntity? lastMessage;

/// Create a copy of SessionDetailsEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionDetailsEntityCopyWith<_SessionDetailsEntity> get copyWith => __$SessionDetailsEntityCopyWithImpl<_SessionDetailsEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SessionDetailsEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionDetailsEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.type, type) || other.type == type)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isPinned, isPinned) || other.isPinned == isPinned)&&(identical(other.lastMessageAt, lastMessageAt) || other.lastMessageAt == lastMessageAt)&&const DeepCollectionEquality().equals(other._roleIds, _roleIds)&&(identical(other.lastMessage, lastMessage) || other.lastMessage == lastMessage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,type,createdAt,isPinned,lastMessageAt,const DeepCollectionEquality().hash(_roleIds),lastMessage);

@override
String toString() {
  return 'SessionDetailsEntity(id: $id, title: $title, type: $type, createdAt: $createdAt, isPinned: $isPinned, lastMessageAt: $lastMessageAt, roleIds: $roleIds, lastMessage: $lastMessage)';
}


}

/// @nodoc
abstract mixin class _$SessionDetailsEntityCopyWith<$Res> implements $SessionDetailsEntityCopyWith<$Res> {
  factory _$SessionDetailsEntityCopyWith(_SessionDetailsEntity value, $Res Function(_SessionDetailsEntity) _then) = __$SessionDetailsEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String type, DateTime createdAt, bool isPinned, DateTime? lastMessageAt, List<String> roleIds, ChatMessageEntity? lastMessage
});


@override $ChatMessageEntityCopyWith<$Res>? get lastMessage;

}
/// @nodoc
class __$SessionDetailsEntityCopyWithImpl<$Res>
    implements _$SessionDetailsEntityCopyWith<$Res> {
  __$SessionDetailsEntityCopyWithImpl(this._self, this._then);

  final _SessionDetailsEntity _self;
  final $Res Function(_SessionDetailsEntity) _then;

/// Create a copy of SessionDetailsEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? type = null,Object? createdAt = null,Object? isPinned = null,Object? lastMessageAt = freezed,Object? roleIds = null,Object? lastMessage = freezed,}) {
  return _then(_SessionDetailsEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,isPinned: null == isPinned ? _self.isPinned : isPinned // ignore: cast_nullable_to_non_nullable
as bool,lastMessageAt: freezed == lastMessageAt ? _self.lastMessageAt : lastMessageAt // ignore: cast_nullable_to_non_nullable
as DateTime?,roleIds: null == roleIds ? _self._roleIds : roleIds // ignore: cast_nullable_to_non_nullable
as List<String>,lastMessage: freezed == lastMessage ? _self.lastMessage : lastMessage // ignore: cast_nullable_to_non_nullable
as ChatMessageEntity?,
  ));
}

/// Create a copy of SessionDetailsEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChatMessageEntityCopyWith<$Res>? get lastMessage {
    if (_self.lastMessage == null) {
    return null;
  }

  return $ChatMessageEntityCopyWith<$Res>(_self.lastMessage!, (value) {
    return _then(_self.copyWith(lastMessage: value));
  });
}
}

// dart format on
