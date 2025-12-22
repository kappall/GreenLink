// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EventModel _$EventModelFromJson(Map<String, dynamic> json) => _EventModel(
  id: (json['id'] as num?)?.toInt(),
  description: json['description'] as String,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
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
  author: UserModel.fromJson(json['author'] as Map<String, dynamic>),
  votes_count: (json['votes_count'] as num?)?.toInt() ?? 0,
  participants_count: (json['participants_count'] as num?)?.toInt() ?? 0,
  maxParticipants: (json['max_participants'] as num).toInt(),
  startDate: DateTime.parse(json['start_date'] as String),
  endDate: DateTime.parse(json['end_date'] as String),
);

Map<String, dynamic> _$EventModelToJson(_EventModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'created_at': instance.createdAt?.toIso8601String(),
      'deleted_at': instance.deletedAt?.toIso8601String(),
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'event_type': _$EventTypeEnumMap[instance.eventType]!,
      'author': instance.author,
      'votes_count': instance.votes_count,
      'participants_count': instance.participants_count,
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
