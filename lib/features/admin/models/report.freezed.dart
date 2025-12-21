// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
ReportContent _$ReportContentFromJson(
  Map<String, dynamic> json
) {
        switch (json['type']) {
                  case 'post':
          return ReportContentPost.fromJson(
            json
          );
                case 'event':
          return ReportContentEvent.fromJson(
            json
          );
                case 'comment':
          return ReportContentComment.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'type',
  'ReportContent',
  'Invalid union type "${json['type']}"!'
);
        }
      
}

/// @nodoc
mixin _$ReportContent {

 Object get data;

  /// Serializes this ReportContent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportContent&&const DeepCollectionEquality().equals(other.data, data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'ReportContent(data: $data)';
}


}

/// @nodoc
class $ReportContentCopyWith<$Res>  {
$ReportContentCopyWith(ReportContent _, $Res Function(ReportContent) __);
}


/// Adds pattern-matching-related methods to [ReportContent].
extension ReportContentPatterns on ReportContent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ReportContentPost value)?  post,TResult Function( ReportContentEvent value)?  event,TResult Function( ReportContentComment value)?  comment,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ReportContentPost() when post != null:
return post(_that);case ReportContentEvent() when event != null:
return event(_that);case ReportContentComment() when comment != null:
return comment(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ReportContentPost value)  post,required TResult Function( ReportContentEvent value)  event,required TResult Function( ReportContentComment value)  comment,}){
final _that = this;
switch (_that) {
case ReportContentPost():
return post(_that);case ReportContentEvent():
return event(_that);case ReportContentComment():
return comment(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ReportContentPost value)?  post,TResult? Function( ReportContentEvent value)?  event,TResult? Function( ReportContentComment value)?  comment,}){
final _that = this;
switch (_that) {
case ReportContentPost() when post != null:
return post(_that);case ReportContentEvent() when event != null:
return event(_that);case ReportContentComment() when comment != null:
return comment(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( PostModel data)?  post,TResult Function( EventModel data)?  event,TResult Function( CommentModel data)?  comment,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ReportContentPost() when post != null:
return post(_that.data);case ReportContentEvent() when event != null:
return event(_that.data);case ReportContentComment() when comment != null:
return comment(_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( PostModel data)  post,required TResult Function( EventModel data)  event,required TResult Function( CommentModel data)  comment,}) {final _that = this;
switch (_that) {
case ReportContentPost():
return post(_that.data);case ReportContentEvent():
return event(_that.data);case ReportContentComment():
return comment(_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( PostModel data)?  post,TResult? Function( EventModel data)?  event,TResult? Function( CommentModel data)?  comment,}) {final _that = this;
switch (_that) {
case ReportContentPost() when post != null:
return post(_that.data);case ReportContentEvent() when event != null:
return event(_that.data);case ReportContentComment() when comment != null:
return comment(_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class ReportContentPost implements ReportContent {
  const ReportContentPost(this.data, {final  String? $type}): $type = $type ?? 'post';
  factory ReportContentPost.fromJson(Map<String, dynamic> json) => _$ReportContentPostFromJson(json);

@override final  PostModel data;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of ReportContent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportContentPostCopyWith<ReportContentPost> get copyWith => _$ReportContentPostCopyWithImpl<ReportContentPost>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReportContentPostToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportContentPost&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'ReportContent.post(data: $data)';
}


}

/// @nodoc
abstract mixin class $ReportContentPostCopyWith<$Res> implements $ReportContentCopyWith<$Res> {
  factory $ReportContentPostCopyWith(ReportContentPost value, $Res Function(ReportContentPost) _then) = _$ReportContentPostCopyWithImpl;
@useResult
$Res call({
 PostModel data
});


$PostModelCopyWith<$Res> get data;

}
/// @nodoc
class _$ReportContentPostCopyWithImpl<$Res>
    implements $ReportContentPostCopyWith<$Res> {
  _$ReportContentPostCopyWithImpl(this._self, this._then);

  final ReportContentPost _self;
  final $Res Function(ReportContentPost) _then;

/// Create a copy of ReportContent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(ReportContentPost(
null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as PostModel,
  ));
}

/// Create a copy of ReportContent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PostModelCopyWith<$Res> get data {
  
  return $PostModelCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}

/// @nodoc
@JsonSerializable()

class ReportContentEvent implements ReportContent {
  const ReportContentEvent(this.data, {final  String? $type}): $type = $type ?? 'event';
  factory ReportContentEvent.fromJson(Map<String, dynamic> json) => _$ReportContentEventFromJson(json);

@override final  EventModel data;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of ReportContent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportContentEventCopyWith<ReportContentEvent> get copyWith => _$ReportContentEventCopyWithImpl<ReportContentEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReportContentEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportContentEvent&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'ReportContent.event(data: $data)';
}


}

/// @nodoc
abstract mixin class $ReportContentEventCopyWith<$Res> implements $ReportContentCopyWith<$Res> {
  factory $ReportContentEventCopyWith(ReportContentEvent value, $Res Function(ReportContentEvent) _then) = _$ReportContentEventCopyWithImpl;
@useResult
$Res call({
 EventModel data
});


$EventModelCopyWith<$Res> get data;

}
/// @nodoc
class _$ReportContentEventCopyWithImpl<$Res>
    implements $ReportContentEventCopyWith<$Res> {
  _$ReportContentEventCopyWithImpl(this._self, this._then);

  final ReportContentEvent _self;
  final $Res Function(ReportContentEvent) _then;

/// Create a copy of ReportContent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(ReportContentEvent(
null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as EventModel,
  ));
}

/// Create a copy of ReportContent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventModelCopyWith<$Res> get data {
  
  return $EventModelCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}

/// @nodoc
@JsonSerializable()

class ReportContentComment implements ReportContent {
  const ReportContentComment(this.data, {final  String? $type}): $type = $type ?? 'comment';
  factory ReportContentComment.fromJson(Map<String, dynamic> json) => _$ReportContentCommentFromJson(json);

@override final  CommentModel data;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of ReportContent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportContentCommentCopyWith<ReportContentComment> get copyWith => _$ReportContentCommentCopyWithImpl<ReportContentComment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReportContentCommentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportContentComment&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'ReportContent.comment(data: $data)';
}


}

/// @nodoc
abstract mixin class $ReportContentCommentCopyWith<$Res> implements $ReportContentCopyWith<$Res> {
  factory $ReportContentCommentCopyWith(ReportContentComment value, $Res Function(ReportContentComment) _then) = _$ReportContentCommentCopyWithImpl;
@useResult
$Res call({
 CommentModel data
});


$CommentModelCopyWith<$Res> get data;

}
/// @nodoc
class _$ReportContentCommentCopyWithImpl<$Res>
    implements $ReportContentCommentCopyWith<$Res> {
  _$ReportContentCommentCopyWithImpl(this._self, this._then);

  final ReportContentComment _self;
  final $Res Function(ReportContentComment) _then;

/// Create a copy of ReportContent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(ReportContentComment(
null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as CommentModel,
  ));
}

/// Create a copy of ReportContent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CommentModelCopyWith<$Res> get data {
  
  return $CommentModelCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$Report {

 int? get id; String get reason; int get author; ReportContent get content;@JsonKey(name: 'deleted_at') DateTime? get deletedAt;@JsonKey(name: 'created_at') DateTime? get createdAt;
/// Create a copy of Report
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportCopyWith<Report> get copyWith => _$ReportCopyWithImpl<Report>(this as Report, _$identity);

  /// Serializes this Report to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Report&&(identical(other.id, id) || other.id == id)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.author, author) || other.author == author)&&(identical(other.content, content) || other.content == content)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,reason,author,content,deletedAt,createdAt);

@override
String toString() {
  return 'Report(id: $id, reason: $reason, author: $author, content: $content, deletedAt: $deletedAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ReportCopyWith<$Res>  {
  factory $ReportCopyWith(Report value, $Res Function(Report) _then) = _$ReportCopyWithImpl;
@useResult
$Res call({
 int? id, String reason, int author, ReportContent content,@JsonKey(name: 'deleted_at') DateTime? deletedAt,@JsonKey(name: 'created_at') DateTime? createdAt
});


$ReportContentCopyWith<$Res> get content;

}
/// @nodoc
class _$ReportCopyWithImpl<$Res>
    implements $ReportCopyWith<$Res> {
  _$ReportCopyWithImpl(this._self, this._then);

  final Report _self;
  final $Res Function(Report) _then;

/// Create a copy of Report
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? reason = null,Object? author = null,Object? content = null,Object? deletedAt = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as int,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as ReportContent,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of Report
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportContentCopyWith<$Res> get content {
  
  return $ReportContentCopyWith<$Res>(_self.content, (value) {
    return _then(_self.copyWith(content: value));
  });
}
}


/// Adds pattern-matching-related methods to [Report].
extension ReportPatterns on Report {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Report value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Report() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Report value)  $default,){
final _that = this;
switch (_that) {
case _Report():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Report value)?  $default,){
final _that = this;
switch (_that) {
case _Report() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  String reason,  int author,  ReportContent content, @JsonKey(name: 'deleted_at')  DateTime? deletedAt, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Report() when $default != null:
return $default(_that.id,_that.reason,_that.author,_that.content,_that.deletedAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  String reason,  int author,  ReportContent content, @JsonKey(name: 'deleted_at')  DateTime? deletedAt, @JsonKey(name: 'created_at')  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _Report():
return $default(_that.id,_that.reason,_that.author,_that.content,_that.deletedAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  String reason,  int author,  ReportContent content, @JsonKey(name: 'deleted_at')  DateTime? deletedAt, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Report() when $default != null:
return $default(_that.id,_that.reason,_that.author,_that.content,_that.deletedAt,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Report extends Report {
  const _Report({this.id, required this.reason, required this.author, required this.content, @JsonKey(name: 'deleted_at') this.deletedAt, @JsonKey(name: 'created_at') this.createdAt}): super._();
  factory _Report.fromJson(Map<String, dynamic> json) => _$ReportFromJson(json);

@override final  int? id;
@override final  String reason;
@override final  int author;
@override final  ReportContent content;
@override@JsonKey(name: 'deleted_at') final  DateTime? deletedAt;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;

/// Create a copy of Report
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportCopyWith<_Report> get copyWith => __$ReportCopyWithImpl<_Report>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReportToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Report&&(identical(other.id, id) || other.id == id)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.author, author) || other.author == author)&&(identical(other.content, content) || other.content == content)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,reason,author,content,deletedAt,createdAt);

@override
String toString() {
  return 'Report(id: $id, reason: $reason, author: $author, content: $content, deletedAt: $deletedAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ReportCopyWith<$Res> implements $ReportCopyWith<$Res> {
  factory _$ReportCopyWith(_Report value, $Res Function(_Report) _then) = __$ReportCopyWithImpl;
@override @useResult
$Res call({
 int? id, String reason, int author, ReportContent content,@JsonKey(name: 'deleted_at') DateTime? deletedAt,@JsonKey(name: 'created_at') DateTime? createdAt
});


@override $ReportContentCopyWith<$Res> get content;

}
/// @nodoc
class __$ReportCopyWithImpl<$Res>
    implements _$ReportCopyWith<$Res> {
  __$ReportCopyWithImpl(this._self, this._then);

  final _Report _self;
  final $Res Function(_Report) _then;

/// Create a copy of Report
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? reason = null,Object? author = null,Object? content = null,Object? deletedAt = freezed,Object? createdAt = freezed,}) {
  return _then(_Report(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as int,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as ReportContent,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of Report
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportContentCopyWith<$Res> get content {
  
  return $ReportContentCopyWith<$Res>(_self.content, (value) {
    return _then(_self.copyWith(content: value));
  });
}
}

// dart format on
