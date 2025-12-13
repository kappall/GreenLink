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

 int get id; String get description;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'deleted_at') DateTime? get deletedAt; double get latitude; double get longitude; PostUserModel get author; List<PostUserModel> get votes;@JsonKey(unknownEnumValue: PostCategory.unknown) PostCategory get category;
/// Create a copy of PostModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostModelCopyWith<PostModel> get copyWith => _$PostModelCopyWithImpl<PostModel>(this as PostModel, _$identity);

  /// Serializes this PostModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostModel&&(identical(other.id, id) || other.id == id)&&(identical(other.description, description) || other.description == description)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.author, author) || other.author == author)&&const DeepCollectionEquality().equals(other.votes, votes)&&(identical(other.category, category) || other.category == category));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,description,createdAt,deletedAt,latitude,longitude,author,const DeepCollectionEquality().hash(votes),category);

@override
String toString() {
  return 'PostModel(id: $id, description: $description, createdAt: $createdAt, deletedAt: $deletedAt, latitude: $latitude, longitude: $longitude, author: $author, votes: $votes, category: $category)';
}


}

/// @nodoc
abstract mixin class $PostModelCopyWith<$Res>  {
  factory $PostModelCopyWith(PostModel value, $Res Function(PostModel) _then) = _$PostModelCopyWithImpl;
@useResult
$Res call({
 int id, String description,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'deleted_at') DateTime? deletedAt, double latitude, double longitude, PostUserModel author, List<PostUserModel> votes,@JsonKey(unknownEnumValue: PostCategory.unknown) PostCategory category
});


$PostUserModelCopyWith<$Res> get author;

}
/// @nodoc
class _$PostModelCopyWithImpl<$Res>
    implements $PostModelCopyWith<$Res> {
  _$PostModelCopyWithImpl(this._self, this._then);

  final PostModel _self;
  final $Res Function(PostModel) _then;

/// Create a copy of PostModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? description = null,Object? createdAt = null,Object? deletedAt = freezed,Object? latitude = null,Object? longitude = null,Object? author = null,Object? votes = null,Object? category = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as PostUserModel,votes: null == votes ? _self.votes : votes // ignore: cast_nullable_to_non_nullable
as List<PostUserModel>,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as PostCategory,
  ));
}
/// Create a copy of PostModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostUserModelCopyWith<$Res> get author {
  
  return $PostUserModelCopyWith<$Res>(_self.author, (value) {
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String description, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'deleted_at')  DateTime? deletedAt,  double latitude,  double longitude,  PostUserModel author,  List<PostUserModel> votes, @JsonKey(unknownEnumValue: PostCategory.unknown)  PostCategory category)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PostModel() when $default != null:
return $default(_that.id,_that.description,_that.createdAt,_that.deletedAt,_that.latitude,_that.longitude,_that.author,_that.votes,_that.category);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String description, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'deleted_at')  DateTime? deletedAt,  double latitude,  double longitude,  PostUserModel author,  List<PostUserModel> votes, @JsonKey(unknownEnumValue: PostCategory.unknown)  PostCategory category)  $default,) {final _that = this;
switch (_that) {
case _PostModel():
return $default(_that.id,_that.description,_that.createdAt,_that.deletedAt,_that.latitude,_that.longitude,_that.author,_that.votes,_that.category);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String description, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'deleted_at')  DateTime? deletedAt,  double latitude,  double longitude,  PostUserModel author,  List<PostUserModel> votes, @JsonKey(unknownEnumValue: PostCategory.unknown)  PostCategory category)?  $default,) {final _that = this;
switch (_that) {
case _PostModel() when $default != null:
return $default(_that.id,_that.description,_that.createdAt,_that.deletedAt,_that.latitude,_that.longitude,_that.author,_that.votes,_that.category);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PostModel extends PostModel {
  const _PostModel({required this.id, required this.description, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'deleted_at') this.deletedAt, required this.latitude, required this.longitude, required this.author, final  List<PostUserModel> votes = const <PostUserModel>[], @JsonKey(unknownEnumValue: PostCategory.unknown) required this.category}): _votes = votes,super._();
  factory _PostModel.fromJson(Map<String, dynamic> json) => _$PostModelFromJson(json);

@override final  int id;
@override final  String description;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'deleted_at') final  DateTime? deletedAt;
@override final  double latitude;
@override final  double longitude;
@override final  PostUserModel author;
 final  List<PostUserModel> _votes;
@override@JsonKey() List<PostUserModel> get votes {
  if (_votes is EqualUnmodifiableListView) return _votes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_votes);
}

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostModel&&(identical(other.id, id) || other.id == id)&&(identical(other.description, description) || other.description == description)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.author, author) || other.author == author)&&const DeepCollectionEquality().equals(other._votes, _votes)&&(identical(other.category, category) || other.category == category));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,description,createdAt,deletedAt,latitude,longitude,author,const DeepCollectionEquality().hash(_votes),category);

@override
String toString() {
  return 'PostModel(id: $id, description: $description, createdAt: $createdAt, deletedAt: $deletedAt, latitude: $latitude, longitude: $longitude, author: $author, votes: $votes, category: $category)';
}


}

/// @nodoc
abstract mixin class _$PostModelCopyWith<$Res> implements $PostModelCopyWith<$Res> {
  factory _$PostModelCopyWith(_PostModel value, $Res Function(_PostModel) _then) = __$PostModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String description,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'deleted_at') DateTime? deletedAt, double latitude, double longitude, PostUserModel author, List<PostUserModel> votes,@JsonKey(unknownEnumValue: PostCategory.unknown) PostCategory category
});


@override $PostUserModelCopyWith<$Res> get author;

}
/// @nodoc
class __$PostModelCopyWithImpl<$Res>
    implements _$PostModelCopyWith<$Res> {
  __$PostModelCopyWithImpl(this._self, this._then);

  final _PostModel _self;
  final $Res Function(_PostModel) _then;

/// Create a copy of PostModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? description = null,Object? createdAt = null,Object? deletedAt = freezed,Object? latitude = null,Object? longitude = null,Object? author = null,Object? votes = null,Object? category = null,}) {
  return _then(_PostModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as PostUserModel,votes: null == votes ? _self._votes : votes // ignore: cast_nullable_to_non_nullable
as List<PostUserModel>,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as PostCategory,
  ));
}

/// Create a copy of PostModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostUserModelCopyWith<$Res> get author {
  
  return $PostUserModelCopyWith<$Res>(_self.author, (value) {
    return _then(_self.copyWith(author: value));
  });
}
}


/// @nodoc
mixin _$PostUserModel {

 int get id; String get email; String? get password;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'deleted_at') DateTime? get deletedAt;
/// Create a copy of PostUserModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostUserModelCopyWith<PostUserModel> get copyWith => _$PostUserModelCopyWithImpl<PostUserModel>(this as PostUserModel, _$identity);

  /// Serializes this PostUserModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostUserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,password,createdAt,deletedAt);

@override
String toString() {
  return 'PostUserModel(id: $id, email: $email, password: $password, createdAt: $createdAt, deletedAt: $deletedAt)';
}


}

/// @nodoc
abstract mixin class $PostUserModelCopyWith<$Res>  {
  factory $PostUserModelCopyWith(PostUserModel value, $Res Function(PostUserModel) _then) = _$PostUserModelCopyWithImpl;
@useResult
$Res call({
 int id, String email, String? password,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'deleted_at') DateTime? deletedAt
});




}
/// @nodoc
class _$PostUserModelCopyWithImpl<$Res>
    implements $PostUserModelCopyWith<$Res> {
  _$PostUserModelCopyWithImpl(this._self, this._then);

  final PostUserModel _self;
  final $Res Function(PostUserModel) _then;

/// Create a copy of PostUserModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = null,Object? password = freezed,Object? createdAt = null,Object? deletedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: freezed == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [PostUserModel].
extension PostUserModelPatterns on PostUserModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostUserModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostUserModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostUserModel value)  $default,){
final _that = this;
switch (_that) {
case _PostUserModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostUserModel value)?  $default,){
final _that = this;
switch (_that) {
case _PostUserModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String email,  String? password, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'deleted_at')  DateTime? deletedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PostUserModel() when $default != null:
return $default(_that.id,_that.email,_that.password,_that.createdAt,_that.deletedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String email,  String? password, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'deleted_at')  DateTime? deletedAt)  $default,) {final _that = this;
switch (_that) {
case _PostUserModel():
return $default(_that.id,_that.email,_that.password,_that.createdAt,_that.deletedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String email,  String? password, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'deleted_at')  DateTime? deletedAt)?  $default,) {final _that = this;
switch (_that) {
case _PostUserModel() when $default != null:
return $default(_that.id,_that.email,_that.password,_that.createdAt,_that.deletedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PostUserModel extends PostUserModel {
  const _PostUserModel({required this.id, required this.email, this.password, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'deleted_at') this.deletedAt}): super._();
  factory _PostUserModel.fromJson(Map<String, dynamic> json) => _$PostUserModelFromJson(json);

@override final  int id;
@override final  String email;
@override final  String? password;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'deleted_at') final  DateTime? deletedAt;

/// Create a copy of PostUserModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostUserModelCopyWith<_PostUserModel> get copyWith => __$PostUserModelCopyWithImpl<_PostUserModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PostUserModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostUserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,password,createdAt,deletedAt);

@override
String toString() {
  return 'PostUserModel(id: $id, email: $email, password: $password, createdAt: $createdAt, deletedAt: $deletedAt)';
}


}

/// @nodoc
abstract mixin class _$PostUserModelCopyWith<$Res> implements $PostUserModelCopyWith<$Res> {
  factory _$PostUserModelCopyWith(_PostUserModel value, $Res Function(_PostUserModel) _then) = __$PostUserModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String email, String? password,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'deleted_at') DateTime? deletedAt
});




}
/// @nodoc
class __$PostUserModelCopyWithImpl<$Res>
    implements _$PostUserModelCopyWith<$Res> {
  __$PostUserModelCopyWithImpl(this._self, this._then);

  final _PostUserModel _self;
  final $Res Function(_PostUserModel) _then;

/// Create a copy of PostUserModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = null,Object? password = freezed,Object? createdAt = null,Object? deletedAt = freezed,}) {
  return _then(_PostUserModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: freezed == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
