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
  votesCount: (json['votes_count'] as num?)?.toInt() ?? 0,
  participantsCount: (json['participants_count'] as num?)?.toInt() ?? 0,
  isParticipating: json['is_participating'] == null
      ? false
      : const BoolConverter().fromJson(json['is_participating']),
  maxParticipants: (json['max_participants'] as num).toInt(),
  startDate: DateTime.parse(json['start_date'] as String),
  endDate: DateTime.parse(json['end_date'] as String),
);

Map<String, dynamic> _$EventModelToJson(
  _EventModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'description': instance.description,
  'created_at': instance.createdAt?.toIso8601String(),
  'deleted_at': instance.deletedAt?.toIso8601String(),
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'event_type': _$EventTypeEnumMap[instance.eventType]!,
  'author': instance.author,
  'votes_count': instance.votesCount,
  'participants_count': instance.participantsCount,
  'is_participating': const BoolConverter().toJson(instance.isParticipating),
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
