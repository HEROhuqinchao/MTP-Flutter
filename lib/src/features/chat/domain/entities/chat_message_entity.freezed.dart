// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
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

/// 消息的唯一标识符。
 int get id;/// 消息的文本内容。
 String get content;/// 消息的创建或发送时间。
 DateTime get createdAt;/// 指示此消息是否由当前用户发送。
 bool get isFromUser;/// 消息发送者的唯一标识符。
 String get senderId;/// 消息发送者的显示名称。
 String get senderName;/// 消息发送者的头像URL或本地路径。
 String get senderAvatar;/// 指示消息是否已被接收方阅读。
///
/// 默认为 `false`。
 bool get isRead;/// 指示是否正在为此消息（通常是用户消息）生成AI回复。
///
/// 默认为 `false`。
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatMessageEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.content, content) || other.content == content)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isFromUser, isFromUser) || other.isFromUser == isFromUser)&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.senderName, senderName) || other.senderName == senderName)&&(identical(other.senderAvatar, senderAvatar) || other.senderAvatar == senderAvatar)&&(identical(other.isRead, isRead) || other.isRead == isRead)&&(identical(other.isGenerating, isGenerating) || other.isGenerating == isGenerating));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,content,createdAt,isFromUser,senderId,senderName,senderAvatar,isRead,isGenerating);

@override
String toString() {
  return 'ChatMessageEntity(id: $id, content: $content, createdAt: $createdAt, isFromUser: $isFromUser, senderId: $senderId, senderName: $senderName, senderAvatar: $senderAvatar, isRead: $isRead, isGenerating: $isGenerating)';
}


}

/// @nodoc
abstract mixin class $ChatMessageEntityCopyWith<$Res>  {
  factory $ChatMessageEntityCopyWith(ChatMessageEntity value, $Res Function(ChatMessageEntity) _then) = _$ChatMessageEntityCopyWithImpl;
@useResult
$Res call({
 int id, String content, DateTime createdAt, bool isFromUser, String senderId, String senderName, String senderAvatar, bool isRead, bool isGenerating
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? content = null,Object? createdAt = null,Object? isFromUser = null,Object? senderId = null,Object? senderName = null,Object? senderAvatar = null,Object? isRead = null,Object? isGenerating = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,isFromUser: null == isFromUser ? _self.isFromUser : isFromUser // ignore: cast_nullable_to_non_nullable
as bool,senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as String,senderName: null == senderName ? _self.senderName : senderName // ignore: cast_nullable_to_non_nullable
as String,senderAvatar: null == senderAvatar ? _self.senderAvatar : senderAvatar // ignore: cast_nullable_to_non_nullable
as String,isRead: null == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool,isGenerating: null == isGenerating ? _self.isGenerating : isGenerating // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatMessageEntity].
extension ChatMessageEntityPatterns on ChatMessageEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatMessageEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatMessageEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatMessageEntity value)  $default,){
final _that = this;
switch (_that) {
case _ChatMessageEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatMessageEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ChatMessageEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String content,  DateTime createdAt,  bool isFromUser,  String senderId,  String senderName,  String senderAvatar,  bool isRead,  bool isGenerating)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatMessageEntity() when $default != null:
return $default(_that.id,_that.content,_that.createdAt,_that.isFromUser,_that.senderId,_that.senderName,_that.senderAvatar,_that.isRead,_that.isGenerating);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String content,  DateTime createdAt,  bool isFromUser,  String senderId,  String senderName,  String senderAvatar,  bool isRead,  bool isGenerating)  $default,) {final _that = this;
switch (_that) {
case _ChatMessageEntity():
return $default(_that.id,_that.content,_that.createdAt,_that.isFromUser,_that.senderId,_that.senderName,_that.senderAvatar,_that.isRead,_that.isGenerating);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String content,  DateTime createdAt,  bool isFromUser,  String senderId,  String senderName,  String senderAvatar,  bool isRead,  bool isGenerating)?  $default,) {final _that = this;
switch (_that) {
case _ChatMessageEntity() when $default != null:
return $default(_that.id,_that.content,_that.createdAt,_that.isFromUser,_that.senderId,_that.senderName,_that.senderAvatar,_that.isRead,_that.isGenerating);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatMessageEntity implements ChatMessageEntity {
  const _ChatMessageEntity({required this.id, required this.content, required this.createdAt, required this.isFromUser, required this.senderId, required this.senderName, required this.senderAvatar, this.isRead = false, this.isGenerating = false});
  factory _ChatMessageEntity.fromJson(Map<String, dynamic> json) => _$ChatMessageEntityFromJson(json);

/// 消息的唯一标识符。
@override final  int id;
/// 消息的文本内容。
@override final  String content;
/// 消息的创建或发送时间。
@override final  DateTime createdAt;
/// 指示此消息是否由当前用户发送。
@override final  bool isFromUser;
/// 消息发送者的唯一标识符。
@override final  String senderId;
/// 消息发送者的显示名称。
@override final  String senderName;
/// 消息发送者的头像URL或本地路径。
@override final  String senderAvatar;
/// 指示消息是否已被接收方阅读。
///
/// 默认为 `false`。
@override@JsonKey() final  bool isRead;
/// 指示是否正在为此消息（通常是用户消息）生成AI回复。
///
/// 默认为 `false`。
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatMessageEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.content, content) || other.content == content)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isFromUser, isFromUser) || other.isFromUser == isFromUser)&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.senderName, senderName) || other.senderName == senderName)&&(identical(other.senderAvatar, senderAvatar) || other.senderAvatar == senderAvatar)&&(identical(other.isRead, isRead) || other.isRead == isRead)&&(identical(other.isGenerating, isGenerating) || other.isGenerating == isGenerating));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,content,createdAt,isFromUser,senderId,senderName,senderAvatar,isRead,isGenerating);

@override
String toString() {
  return 'ChatMessageEntity(id: $id, content: $content, createdAt: $createdAt, isFromUser: $isFromUser, senderId: $senderId, senderName: $senderName, senderAvatar: $senderAvatar, isRead: $isRead, isGenerating: $isGenerating)';
}


}

/// @nodoc
abstract mixin class _$ChatMessageEntityCopyWith<$Res> implements $ChatMessageEntityCopyWith<$Res> {
  factory _$ChatMessageEntityCopyWith(_ChatMessageEntity value, $Res Function(_ChatMessageEntity) _then) = __$ChatMessageEntityCopyWithImpl;
@override @useResult
$Res call({
 int id, String content, DateTime createdAt, bool isFromUser, String senderId, String senderName, String senderAvatar, bool isRead, bool isGenerating
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? content = null,Object? createdAt = null,Object? isFromUser = null,Object? senderId = null,Object? senderName = null,Object? senderAvatar = null,Object? isRead = null,Object? isGenerating = null,}) {
  return _then(_ChatMessageEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,isFromUser: null == isFromUser ? _self.isFromUser : isFromUser // ignore: cast_nullable_to_non_nullable
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
