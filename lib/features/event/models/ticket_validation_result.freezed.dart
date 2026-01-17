// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ticket_validation_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TicketValidationResult {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TicketValidationResult);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TicketValidationResult()';
}


}

/// @nodoc
class $TicketValidationResultCopyWith<$Res>  {
$TicketValidationResultCopyWith(TicketValidationResult _, $Res Function(TicketValidationResult) __);
}


/// Adds pattern-matching-related methods to [TicketValidationResult].
extension TicketValidationResultPatterns on TicketValidationResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _TicketValid value)?  valid,TResult Function( _TicketWrongEvent value)?  wrongEvent,TResult Function( _TicketError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TicketValid() when valid != null:
return valid(_that);case _TicketWrongEvent() when wrongEvent != null:
return wrongEvent(_that);case _TicketError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _TicketValid value)  valid,required TResult Function( _TicketWrongEvent value)  wrongEvent,required TResult Function( _TicketError value)  error,}){
final _that = this;
switch (_that) {
case _TicketValid():
return valid(_that);case _TicketWrongEvent():
return wrongEvent(_that);case _TicketError():
return error(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _TicketValid value)?  valid,TResult? Function( _TicketWrongEvent value)?  wrongEvent,TResult? Function( _TicketError value)?  error,}){
final _that = this;
switch (_that) {
case _TicketValid() when valid != null:
return valid(_that);case _TicketWrongEvent() when wrongEvent != null:
return wrongEvent(_that);case _TicketError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String? userName)?  valid,TResult Function()?  wrongEvent,TResult Function( String? message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TicketValid() when valid != null:
return valid(_that.userName);case _TicketWrongEvent() when wrongEvent != null:
return wrongEvent();case _TicketError() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String? userName)  valid,required TResult Function()  wrongEvent,required TResult Function( String? message)  error,}) {final _that = this;
switch (_that) {
case _TicketValid():
return valid(_that.userName);case _TicketWrongEvent():
return wrongEvent();case _TicketError():
return error(_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String? userName)?  valid,TResult? Function()?  wrongEvent,TResult? Function( String? message)?  error,}) {final _that = this;
switch (_that) {
case _TicketValid() when valid != null:
return valid(_that.userName);case _TicketWrongEvent() when wrongEvent != null:
return wrongEvent();case _TicketError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _TicketValid extends TicketValidationResult {
  const _TicketValid({this.userName}): super._();
  

 final  String? userName;

/// Create a copy of TicketValidationResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TicketValidCopyWith<_TicketValid> get copyWith => __$TicketValidCopyWithImpl<_TicketValid>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TicketValid&&(identical(other.userName, userName) || other.userName == userName));
}


@override
int get hashCode => Object.hash(runtimeType,userName);

@override
String toString() {
  return 'TicketValidationResult.valid(userName: $userName)';
}


}

/// @nodoc
abstract mixin class _$TicketValidCopyWith<$Res> implements $TicketValidationResultCopyWith<$Res> {
  factory _$TicketValidCopyWith(_TicketValid value, $Res Function(_TicketValid) _then) = __$TicketValidCopyWithImpl;
@useResult
$Res call({
 String? userName
});




}
/// @nodoc
class __$TicketValidCopyWithImpl<$Res>
    implements _$TicketValidCopyWith<$Res> {
  __$TicketValidCopyWithImpl(this._self, this._then);

  final _TicketValid _self;
  final $Res Function(_TicketValid) _then;

/// Create a copy of TicketValidationResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? userName = freezed,}) {
  return _then(_TicketValid(
userName: freezed == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _TicketWrongEvent extends TicketValidationResult {
  const _TicketWrongEvent(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TicketWrongEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TicketValidationResult.wrongEvent()';
}


}




/// @nodoc


class _TicketError extends TicketValidationResult {
  const _TicketError({this.message}): super._();
  

 final  String? message;

/// Create a copy of TicketValidationResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TicketErrorCopyWith<_TicketError> get copyWith => __$TicketErrorCopyWithImpl<_TicketError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TicketError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'TicketValidationResult.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$TicketErrorCopyWith<$Res> implements $TicketValidationResultCopyWith<$Res> {
  factory _$TicketErrorCopyWith(_TicketError value, $Res Function(_TicketError) _then) = __$TicketErrorCopyWithImpl;
@useResult
$Res call({
 String? message
});




}
/// @nodoc
class __$TicketErrorCopyWithImpl<$Res>
    implements _$TicketErrorCopyWith<$Res> {
  __$TicketErrorCopyWithImpl(this._self, this._then);

  final _TicketError _self;
  final $Res Function(_TicketError) _then;

/// Create a copy of TicketValidationResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(_TicketError(
message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
