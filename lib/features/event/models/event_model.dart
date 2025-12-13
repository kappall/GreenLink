// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_model.freezed.dart';
part 'event_model.g.dart';

@JsonEnum()
enum EventType { cleaning, planting, emergency, learning, other, unknown }

@freezed
abstract class EventModel with _$EventModel {
  const EventModel._();

  const factory EventModel({
    required int id,
    required String description,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'deleted_at') DateTime? deletedAt,
    required double latitude,
    required double longitude,
    @JsonKey(name: 'event_type', unknownEnumValue: EventType.unknown)
    required EventType eventType,
    required EventUserModel author,
    @Default(<EventUserModel>[]) List<EventUserModel> votes,
    @Default(<EventUserModel>[]) List<EventUserModel> participants,
    @JsonKey(name: 'max_participants') required int maxParticipants,
    @JsonKey(name: 'start_date') required DateTime startDate,
    @JsonKey(name: 'end_date') required DateTime endDate,
  }) = _EventModel;

  factory EventModel.fromJson(Map<String, dynamic> json) =>
      _$EventModelFromJson(json);
}

@freezed
abstract class EventUserModel with _$EventUserModel {
  const EventUserModel._();

  const factory EventUserModel({
    required int id,
    required String email,
    String? username,
    String? password,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'deleted_at') DateTime? deletedAt,
  }) = _EventUserModel;

  factory EventUserModel.fromJson(Map<String, dynamic> json) =>
      _$EventUserModelFromJson(json);
}
