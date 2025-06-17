// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_list_item_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SessionListItemEntity {

/// 会话的唯一标识符。
 String get id;/// 会话的标题或名称。
 String get title;/// 会话类型。
///
/// 0 代表私聊，1 代表群聊。
 int get type;/// 会话的创建时间。
 DateTime get createdAt;/// 指示会话是否被置顶。
 bool get isPinned;/// 会话的头像URL或本地路径。
///
/// 如果没有头像，则为 `null`。
 String? get avatar;/// 会话中未读消息的数量。
///
/// 如果没有未读消息，则为 `0`。
 int get unreadCount;/// 会话中最后一条消息的发送时间。
///
/// 如果会话中没有消息，则为 `null`。
 DateTime? get lastMessageAt;/// 会话中的最后一条消息实体。
 String get lastMessage;
/// Create a copy of SessionListItemEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionListItemEntityCopyWith<SessionListItemEntity> get copyWith => _$SessionListItemEntityCopyWithImpl<SessionListItemEntity>(this as SessionListItemEntity, _$identity);

  /// Serializes this SessionListItemEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionListItemEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.type, type) || other.type == type)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isPinned, isPinned) || other.isPinned == isPinned)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount)&&(identical(other.lastMessageAt, lastMessageAt) || other.lastMessageAt == lastMessageAt)&&(identical(other.lastMessage, lastMessage) || other.lastMessage == lastMessage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,type,createdAt,isPinned,avatar,unreadCount,lastMessageAt,lastMessage);

@override
String toString() {
  return 'SessionListItemEntity(id: $id, title: $title, type: $type, createdAt: $createdAt, isPinned: $isPinned, avatar: $avatar, unreadCount: $unreadCount, lastMessageAt: $lastMessageAt, lastMessage: $lastMessage)';
}


}

/// @nodoc
abstract mixin class $SessionListItemEntityCopyWith<$Res>  {
  factory $SessionListItemEntityCopyWith(SessionListItemEntity value, $Res Function(SessionListItemEntity) _then) = _$SessionListItemEntityCopyWithImpl;
@useResult
$Res call({
 String id, String title, int type, DateTime createdAt, bool isPinned, String? avatar, int unreadCount, DateTime? lastMessageAt, String lastMessage
});




}
/// @nodoc
class _$SessionListItemEntityCopyWithImpl<$Res>
    implements $SessionListItemEntityCopyWith<$Res> {
  _$SessionListItemEntityCopyWithImpl(this._self, this._then);

  final SessionListItemEntity _self;
  final $Res Function(SessionListItemEntity) _then;

/// Create a copy of SessionListItemEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? type = null,Object? createdAt = null,Object? isPinned = null,Object? avatar = freezed,Object? unreadCount = null,Object? lastMessageAt = freezed,Object? lastMessage = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,isPinned: null == isPinned ? _self.isPinned : isPinned // ignore: cast_nullable_to_non_nullable
as bool,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String?,unreadCount: null == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int,lastMessageAt: freezed == lastMessageAt ? _self.lastMessageAt : lastMessageAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastMessage: null == lastMessage ? _self.lastMessage : lastMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _SessionListItemEntity implements SessionListItemEntity {
  const _SessionListItemEntity({required this.id, required this.title, required this.type, required this.createdAt, required this.isPinned, this.avatar, required this.unreadCount, this.lastMessageAt, required this.lastMessage});
  factory _SessionListItemEntity.fromJson(Map<String, dynamic> json) => _$SessionListItemEntityFromJson(json);

/// 会话的唯一标识符。
@override final  String id;
/// 会话的标题或名称。
@override final  String title;
/// 会话类型。
///
/// 0 代表私聊，1 代表群聊。
@override final  int type;
/// 会话的创建时间。
@override final  DateTime createdAt;
/// 指示会话是否被置顶。
@override final  bool isPinned;
/// 会话的头像URL或本地路径。
///
/// 如果没有头像，则为 `null`。
@override final  String? avatar;
/// 会话中未读消息的数量。
///
/// 如果没有未读消息，则为 `0`。
@override final  int unreadCount;
/// 会话中最后一条消息的发送时间。
///
/// 如果会话中没有消息，则为 `null`。
@override final  DateTime? lastMessageAt;
/// 会话中的最后一条消息实体。
@override final  String lastMessage;

/// Create a copy of SessionListItemEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionListItemEntityCopyWith<_SessionListItemEntity> get copyWith => __$SessionListItemEntityCopyWithImpl<_SessionListItemEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SessionListItemEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionListItemEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.type, type) || other.type == type)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isPinned, isPinned) || other.isPinned == isPinned)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount)&&(identical(other.lastMessageAt, lastMessageAt) || other.lastMessageAt == lastMessageAt)&&(identical(other.lastMessage, lastMessage) || other.lastMessage == lastMessage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,type,createdAt,isPinned,avatar,unreadCount,lastMessageAt,lastMessage);

@override
String toString() {
  return 'SessionListItemEntity(id: $id, title: $title, type: $type, createdAt: $createdAt, isPinned: $isPinned, avatar: $avatar, unreadCount: $unreadCount, lastMessageAt: $lastMessageAt, lastMessage: $lastMessage)';
}


}

/// @nodoc
abstract mixin class _$SessionListItemEntityCopyWith<$Res> implements $SessionListItemEntityCopyWith<$Res> {
  factory _$SessionListItemEntityCopyWith(_SessionListItemEntity value, $Res Function(_SessionListItemEntity) _then) = __$SessionListItemEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, int type, DateTime createdAt, bool isPinned, String? avatar, int unreadCount, DateTime? lastMessageAt, String lastMessage
});




}
/// @nodoc
class __$SessionListItemEntityCopyWithImpl<$Res>
    implements _$SessionListItemEntityCopyWith<$Res> {
  __$SessionListItemEntityCopyWithImpl(this._self, this._then);

  final _SessionListItemEntity _self;
  final $Res Function(_SessionListItemEntity) _then;

/// Create a copy of SessionListItemEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? type = null,Object? createdAt = null,Object? isPinned = null,Object? avatar = freezed,Object? unreadCount = null,Object? lastMessageAt = freezed,Object? lastMessage = null,}) {
  return _then(_SessionListItemEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,isPinned: null == isPinned ? _self.isPinned : isPinned // ignore: cast_nullable_to_non_nullable
as bool,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String?,unreadCount: null == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int,lastMessageAt: freezed == lastMessageAt ? _self.lastMessageAt : lastMessageAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastMessage: null == lastMessage ? _self.lastMessage : lastMessage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
