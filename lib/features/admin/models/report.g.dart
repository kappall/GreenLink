// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportContentPost _$ReportContentPostFromJson(Map<String, dynamic> json) =>
    ReportContentPost(
      id: (json['id'] as num).toInt(),
      description: json['description'] as String,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$ReportContentPostToJson(ReportContentPost instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'type': instance.$type,
    };

ReportContentEvent _$ReportContentEventFromJson(Map<String, dynamic> json) =>
    ReportContentEvent(
      id: (json['id'] as num).toInt(),
      description: json['description'] as String,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$ReportContentEventToJson(ReportContentEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'type': instance.$type,
    };

ReportContentComment _$ReportContentCommentFromJson(
  Map<String, dynamic> json,
) => ReportContentComment(
  id: (json['id'] as num).toInt(),
  description: json['description'] as String,
  $type: json['type'] as String?,
);

Map<String, dynamic> _$ReportContentCommentToJson(
  ReportContentComment instance,
) => <String, dynamic>{
  'id': instance.id,
  'description': instance.description,
  'type': instance.$type,
};

ReportContentUnknown _$ReportContentUnknownFromJson(
  Map<String, dynamic> json,
) => ReportContentUnknown($type: json['type'] as String?);

Map<String, dynamic> _$ReportContentUnknownToJson(
  ReportContentUnknown instance,
) => <String, dynamic>{'type': instance.$type};

_Report _$ReportFromJson(Map<String, dynamic> json) => _Report(
  id: (json['id'] as num?)?.toInt(),
  reason: json['reason'] as String,
  author: UserModel.fromJson(json['author'] as Map<String, dynamic>),
  content: const ReportContentConverter().fromJson(
    json['content'] as Map<String, dynamic>,
  ),
  deletedAt: json['deleted_at'] == null
      ? null
      : DateTime.parse(json['deleted_at'] as String),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$ReportToJson(_Report instance) => <String, dynamic>{
  'id': instance.id,
  'reason': instance.reason,
  'author': instance.author,
  'content': const ReportContentConverter().toJson(instance.content),
  'deleted_at': instance.deletedAt?.toIso8601String(),
  'created_at': instance.createdAt?.toIso8601String(),
};
