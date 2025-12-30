// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'role_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RoleState {

/// 角色列表
 List<RoleEntity> get roles;/// 选中的角色
 RoleEntity? get selectedRole;/// 正在加载
 bool get isLoading;/// 错误消息
 String? get errorMessage;
/// Create a copy of RoleState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoleStateCopyWith<RoleState> get copyWith => _$RoleStateCopyWithImpl<RoleState>(this as RoleState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoleState&&const DeepCollectionEquality().equals(other.roles, roles)&&(identical(other.selectedRole, selectedRole) || other.selectedRole == selectedRole)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(roles),selectedRole,isLoading,errorMessage);

@override
String toString() {
  return 'RoleState(roles: $roles, selectedRole: $selectedRole, isLoading: $isLoading, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $RoleStateCopyWith<$Res>  {
  factory $RoleStateCopyWith(RoleState value, $Res Function(RoleState) _then) = _$RoleStateCopyWithImpl;
@useResult
$Res call({
 List<RoleEntity> roles, RoleEntity? selectedRole, bool isLoading, String? errorMessage
});


$RoleEntityCopyWith<$Res>? get selectedRole;

}
/// @nodoc
class _$RoleStateCopyWithImpl<$Res>
    implements $RoleStateCopyWith<$Res> {
  _$RoleStateCopyWithImpl(this._self, this._then);

  final RoleState _self;
  final $Res Function(RoleState) _then;

/// Create a copy of RoleState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? roles = null,Object? selectedRole = freezed,Object? isLoading = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
roles: null == roles ? _self.roles : roles // ignore: cast_nullable_to_non_nullable
as List<RoleEntity>,selectedRole: freezed == selectedRole ? _self.selectedRole : selectedRole // ignore: cast_nullable_to_non_nullable
as RoleEntity?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of RoleState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RoleEntityCopyWith<$Res>? get selectedRole {
    if (_self.selectedRole == null) {
    return null;
  }

  return $RoleEntityCopyWith<$Res>(_self.selectedRole!, (value) {
    return _then(_self.copyWith(selectedRole: value));
  });
}
}


/// Adds pattern-matching-related methods to [RoleState].
extension RoleStatePatterns on RoleState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RoleState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RoleState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RoleState value)  $default,){
final _that = this;
switch (_that) {
case _RoleState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RoleState value)?  $default,){
final _that = this;
switch (_that) {
case _RoleState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<RoleEntity> roles,  RoleEntity? selectedRole,  bool isLoading,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoleState() when $default != null:
return $default(_that.roles,_that.selectedRole,_that.isLoading,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<RoleEntity> roles,  RoleEntity? selectedRole,  bool isLoading,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _RoleState():
return $default(_that.roles,_that.selectedRole,_that.isLoading,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<RoleEntity> roles,  RoleEntity? selectedRole,  bool isLoading,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _RoleState() when $default != null:
return $default(_that.roles,_that.selectedRole,_that.isLoading,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _RoleState implements RoleState {
  const _RoleState({final  List<RoleEntity> roles = const [], this.selectedRole, this.isLoading = false, this.errorMessage}): _roles = roles;
  

/// 角色列表
 final  List<RoleEntity> _roles;
/// 角色列表
@override@JsonKey() List<RoleEntity> get roles {
  if (_roles is EqualUnmodifiableListView) return _roles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_roles);
}

/// 选中的角色
@override final  RoleEntity? selectedRole;
/// 正在加载
@override@JsonKey() final  bool isLoading;
/// 错误消息
@override final  String? errorMessage;

/// Create a copy of RoleState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoleStateCopyWith<_RoleState> get copyWith => __$RoleStateCopyWithImpl<_RoleState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoleState&&const DeepCollectionEquality().equals(other._roles, _roles)&&(identical(other.selectedRole, selectedRole) || other.selectedRole == selectedRole)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_roles),selectedRole,isLoading,errorMessage);

@override
String toString() {
  return 'RoleState(roles: $roles, selectedRole: $selectedRole, isLoading: $isLoading, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$RoleStateCopyWith<$Res> implements $RoleStateCopyWith<$Res> {
  factory _$RoleStateCopyWith(_RoleState value, $Res Function(_RoleState) _then) = __$RoleStateCopyWithImpl;
@override @useResult
$Res call({
 List<RoleEntity> roles, RoleEntity? selectedRole, bool isLoading, String? errorMessage
});


@override $RoleEntityCopyWith<$Res>? get selectedRole;

}
/// @nodoc
class __$RoleStateCopyWithImpl<$Res>
    implements _$RoleStateCopyWith<$Res> {
  __$RoleStateCopyWithImpl(this._self, this._then);

  final _RoleState _self;
  final $Res Function(_RoleState) _then;

/// Create a copy of RoleState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? roles = null,Object? selectedRole = freezed,Object? isLoading = null,Object? errorMessage = freezed,}) {
  return _then(_RoleState(
roles: null == roles ? _self._roles : roles // ignore: cast_nullable_to_non_nullable
as List<RoleEntity>,selectedRole: freezed == selectedRole ? _self.selectedRole : selectedRole // ignore: cast_nullable_to_non_nullable
as RoleEntity?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of RoleState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RoleEntityCopyWith<$Res>? get selectedRole {
    if (_self.selectedRole == null) {
    return null;
  }

  return $RoleEntityCopyWith<$Res>(_self.selectedRole!, (value) {
    return _then(_self.copyWith(selectedRole: value));
  });
}
}

// dart format on
