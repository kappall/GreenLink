// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'comment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CommentModel {

 int get id; String get description; UserModel get author; List<UserModel> get votes;@JsonKey(name: 'votes_count') int get votesCount;@JsonKey(name: 'has_voted') bool get hasVoted; int get content;@JsonKey(name: 'deleted_at') DateTime? get deletedAt;@JsonKey(name: 'created_at') DateTime get createdAt;
/// Create a copy of CommentModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommentModelCopyWith<CommentModel> get copyWith => _$CommentModelCopyWithImpl<CommentModel>(this as CommentModel, _$identity);

  /// Serializes this CommentModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.description, description) || other.description == description)&&(identical(other.author, author) || other.author == author)&&const DeepCollectionEquality().equals(other.votes, votes)&&(identical(other.votesCount, votesCount) || other.votesCount == votesCount)&&(identical(other.hasVoted, hasVoted) || other.hasVoted == hasVoted)&&(identical(other.content, content) || other.content == content)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,description,author,const DeepCollectionEquality().hash(votes),votesCount,hasVoted,content,deletedAt,createdAt);

@override
String toString() {
  return 'CommentModel(id: $id, description: $description, author: $author, votes: $votes, votesCount: $votesCount, hasVoted: $hasVoted, content: $content, deletedAt: $deletedAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $CommentModelCopyWith<$Res>  {
  factory $CommentModelCopyWith(CommentModel value, $Res Function(CommentModel) _then) = _$CommentModelCopyWithImpl;
@useResult
$Res call({
 int id, String description, UserModel author, List<UserModel> votes,@JsonKey(name: 'votes_count') int votesCount,@JsonKey(name: 'has_voted') bool hasVoted, int content,@JsonKey(name: 'deleted_at') DateTime? deletedAt,@JsonKey(name: 'created_at') DateTime createdAt
});


$UserModelCopyWith<$Res> get author;

}
/// @nodoc
class _$CommentModelCopyWithImpl<$Res>
    implements $CommentModelCopyWith<$Res> {
  _$CommentModelCopyWithImpl(this._self, this._then);

  final CommentModel _self;
  final $Res Function(CommentModel) _then;

/// Create a copy of CommentModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? description = null,Object? author = null,Object? votes = null,Object? votesCount = null,Object? hasVoted = null,Object? content = null,Object? deletedAt = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as UserModel,votes: null == votes ? _self.votes : votes // ignore: cast_nullable_to_non_nullable
as List<UserModel>,votesCount: null == votesCount ? _self.votesCount : votesCount // ignore: cast_nullable_to_non_nullable
as int,hasVoted: null == hasVoted ? _self.hasVoted : hasVoted // ignore: cast_nullable_to_non_nullable
as bool,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as int,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of CommentModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserModelCopyWith<$Res> get author {
  
  return $UserModelCopyWith<$Res>(_self.author, (value) {
    return _then(_self.copyWith(author: value));
  });
}
}


/// Adds pattern-matching-related methods to [CommentModel].
extension CommentModelPatterns on CommentModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CommentModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CommentModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CommentModel value)  $default,){
final _that = this;
switch (_that) {
case _CommentModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CommentModel value)?  $default,){
final _that = this;
switch (_that) {
case _CommentModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String description,  UserModel author,  List<UserModel> votes, @JsonKey(name: 'votes_count')  int votesCount, @JsonKey(name: 'has_voted')  bool hasVoted,  int content, @JsonKey(name: 'deleted_at')  DateTime? deletedAt, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CommentModel() when $default != null:
return $default(_that.id,_that.description,_that.author,_that.votes,_that.votesCount,_that.hasVoted,_that.content,_that.deletedAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String description,  UserModel author,  List<UserModel> votes, @JsonKey(name: 'votes_count')  int votesCount, @JsonKey(name: 'has_voted')  bool hasVoted,  int content, @JsonKey(name: 'deleted_at')  DateTime? deletedAt, @JsonKey(name: 'created_at')  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _CommentModel():
return $default(_that.id,_that.description,_that.author,_that.votes,_that.votesCount,_that.hasVoted,_that.content,_that.deletedAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String description,  UserModel author,  List<UserModel> votes, @JsonKey(name: 'votes_count')  int votesCount, @JsonKey(name: 'has_voted')  bool hasVoted,  int content, @JsonKey(name: 'deleted_at')  DateTime? deletedAt, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _CommentModel() when $default != null:
return $default(_that.id,_that.description,_that.author,_that.votes,_that.votesCount,_that.hasVoted,_that.content,_that.deletedAt,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CommentModel implements CommentModel {
  const _CommentModel({required this.id, required this.description, required this.author, final  List<UserModel> votes = const [], @JsonKey(name: 'votes_count') required this.votesCount, @JsonKey(name: 'has_voted') this.hasVoted = false, required this.content, @JsonKey(name: 'deleted_at') this.deletedAt, @JsonKey(name: 'created_at') required this.createdAt}): _votes = votes;
  factory _CommentModel.fromJson(Map<String, dynamic> json) => _$CommentModelFromJson(json);

@override final  int id;
@override final  String description;
@override final  UserModel author;
 final  List<UserModel> _votes;
@override@JsonKey() List<UserModel> get votes {
  if (_votes is EqualUnmodifiableListView) return _votes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_votes);
}

@override@JsonKey(name: 'votes_count') final  int votesCount;
@override@JsonKey(name: 'has_voted') final  bool hasVoted;
@override final  int content;
@override@JsonKey(name: 'deleted_at') final  DateTime? deletedAt;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;

/// Create a copy of CommentModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommentModelCopyWith<_CommentModel> get copyWith => __$CommentModelCopyWithImpl<_CommentModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CommentModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CommentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.description, description) || other.description == description)&&(identical(other.author, author) || other.author == author)&&const DeepCollectionEquality().equals(other._votes, _votes)&&(identical(other.votesCount, votesCount) || other.votesCount == votesCount)&&(identical(other.hasVoted, hasVoted) || other.hasVoted == hasVoted)&&(identical(other.content, content) || other.content == content)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,description,author,const DeepCollectionEquality().hash(_votes),votesCount,hasVoted,content,deletedAt,createdAt);

@override
String toString() {
  return 'CommentModel(id: $id, description: $description, author: $author, votes: $votes, votesCount: $votesCount, hasVoted: $hasVoted, content: $content, deletedAt: $deletedAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$CommentModelCopyWith<$Res> implements $CommentModelCopyWith<$Res> {
  factory _$CommentModelCopyWith(_CommentModel value, $Res Function(_CommentModel) _then) = __$CommentModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String description, UserModel author, List<UserModel> votes,@JsonKey(name: 'votes_count') int votesCount,@JsonKey(name: 'has_voted') bool hasVoted, int content,@JsonKey(name: 'deleted_at') DateTime? deletedAt,@JsonKey(name: 'created_at') DateTime createdAt
});


@override $UserModelCopyWith<$Res> get author;

}
/// @nodoc
class __$CommentModelCopyWithImpl<$Res>
    implements _$CommentModelCopyWith<$Res> {
  __$CommentModelCopyWithImpl(this._self, this._then);

  final _CommentModel _self;
  final $Res Function(_CommentModel) _then;

/// Create a copy of CommentModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? description = null,Object? author = null,Object? votes = null,Object? votesCount = null,Object? hasVoted = null,Object? content = null,Object? deletedAt = freezed,Object? createdAt = null,}) {
  return _then(_CommentModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as UserModel,votes: null == votes ? _self._votes : votes // ignore: cast_nullable_to_non_nullable
as List<UserModel>,votesCount: null == votesCount ? _self.votesCount : votesCount // ignore: cast_nullable_to_non_nullable
as int,hasVoted: null == hasVoted ? _self.hasVoted : hasVoted // ignore: cast_nullable_to_non_nullable
as bool,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as int,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of CommentModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserModelCopyWith<$Res> get author {
  
  return $UserModelCopyWith<$Res>(_self.author, (value) {
    return _then(_self.copyWith(author: value));
  });
}
}

// dart format on
