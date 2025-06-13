// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
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

 List<RoleEntity> get roles; RoleEntity? get selectedRole; bool get isLoading; String? get errorMessage;
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


/// @nodoc


class _RoleState implements RoleState {
  const _RoleState({final  List<RoleEntity> roles = const [], this.selectedRole, this.isLoading = false, this.errorMessage}): _roles = roles;
  

 final  List<RoleEntity> _roles;
@override@JsonKey() List<RoleEntity> get roles {
  if (_roles is EqualUnmodifiableListView) return _roles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_roles);
}

@override final  RoleEntity? selectedRole;
@override@JsonKey() final  bool isLoading;
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
