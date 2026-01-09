// ignore_for_file: invalid_annotation_target

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:greenlinkapp/features/user/models/user_model.dart';

import '../../../core/common/widgets/bool_converter.dart';

part 'event_model.freezed.dart';
part 'event_model.g.dart';

@JsonEnum()
enum EventType { cleaning, planting, emergency, learning, other, unknown }

@freezed
abstract class EventModel with _$EventModel {
  const EventModel._();

  const factory EventModel({
    int? id,
    required String description,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'deleted_at') DateTime? deletedAt,
    required double latitude,
    required double longitude,
    @JsonKey(name: 'event_type', unknownEnumValue: EventType.unknown)
    required EventType eventType,
    required UserModel author,
    @Default("Evento") String title,
    @JsonKey(name: 'votes_count') @Default(0) int votesCount,
    @JsonKey(name: 'participants_count') @Default(0) int participantsCount,
    @BoolConverter()
    @JsonKey(name: 'is_participating')
    @Default(false)
    bool isParticipating,
    @JsonKey(name: 'max_participants') int? maxParticipants,
    @JsonKey(name: 'start_date') required DateTime startDate,
    @JsonKey(name: 'end_date') required DateTime endDate,
  }) = _EventModel;

  factory EventModel.fromJson(Map<String, dynamic> json) =>
      _$EventModelFromJson(json);
}

extension EventTypeUI on EventType {
  String get label {
    switch (this) {
      case EventType.cleaning:
        return 'Pulizia';
      case EventType.planting:
        return 'Piantumazione';
      case EventType.emergency:
        return 'Emergenza';
      case EventType.learning:
        return 'Formazione';
      case EventType.other:
        return 'Altro';
      case EventType.unknown:
        return 'Sconosciuto';
    }
  }

  IconData get icon {
    switch (this) {
      case EventType.cleaning:
        return Icons.cleaning_services;
      case EventType.planting:
        return Icons.park;
      case EventType.emergency:
        return Icons.emergency;
      case EventType.learning:
        return Icons.school;
      case EventType.other:
        return Icons.help_outline;
      case EventType.unknown:
        return Icons.help;
    }
  }

  Color get color {
    switch (this) {
      case EventType.cleaning:
        return Colors.cyan;
      case EventType.planting:
        return Colors.green;
      case EventType.emergency:
        return Colors.orange;
      case EventType.learning:
        return Colors.blue;
      case EventType.other:
        return Colors.grey;
      case EventType.unknown:
        return Colors.black;
    }
  }
}
