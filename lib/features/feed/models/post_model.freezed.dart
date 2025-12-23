// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PostModel {

 int? get id; String get description;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'deleted_at') DateTime? get deletedAt; double get latitude; double get longitude; UserModel get author;@JsonKey(name: 'votes_count') int get votesCount; List<CommentModel> get comments;@JsonKey(name: 'has_voted') bool get hasVoted;@JsonKey(unknownEnumValue: PostCategory.unknown) PostCategory get category;
/// Create a copy of PostModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostModelCopyWith<PostModel> get copyWith => _$PostModelCopyWithImpl<PostModel>(this as PostModel, _$identity);

  /// Serializes this PostModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostModel&&(identical(other.id, id) || other.id == id)&&(identical(other.description, description) || other.description == description)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.author, author) || other.author == author)&&(identical(other.votesCount, votesCount) || other.votesCount == votesCount)&&const DeepCollectionEquality().equals(other.comments, comments)&&(identical(other.hasVoted, hasVoted) || other.hasVoted == hasVoted)&&(identical(other.category, category) || other.category == category));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,description,createdAt,deletedAt,latitude,longitude,author,votesCount,const DeepCollectionEquality().hash(comments),hasVoted,category);

@override
String toString() {
  return 'PostModel(id: $id, description: $description, createdAt: $createdAt, deletedAt: $deletedAt, latitude: $latitude, longitude: $longitude, author: $author, votesCount: $votesCount, comments: $comments, hasVoted: $hasVoted, category: $category)';
}


}

/// @nodoc
abstract mixin class $PostModelCopyWith<$Res>  {
  factory $PostModelCopyWith(PostModel value, $Res Function(PostModel) _then) = _$PostModelCopyWithImpl;
@useResult
$Res call({
 int? id, String description,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'deleted_at') DateTime? deletedAt, double latitude, double longitude, UserModel author,@JsonKey(name: 'votes_count') int votesCount, List<CommentModel> comments,@JsonKey(name: 'has_voted') bool hasVoted,@JsonKey(unknownEnumValue: PostCategory.unknown) PostCategory category
});


$UserModelCopyWith<$Res> get author;

}
/// @nodoc
class _$PostModelCopyWithImpl<$Res>
    implements $PostModelCopyWith<$Res> {
  _$PostModelCopyWithImpl(this._self, this._then);

  final PostModel _self;
  final $Res Function(PostModel) _then;

/// Create a copy of PostModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? description = null,Object? createdAt = freezed,Object? deletedAt = freezed,Object? latitude = null,Object? longitude = null,Object? author = null,Object? votesCount = null,Object? comments = null,Object? hasVoted = null,Object? category = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as UserModel,votesCount: null == votesCount ? _self.votesCount : votesCount // ignore: cast_nullable_to_non_nullable
as int,comments: null == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as List<CommentModel>,hasVoted: null == hasVoted ? _self.hasVoted : hasVoted // ignore: cast_nullable_to_non_nullable
as bool,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as PostCategory,
  ));
}
/// Create a copy of PostModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserModelCopyWith<$Res> get author {
  
  return $UserModelCopyWith<$Res>(_self.author, (value) {
    return _then(_self.copyWith(author: value));
  });
}
}


/// Adds pattern-matching-related methods to [PostModel].
extension PostModelPatterns on PostModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostModel value)  $default,){
final _that = this;
switch (_that) {
case _PostModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostModel value)?  $default,){
final _that = this;
switch (_that) {
case _PostModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  String description, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'deleted_at')  DateTime? deletedAt,  double latitude,  double longitude,  UserModel author, @JsonKey(name: 'votes_count')  int votesCount,  List<CommentModel> comments, @JsonKey(name: 'has_voted')  bool hasVoted, @JsonKey(unknownEnumValue: PostCategory.unknown)  PostCategory category)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PostModel() when $default != null:
return $default(_that.id,_that.description,_that.createdAt,_that.deletedAt,_that.latitude,_that.longitude,_that.author,_that.votesCount,_that.comments,_that.hasVoted,_that.category);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  String description, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'deleted_at')  DateTime? deletedAt,  double latitude,  double longitude,  UserModel author, @JsonKey(name: 'votes_count')  int votesCount,  List<CommentModel> comments, @JsonKey(name: 'has_voted')  bool hasVoted, @JsonKey(unknownEnumValue: PostCategory.unknown)  PostCategory category)  $default,) {final _that = this;
switch (_that) {
case _PostModel():
return $default(_that.id,_that.description,_that.createdAt,_that.deletedAt,_that.latitude,_that.longitude,_that.author,_that.votesCount,_that.comments,_that.hasVoted,_that.category);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  String description, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'deleted_at')  DateTime? deletedAt,  double latitude,  double longitude,  UserModel author, @JsonKey(name: 'votes_count')  int votesCount,  List<CommentModel> comments, @JsonKey(name: 'has_voted')  bool hasVoted, @JsonKey(unknownEnumValue: PostCategory.unknown)  PostCategory category)?  $default,) {final _that = this;
switch (_that) {
case _PostModel() when $default != null:
return $default(_that.id,_that.description,_that.createdAt,_that.deletedAt,_that.latitude,_that.longitude,_that.author,_that.votesCount,_that.comments,_that.hasVoted,_that.category);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PostModel extends PostModel {
  const _PostModel({this.id, required this.description, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'deleted_at') this.deletedAt, required this.latitude, required this.longitude, required this.author, @JsonKey(name: 'votes_count') this.votesCount = 0, final  List<CommentModel> comments = const [], @JsonKey(name: 'has_voted') this.hasVoted = false, @JsonKey(unknownEnumValue: PostCategory.unknown) required this.category}): _comments = comments,super._();
  factory _PostModel.fromJson(Map<String, dynamic> json) => _$PostModelFromJson(json);

@override final  int? id;
@override final  String description;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'deleted_at') final  DateTime? deletedAt;
@override final  double latitude;
@override final  double longitude;
@override final  UserModel author;
@override@JsonKey(name: 'votes_count') final  int votesCount;
 final  List<CommentModel> _comments;
@override@JsonKey() List<CommentModel> get comments {
  if (_comments is EqualUnmodifiableListView) return _comments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_comments);
}

@override@JsonKey(name: 'has_voted') final  bool hasVoted;
@override@JsonKey(unknownEnumValue: PostCategory.unknown) final  PostCategory category;

/// Create a copy of PostModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostModelCopyWith<_PostModel> get copyWith => __$PostModelCopyWithImpl<_PostModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PostModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostModel&&(identical(other.id, id) || other.id == id)&&(identical(other.description, description) || other.description == description)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.author, author) || other.author == author)&&(identical(other.votesCount, votesCount) || other.votesCount == votesCount)&&const DeepCollectionEquality().equals(other._comments, _comments)&&(identical(other.hasVoted, hasVoted) || other.hasVoted == hasVoted)&&(identical(other.category, category) || other.category == category));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,description,createdAt,deletedAt,latitude,longitude,author,votesCount,const DeepCollectionEquality().hash(_comments),hasVoted,category);

@override
String toString() {
  return 'PostModel(id: $id, description: $description, createdAt: $createdAt, deletedAt: $deletedAt, latitude: $latitude, longitude: $longitude, author: $author, votesCount: $votesCount, comments: $comments, hasVoted: $hasVoted, category: $category)';
}


}

/// @nodoc
abstract mixin class _$PostModelCopyWith<$Res> implements $PostModelCopyWith<$Res> {
  factory _$PostModelCopyWith(_PostModel value, $Res Function(_PostModel) _then) = __$PostModelCopyWithImpl;
@override @useResult
$Res call({
 int? id, String description,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'deleted_at') DateTime? deletedAt, double latitude, double longitude, UserModel author,@JsonKey(name: 'votes_count') int votesCount, List<CommentModel> comments,@JsonKey(name: 'has_voted') bool hasVoted,@JsonKey(unknownEnumValue: PostCategory.unknown) PostCategory category
});


@override $UserModelCopyWith<$Res> get author;

}
/// @nodoc
class __$PostModelCopyWithImpl<$Res>
    implements _$PostModelCopyWith<$Res> {
  __$PostModelCopyWithImpl(this._self, this._then);

  final _PostModel _self;
  final $Res Function(_PostModel) _then;

/// Create a copy of PostModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? description = null,Object? createdAt = freezed,Object? deletedAt = freezed,Object? latitude = null,Object? longitude = null,Object? author = null,Object? votesCount = null,Object? comments = null,Object? hasVoted = null,Object? category = null,}) {
  return _then(_PostModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as UserModel,votesCount: null == votesCount ? _self.votesCount : votesCount // ignore: cast_nullable_to_non_nullable
as int,comments: null == comments ? _self._comments : comments // ignore: cast_nullable_to_non_nullable
as List<CommentModel>,hasVoted: null == hasVoted ? _self.hasVoted : hasVoted // ignore: cast_nullable_to_non_nullable
as bool,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as PostCategory,
  ));
}

/// Create a copy of PostModel
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
