// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MessageEntity {

 String? get id; String get content; DateTime get timestamp; bool get isFromUser; bool get isRead; bool get isGenerating; bool get isSystem; String? get senderName; String? get senderAvatar;
/// Create a copy of MessageEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessageEntityCopyWith<MessageEntity> get copyWith => _$MessageEntityCopyWithImpl<MessageEntity>(this as MessageEntity, _$identity);

  /// Serializes this MessageEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessageEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.content, content) || other.content == content)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.isFromUser, isFromUser) || other.isFromUser == isFromUser)&&(identical(other.isRead, isRead) || other.isRead == isRead)&&(identical(other.isGenerating, isGenerating) || other.isGenerating == isGenerating)&&(identical(other.isSystem, isSystem) || other.isSystem == isSystem)&&(identical(other.senderName, senderName) || other.senderName == senderName)&&(identical(other.senderAvatar, senderAvatar) || other.senderAvatar == senderAvatar));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,content,timestamp,isFromUser,isRead,isGenerating,isSystem,senderName,senderAvatar);

@override
String toString() {
  return 'MessageEntity(id: $id, content: $content, timestamp: $timestamp, isFromUser: $isFromUser, isRead: $isRead, isGenerating: $isGenerating, isSystem: $isSystem, senderName: $senderName, senderAvatar: $senderAvatar)';
}


}

/// @nodoc
abstract mixin class $MessageEntityCopyWith<$Res>  {
  factory $MessageEntityCopyWith(MessageEntity value, $Res Function(MessageEntity) _then) = _$MessageEntityCopyWithImpl;
@useResult
$Res call({
 String? id, String content, DateTime timestamp, bool isFromUser, bool isRead, bool isGenerating, bool isSystem, String? senderName, String? senderAvatar
});




}
/// @nodoc
class _$MessageEntityCopyWithImpl<$Res>
    implements $MessageEntityCopyWith<$Res> {
  _$MessageEntityCopyWithImpl(this._self, this._then);

  final MessageEntity _self;
  final $Res Function(MessageEntity) _then;

/// Create a copy of MessageEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? content = null,Object? timestamp = null,Object? isFromUser = null,Object? isRead = null,Object? isGenerating = null,Object? isSystem = null,Object? senderName = freezed,Object? senderAvatar = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,isFromUser: null == isFromUser ? _self.isFromUser : isFromUser // ignore: cast_nullable_to_non_nullable
as bool,isRead: null == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool,isGenerating: null == isGenerating ? _self.isGenerating : isGenerating // ignore: cast_nullable_to_non_nullable
as bool,isSystem: null == isSystem ? _self.isSystem : isSystem // ignore: cast_nullable_to_non_nullable
as bool,senderName: freezed == senderName ? _self.senderName : senderName // ignore: cast_nullable_to_non_nullable
as String?,senderAvatar: freezed == senderAvatar ? _self.senderAvatar : senderAvatar // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _MessageEntity implements MessageEntity {
  const _MessageEntity({this.id, required this.content, required this.timestamp, required this.isFromUser, this.isRead = false, this.isGenerating = false, this.isSystem = false, this.senderName, this.senderAvatar});
  factory _MessageEntity.fromJson(Map<String, dynamic> json) => _$MessageEntityFromJson(json);

@override final  String? id;
@override final  String content;
@override final  DateTime timestamp;
@override final  bool isFromUser;
@override@JsonKey() final  bool isRead;
@override@JsonKey() final  bool isGenerating;
@override@JsonKey() final  bool isSystem;
@override final  String? senderName;
@override final  String? senderAvatar;

/// Create a copy of MessageEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MessageEntityCopyWith<_MessageEntity> get copyWith => __$MessageEntityCopyWithImpl<_MessageEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MessageEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MessageEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.content, content) || other.content == content)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.isFromUser, isFromUser) || other.isFromUser == isFromUser)&&(identical(other.isRead, isRead) || other.isRead == isRead)&&(identical(other.isGenerating, isGenerating) || other.isGenerating == isGenerating)&&(identical(other.isSystem, isSystem) || other.isSystem == isSystem)&&(identical(other.senderName, senderName) || other.senderName == senderName)&&(identical(other.senderAvatar, senderAvatar) || other.senderAvatar == senderAvatar));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,content,timestamp,isFromUser,isRead,isGenerating,isSystem,senderName,senderAvatar);

@override
String toString() {
  return 'MessageEntity(id: $id, content: $content, timestamp: $timestamp, isFromUser: $isFromUser, isRead: $isRead, isGenerating: $isGenerating, isSystem: $isSystem, senderName: $senderName, senderAvatar: $senderAvatar)';
}


}

/// @nodoc
abstract mixin class _$MessageEntityCopyWith<$Res> implements $MessageEntityCopyWith<$Res> {
  factory _$MessageEntityCopyWith(_MessageEntity value, $Res Function(_MessageEntity) _then) = __$MessageEntityCopyWithImpl;
@override @useResult
$Res call({
 String? id, String content, DateTime timestamp, bool isFromUser, bool isRead, bool isGenerating, bool isSystem, String? senderName, String? senderAvatar
});




}
/// @nodoc
class __$MessageEntityCopyWithImpl<$Res>
    implements _$MessageEntityCopyWith<$Res> {
  __$MessageEntityCopyWithImpl(this._self, this._then);

  final _MessageEntity _self;
  final $Res Function(_MessageEntity) _then;

/// Create a copy of MessageEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? content = null,Object? timestamp = null,Object? isFromUser = null,Object? isRead = null,Object? isGenerating = null,Object? isSystem = null,Object? senderName = freezed,Object? senderAvatar = freezed,}) {
  return _then(_MessageEntity(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,isFromUser: null == isFromUser ? _self.isFromUser : isFromUser // ignore: cast_nullable_to_non_nullable
as bool,isRead: null == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool,isGenerating: null == isGenerating ? _self.isGenerating : isGenerating // ignore: cast_nullable_to_non_nullable
as bool,isSystem: null == isSystem ? _self.isSystem : isSystem // ignore: cast_nullable_to_non_nullable
as bool,senderName: freezed == senderName ? _self.senderName : senderName // ignore: cast_nullable_to_non_nullable
as String?,senderAvatar: freezed == senderAvatar ? _self.senderAvatar : senderAvatar // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
