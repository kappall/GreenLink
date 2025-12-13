// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EventModel _$EventModelFromJson(Map<String, dynamic> json) => _EventModel(
  id: (json['id'] as num).toInt(),
  description: json['description'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  deletedAt: json['deleted_at'] == null
      ? null
      : DateTime.parse(json['deleted_at'] as String),
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  eventType: $enumDecode(
    _$EventTypeEnumMap,
    json['event_type'],
    unknownValue: EventType.unknown,
  ),
  author: EventUserModel.fromJson(json['author'] as Map<String, dynamic>),
  votes:
      (json['votes'] as List<dynamic>?)
          ?.map((e) => EventUserModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <EventUserModel>[],
  participants:
      (json['participants'] as List<dynamic>?)
          ?.map((e) => EventUserModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <EventUserModel>[],
  maxParticipants: (json['max_participants'] as num).toInt(),
  startDate: DateTime.parse(json['start_date'] as String),
  endDate: DateTime.parse(json['end_date'] as String),
);

Map<String, dynamic> _$EventModelToJson(_EventModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'created_at': instance.createdAt.toIso8601String(),
      'deleted_at': instance.deletedAt?.toIso8601String(),
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'event_type': _$EventTypeEnumMap[instance.eventType]!,
      'author': instance.author,
      'votes': instance.votes,
      'participants': instance.participants,
      'max_participants': instance.maxParticipants,
      'start_date': instance.startDate.toIso8601String(),
      'end_date': instance.endDate.toIso8601String(),
    };

const _$EventTypeEnumMap = {
  EventType.cleaning: 'cleaning',
  EventType.planting: 'planting',
  EventType.emergency: 'emergency',
  EventType.learning: 'learning',
  EventType.other: 'other',
  EventType.unknown: 'unknown',
};

_EventUserModel _$EventUserModelFromJson(Map<String, dynamic> json) =>
    _EventUserModel(
      id: (json['id'] as num).toInt(),
      email: json['email'] as String,
      username: json['username'] as String?,
      password: json['password'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
    );

Map<String, dynamic> _$EventUserModelToJson(_EventUserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'username': instance.username,
      'password': instance.password,
      'created_at': instance.createdAt.toIso8601String(),
      'deleted_at': instance.deletedAt?.toIso8601String(),
    };
