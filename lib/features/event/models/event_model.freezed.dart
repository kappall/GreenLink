// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EventModel {

 int? get id; String get description;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'deleted_at') DateTime? get deletedAt; double get latitude; double get longitude;@JsonKey(name: 'event_type', unknownEnumValue: EventType.unknown) EventType get eventType; UserModel get author; String get title;@JsonKey(name: 'votes_count') int get votesCount;@JsonKey(name: 'participants_count') int get participantsCount;@BoolConverter()@JsonKey(name: 'is_participating') bool get isParticipating;@JsonKey(name: 'max_participants') int? get maxParticipants;@JsonKey(name: 'start_date') DateTime get startDate;@JsonKey(name: 'end_date') DateTime get endDate;
/// Create a copy of EventModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventModelCopyWith<EventModel> get copyWith => _$EventModelCopyWithImpl<EventModel>(this as EventModel, _$identity);

  /// Serializes this EventModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventModel&&(identical(other.id, id) || other.id == id)&&(identical(other.description, description) || other.description == description)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.eventType, eventType) || other.eventType == eventType)&&(identical(other.author, author) || other.author == author)&&(identical(other.title, title) || other.title == title)&&(identical(other.votesCount, votesCount) || other.votesCount == votesCount)&&(identical(other.participantsCount, participantsCount) || other.participantsCount == participantsCount)&&(identical(other.isParticipating, isParticipating) || other.isParticipating == isParticipating)&&(identical(other.maxParticipants, maxParticipants) || other.maxParticipants == maxParticipants)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,description,createdAt,deletedAt,latitude,longitude,eventType,author,title,votesCount,participantsCount,isParticipating,maxParticipants,startDate,endDate);

@override
String toString() {
  return 'EventModel(id: $id, description: $description, createdAt: $createdAt, deletedAt: $deletedAt, latitude: $latitude, longitude: $longitude, eventType: $eventType, author: $author, title: $title, votesCount: $votesCount, participantsCount: $participantsCount, isParticipating: $isParticipating, maxParticipants: $maxParticipants, startDate: $startDate, endDate: $endDate)';
}


}

/// @nodoc
abstract mixin class $EventModelCopyWith<$Res>  {
  factory $EventModelCopyWith(EventModel value, $Res Function(EventModel) _then) = _$EventModelCopyWithImpl;
@useResult
$Res call({
 int? id, String description,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'deleted_at') DateTime? deletedAt, double latitude, double longitude,@JsonKey(name: 'event_type', unknownEnumValue: EventType.unknown) EventType eventType, UserModel author, String title,@JsonKey(name: 'votes_count') int votesCount,@JsonKey(name: 'participants_count') int participantsCount,@BoolConverter()@JsonKey(name: 'is_participating') bool isParticipating,@JsonKey(name: 'max_participants') int? maxParticipants,@JsonKey(name: 'start_date') DateTime startDate,@JsonKey(name: 'end_date') DateTime endDate
});


$UserModelCopyWith<$Res> get author;

}
/// @nodoc
class _$EventModelCopyWithImpl<$Res>
    implements $EventModelCopyWith<$Res> {
  _$EventModelCopyWithImpl(this._self, this._then);

  final EventModel _self;
  final $Res Function(EventModel) _then;

/// Create a copy of EventModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? description = null,Object? createdAt = freezed,Object? deletedAt = freezed,Object? latitude = null,Object? longitude = null,Object? eventType = null,Object? author = null,Object? title = null,Object? votesCount = null,Object? participantsCount = null,Object? isParticipating = null,Object? maxParticipants = freezed,Object? startDate = null,Object? endDate = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,eventType: null == eventType ? _self.eventType : eventType // ignore: cast_nullable_to_non_nullable
as EventType,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as UserModel,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,votesCount: null == votesCount ? _self.votesCount : votesCount // ignore: cast_nullable_to_non_nullable
as int,participantsCount: null == participantsCount ? _self.participantsCount : participantsCount // ignore: cast_nullable_to_non_nullable
as int,isParticipating: null == isParticipating ? _self.isParticipating : isParticipating // ignore: cast_nullable_to_non_nullable
as bool,maxParticipants: freezed == maxParticipants ? _self.maxParticipants : maxParticipants // ignore: cast_nullable_to_non_nullable
as int?,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of EventModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserModelCopyWith<$Res> get author {
  
  return $UserModelCopyWith<$Res>(_self.author, (value) {
    return _then(_self.copyWith(author: value));
  });
}
}


/// Adds pattern-matching-related methods to [EventModel].
extension EventModelPatterns on EventModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EventModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EventModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EventModel value)  $default,){
final _that = this;
switch (_that) {
case _EventModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EventModel value)?  $default,){
final _that = this;
switch (_that) {
case _EventModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  String description, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'deleted_at')  DateTime? deletedAt,  double latitude,  double longitude, @JsonKey(name: 'event_type', unknownEnumValue: EventType.unknown)  EventType eventType,  UserModel author,  String title, @JsonKey(name: 'votes_count')  int votesCount, @JsonKey(name: 'participants_count')  int participantsCount, @BoolConverter()@JsonKey(name: 'is_participating')  bool isParticipating, @JsonKey(name: 'max_participants')  int? maxParticipants, @JsonKey(name: 'start_date')  DateTime startDate, @JsonKey(name: 'end_date')  DateTime endDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EventModel() when $default != null:
return $default(_that.id,_that.description,_that.createdAt,_that.deletedAt,_that.latitude,_that.longitude,_that.eventType,_that.author,_that.title,_that.votesCount,_that.participantsCount,_that.isParticipating,_that.maxParticipants,_that.startDate,_that.endDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  String description, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'deleted_at')  DateTime? deletedAt,  double latitude,  double longitude, @JsonKey(name: 'event_type', unknownEnumValue: EventType.unknown)  EventType eventType,  UserModel author,  String title, @JsonKey(name: 'votes_count')  int votesCount, @JsonKey(name: 'participants_count')  int participantsCount, @BoolConverter()@JsonKey(name: 'is_participating')  bool isParticipating, @JsonKey(name: 'max_participants')  int? maxParticipants, @JsonKey(name: 'start_date')  DateTime startDate, @JsonKey(name: 'end_date')  DateTime endDate)  $default,) {final _that = this;
switch (_that) {
case _EventModel():
return $default(_that.id,_that.description,_that.createdAt,_that.deletedAt,_that.latitude,_that.longitude,_that.eventType,_that.author,_that.title,_that.votesCount,_that.participantsCount,_that.isParticipating,_that.maxParticipants,_that.startDate,_that.endDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  String description, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'deleted_at')  DateTime? deletedAt,  double latitude,  double longitude, @JsonKey(name: 'event_type', unknownEnumValue: EventType.unknown)  EventType eventType,  UserModel author,  String title, @JsonKey(name: 'votes_count')  int votesCount, @JsonKey(name: 'participants_count')  int participantsCount, @BoolConverter()@JsonKey(name: 'is_participating')  bool isParticipating, @JsonKey(name: 'max_participants')  int? maxParticipants, @JsonKey(name: 'start_date')  DateTime startDate, @JsonKey(name: 'end_date')  DateTime endDate)?  $default,) {final _that = this;
switch (_that) {
case _EventModel() when $default != null:
return $default(_that.id,_that.description,_that.createdAt,_that.deletedAt,_that.latitude,_that.longitude,_that.eventType,_that.author,_that.title,_that.votesCount,_that.participantsCount,_that.isParticipating,_that.maxParticipants,_that.startDate,_that.endDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EventModel extends EventModel {
  const _EventModel({this.id, required this.description, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'deleted_at') this.deletedAt, required this.latitude, required this.longitude, @JsonKey(name: 'event_type', unknownEnumValue: EventType.unknown) required this.eventType, required this.author, this.title = "Evento", @JsonKey(name: 'votes_count') this.votesCount = 0, @JsonKey(name: 'participants_count') this.participantsCount = 0, @BoolConverter()@JsonKey(name: 'is_participating') this.isParticipating = false, @JsonKey(name: 'max_participants') this.maxParticipants, @JsonKey(name: 'start_date') required this.startDate, @JsonKey(name: 'end_date') required this.endDate}): super._();
  factory _EventModel.fromJson(Map<String, dynamic> json) => _$EventModelFromJson(json);

@override final  int? id;
@override final  String description;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'deleted_at') final  DateTime? deletedAt;
@override final  double latitude;
@override final  double longitude;
@override@JsonKey(name: 'event_type', unknownEnumValue: EventType.unknown) final  EventType eventType;
@override final  UserModel author;
@override@JsonKey() final  String title;
@override@JsonKey(name: 'votes_count') final  int votesCount;
@override@JsonKey(name: 'participants_count') final  int participantsCount;
@override@BoolConverter()@JsonKey(name: 'is_participating') final  bool isParticipating;
@override@JsonKey(name: 'max_participants') final  int? maxParticipants;
@override@JsonKey(name: 'start_date') final  DateTime startDate;
@override@JsonKey(name: 'end_date') final  DateTime endDate;

/// Create a copy of EventModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventModelCopyWith<_EventModel> get copyWith => __$EventModelCopyWithImpl<_EventModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EventModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventModel&&(identical(other.id, id) || other.id == id)&&(identical(other.description, description) || other.description == description)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.eventType, eventType) || other.eventType == eventType)&&(identical(other.author, author) || other.author == author)&&(identical(other.title, title) || other.title == title)&&(identical(other.votesCount, votesCount) || other.votesCount == votesCount)&&(identical(other.participantsCount, participantsCount) || other.participantsCount == participantsCount)&&(identical(other.isParticipating, isParticipating) || other.isParticipating == isParticipating)&&(identical(other.maxParticipants, maxParticipants) || other.maxParticipants == maxParticipants)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,description,createdAt,deletedAt,latitude,longitude,eventType,author,title,votesCount,participantsCount,isParticipating,maxParticipants,startDate,endDate);

@override
String toString() {
  return 'EventModel(id: $id, description: $description, createdAt: $createdAt, deletedAt: $deletedAt, latitude: $latitude, longitude: $longitude, eventType: $eventType, author: $author, title: $title, votesCount: $votesCount, participantsCount: $participantsCount, isParticipating: $isParticipating, maxParticipants: $maxParticipants, startDate: $startDate, endDate: $endDate)';
}


}

/// @nodoc
abstract mixin class _$EventModelCopyWith<$Res> implements $EventModelCopyWith<$Res> {
  factory _$EventModelCopyWith(_EventModel value, $Res Function(_EventModel) _then) = __$EventModelCopyWithImpl;
@override @useResult
$Res call({
 int? id, String description,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'deleted_at') DateTime? deletedAt, double latitude, double longitude,@JsonKey(name: 'event_type', unknownEnumValue: EventType.unknown) EventType eventType, UserModel author, String title,@JsonKey(name: 'votes_count') int votesCount,@JsonKey(name: 'participants_count') int participantsCount,@BoolConverter()@JsonKey(name: 'is_participating') bool isParticipating,@JsonKey(name: 'max_participants') int? maxParticipants,@JsonKey(name: 'start_date') DateTime startDate,@JsonKey(name: 'end_date') DateTime endDate
});


@override $UserModelCopyWith<$Res> get author;

}
/// @nodoc
class __$EventModelCopyWithImpl<$Res>
    implements _$EventModelCopyWith<$Res> {
  __$EventModelCopyWithImpl(this._self, this._then);

  final _EventModel _self;
  final $Res Function(_EventModel) _then;

/// Create a copy of EventModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? description = null,Object? createdAt = freezed,Object? deletedAt = freezed,Object? latitude = null,Object? longitude = null,Object? eventType = null,Object? author = null,Object? title = null,Object? votesCount = null,Object? participantsCount = null,Object? isParticipating = null,Object? maxParticipants = freezed,Object? startDate = null,Object? endDate = null,}) {
  return _then(_EventModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,eventType: null == eventType ? _self.eventType : eventType // ignore: cast_nullable_to_non_nullable
as EventType,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as UserModel,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,votesCount: null == votesCount ? _self.votesCount : votesCount // ignore: cast_nullable_to_non_nullable
as int,participantsCount: null == participantsCount ? _self.participantsCount : participantsCount // ignore: cast_nullable_to_non_nullable
as int,isParticipating: null == isParticipating ? _self.isParticipating : isParticipating // ignore: cast_nullable_to_non_nullable
as bool,maxParticipants: freezed == maxParticipants ? _self.maxParticipants : maxParticipants // ignore: cast_nullable_to_non_nullable
as int?,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of EventModel
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
