// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_message_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatMessageEntity {

/// 消息ID
 int get id;/// 消息内容
 String get content;/// 消息创建时间
 DateTime get createdAt;/// 是否为用户自身消息
 bool get isFromUser;/// 是否为系统消息
 bool get isSystem;/// 发送者 ID
 String get senderId;/// 发送者名称
 String get senderName;/// 发送者头像
 String get senderAvatar;/// 是否已读
 bool get isRead;/// 是否正在生成回复
 bool get isGenerating;
/// Create a copy of ChatMessageEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatMessageEntityCopyWith<ChatMessageEntity> get copyWith => _$ChatMessageEntityCopyWithImpl<ChatMessageEntity>(this as ChatMessageEntity, _$identity);

  /// Serializes this ChatMessageEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatMessageEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.content, content) || other.content == content)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isFromUser, isFromUser) || other.isFromUser == isFromUser)&&(identical(other.isSystem, isSystem) || other.isSystem == isSystem)&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.senderName, senderName) || other.senderName == senderName)&&(identical(other.senderAvatar, senderAvatar) || other.senderAvatar == senderAvatar)&&(identical(other.isRead, isRead) || other.isRead == isRead)&&(identical(other.isGenerating, isGenerating) || other.isGenerating == isGenerating));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,content,createdAt,isFromUser,isSystem,senderId,senderName,senderAvatar,isRead,isGenerating);

@override
String toString() {
  return 'ChatMessageEntity(id: $id, content: $content, createdAt: $createdAt, isFromUser: $isFromUser, isSystem: $isSystem, senderId: $senderId, senderName: $senderName, senderAvatar: $senderAvatar, isRead: $isRead, isGenerating: $isGenerating)';
}


}

/// @nodoc
abstract mixin class $ChatMessageEntityCopyWith<$Res>  {
  factory $ChatMessageEntityCopyWith(ChatMessageEntity value, $Res Function(ChatMessageEntity) _then) = _$ChatMessageEntityCopyWithImpl;
@useResult
$Res call({
 int id, String content, DateTime createdAt, bool isFromUser, bool isSystem, String senderId, String senderName, String senderAvatar, bool isRead, bool isGenerating
});




}
/// @nodoc
class _$ChatMessageEntityCopyWithImpl<$Res>
    implements $ChatMessageEntityCopyWith<$Res> {
  _$ChatMessageEntityCopyWithImpl(this._self, this._then);

  final ChatMessageEntity _self;
  final $Res Function(ChatMessageEntity) _then;

/// Create a copy of ChatMessageEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? content = null,Object? createdAt = null,Object? isFromUser = null,Object? isSystem = null,Object? senderId = null,Object? senderName = null,Object? senderAvatar = null,Object? isRead = null,Object? isGenerating = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,isFromUser: null == isFromUser ? _self.isFromUser : isFromUser // ignore: cast_nullable_to_non_nullable
as bool,isSystem: null == isSystem ? _self.isSystem : isSystem // ignore: cast_nullable_to_non_nullable
as bool,senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as String,senderName: null == senderName ? _self.senderName : senderName // ignore: cast_nullable_to_non_nullable
as String,senderAvatar: null == senderAvatar ? _self.senderAvatar : senderAvatar // ignore: cast_nullable_to_non_nullable
as String,isRead: null == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool,isGenerating: null == isGenerating ? _self.isGenerating : isGenerating // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _ChatMessageEntity implements ChatMessageEntity {
  const _ChatMessageEntity({required this.id, required this.content, required this.createdAt, required this.isFromUser, required this.isSystem, required this.senderId, required this.senderName, required this.senderAvatar, this.isRead = false, this.isGenerating = false});
  factory _ChatMessageEntity.fromJson(Map<String, dynamic> json) => _$ChatMessageEntityFromJson(json);

/// 消息ID
@override final  int id;
/// 消息内容
@override final  String content;
/// 消息创建时间
@override final  DateTime createdAt;
/// 是否为用户自身消息
@override final  bool isFromUser;
/// 是否为系统消息
@override final  bool isSystem;
/// 发送者 ID
@override final  String senderId;
/// 发送者名称
@override final  String senderName;
/// 发送者头像
@override final  String senderAvatar;
/// 是否已读
@override@JsonKey() final  bool isRead;
/// 是否正在生成回复
@override@JsonKey() final  bool isGenerating;

/// Create a copy of ChatMessageEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatMessageEntityCopyWith<_ChatMessageEntity> get copyWith => __$ChatMessageEntityCopyWithImpl<_ChatMessageEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatMessageEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatMessageEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.content, content) || other.content == content)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isFromUser, isFromUser) || other.isFromUser == isFromUser)&&(identical(other.isSystem, isSystem) || other.isSystem == isSystem)&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.senderName, senderName) || other.senderName == senderName)&&(identical(other.senderAvatar, senderAvatar) || other.senderAvatar == senderAvatar)&&(identical(other.isRead, isRead) || other.isRead == isRead)&&(identical(other.isGenerating, isGenerating) || other.isGenerating == isGenerating));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,content,createdAt,isFromUser,isSystem,senderId,senderName,senderAvatar,isRead,isGenerating);

@override
String toString() {
  return 'ChatMessageEntity(id: $id, content: $content, createdAt: $createdAt, isFromUser: $isFromUser, isSystem: $isSystem, senderId: $senderId, senderName: $senderName, senderAvatar: $senderAvatar, isRead: $isRead, isGenerating: $isGenerating)';
}


}

/// @nodoc
abstract mixin class _$ChatMessageEntityCopyWith<$Res> implements $ChatMessageEntityCopyWith<$Res> {
  factory _$ChatMessageEntityCopyWith(_ChatMessageEntity value, $Res Function(_ChatMessageEntity) _then) = __$ChatMessageEntityCopyWithImpl;
@override @useResult
$Res call({
 int id, String content, DateTime createdAt, bool isFromUser, bool isSystem, String senderId, String senderName, String senderAvatar, bool isRead, bool isGenerating
});




}
/// @nodoc
class __$ChatMessageEntityCopyWithImpl<$Res>
    implements _$ChatMessageEntityCopyWith<$Res> {
  __$ChatMessageEntityCopyWithImpl(this._self, this._then);

  final _ChatMessageEntity _self;
  final $Res Function(_ChatMessageEntity) _then;

/// Create a copy of ChatMessageEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? content = null,Object? createdAt = null,Object? isFromUser = null,Object? isSystem = null,Object? senderId = null,Object? senderName = null,Object? senderAvatar = null,Object? isRead = null,Object? isGenerating = null,}) {
  return _then(_ChatMessageEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,isFromUser: null == isFromUser ? _self.isFromUser : isFromUser // ignore: cast_nullable_to_non_nullable
as bool,isSystem: null == isSystem ? _self.isSystem : isSystem // ignore: cast_nullable_to_non_nullable
as bool,senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as String,senderName: null == senderName ? _self.senderName : senderName // ignore: cast_nullable_to_non_nullable
as String,senderAvatar: null == senderAvatar ? _self.senderAvatar : senderAvatar // ignore: cast_nullable_to_non_nullable
as String,isRead: null == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool,isGenerating: null == isGenerating ? _self.isGenerating : isGenerating // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
