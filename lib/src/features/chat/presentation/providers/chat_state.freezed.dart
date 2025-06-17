// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChatState {

/// 所有可用的聊天会话列表。
/// 默认为空列表。
 List<SessionListItemEntity> get sessions;/// 当前在 [sessions] 列表中选中的会话索引。
/// 默认为 0。
 int get selectedSessionIndex;/// 当前活动或正在查看的聊天会话。
/// 如果当前没有活动的会话，则可以为 `null`。
 ActiveSessionEntity? get currentSession;/// 指示聊天数据（例如，会话列表）当前是否正在加载。
/// 默认为 `false`。
 bool get isLoading;/// 指示当前是否正在为消息生成AI回复。
/// 默认为 `false`。
 bool get isGenerating;/// 如果发生错误，则为错误信息字符串，否则为 `null`。
 String? get errorMessage;/// 用户输入的用于筛选会话的当前搜索查询文本。
/// 默认为空字符串。
 String get searchQuery;
/// Create a copy of ChatState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatStateCopyWith<ChatState> get copyWith => _$ChatStateCopyWithImpl<ChatState>(this as ChatState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatState&&const DeepCollectionEquality().equals(other.sessions, sessions)&&(identical(other.selectedSessionIndex, selectedSessionIndex) || other.selectedSessionIndex == selectedSessionIndex)&&(identical(other.currentSession, currentSession) || other.currentSession == currentSession)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isGenerating, isGenerating) || other.isGenerating == isGenerating)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(sessions),selectedSessionIndex,currentSession,isLoading,isGenerating,errorMessage,searchQuery);

@override
String toString() {
  return 'ChatState(sessions: $sessions, selectedSessionIndex: $selectedSessionIndex, currentSession: $currentSession, isLoading: $isLoading, isGenerating: $isGenerating, errorMessage: $errorMessage, searchQuery: $searchQuery)';
}


}

/// @nodoc
abstract mixin class $ChatStateCopyWith<$Res>  {
  factory $ChatStateCopyWith(ChatState value, $Res Function(ChatState) _then) = _$ChatStateCopyWithImpl;
@useResult
$Res call({
 List<SessionListItemEntity> sessions, int selectedSessionIndex, ActiveSessionEntity? currentSession, bool isLoading, bool isGenerating, String? errorMessage, String searchQuery
});


$ActiveSessionEntityCopyWith<$Res>? get currentSession;

}
/// @nodoc
class _$ChatStateCopyWithImpl<$Res>
    implements $ChatStateCopyWith<$Res> {
  _$ChatStateCopyWithImpl(this._self, this._then);

  final ChatState _self;
  final $Res Function(ChatState) _then;

/// Create a copy of ChatState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessions = null,Object? selectedSessionIndex = null,Object? currentSession = freezed,Object? isLoading = null,Object? isGenerating = null,Object? errorMessage = freezed,Object? searchQuery = null,}) {
  return _then(_self.copyWith(
sessions: null == sessions ? _self.sessions : sessions // ignore: cast_nullable_to_non_nullable
as List<SessionListItemEntity>,selectedSessionIndex: null == selectedSessionIndex ? _self.selectedSessionIndex : selectedSessionIndex // ignore: cast_nullable_to_non_nullable
as int,currentSession: freezed == currentSession ? _self.currentSession : currentSession // ignore: cast_nullable_to_non_nullable
as ActiveSessionEntity?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isGenerating: null == isGenerating ? _self.isGenerating : isGenerating // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of ChatState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActiveSessionEntityCopyWith<$Res>? get currentSession {
    if (_self.currentSession == null) {
    return null;
  }

  return $ActiveSessionEntityCopyWith<$Res>(_self.currentSession!, (value) {
    return _then(_self.copyWith(currentSession: value));
  });
}
}


/// @nodoc


class _ChatState implements ChatState {
  const _ChatState({final  List<SessionListItemEntity> sessions = const [], this.selectedSessionIndex = -1, this.currentSession, this.isLoading = false, this.isGenerating = false, this.errorMessage, this.searchQuery = ''}): _sessions = sessions;
  

/// 所有可用的聊天会话列表。
/// 默认为空列表。
 final  List<SessionListItemEntity> _sessions;
/// 所有可用的聊天会话列表。
/// 默认为空列表。
@override@JsonKey() List<SessionListItemEntity> get sessions {
  if (_sessions is EqualUnmodifiableListView) return _sessions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sessions);
}

/// 当前在 [sessions] 列表中选中的会话索引。
/// 默认为 0。
@override@JsonKey() final  int selectedSessionIndex;
/// 当前活动或正在查看的聊天会话。
/// 如果当前没有活动的会话，则可以为 `null`。
@override final  ActiveSessionEntity? currentSession;
/// 指示聊天数据（例如，会话列表）当前是否正在加载。
/// 默认为 `false`。
@override@JsonKey() final  bool isLoading;
/// 指示当前是否正在为消息生成AI回复。
/// 默认为 `false`。
@override@JsonKey() final  bool isGenerating;
/// 如果发生错误，则为错误信息字符串，否则为 `null`。
@override final  String? errorMessage;
/// 用户输入的用于筛选会话的当前搜索查询文本。
/// 默认为空字符串。
@override@JsonKey() final  String searchQuery;

/// Create a copy of ChatState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatStateCopyWith<_ChatState> get copyWith => __$ChatStateCopyWithImpl<_ChatState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatState&&const DeepCollectionEquality().equals(other._sessions, _sessions)&&(identical(other.selectedSessionIndex, selectedSessionIndex) || other.selectedSessionIndex == selectedSessionIndex)&&(identical(other.currentSession, currentSession) || other.currentSession == currentSession)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isGenerating, isGenerating) || other.isGenerating == isGenerating)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_sessions),selectedSessionIndex,currentSession,isLoading,isGenerating,errorMessage,searchQuery);

@override
String toString() {
  return 'ChatState(sessions: $sessions, selectedSessionIndex: $selectedSessionIndex, currentSession: $currentSession, isLoading: $isLoading, isGenerating: $isGenerating, errorMessage: $errorMessage, searchQuery: $searchQuery)';
}


}

/// @nodoc
abstract mixin class _$ChatStateCopyWith<$Res> implements $ChatStateCopyWith<$Res> {
  factory _$ChatStateCopyWith(_ChatState value, $Res Function(_ChatState) _then) = __$ChatStateCopyWithImpl;
@override @useResult
$Res call({
 List<SessionListItemEntity> sessions, int selectedSessionIndex, ActiveSessionEntity? currentSession, bool isLoading, bool isGenerating, String? errorMessage, String searchQuery
});


@override $ActiveSessionEntityCopyWith<$Res>? get currentSession;

}
/// @nodoc
class __$ChatStateCopyWithImpl<$Res>
    implements _$ChatStateCopyWith<$Res> {
  __$ChatStateCopyWithImpl(this._self, this._then);

  final _ChatState _self;
  final $Res Function(_ChatState) _then;

/// Create a copy of ChatState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessions = null,Object? selectedSessionIndex = null,Object? currentSession = freezed,Object? isLoading = null,Object? isGenerating = null,Object? errorMessage = freezed,Object? searchQuery = null,}) {
  return _then(_ChatState(
sessions: null == sessions ? _self._sessions : sessions // ignore: cast_nullable_to_non_nullable
as List<SessionListItemEntity>,selectedSessionIndex: null == selectedSessionIndex ? _self.selectedSessionIndex : selectedSessionIndex // ignore: cast_nullable_to_non_nullable
as int,currentSession: freezed == currentSession ? _self.currentSession : currentSession // ignore: cast_nullable_to_non_nullable
as ActiveSessionEntity?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isGenerating: null == isGenerating ? _self.isGenerating : isGenerating // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of ChatState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActiveSessionEntityCopyWith<$Res>? get currentSession {
    if (_self.currentSession == null) {
    return null;
  }

  return $ActiveSessionEntityCopyWith<$Res>(_self.currentSession!, (value) {
    return _then(_self.copyWith(currentSession: value));
  });
}
}

// dart format on
